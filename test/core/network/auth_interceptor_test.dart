import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/network/auth_interceptor.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';

class _FakeAuthBloc extends Fake implements AuthBloc {
  bool logoutCalled = false;

  @override
  void add(AuthEvent event) {
    if (event is LogoutEvent) {
      logoutCalled = true;
    }
  }
}

class _TestHandler extends ErrorInterceptorHandler {
  DioException? errorPassed;

  @override
  void next(DioException err) {
    errorPassed = err;
  }
}

void main() {
  late AuthInterceptor interceptor;
  late _FakeAuthBloc fakeAuthBloc;
  late _TestHandler testHandler;

  setUp(() {
    interceptor = AuthInterceptor();
    fakeAuthBloc = _FakeAuthBloc();
    testHandler = _TestHandler();

    if (sl.isRegistered<AuthBloc>()) {
      sl.unregister<AuthBloc>();
    }
    sl.registerSingleton<AuthBloc>(fakeAuthBloc);
  });

  tearDown(() {
    if (sl.isRegistered<AuthBloc>()) {
      sl.unregister<AuthBloc>();
    }
  });

  test('triggers LogoutEvent on 401 Unauthorized', () {
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/api/profile'),
      response: Response(
        requestOptions: RequestOptions(path: '/api/profile'),
        statusCode: 401,
      ),
    );

    interceptor.onError(dioError, testHandler);

    expect(fakeAuthBloc.logoutCalled, isTrue);
    expect(testHandler.errorPassed, equals(dioError));
  });

  test('triggers LogoutEvent on 403 Forbidden', () {
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/api/profile'),
      response: Response(
        requestOptions: RequestOptions(path: '/api/profile'),
        statusCode: 403,
      ),
    );

    interceptor.onError(dioError, testHandler);

    expect(fakeAuthBloc.logoutCalled, isTrue);
    expect(testHandler.errorPassed, equals(dioError));
  });

  test('does not trigger LogoutEvent on login endpoint 401/403', () {
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/api/login'),
      response: Response(
        requestOptions: RequestOptions(path: '/api/login'),
        statusCode: 401,
      ),
    );

    interceptor.onError(dioError, testHandler);

    expect(fakeAuthBloc.logoutCalled, isFalse);
    expect(testHandler.errorPassed, equals(dioError));
  });
}
