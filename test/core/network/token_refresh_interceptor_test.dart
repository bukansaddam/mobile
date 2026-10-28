import 'dart:convert';
import 'dart:typed_data';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/network/token_refresh_interceptor.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLocal extends Fake implements AuthLocalDatasource {
  String? token;
  String? refreshToken;
  UserModel? user;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> saveToken(String value) async => token = value;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> saveRefreshToken(String value) async => refreshToken = value;

  @override
  Future<void> saveUser(UserModel value) async => user = value;
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.onRequest);

  final ResponseBody Function(RequestOptions options) onRequest;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    return onRequest(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, int statusCode) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  const refreshBody = {
    'success': true,
    'message': 'Token berhasil diperbarui',
    'access_token': 'new-access',
    'token_type': 'Bearer',
    'user': {'id': 250420, 'name': 'Agus Sunandar'},
  };

  late _FakeLocal local;
  late Dio dio;
  late _FakeAdapter mainAdapter;
  late _FakeAdapter refreshAdapter;
  late int refreshStatus;

  setUp(() {
    refreshStatus = 200;
    local = _FakeLocal()
      ..token = 'old-access'
      ..refreshToken = 'refresh-1';

    if (sl.isRegistered<AuthLocalDatasource>()) {
      sl.unregister<AuthLocalDatasource>();
    }
    sl.registerSingleton<AuthLocalDatasource>(local);

    mainAdapter = _FakeAdapter((options) {
      if (options.headers['Authorization'] == 'Bearer old-access') {
        return _json({'message': 'Unauthenticated.'}, 401);
      }
      return _json({'success': true}, 200);
    });
    refreshAdapter = _FakeAdapter((_) => _json(refreshBody, refreshStatus));

    dio = Dio(BaseOptions(baseUrl: 'https://test.local'));
    dio.httpClientAdapter = mainAdapter;
    dio.options.headers['Authorization'] = 'Bearer old-access';

    final refreshDio = Dio(BaseOptions(baseUrl: 'https://test.local'));
    refreshDio.httpClientAdapter = refreshAdapter;

    dio.interceptors.add(
      TokenRefreshInterceptor(dio: dio, refreshDio: refreshDio),
    );
  });

  tearDown(() {
    if (sl.isRegistered<AuthLocalDatasource>()) {
      sl.unregister<AuthLocalDatasource>();
    }
  });

  test('refresh lalu ulangi request saat 401', () async {
    final response = await dio.get('/api/profile');

    expect(response.statusCode, 200);
    expect(refreshAdapter.calls, 1);
    expect(local.token, 'new-access');
    expect(local.user?.name, 'Agus Sunandar');
    expect(dio.options.headers['Authorization'], 'Bearer new-access');
  });

  test(
    'mempertahankan refresh token lama bila respons tidak mengirimnya',
    () async {
      await dio.get('/api/profile');

      expect(local.refreshToken, 'refresh-1');
    },
  );

  test('dua 401 bersamaan hanya memicu satu refresh', () async {
    final responses = await Future.wait([
      dio.get('/api/profile'),
      dio.get('/api/news'),
    ]);

    expect(responses.every((response) => response.statusCode == 200), isTrue);
    expect(refreshAdapter.calls, 1);
  });

  test('tanpa refresh token, error 401 diteruskan', () async {
    local.refreshToken = null;

    await expectLater(dio.get('/api/profile'), throwsA(isA<DioException>()));
    expect(refreshAdapter.calls, 0);
  });

  test('refresh ditolak, error asli diteruskan', () async {
    refreshStatus = 401;

    await expectLater(dio.get('/api/profile'), throwsA(isA<DioException>()));
    expect(local.token, 'old-access');
  });
}
