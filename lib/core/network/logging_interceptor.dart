import 'dart:convert';
import 'dart:typed_data';

import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Interceptor untuk logging ringkas network request dan response.
class LoggingInterceptor extends Interceptor {
  static const _stopwatchKey = '_loggingStopwatch';
  static const _maxBodyChars = 500;
  static const _maxBodyLines = 10;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppLogger.isProduction) {
      handler.next(options);
      return;
    }

    options.extra[_stopwatchKey] = Stopwatch()..start();

    AppLogger.d(
      '╔════ REQUEST ════════════════════════════\n'
      '║ ${options.method} ${options.uri}\n'
      '║ Data: ${_formatData(options.data)}\n'
      '╚═════════════════════════════════════════',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppLogger.isProduction) {
      handler.next(response);
      return;
    }

    AppLogger.i(
      '╔════ RESPONSE ═══════════════════════════\n'
      '║ Status: ${response.statusCode}${_takeDurationLine(response.requestOptions)}\n'
      '║ URL: ${response.requestOptions.uri}\n'
      '║ Data: ${_formatData(response.data)}\n'
      '╚═════════════════════════════════════════',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppLogger.isProduction) {
      handler.next(err);
      return;
    }

    AppLogger.e(
      '╔════ ERROR ══════════════════════════════\n'
      '║ Status: ${err.response?.statusCode}${_takeDurationLine(err.requestOptions)}\n'
      '║ URL: ${err.requestOptions.uri}\n'
      '║ Message: ${err.message}\n'
      '║ Data: ${_formatData(err.response?.data)}\n'
      '╚═════════════════════════════════════════',
      err,
      err.stackTrace,
    );
    handler.next(err);
  }

  static String _takeDurationLine(RequestOptions options) {
    final raw = options.extra.remove(_stopwatchKey);
    if (raw is! Stopwatch) return '';
    raw.stop();
    final ms = raw.elapsedMilliseconds;
    return '\n║ Duration: $ms ms (${(ms / 1000).toStringAsFixed(2)} s)';
  }

  static String _formatData(dynamic data) {
    if (data == null) return 'null';
    if (data is Uint8List || data is ResponseBody) {
      return '<binary ${data.runtimeType}>';
    }
    if (data is FormData) {
      return '<FormData fields:${data.fields.length} files:${data.files.length}>';
    }

    String raw;
    if (data is String) {
      raw = data.trim();
    } else if (data is Map || data is Iterable) {
      try {
        raw = jsonEncode(data, toEncodable: _toStringFallback);
      } catch (_) {
        raw = data.toString();
      }
    } else {
      raw = data.toString();
    }

    return _truncate(raw);
  }

  static Object? _toStringFallback(dynamic object) => object.toString();

  static String _truncate(String text) {
    final sample = text.length > _maxBodyChars
        ? text.substring(0, _maxBodyChars)
        : text;
    final lines = sample.split('\n');
    final overLines = lines.length > _maxBodyLines;
    final overChars = text.length > _maxBodyChars;

    if (!overLines && !overChars) return sample;

    final preview = overLines ? lines.take(_maxBodyLines).join('\n') : sample;
    return '$preview... (truncated, ${text.length} chars)';
  }
}
