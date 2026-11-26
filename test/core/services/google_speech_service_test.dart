import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/services/google_speech_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHttpClientAdapter implements HttpClientAdapter {
  RequestOptions? lastOptions;
  int callCount = 0;
  Future<ResponseBody> Function(RequestOptions options)? onFetch;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    lastOptions = options;
    if (onFetch != null) {
      return onFetch!(options);
    }
    return _jsonResponse({
      'success': true,
      'data': {'transcript': ''},
    });
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
  late GoogleSpeechService service;

  setUp(() {
    adapter = _FakeHttpClientAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.httpClientAdapter = adapter;
    service = GoogleSpeechService(dio: dio);
  });

  group('GoogleSpeechService backend proxy', () {
    test(
      'returns empty string without network call when audioBytes is empty',
      () async {
        final result = await service.transcribeAudioBytes(const <int>[]);

        expect(result, isEmpty);
        expect(adapter.callCount, 0);
      },
    );

    test('posts multipart WAV audio to speechTranscribe and parses nested data.transcript', () async {
      adapter.onFetch = (_) async => _jsonResponse({
        'success': true,
        'data': {'transcript': '  Situasi aman terkendali  '},
      });

      final result = await service.transcribeAudioBytes(const <int>[
        1,
        2,
        3,
        4,
      ], sampleRateHertz: 16000);

      expect(result, 'Situasi aman terkendali');
      expect(adapter.lastOptions?.method, 'POST');
      expect(adapter.lastOptions?.path, ApiConstants.speechTranscribe);
      expect(adapter.lastOptions?.data, isA<FormData>());
      final formData = adapter.lastOptions!.data as FormData;
      expect(formData.files.any((entry) => entry.key == 'audio'), isTrue);
      expect(
        formData.fields.any(
          (entry) => entry.key == 'language_code' && entry.value == 'id-ID',
        ),
        isTrue,
      );
    });

    test('parses flat transcript and null transcript safely', () async {
      adapter.onFetch = (_) async => _jsonResponse({'transcript': 'Aman'});
      expect(await service.transcribeAudioBytes(const <int>[1, 2]), 'Aman');

      adapter.onFetch = (_) async => _jsonResponse({
        'data': {'transcript': null},
      });
      expect(await service.transcribeAudioBytes(const <int>[1, 2]), isEmpty);
    });

    test(
      'throws friendly ServerException when backend proxy returns 404 or 501',
      () async {
        for (final statusCode in [404, 501]) {
          adapter.onFetch = (_) async =>
              _jsonResponse({'message': 'Not found'}, statusCode: statusCode);

          await expectLater(
            service.transcribeAudioBytes(const <int>[1, 2, 3]),
            throwsA(
              isA<ServerException>()
                  .having((e) => e.statusCode, 'statusCode', statusCode)
                  .having(
                    (e) => e.message,
                    'message',
                    'Fitur dikte suara sedang dalam pemeliharaan. Silakan ketik keterangan secara manual.',
                  ),
            ),
          );
        }
      },
    );

    test('maps server error to AppException', () async {
      adapter.onFetch = (_) async =>
          _jsonResponse({'message': 'Server sibuk'}, statusCode: 500);

      await expectLater(
        service.transcribeAudioBytes(const <int>[1, 2, 3]),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('Security regression guard (#1)', () {
    test(
      'pubspec.yaml does not bundle service account JSON or GCP auth packages',
      () {
        final pubspec = File('pubspec.yaml').readAsStringSync();

        expect(pubspec.contains('lib/core/crd'), isFalse);
        expect(pubspec.contains('akar-504702'), isFalse);
        expect(pubspec.contains('googleapis_auth'), isFalse);
        expect(pubspec.contains('google_speech'), isFalse);
        expect(
          File('lib/core/crd/akar-504702-d2d27b0e66f2.json').existsSync(),
          isFalse,
        );
      },
    );
  });
}
