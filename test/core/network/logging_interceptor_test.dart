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

class _PassThroughRequestHandler extends RequestInterceptorHandler {
  @override
  void next(RequestOptions requestOptions) {}
}

void main() {
  test('logs request duration and truncates oversized JSON response', () async {
    final longRawLine = 'RAW_LINE_${'X' * 1200}_TAIL_MARKER';
    final payload = {
      'success': true,
      'message': 'Dokumen berhasil dipindai.',
      'data': {
        'document_type': 'ktp',
        'raw_texts': ['PROVINSI JAWA BARAT', longRawLine],
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
    expect(joined, contains('"document_type":"ktp"'));
    expect(joined, contains('(truncated,'));
    expect(joined, isNot(contains('TAIL_MARKER')));
  });

  test('caps multi-line response bodies so logs stay compact', () async {
    final multiLinePayload = List.generate(30, (i) => 'line_$i').join('\n');
    final interceptor = LoggingInterceptor();
    final response = Response(
      requestOptions: RequestOptions(path: '/api/multiline'),
      statusCode: 200,
      data: multiLinePayload,
    );

    final lines = <String>[];
    runZoned(
      () => interceptor.onResponse(response, _PassThroughResponseHandler()),
      zoneSpecification: ZoneSpecification(
        print: (_, _, _, line) => lines.add(line),
      ),
    );

    final joined = lines.join('\n');
    expect(joined, contains('line_0'));
    expect(joined, contains('(truncated,'));
    expect(joined, isNot(contains('line_29')));
  });

  test('logs duration and error body on DioException', () async {
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
    expect(joined, contains('"message":"OCR timeout"'));
  });

  test('handles binary, FormData, and missing stopwatch safely', () async {
    final interceptor = LoggingInterceptor();
    final formData = FormData.fromMap({'note': 'test'});
    final response = Response(
      requestOptions: RequestOptions(path: '/api/file', data: formData),
      statusCode: 200,
      data: Uint8List.fromList([1, 2, 3, 4]),
    );

    final lines = <String>[];
    runZoned(
      () {
        interceptor.onRequest(
          response.requestOptions,
          _PassThroughRequestHandler(),
        );
        interceptor.onResponse(response, _PassThroughResponseHandler());
      },
      zoneSpecification: ZoneSpecification(
        print: (_, _, _, line) => lines.add(line),
      ),
    );

    final noStopwatchLines = <String>[];
    runZoned(
      () => interceptor.onResponse(
        Response(
          requestOptions: RequestOptions(path: '/api/no-timer'),
          statusCode: 200,
          data: 'ok',
        ),
        _PassThroughResponseHandler(),
      ),
      zoneSpecification: ZoneSpecification(
        print: (_, _, _, line) => noStopwatchLines.add(line),
      ),
    );

    final joined = lines.join('\n');
    expect(joined, contains('<FormData fields:1 files:0>'));
    expect(joined, contains('<binary Uint8List>'));
    expect(joined, contains('Duration:'));
    expect(noStopwatchLines.join('\n'), isNot(contains('Duration:')));
  });
}
