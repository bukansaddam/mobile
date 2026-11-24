import 'dart:async';

import 'package:akar/features/permissions/data/services/app_permission_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:akar/features/permissions/presentation/bloc/permission_onboarding_bloc/permission_onboarding_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePermissionGateway implements PermissionGateway {
  final Map<AppPermissionType, PermissionStepStatus> checkStatuses = {};
  final Map<AppPermissionType, PermissionStepStatus> requestResults = {};
  final Map<AppPermissionType, Completer<PermissionStepStatus>>
      pendingRequests = {};
  final List<AppPermissionType> requestedTypes = [];

  int openSettingsCalls = 0;

  @override
  Future<PermissionStepStatus> checkStatus(AppPermissionType type) async {
    return checkStatuses[type] ?? PermissionStepStatus.denied;
  }

  @override
  Future<PermissionStepStatus> request(AppPermissionType type) async {
    requestedTypes.add(type);
    final pending = pendingRequests.remove(type);
    if (pending != null) {
      final result = await pending.future;
      checkStatuses[type] = result;
      return result;
    }
    final result = requestResults[type] ?? PermissionStepStatus.denied;
    checkStatuses[type] = result;
    return result;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCalls += 1;
    return true;
  }
}

Future<void> _pumpEvents() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('PermissionOnboardingBloc', () {
    late _FakePermissionGateway gateway;
    late AppPermissionService service;
    late PermissionOnboardingBloc bloc;

    setUp(() {
      gateway = _FakePermissionGateway();
      service = AppPermissionService(gateway: gateway);
      bloc = PermissionOnboardingBloc(permissionService: service);
    });

    tearDown(() async {
      await bloc.close();
      service.dispose();
    });

    test('initial state is PermissionOnboardingInitial', () {
      expect(bloc.state, const PermissionOnboardingInitial());
    });

    test(
      'LoadPermissionsEvent(isOfficer: false) loads 3 Masyarakat steps and focuses index 0 when none are granted',
      () async {
        final emitted = <PermissionOnboardingState>[];
        final sub = bloc.stream.listen(emitted.add);

        bloc.add(const LoadPermissionsEvent(isOfficer: false));
        await _pumpEvents();

        expect(emitted, hasLength(2));
        expect(emitted[0], const PermissionOnboardingLoading());
        expect(emitted[1], isA<PermissionOnboardingLoaded>());

        final loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.isOfficer, isFalse);
        expect(loaded.steps, hasLength(3));
        expect(
          loaded.steps.map((s) => s.type).toList(),
          equals([
            AppPermissionType.locationWhenInUse,
            AppPermissionType.camera,
            AppPermissionType.notification,
          ]),
        );
        expect(loaded.activeStepIndex, equals(0));
        expect(loaded.isRequesting, isFalse);
        expect(loaded.isCompleted, isFalse);
        expect(loaded.grantedCount, equals(0));
        expect(loaded.currentStep.type, AppPermissionType.locationWhenInUse);
        expect(loaded.currentStatus, PermissionStepStatus.notRequested);

        expect(
          () => loaded.steps.add(loaded.steps.first),
          throwsUnsupportedError,
        );
        expect(
          () => loaded.statuses[AppPermissionType.camera] =
              PermissionStepStatus.granted,
          throwsUnsupportedError,
        );

        await sub.cancel();
      },
    );

    test(
      'LoadPermissionsEvent(isOfficer: true) auto-skips already granted steps to microphone at index 3',
      () async {
        gateway.checkStatuses.addAll({
          AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          AppPermissionType.locationAlways: PermissionStepStatus.granted,
          AppPermissionType.camera: PermissionStepStatus.granted,
          AppPermissionType.microphone: PermissionStepStatus.denied,
          AppPermissionType.notification: PermissionStepStatus.denied,
        });

        bloc.add(const LoadPermissionsEvent(isOfficer: true));
        await _pumpEvents();

        final loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.isOfficer, isTrue);
        expect(loaded.steps, hasLength(5));
        expect(loaded.activeStepIndex, equals(3));
        expect(loaded.currentStep.type, AppPermissionType.microphone);
        expect(loaded.grantedCount, equals(3));
        expect(loaded.isCompleted, isFalse);
      },
    );

    test(
      'LoadPermissionsEvent emits PermissionOnboardingLoaded with isCompleted true when all permissions are already granted',
      () async {
        gateway.checkStatuses.addAll({
          AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          AppPermissionType.camera: PermissionStepStatus.granted,
          AppPermissionType.notification: PermissionStepStatus.granted,
        });

        bloc.add(const LoadPermissionsEvent(isOfficer: false));
        await _pumpEvents();

        final loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.isCompleted, isTrue);
        expect(loaded.activeStepIndex, equals(2));
        expect(loaded.grantedCount, equals(3));
      },
    );

    test(
      'RequestCurrentPermissionEvent grants step 0 and advances activeStepIndex to step 1',
      () async {
        bloc.add(const LoadPermissionsEvent(isOfficer: false));
        await _pumpEvents();

        gateway.requestResults[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.granted;

        final emitted = <PermissionOnboardingState>[];
        final sub = bloc.stream.listen(emitted.add);

        bloc.add(const RequestCurrentPermissionEvent());
        await _pumpEvents();

        expect(emitted, hasLength(2));
        final requestingState = emitted[0] as PermissionOnboardingLoaded;
        expect(requestingState.isRequesting, isTrue);
        expect(requestingState.activeStepIndex, equals(0));

        final advancedState = emitted[1] as PermissionOnboardingLoaded;
        expect(advancedState.isRequesting, isFalse);
        expect(advancedState.activeStepIndex, equals(1));
        expect(advancedState.currentStep.type, AppPermissionType.camera);
        expect(advancedState.grantedCount, equals(1));
        expect(advancedState.isCompleted, isFalse);

        await sub.cancel();
      },
    );

    test(
      'rapid double-tap of RequestCurrentPermissionEvent while isRequesting is true invokes gateway.request only once',
      () async {
        bloc.add(const LoadPermissionsEvent(isOfficer: false));
        await _pumpEvents();

        final completer = Completer<PermissionStepStatus>();
        gateway.pendingRequests[AppPermissionType.locationWhenInUse] =
            completer;

        bloc.add(const RequestCurrentPermissionEvent());
        await Future<void>.delayed(Duration.zero);

        expect((bloc.state as PermissionOnboardingLoaded).isRequesting, isTrue);

        bloc.add(const RequestCurrentPermissionEvent());
        await Future<void>.delayed(Duration.zero);

        expect(gateway.requestedTypes, hasLength(1));

        completer.complete(PermissionStepStatus.granted);
        await _pumpEvents();

        final loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.isRequesting, isFalse);
        expect(loaded.activeStepIndex, equals(1));
        expect(gateway.requestedTypes, hasLength(1));
      },
    );

    test(
      'RequestCurrentPermissionEvent stays on same index with denied or requiresSettings status when not granted',
      () async {
        bloc.add(const LoadPermissionsEvent(isOfficer: true));
        await _pumpEvents();

        gateway.requestResults[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.denied;
        bloc.add(const RequestCurrentPermissionEvent());
        await _pumpEvents();

        var loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(0));
        expect(loaded.currentStatus, PermissionStepStatus.denied);
        expect(loaded.currentStatus.requiresSettings, isFalse);

        gateway.requestResults[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.permanentlyDenied;
        bloc.add(const RequestCurrentPermissionEvent());
        await _pumpEvents();

        loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(0));
        expect(loaded.currentStatus, PermissionStepStatus.permanentlyDenied);
        expect(loaded.currentStatus.requiresSettings, isTrue);

        gateway.requestResults[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.granted;
        bloc.add(const RequestCurrentPermissionEvent());
        await _pumpEvents();

        loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(1));
        expect(loaded.currentStep.type, AppPermissionType.locationAlways);

        gateway.requestResults[AppPermissionType.locationAlways] =
            PermissionStepStatus.denied;
        bloc.add(const RequestCurrentPermissionEvent());
        await _pumpEvents();

        loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(1));
        expect(loaded.currentStatus, PermissionStepStatus.needsSettings);
        expect(loaded.currentStatus.requiresSettings, isTrue);
      },
    );

    test(
      'OpenPermissionSettingsEvent delegates to permissionService.openAppSettings()',
      () async {
        bloc.add(const LoadPermissionsEvent(isOfficer: true));
        await _pumpEvents();

        bloc.add(const OpenPermissionSettingsEvent());
        await _pumpEvents();

        expect(gateway.openSettingsCalls, equals(1));
      },
    );

    test(
      'RefreshPermissionsEvent advances to camera when locationAlways is granted and pulls back to index 0 if locationWhenInUse is revoked',
      () async {
        gateway.checkStatuses.addAll({
          AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          AppPermissionType.locationAlways: PermissionStepStatus.denied,
          AppPermissionType.camera: PermissionStepStatus.denied,
          AppPermissionType.microphone: PermissionStepStatus.denied,
          AppPermissionType.notification: PermissionStepStatus.denied,
        });

        bloc.add(const LoadPermissionsEvent(isOfficer: true));
        await _pumpEvents();

        var loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(1));
        expect(loaded.currentStep.type, AppPermissionType.locationAlways);

        // User grants locationAlways in OS Settings and returns.
        gateway.checkStatuses[AppPermissionType.locationAlways] =
            PermissionStepStatus.granted;
        bloc.add(const RefreshPermissionsEvent());
        await _pumpEvents();

        loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(2));
        expect(loaded.currentStep.type, AppPermissionType.camera);
        expect(loaded.grantedCount, equals(2));

        // User revokes locationWhenInUse in OS Settings while on camera/locationAlways.
        gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.denied;
        bloc.add(const RefreshPermissionsEvent());
        await _pumpEvents();

        loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(0));
        expect(loaded.currentStep.type, AppPermissionType.locationWhenInUse);
        expect(loaded.isCompleted, isFalse);
      },
    );

    test(
      'RefreshPermissionsEvent specifically pulls activeStepIndex back from 1 (locationAlways) to 0 (locationWhenInUse) when revoked',
      () async {
        gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.granted;
        bloc.add(const LoadPermissionsEvent(isOfficer: true));
        await _pumpEvents();

        expect((bloc.state as PermissionOnboardingLoaded).activeStepIndex, 1);

        gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.denied;
        bloc.add(const RefreshPermissionsEvent());
        await _pumpEvents();

        final loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(0));
        expect(loaded.currentStep.type, AppPermissionType.locationWhenInUse);
      },
    );

    test(
      'granting the final remaining permission sets isCompleted true and blocks further requests',
      () async {
        gateway.checkStatuses.addAll({
          AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          AppPermissionType.camera: PermissionStepStatus.granted,
          AppPermissionType.notification: PermissionStepStatus.denied,
        });

        bloc.add(const LoadPermissionsEvent(isOfficer: false));
        await _pumpEvents();

        var loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.activeStepIndex, equals(2));
        expect(loaded.isCompleted, isFalse);

        gateway.requestResults[AppPermissionType.notification] =
            PermissionStepStatus.granted;
        bloc.add(const RequestCurrentPermissionEvent());
        await _pumpEvents();

        loaded = bloc.state as PermissionOnboardingLoaded;
        expect(loaded.isCompleted, isTrue);
        expect(loaded.activeStepIndex, equals(2));
        expect(loaded.grantedCount, equals(3));

        // Additional request after completion is ignored.
        bloc.add(const RequestCurrentPermissionEvent());
        await _pumpEvents();
        expect(gateway.requestedTypes, equals([AppPermissionType.notification]));
      },
    );
  });
}
