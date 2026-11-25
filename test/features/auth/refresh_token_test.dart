import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_user_usecase.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:akar/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemote extends Fake implements AuthRemoteDatasource {
  bool fail = false;
  Object? errorToThrow;
  String? receivedRefreshToken;

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    receivedRefreshToken = refreshToken;
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    if (fail) {
      throw Exception('Refresh token tidak valid');
    }
    return AuthModel.fromJson({
      'message': 'Token berhasil diperbarui',
      'access_token': 'new-access',
      'token_type': 'Bearer',
      'user': {'id': 250420, 'name': 'Agus Sunandar', 'role': 'officer'},
    });
  }
}

class _FakeLocal extends Fake implements AuthLocalDatasource {
  String? token;
  DateTime? lastActivityAt;
  String? refreshToken;
  UserModel? user;
  int clearSessionCalls = 0;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> saveToken(String value) async {
    token = value;
    await touchActivity();
  }

  @override
  Future<DateTime?> getLastActivityAt() async => lastActivityAt;

  @override
  Future<void> touchActivity() async {
    lastActivityAt = DateTime.now();
  }

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> saveRefreshToken(String value) async => refreshToken = value;

  @override
  Future<UserModel?> getUser() async => user;

  @override
  Future<void> saveUser(UserModel value) async => user = value;

  @override
  Future<void> clearSession() async {
    clearSessionCalls++;
    token = null;
    lastActivityAt = null;
    refreshToken = null;
    user = null;
  }
}

void main() {
  group('AuthRepository refreshToken', () {
    late _FakeRemote remote;
    late _FakeLocal local;
    late AuthRepositoryImpl repository;

    setUp(() {
      remote = _FakeRemote();
      local = _FakeLocal()
        ..token = 'old-access'
        ..lastActivityAt = DateTime.now().subtract(const Duration(hours: 13))
        ..refreshToken = 'old-refresh'
        ..user = UserModel.fromJson({'id': 250420, 'name': 'Nama Lama'});
      repository = AuthRepositoryImpl(
        remoteDatasource: remote,
        localDatasource: local,
      );
    });

    test('menyimpan access token dan user dari respons refresh', () async {
      final result = await repository.refreshToken();

      expect(result.isRight, isTrue);
      expect(result.right.accessToken, 'new-access');
      expect(result.right.user.name, 'Agus Sunandar');
      expect(local.token, 'new-access');
      expect(local.user?.name, 'Agus Sunandar');
      expect(remote.receivedRefreshToken, 'old-refresh');
    });

    test(
      'mempertahankan role sesi aktif saat refresh untuk akun multi-role',
      () async {
        local.user = UserModel.fromJson({
          'id': 250420,
          'name': 'Multi Role',
          'role': 'member',
          'village_members_id': 6234204,
        });

        final result = await repository.refreshToken();

        expect(result.isRight, isTrue);
        expect(result.right.user.role, 'member');
        expect(result.right.user.isMember, isTrue);
        expect(local.user?.role, 'member');
      },
    );

    test(
      'mempertahankan refresh token lama bila respons tidak mengirimnya',
      () async {
        await repository.refreshToken();

        expect(local.refreshToken, 'old-refresh');
      },
    );

    test('tidak memanggil refresh bila token belum 12 jam', () async {
      local.lastActivityAt = DateTime.now().subtract(const Duration(hours: 11));

      final result = await repository.refreshToken();

      expect(result.right.accessToken, 'old-access');
      expect(local.token, 'old-access');
      expect(remote.receivedRefreshToken, isNull);
    });

    test('memakai sesi tersimpan bila refresh token belum ada', () async {
      local.refreshToken = null;

      final result = await repository.refreshToken();

      expect(result.right.accessToken, 'old-access');
      expect(result.right.user.name, 'Nama Lama');
      expect(remote.receivedRefreshToken, isNull);
    });

    test('mengembalikan failure saat refresh ditolak', () async {
      remote.fail = true;

      final result = await repository.refreshToken();

      expect(result.isLeft, isTrue);
      expect(local.token, 'old-access');
      expect(local.refreshToken, 'old-refresh');
    });

    test('mengembalikan NetworkFailure saat refresh gagal koneksi', () async {
      remote.errorToThrow = const SocketException('No internet');

      final result = await repository.refreshToken();

      expect(result.isLeft, isTrue);
      expect(result.left, isA<NetworkFailure>());
      expect(result.left.isRetryable, isTrue);
    });
  });

  group('AuthBloc CheckAuthStatusEvent offline resilience', () {
    late _FakeRemote remote;
    late _FakeLocal local;
    late AuthRepositoryImpl repository;
    late AuthBloc authBloc;

    AuthBloc createBloc() {
      return AuthBloc(
        loginUsecase: LoginUsecase(repository),
        registerUsecase: RegisterUsecase(repository),
        getSavedUserUsecase: GetSavedUserUsecase(repository),
        getSavedTokenUsecase: GetSavedTokenUsecase(repository),
        logoutUsecase: LogoutUsecase(repository),
        refreshTokenUsecase: RefreshTokenUsecase(repository),
      );
    }

    setUp(() {
      remote = _FakeRemote();
      local = _FakeLocal()
        ..token = 'cached-access'
        ..lastActivityAt = DateTime.now().subtract(const Duration(hours: 13))
        ..refreshToken = 'cached-refresh'
        ..user = UserModel.fromJson({
          'id': 250420,
          'name': 'Petugas Lapangan',
          'role': 'officer',
        });
      repository = AuthRepositoryImpl(
        remoteDatasource: remote,
        localDatasource: local,
      );
      authBloc = createBloc();
    });

    tearDown(() async {
      await authBloc.close();
    });

    test(
      'mempertahankan sesi offline saat refresh timeout atau SocketException',
      () async {
        remote.errorToThrow = TimeoutException('Timeout 8s');

        final expected = expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthChecking>(),
            isA<AuthAuthenticated>()
                .having((s) => s.token, 'token', 'cached-access')
                .having((s) => s.isOfflineSession, 'isOfflineSession', isTrue),
          ]),
        );

        authBloc.add(const CheckAuthStatusEvent());
        await expected;

        expect(local.clearSessionCalls, 0);
        expect(local.token, 'cached-access');
      },
    );

    test('mempertahankan sesi offline saat server refresh balas 503', () async {
      remote.errorToThrow = DioException(
        requestOptions: RequestOptions(path: '/refresh-token'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/refresh-token'),
          statusCode: 503,
        ),
      );

      final expected = expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthChecking>(),
          isA<AuthAuthenticated>().having(
            (s) => s.isOfflineSession,
            'isOfflineSession',
            isTrue,
          ),
        ]),
      );

      authBloc.add(const CheckAuthStatusEvent());
      await expected;

      expect(local.clearSessionCalls, 0);
    });

    test('tetap logout saat server refresh balas 401 Unauthorized', () async {
      remote.errorToThrow = const UnauthorizedException(
        'Token expired',
        statusCode: 401,
      );

      final expected = expectLater(
        authBloc.stream,
        emitsInOrder([isA<AuthChecking>(), isA<AuthUnauthenticated>()]),
      );

      authBloc.add(const CheckAuthStatusEvent());
      await expected;

      expect(local.clearSessionCalls, 1);
      expect(local.token, isNull);
    });

    test('tidak menganggap HandshakeException sebagai offline', () async {
      remote.errorToThrow = const HandshakeException('Certificate verify fail');

      final expected = expectLater(
        authBloc.stream,
        emitsInOrder([isA<AuthChecking>(), isA<AuthUnauthenticated>()]),
      );

      authBloc.add(const CheckAuthStatusEvent());
      await expected;

      expect(local.clearSessionCalls, 1);
    });
  });
}
