import 'package:akar/features/permissions/data/services/app_permission_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePermissionGateway implements PermissionGateway {
  final Map<AppPermissionType, PermissionStepStatus> checkStatuses = {};
  final Map<AppPermissionType, PermissionStepStatus> requestResults = {};
  final Set<AppPermissionType> checkErrors = {};
  final Set<AppPermissionType> requestErrors = {};
  final List<AppPermissionType> checkedTypes = [];
  final List<AppPermissionType> requestedTypes = [];

  bool openSettingsResult = true;
  bool openSettingsThrows = false;
  int openSettingsCalls = 0;

  @override
  Future<PermissionStepStatus> checkStatus(AppPermissionType type) async {
    checkedTypes.add(type);
    if (checkErrors.contains(type)) {
      throw Exception('checkStatus failed for $type');
    }
    return checkStatuses[type] ?? PermissionStepStatus.denied;
  }

  @override
  Future<PermissionStepStatus> request(AppPermissionType type) async {
    requestedTypes.add(type);
    if (requestErrors.contains(type)) {
      throw Exception('request failed for $type');
    }
    final result = requestResults[type] ?? PermissionStepStatus.denied;
    checkStatuses[type] = result;
    return result;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCalls += 1;
    if (openSettingsThrows) {
      throw Exception('openSettings failed');
    }
    return openSettingsResult;
  }
}

void main() {
  group('PermissionStepStatus', () {
    test('isGranted and requiresSettings reflect status semantics', () {
      expect(PermissionStepStatus.notRequested.isGranted, isFalse);
      expect(PermissionStepStatus.notRequested.requiresSettings, isFalse);

      expect(PermissionStepStatus.granted.isGranted, isTrue);
      expect(PermissionStepStatus.granted.requiresSettings, isFalse);

      expect(PermissionStepStatus.denied.isGranted, isFalse);
      expect(PermissionStepStatus.denied.requiresSettings, isFalse);

      expect(PermissionStepStatus.permanentlyDenied.isGranted, isFalse);
      expect(PermissionStepStatus.permanentlyDenied.requiresSettings, isTrue);

      expect(PermissionStepStatus.needsSettings.isGranted, isFalse);
      expect(PermissionStepStatus.needsSettings.requiresSettings, isTrue);
    });
  });

  group('PermissionStepCatalog', () {
    test('stepsForRole(isOfficer: false) returns ordered Masyarakat steps', () {
      final steps = PermissionStepCatalog.stepsForRole(isOfficer: false);

      expect(steps, hasLength(3));
      expect(
        steps.map((s) => s.type).toList(),
        equals([
          AppPermissionType.locationWhenInUse,
          AppPermissionType.camera,
          AppPermissionType.notification,
        ]),
      );
      expect(
        steps.where((s) => s.type == AppPermissionType.locationAlways),
        isEmpty,
      );
    });

    test('stepsForRole(isOfficer: true) returns ordered Linmas steps', () {
      final steps = PermissionStepCatalog.stepsForRole(isOfficer: true);

      expect(steps, hasLength(5));
      expect(
        steps.map((s) => s.type).toList(),
        equals([
          AppPermissionType.locationWhenInUse,
          AppPermissionType.locationAlways,
          AppPermissionType.camera,
          AppPermissionType.microphone,
          AppPermissionType.notification,
        ]),
      );

      final alwaysStep = steps.firstWhere(
        (s) => s.type == AppPermissionType.locationAlways,
      );
      expect(
        alwaysStep.disclosureNote,
        equals(
          'Pada layar berikutnya, pilih Izinkan sepanjang waktu / Selalu agar pelacakan patroli tetap aktif di latar belakang.',
        ),
      );
    });

    test('catalog strings do not contain em dash characters', () {
      final allSteps = [
        ...PermissionStepCatalog.stepsForRole(isOfficer: false),
        ...PermissionStepCatalog.stepsForRole(isOfficer: true),
      ];

      for (final step in allSteps) {
        expect(step.title.contains('—'), isFalse);
        expect(step.description.contains('—'), isFalse);
        expect(step.actionLabel.contains('—'), isFalse);
        expect(step.settingsHint.contains('—'), isFalse);
        expect(step.disclosureNote?.contains('—') ?? false, isFalse);
      }
    });
  });

  group('AppPermissionService', () {
    late FakePermissionGateway gateway;
    late AppPermissionService service;

    setUp(() {
      gateway = FakePermissionGateway();
      service = AppPermissionService(gateway: gateway);
    });

    tearDown(() {
      service.dispose();
    });

    test('unprimed hasAllRequiredPermissionsSync returns false', () {
      expect(service.hasAllRequiredPermissionsSync(isOfficer: false), isFalse);
      expect(service.hasAllRequiredPermissionsSync(isOfficer: true), isFalse);
      expect(service.cachedStatuses, isEmpty);
    });

    test(
      'refreshStatuses(isOfficer: false) caches statuses, sets sync true when all 3 granted, and notifies listeners',
      () async {
        gateway.checkStatuses.addAll({
          AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          AppPermissionType.camera: PermissionStepStatus.granted,
          AppPermissionType.notification: PermissionStepStatus.granted,
        });

        var notifications = 0;
        service.addListener(() => notifications += 1);

        final result = await service.refreshStatuses(isOfficer: false);

        expect(result, hasLength(3));
        expect(service.cachedStatuses[AppPermissionType.locationWhenInUse],
            PermissionStepStatus.granted);
        expect(service.cachedStatuses[AppPermissionType.camera],
            PermissionStepStatus.granted);
        expect(service.cachedStatuses[AppPermissionType.notification],
            PermissionStepStatus.granted);
        expect(service.hasAllRequiredPermissionsSync(isOfficer: false), isTrue);
        expect(notifications, equals(1));
      },
    );

    test(
      'refreshStatuses(isOfficer: true) returns false when only Masyarakat 3 permissions are granted',
      () async {
        gateway.checkStatuses.addAll({
          AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          AppPermissionType.camera: PermissionStepStatus.granted,
          AppPermissionType.notification: PermissionStepStatus.granted,
          AppPermissionType.locationAlways: PermissionStepStatus.denied,
          AppPermissionType.microphone: PermissionStepStatus.denied,
        });

        await service.refreshStatuses(isOfficer: true);

        expect(service.hasAllRequiredPermissionsSync(isOfficer: true), isFalse);
        expect(
          service.cachedStatuses[AppPermissionType.locationAlways],
          PermissionStepStatus.notRequested,
        );
        expect(
          service.cachedStatuses[AppPermissionType.microphone],
          PermissionStepStatus.notRequested,
        );
      },
    );

    test(
      'refreshStatuses distinguishes notRequested vs denied/needsSettings using attempted history',
      () async {
        gateway.checkStatuses.addAll({
          AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          AppPermissionType.locationAlways: PermissionStepStatus.denied,
          AppPermissionType.camera: PermissionStepStatus.denied,
          AppPermissionType.microphone: PermissionStepStatus.denied,
          AppPermissionType.notification: PermissionStepStatus.denied,
        });

        await service.refreshStatuses(isOfficer: true);
        expect(
          service.cachedStatuses[AppPermissionType.camera],
          PermissionStepStatus.notRequested,
        );
        expect(
          service.cachedStatuses[AppPermissionType.locationAlways],
          PermissionStepStatus.notRequested,
        );

        gateway.requestResults[AppPermissionType.camera] =
            PermissionStepStatus.denied;
        gateway.requestResults[AppPermissionType.locationAlways] =
            PermissionStepStatus.denied;

        await service.requestPermission(
          AppPermissionType.camera,
          isOfficer: true,
        );
        await service.requestPermission(
          AppPermissionType.locationAlways,
          isOfficer: true,
        );

        await service.refreshStatuses(isOfficer: true);
        expect(
          service.cachedStatuses[AppPermissionType.camera],
          PermissionStepStatus.denied,
        );
        expect(
          service.cachedStatuses[AppPermissionType.locationAlways],
          PermissionStepStatus.needsSettings,
        );
        expect(
          service.cachedStatuses[AppPermissionType.microphone],
          PermissionStepStatus.notRequested,
        );

        gateway.checkStatuses[AppPermissionType.locationAlways] =
            PermissionStepStatus.granted;
        await service.refreshStatuses(isOfficer: true);
        expect(
          service.cachedStatuses[AppPermissionType.locationAlways],
          PermissionStepStatus.granted,
        );
      },
    );

    test(
      '2-step locationAlways guard blocks request when locationWhenInUse is not granted',
      () async {
        gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.denied;
        await service.refreshStatuses(isOfficer: true);

        final status = await service.requestPermission(
          AppPermissionType.locationAlways,
          isOfficer: true,
        );

        expect(status, PermissionStepStatus.denied);
        expect(
          gateway.requestedTypes,
          isNot(contains(AppPermissionType.locationAlways)),
        );
        expect(
          gateway.checkedTypes
              .where((t) => t == AppPermissionType.locationWhenInUse)
              .length,
          equals(2),
        );
      },
    );

    test(
      '2-step locationAlways guard proceeds when re-check finds locationWhenInUse granted',
      () async {
        gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.denied;
        await service.refreshStatuses(isOfficer: true);

        gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.granted;
        gateway.requestResults[AppPermissionType.locationAlways] =
            PermissionStepStatus.granted;

        final status = await service.requestPermission(
          AppPermissionType.locationAlways,
          isOfficer: true,
        );

        expect(status, PermissionStepStatus.granted);
        expect(
          service.cachedStatuses[AppPermissionType.locationWhenInUse],
          PermissionStepStatus.granted,
        );
        expect(
          gateway.requestedTypes,
          contains(AppPermissionType.locationAlways),
        );
      },
    );

    test(
      'locationAlways normalizes denied to needsSettings when locationWhenInUse is granted',
      () async {
        gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.granted;
        await service.refreshStatuses(isOfficer: true);

        gateway.requestResults[AppPermissionType.locationAlways] =
            PermissionStepStatus.denied;

        var notifications = 0;
        service.addListener(() => notifications += 1);

        final status = await service.requestPermission(
          AppPermissionType.locationAlways,
          isOfficer: true,
        );

        expect(
          gateway.requestedTypes,
          contains(AppPermissionType.locationAlways),
        );
        expect(status, PermissionStepStatus.needsSettings);
        expect(
          service.cachedStatuses[AppPermissionType.locationAlways],
          PermissionStepStatus.needsSettings,
        );
        expect(notifications, equals(1));
      },
    );

    test(
      'gateway exception during refreshStatuses or requestPermission degrades to denied without throwing',
      () async {
        gateway.checkErrors.add(AppPermissionType.camera);
        gateway.checkStatuses[AppPermissionType.locationWhenInUse] =
            PermissionStepStatus.granted;
        gateway.checkStatuses[AppPermissionType.notification] =
            PermissionStepStatus.granted;

        final refreshed = await service.refreshStatuses(isOfficer: false);
        expect(refreshed[AppPermissionType.camera], PermissionStepStatus.denied);
        expect(
          refreshed[AppPermissionType.locationWhenInUse],
          PermissionStepStatus.granted,
        );
        expect(service.hasAllRequiredPermissionsSync(isOfficer: false), isFalse);

        gateway.requestErrors.add(AppPermissionType.camera);
        final requested = await service.requestPermission(
          AppPermissionType.camera,
          isOfficer: false,
        );
        expect(requested, PermissionStepStatus.denied);
        expect(
          service.cachedStatuses[AppPermissionType.camera],
          PermissionStepStatus.denied,
        );
      },
    );

    test('openAppSettings delegates to gateway and returns false on exception',
        () async {
      gateway.openSettingsResult = true;
      expect(await service.openAppSettings(), isTrue);
      expect(gateway.openSettingsCalls, equals(1));

      gateway.openSettingsThrows = true;
      expect(await service.openAppSettings(), isFalse);
      expect(gateway.openSettingsCalls, equals(2));
    });

    test(
      'resetCache clears cached statuses, attempted history, and resets sync flag',
      () async {
        gateway.checkStatuses.addAll({
          AppPermissionType.locationWhenInUse: PermissionStepStatus.granted,
          AppPermissionType.camera: PermissionStepStatus.granted,
          AppPermissionType.notification: PermissionStepStatus.granted,
        });

        await service.refreshStatuses(isOfficer: false);
        expect(service.hasAllRequiredPermissionsSync(isOfficer: false), isTrue);

        gateway.requestResults[AppPermissionType.camera] =
            PermissionStepStatus.denied;
        await service.requestPermission(
          AppPermissionType.camera,
          isOfficer: false,
        );

        var notifications = 0;
        service.addListener(() => notifications += 1);

        service.resetCache();

        expect(service.cachedStatuses, isEmpty);
        expect(service.hasAllRequiredPermissionsSync(isOfficer: false), isFalse);
        expect(notifications, equals(1));

        gateway.checkStatuses[AppPermissionType.camera] =
            PermissionStepStatus.denied;
        await service.refreshStatuses(isOfficer: true);
        expect(
          service.cachedStatuses[AppPermissionType.camera],
          PermissionStepStatus.notRequested,
        );
      },
    );
  });
}
