import 'dart:convert';
import 'dart:typed_data';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/services/app_update_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeHttpClientAdapter implements HttpClientAdapter {
  RequestOptions? lastOptions;
  Future<ResponseBody> Function(RequestOptions options)? onFetch;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    if (onFetch != null) {
      return onFetch!(options);
    }
    return _jsonResponse({'success': true, 'message': 'OK', 'data': {}});
  }
}

ResponseBody _jsonResponse(Map<String, dynamic> body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  late Dio dio;
  late _FakeHttpClientAdapter adapter;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    adapter = _FakeHttpClientAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.httpClientAdapter = adapter;
  });

  group('compareSemanticVersions', () {
    test('compares multi-digit semver, prefixes, build suffixes, and 2-part versions', () {
      expect(compareSemanticVersions('1.10.0', '1.2.0'), greaterThan(0));
      expect(compareSemanticVersions('1.2.0', '1.10.0'), lessThan(0));
      expect(compareSemanticVersions('v1.2.0+5', '1.2.0'), equals(0));
      expect(compareSemanticVersions('1.2', '1.1.9'), greaterThan(0));
      expect(compareSemanticVersions('0.1.0', '1.0.0'), lessThan(0));
      expect(compareSemanticVersions('invalid', '1.0.0'), isNull);
      expect(compareSemanticVersions('1.0.0', ''), isNull);
    });
  });

  group('AppUpdateService.checkForUpdate', () {
    test('requests platform query and returns optional AppUpdateInfo when newer version exists', () async {
      adapter.onFetch = (_) async => _jsonResponse({
        'success': true,
        'message': 'Data versi aplikasi berhasil diambil.',
        'data': {
          'platform': 'android',
          'version': '1.1.0',
          'min_version': '1.0.0',
          'is_must_update': false,
          'download_url': 'https://akaraslinmas.id/download/android',
        },
      });

      final service = AppUpdateService(
        dio: dio,
        prefs: prefs,
        currentVersionProvider: () async => '1.0.0',
        platformProvider: () => 'android',
      );

      final result = await service.checkForUpdate();

      expect(adapter.lastOptions?.method, 'GET');
      expect(adapter.lastOptions?.path, ApiConstants.appVersion);
      expect(adapter.lastOptions?.queryParameters['platform'], 'android');
      expect(result, isNotNull);
      expect(result!.currentVersion, '1.0.0');
      expect(result.latestVersion, '1.1.0');
      expect(result.minVersion, '1.0.0');
      expect(result.isMustUpdate, isFalse);
      expect(result.isForceUpdate, isFalse);
      expect(result.downloadUrl, 'https://akaraslinmas.id/download/android');
    });

    test('enforces force update when current version is below min_version even if is_must_update is false', () async {
      adapter.onFetch = (_) async => _jsonResponse({
        'success': true,
        'message': 'OK',
        'data': {
          'platform': 'android',
          'version': '1.2.0',
          'min_version': '1.1.0',
          'is_must_update': false,
          'download_url': 'https://akaraslinmas.id/download/android',
        },
      });

      final service = AppUpdateService(
        dio: dio,
        prefs: prefs,
        currentVersionProvider: () async => '1.0.0',
        platformProvider: () => 'android',
      );

      final result = await service.checkForUpdate();

      expect(result, isNotNull);
      expect(result!.isForceUpdate, isTrue);
    });

    test(
      'supports omitted min_version and falls back to is_must_update',
      () async {
        adapter.onFetch = (_) async => _jsonResponse({
          'success': true,
          'message': 'OK',
          'data': {
            'platform': 'ios',
            'version': '1.1.0',
            'is_must_update': true,
            'download_url': 'https://akaraslinmas.id/download/ios',
          },
        });

        final service = AppUpdateService(
          dio: dio,
          prefs: prefs,
          currentVersionProvider: () async => '1.0.0',
          platformProvider: () => 'ios',
        );

        final result = await service.checkForUpdate();

        expect(result, isNotNull);
        expect(result!.minVersion, isNull);
        expect(result.isForceUpdate, isTrue);
      },
    );

    test('returns null when already up to date, error, success false, or unsafe download_url', () async {
      final cases = <Future<ResponseBody> Function(RequestOptions)>[
        (_) async => _jsonResponse({
          'success': true,
          'message': 'Up to date',
          'data': {
            'platform': 'android',
            'version': '1.0.0',
            'is_must_update': false,
            'download_url': 'https://akaraslinmas.id/download/android',
          },
        }),
        (_) async => _jsonResponse({
          'success': false,
          'message': 'Disabled',
          'data': null,
        }),
        (_) async => _jsonResponse({'message': 'Not Found'}, statusCode: 404),
        (_) async => _jsonResponse({
          'success': true,
          'message': 'Bad URL',
          'data': {
            'platform': 'android',
            'version': '1.2.0',
            'is_must_update': true,
            'download_url': 'javascript:alert(1)',
          },
        }),
        (_) async => _jsonResponse({
          'success': true,
          'message': 'Insecure HTTP',
          'data': {
            'platform': 'android',
            'version': '1.2.0',
            'is_must_update': false,
            'download_url': 'http://akaraslinmas.id/app.apk',
          },
        }),
      ];

      for (final handler in cases) {
        adapter.onFetch = handler;
        final service = AppUpdateService(
          dio: dio,
          prefs: prefs,
          currentVersionProvider: () async => '1.0.0',
          platformProvider: () => 'android',
          allowInsecureHttp: false,
        );
        expect(await service.checkForUpdate(), isNull);
      }
    });

    test('respects 24h cooldown for optional updates and re-prompts after 24h or on newer version', () async {
      var now = DateTime(2026, 11, 26, 10, 0);
      var serverVersion = '1.1.0';
      var isMustUpdate = false;

      adapter.onFetch = (_) async => _jsonResponse({
        'success': true,
        'message': 'OK',
        'data': {
          'platform': 'android',
          'version': serverVersion,
          'is_must_update': isMustUpdate,
          'download_url': 'https://akaraslinmas.id/download/android',
        },
      });

      final service = AppUpdateService(
        dio: dio,
        prefs: prefs,
        currentVersionProvider: () async => '1.0.0',
        platformProvider: () => 'android',
        nowProvider: () => now,
      );

      expect(await service.checkForUpdate(), isNotNull);

      await service.dismissOptionalUpdate('1.1.0');

      // 23 hours later: still suppressed for 1.1.0
      now = now.add(const Duration(hours: 23));
      expect(await service.checkForUpdate(), isNull);

      // Server releases newer version 1.2.0 within cooldown: immediately shown
      serverVersion = '1.2.0';
      final newer = await service.checkForUpdate();
      expect(newer?.latestVersion, '1.2.0');

      // Back to 1.1.0 after 24h1m: re-shown
      serverVersion = '1.1.0';
      now = now.add(const Duration(hours: 1, minutes: 1));
      final expired = await service.checkForUpdate();
      expect(expired?.latestVersion, '1.1.0');

      // Force update ignores dismissal cooldown
      await service.dismissOptionalUpdate('1.1.0');
      isMustUpdate = true;
      final forced = await service.checkForUpdate();
      expect(forced?.isForceUpdate, isTrue);
    });
  });
}
