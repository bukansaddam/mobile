import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:akar/core/network/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.onFetch);

  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => onFetch(options);

  @override
  void close({bool force = false}) {}
}

class _PassThroughResponseHandler extends ResponseInterceptorHandler {
  @override
  void next(Response response) {}
}

void main() {
  test('logs request duration and complete raw OCR JSON without truncation', () async {
    final longRawLine = 'RAW_LINE_${'X' * 1200}_TAIL_MARKER';
    final payload = {
      'success': true,
      'message': 'Dokumen berhasil dipindai.',
      'data': {
        'document_type': 'ktp',
        'nik': '3271063010020008',
        'raw_texts': ['PROVINSI JAWA BARAT', longRawLine],
        'all_fields': {'nama': 'BUDI SANTOSO', 'nik': '3271063010020008'},
      },
    };

    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = _FakeAdapter((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 25));
        return ResponseBody.fromString(
          jsonEncode(payload),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      })
      ..interceptors.add(LoggingInterceptor());

    final lines = <String>[];
    await runZoned(
      () => dio.post('/api/ocr/scan'),
      zoneSpecification: ZoneSpecification(
        print: (_, _, _, line) => lines.add(line),
      ),
    );

    final joined = lines.join('\n');
    expect(joined, contains('Duration:'));
    expect(joined, contains('ms ('));
    expect(joined, contains('"document_type": "ktp"'));
    expect(joined, contains('"nama": "BUDI SANTOSO"'));
    expect(joined, contains('TAIL_MARKER'));
    for (final line in lines) {
      expect(line.length, lessThanOrEqualTo(900));
    }
  });

  test('logs duration and raw error body on DioException', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = _FakeAdapter((_) async {
        return ResponseBody.fromString(
          jsonEncode({'success': false, 'message': 'OCR timeout'}),
          504,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      })
      ..interceptors.add(LoggingInterceptor());

    final lines = <String>[];
    await expectLater(
      runZoned(
        () => dio.post('/api/ocr/scan'),
        zoneSpecification: ZoneSpecification(
          print: (_, _, _, line) => lines.add(line),
        ),
      ),
      throwsA(isA<DioException>()),
    );

    final joined = lines.join('\n');
    expect(joined, contains('Duration:'));
    expect(joined, contains('"message": "OCR timeout"'));
  });

  test('handles binary payload and missing stopwatch safely', () async {
    final interceptor = LoggingInterceptor();
    final response = Response(
      requestOptions: RequestOptions(path: '/api/file'),
      statusCode: 200,
      data: Uint8List.fromList([1, 2, 3, 4]),
    );

    final lines = <String>[];
    runZoned(
      () => interceptor.onResponse(response, _PassThroughResponseHandler()),
      zoneSpecification: ZoneSpecification(
        print: (_, _, _, line) => lines.add(line),
      ),
    );

    final joined = lines.join('\n');
    expect(joined, contains('<binary Uint8List>'));
    expect(joined, isNot(contains('Duration:')));
  });
}
