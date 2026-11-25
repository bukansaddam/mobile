import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_user_usecase.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:akar/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/permissions/data/services/app_permission_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/domain/services/permission_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

class _NoopPermissionGateway implements PermissionGateway {
  @override
  Future<PermissionStepStatus> checkStatus(AppPermissionType type) async =>
      PermissionStepStatus.granted;

  @override
  Future<PermissionStepStatus> request(AppPermissionType type) async =>
      PermissionStepStatus.granted;

  @override
  Future<bool> openSettings() async => true;
}

class _SpyPermissionService extends AppPermissionService {
  _SpyPermissionService() : super(gateway: _NoopPermissionGateway());

  final List<bool> refreshOfficerFlags = [];
  int resetCacheCalls = 0;
  Completer<void>? refreshGate;

  @override
  Future<Map<AppPermissionType, PermissionStepStatus>> refreshStatuses({
    required bool isOfficer,
  }) async {
    refreshOfficerFlags.add(isOfficer);
    if (refreshGate != null) {
      await refreshGate!.future;
    }
    return super.refreshStatuses(isOfficer: isOfficer);
  }

  @override
  void resetCache() {
    resetCacheCalls++;
    super.resetCache();
  }
}

class _FakeLoginUsecase extends Fake implements LoginUsecase {
  Either<Failure, AuthEntity>? result;

  @override
  Future<Either<Failure, AuthEntity>> call({
    required String username,
    required String password,
    String? deviceId,
    bool isOfficer = false,
  }) async {
    return result!;
  }
}

class _FakeRegisterUsecase extends Fake implements RegisterUsecase {
  Either<Failure, AuthEntity>? result;

  @override
  Future<Either<Failure, AuthEntity>> call({
    required String name,
    required String phoneNumber,
    required String nik,
    String birthPlace = '',
    String birthDate = '',
    String address = '',
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String otpChallengeToken = '',
    String otpCode = '',
    File? ktpPhoto,
    String? deviceId,
  }) async {
    return result!;
  }
}

class _FakeGetSavedUserUsecase extends Fake implements GetSavedUserUsecase {
  Either<Failure, UserEntity?> result = const Right(null);

  @override
  Future<Either<Failure, UserEntity?>> call() async => result;
}

class _FakeGetSavedTokenUsecase extends Fake implements GetSavedTokenUsecase {
  Either<Failure, String?> result = const Right(null);

  @override
  Future<Either<Failure, String?>> call() async => result;
}

class _FakeLogoutUsecase extends Fake implements LogoutUsecase {
  @override
  Future<Either<Failure, void>> call() async => const Right(null);
}

class _FakeRefreshTokenUsecase extends Fake implements RefreshTokenUsecase {
  Either<Failure, AuthEntity> result = const Left(
    NetworkFailure('Offline'),
  );

  @override
  Future<Either<Failure, AuthEntity>> call() async => result;
}

void main() {
  late _FakeLoginUsecase loginUsecase;
  late _FakeRegisterUsecase registerUsecase;
  late _FakeGetSavedUserUsecase getSavedUserUsecase;
  late _FakeGetSavedTokenUsecase getSavedTokenUsecase;
  late _FakeLogoutUsecase logoutUsecase;
  late _FakeRefreshTokenUsecase refreshTokenUsecase;
  late _SpyPermissionService permissionService;
  late AuthBloc authBloc;

  const officerUser = UserEntity(
    id: 1,
    name: 'Petugas Linmas',
    role: 'officer',
  );
  const memberUser = UserEntity(
    id: 2,
    name: 'Warga Masyarakat',
    role: 'member',
  );

  setUp(() {
    loginUsecase = _FakeLoginUsecase();
    registerUsecase = _FakeRegisterUsecase();
    getSavedUserUsecase = _FakeGetSavedUserUsecase();
    getSavedTokenUsecase = _FakeGetSavedTokenUsecase();
    logoutUsecase = _FakeLogoutUsecase();
    refreshTokenUsecase = _FakeRefreshTokenUsecase();
    permissionService = _SpyPermissionService();

    authBloc = AuthBloc(
      loginUsecase: loginUsecase,
      registerUsecase: registerUsecase,
      getSavedUserUsecase: getSavedUserUsecase,
      getSavedTokenUsecase: getSavedTokenUsecase,
      logoutUsecase: logoutUsecase,
      refreshTokenUsecase: refreshTokenUsecase,
      permissionService: permissionService,
    );
  });

  tearDown(() async {
    await authBloc.close();
  });

  group('AuthBloc permission sync', () {
    test(
      'CheckAuthStatusEvent (online refresh) awaits refreshStatuses(isOfficer: true) before emitting AuthAuthenticated',
      () async {
        final gate = Completer<void>();
        permissionService.refreshGate = gate;
        getSavedTokenUsecase.result = const Right('cached-token');
        getSavedUserUsecase.result = const Right(officerUser);
        refreshTokenUsecase.result = const Right(
          AuthEntity(accessToken: 'fresh-token', user: officerUser),
        );

        authBloc.add(const CheckAuthStatusEvent());
        await pumpEventQueue();

        expect(permissionService.refreshOfficerFlags, [true]);
        expect(authBloc.state, isA<AuthChecking>());

        gate.complete();
        await pumpEventQueue();

        expect(authBloc.state, isA<AuthAuthenticated>());
        final state = authBloc.state as AuthAuthenticated;
        expect(state.token, 'fresh-token');
        expect(state.isOfflineSession, isFalse);
      },
    );

    test(
      'CheckAuthStatusEvent (offline retryable fallback) awaits refreshStatuses(isOfficer: false) before emitting AuthAuthenticated(isOfflineSession: true)',
      () async {
        final gate = Completer<void>();
        permissionService.refreshGate = gate;
        getSavedTokenUsecase.result = const Right('cached-token');
        getSavedUserUsecase.result = const Right(memberUser);
        refreshTokenUsecase.result = const Left(
          NetworkFailure('No internet'),
        );

        authBloc.add(const CheckAuthStatusEvent());
        await pumpEventQueue();

        expect(permissionService.refreshOfficerFlags, [false]);
        expect(authBloc.state, isA<AuthChecking>());

        gate.complete();
        await pumpEventQueue();

        expect(authBloc.state, isA<AuthAuthenticated>());
        final state = authBloc.state as AuthAuthenticated;
        expect(state.token, 'cached-token');
        expect(state.isOfflineSession, isTrue);
      },
    );

    test(
      'LoginEvent awaits refreshStatuses(isOfficer: true) before emitting AuthAuthenticated',
      () async {
        final gate = Completer<void>();
        permissionService.refreshGate = gate;
        loginUsecase.result = const Right(
          AuthEntity(accessToken: 'login-token', user: officerUser),
        );

        authBloc.add(
          const LoginEvent(
            username: 'officer1',
            password: 'secret',
            deviceId: 'device-1',
          ),
        );
        await pumpEventQueue();

        expect(permissionService.refreshOfficerFlags, [true]);
        expect(authBloc.state, isA<AuthLoading>());

        gate.complete();
        await pumpEventQueue();

        expect(authBloc.state, isA<AuthAuthenticated>());
        final state = authBloc.state as AuthAuthenticated;
        expect(state.token, 'login-token');
      },
    );

    test(
      'RegisterEvent (when access token returned) awaits refreshStatuses(isOfficer: false) before emitting AuthAuthenticated',
      () async {
        final gate = Completer<void>();
        permissionService.refreshGate = gate;
        registerUsecase.result = const Right(
          AuthEntity(accessToken: 'register-token', user: memberUser),
        );

        authBloc.add(
          const RegisterEvent(
            name: 'Warga',
            phoneNumber: '08123456789',
            nik: '1234567890123456',
            longitude: 106.8,
            latitude: -6.2,
            username: 'warga1',
            email: 'warga1@example.com',
            password: 'secret',
            passwordConfirmation: 'secret',
            deviceId: 'device-2',
          ),
        );
        await pumpEventQueue();

        expect(permissionService.refreshOfficerFlags, [false]);
        expect(authBloc.state, isA<AuthLoading>());

        gate.complete();
        await pumpEventQueue();

        expect(authBloc.state, isA<AuthAuthenticated>());
        final state = authBloc.state as AuthAuthenticated;
        expect(state.token, 'register-token');
      },
    );

    test(
      'LogoutEvent calls permissionService.resetCache() before emitting AuthLoading and before AuthUnauthenticated',
      () async {
        await permissionService.refreshStatuses(isOfficer: true);
        expect(permissionService.hasAllRequiredPermissionsSync(isOfficer: true), isTrue);

        int? resetCallsAtLoading;
        bool? hasAllAtLoading;
        final sub = authBloc.stream.listen((state) {
          if (state is AuthLoading) {
            resetCallsAtLoading = permissionService.resetCacheCalls;
            hasAllAtLoading =
                permissionService.hasAllRequiredPermissionsSync(isOfficer: true);
          }
        });
        addTearDown(sub.cancel);

        authBloc.add(const LogoutEvent(clearOfflineQueue: false));
        await pumpEventQueue();

        expect(resetCallsAtLoading, equals(1));
        expect(hasAllAtLoading, isFalse);
        expect(permissionService.resetCacheCalls, equals(2));
        expect(
          permissionService.hasAllRequiredPermissionsSync(isOfficer: true),
          isFalse,
        );
        expect(authBloc.state, isA<AuthUnauthenticated>());
      },
    );
  });
}
