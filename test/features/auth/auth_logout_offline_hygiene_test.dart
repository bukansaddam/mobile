import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/network/auth_interceptor.dart';
import 'package:akar/core/offline/offline_master_cache_local_datasource.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/get_saved_user_usecase.dart';
import 'package:akar/features/auth/domain/usecases/login_usecase.dart';
import 'package:akar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:akar/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:akar/features/auth/domain/usecases/register_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLogoutUsecase extends Fake implements LogoutUsecase {
  int callCount = 0;
  @override
  Future<Either<Failure, void>> call() async {
    callCount++;
    return const Right(null);
  }
}

class _FakeLoginUsecase extends Fake implements LoginUsecase {}

class _FakeRegisterUsecase extends Fake implements RegisterUsecase {}

class _FakeGetSavedUserUsecase extends Fake implements GetSavedUserUsecase {}

class _FakeGetSavedTokenUsecase extends Fake implements GetSavedTokenUsecase {}

class _FakeRefreshTokenUsecase extends Fake implements RefreshTokenUsecase {}

class _FakeOfflineQueueDatasource extends Fake
    implements OfflineQueueLocalDatasource {
  final List<String> clearedUsers = [];

  @override
  Future<void> clearForUser(String userId) async {
    clearedUsers.add(userId);
  }
}

class _FakeOfflineMasterCacheDatasource extends Fake
    implements OfflineMasterCacheLocalDatasource {
  int clearAllCalls = 0;

  @override
  Future<void> clearAll() async {
    clearAllCalls++;
  }
}

class _FakeAuthLocalDatasource extends Fake implements AuthLocalDatasource {
  String? userId;

  @override
  String? getCachedUserId() => userId;
}

class _SpyAuthBloc extends Fake implements AuthBloc {
  LogoutEvent? receivedEvent;

  @override
  void add(AuthEvent event) {
    if (event is LogoutEvent) {
      receivedEvent = event;
    }
  }
}

class _FakeErrorHandler extends ErrorInterceptorHandler {
  DioException? errorPassed;

  @override
  void next(DioException err) {
    errorPassed = err;
  }
}

void main() {
  group('LogoutEvent hygiene', () {
    test('LogoutEvent default clearOfflineQueue is true', () {
      const event = LogoutEvent();
      expect(event.clearOfflineQueue, isTrue);
    });

    test(
      'LogoutEvent supports clearOfflineQueue false for 401 token expiry',
      () {
        const event = LogoutEvent(clearOfflineQueue: false);
        expect(event.clearOfflineQueue, isFalse);
      },
    );
  });

  group('AuthBloc logout hygiene with Offline Engine', () {
    late _FakeLogoutUsecase fakeLogoutUsecase;
    late _FakeOfflineQueueDatasource fakeQueueDatasource;
    late _FakeOfflineMasterCacheDatasource fakeMasterCacheDatasource;
    late _FakeAuthLocalDatasource fakeAuthLocalDatasource;
    late AuthBloc authBloc;

    setUp(() {
      fakeLogoutUsecase = _FakeLogoutUsecase();
      fakeQueueDatasource = _FakeOfflineQueueDatasource();
      fakeMasterCacheDatasource = _FakeOfflineMasterCacheDatasource();
      fakeAuthLocalDatasource = _FakeAuthLocalDatasource()..userId = 'user-123';

      if (sl.isRegistered<OfflineQueueLocalDatasource>()) {
        sl.unregister<OfflineQueueLocalDatasource>();
      }
      if (sl.isRegistered<OfflineMasterCacheLocalDatasource>()) {
        sl.unregister<OfflineMasterCacheLocalDatasource>();
      }
      if (sl.isRegistered<AuthLocalDatasource>()) {
        sl.unregister<AuthLocalDatasource>();
      }

      sl.registerSingleton<OfflineQueueLocalDatasource>(fakeQueueDatasource);
      sl.registerSingleton<OfflineMasterCacheLocalDatasource>(
        fakeMasterCacheDatasource,
      );
      sl.registerSingleton<AuthLocalDatasource>(fakeAuthLocalDatasource);

      authBloc = AuthBloc(
        loginUsecase: _FakeLoginUsecase(),
        registerUsecase: _FakeRegisterUsecase(),
        getSavedUserUsecase: _FakeGetSavedUserUsecase(),
        getSavedTokenUsecase: _FakeGetSavedTokenUsecase(),
        logoutUsecase: fakeLogoutUsecase,
        refreshTokenUsecase: _FakeRefreshTokenUsecase(),
      );
    });

    tearDown(() async {
      await authBloc.close();
      if (sl.isRegistered<OfflineQueueLocalDatasource>()) {
        sl.unregister<OfflineQueueLocalDatasource>();
      }
      if (sl.isRegistered<OfflineMasterCacheLocalDatasource>()) {
        sl.unregister<OfflineMasterCacheLocalDatasource>();
      }
      if (sl.isRegistered<AuthLocalDatasource>()) {
        sl.unregister<AuthLocalDatasource>();
      }
    });

    test(
      'clears user queue and master cache when clearOfflineQueue is true',
      () async {
        fakeAuthLocalDatasource.userId = '123';

        authBloc.add(const LogoutEvent(clearOfflineQueue: true));
        await pumpEventQueue();

        expect(fakeQueueDatasource.clearedUsers, contains('123'));
        expect(fakeMasterCacheDatasource.clearAllCalls, equals(1));
        expect(fakeLogoutUsecase.callCount, equals(1));
        expect(authBloc.state, isA<AuthUnauthenticated>());
      },
    );

    test('retains user queue and master cache when clearOfflineQueue is false (401 expiry)', () async {
      fakeAuthLocalDatasource.userId = '123';

      authBloc.add(const LogoutEvent(clearOfflineQueue: false));
      await pumpEventQueue();

      expect(fakeQueueDatasource.clearedUsers, isEmpty);
      expect(fakeMasterCacheDatasource.clearAllCalls, equals(0));
      expect(fakeLogoutUsecase.callCount, equals(1));
      expect(authBloc.state, isA<AuthUnauthenticated>());
    });
  });

  group('AuthInterceptor auto-logout hygiene', () {
    late AuthInterceptor interceptor;
    late _SpyAuthBloc spyAuthBloc;
    late _FakeErrorHandler errorHandler;

    setUp(() {
      interceptor = AuthInterceptor();
      spyAuthBloc = _SpyAuthBloc();
      errorHandler = _FakeErrorHandler();

      if (sl.isRegistered<AuthBloc>()) {
        sl.unregister<AuthBloc>();
      }
      sl.registerSingleton<AuthBloc>(spyAuthBloc);
    });

    tearDown(() {
      if (sl.isRegistered<AuthBloc>()) {
        sl.unregister<AuthBloc>();
      }
    });

    test('triggers LogoutEvent(clearOfflineQueue: false) on HTTP 401', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/complaints'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/complaints'),
          statusCode: 401,
        ),
      );

      interceptor.onError(dioError, errorHandler);

      expect(spyAuthBloc.receivedEvent, isNotNull);
      expect(spyAuthBloc.receivedEvent!.clearOfflineQueue, isFalse);
    });

    test('triggers LogoutEvent(clearOfflineQueue: false) on HTTP 403', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/complaints'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/complaints'),
          statusCode: 403,
        ),
      );

      interceptor.onError(dioError, errorHandler);

      expect(spyAuthBloc.receivedEvent, isNotNull);
      expect(spyAuthBloc.receivedEvent!.clearOfflineQueue, isFalse);
    });
  });
}
