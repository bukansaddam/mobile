import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/network/auth_interceptor.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
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

class _FakeLocal extends Fake implements AuthLocalDatasource {
  int touchCount = 0;

  @override
  Future<void> touchActivity() async => touchCount++;
}

class _TestHandler extends ErrorInterceptorHandler {
  DioException? errorPassed;

  @override
  void next(DioException err) {
    errorPassed = err;
  }
}

class _ResponseHandler extends ResponseInterceptorHandler {
  Response? responsePassed;

  @override
  void next(Response response) {
    responsePassed = response;
  }
}

void main() {
  late AuthInterceptor interceptor;
  late _FakeAuthBloc fakeAuthBloc;
  late _FakeLocal fakeLocal;
  late _TestHandler testHandler;

  setUp(() {
    interceptor = AuthInterceptor();
    fakeAuthBloc = _FakeAuthBloc();
    fakeLocal = _FakeLocal();
    testHandler = _TestHandler();

    if (sl.isRegistered<AuthBloc>()) {
      sl.unregister<AuthBloc>();
    }
    if (sl.isRegistered<AuthLocalDatasource>()) {
      sl.unregister<AuthLocalDatasource>();
    }
    sl.registerSingleton<AuthBloc>(fakeAuthBloc);
    sl.registerSingleton<AuthLocalDatasource>(fakeLocal);
  });

  tearDown(() {
    if (sl.isRegistered<AuthBloc>()) {
      sl.unregister<AuthBloc>();
    }
    if (sl.isRegistered<AuthLocalDatasource>()) {
      sl.unregister<AuthLocalDatasource>();
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

  test('mencatat aktivitas dan membatasi tulisan berdekatan', () {
    final options = RequestOptions(
      path: '/api/profile',
      headers: {'Authorization': 'Bearer token'},
    );
    final response = Response(requestOptions: options, statusCode: 200);
    final handler = _ResponseHandler();

    interceptor.onResponse(response, handler);
    interceptor.onResponse(response, handler);

    expect(fakeLocal.touchCount, 1);
    expect(handler.responsePassed, response);
  });

  test('tidak mencatat aktivitas tanpa Authorization', () {
    final options = RequestOptions(path: '/api/news');
    final response = Response(requestOptions: options, statusCode: 200);

    interceptor.onResponse(response, _ResponseHandler());

    expect(fakeLocal.touchCount, 0);
  });
}
