import 'dart:convert';
import 'dart:typed_data';

import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Interceptor untuk logging semua network request dan response.
class LoggingInterceptor extends Interceptor {
  static const _stopwatchKey = '_loggingStopwatch';
  static const _maxLogLineLength = 800;
  static const _jsonEncoder = JsonEncoder.withIndent('  ', _toStringFallback);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppLogger.isProduction) {
      handler.next(options);
      return;
    }

    options.extra[_stopwatchKey] = Stopwatch()..start();

    AppLogger.d('''
╔════ REQUEST ════════════════════════════
║ ${options.method} ${options.uri}
║ Headers: ${options.headers}
║ Data: ${options.data}
╚═════════════════════════════════════════''');
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
      '║ Data:\n'
      '${_formatData(response.data)}\n'
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
      '║ Data:\n'
      '${_formatData(err.response?.data)}\n'
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

    String raw;
    if (data is String) {
      raw = _tryPrettyJsonString(data);
    } else if (data is Map || data is Iterable) {
      try {
        raw = _jsonEncoder.convert(data);
      } catch (_) {
        raw = data.toString();
      }
    } else {
      raw = data.toString();
    }

    return _chunkLines(raw, _maxLogLineLength);
  }

  static String _tryPrettyJsonString(String input) {
    final trimmed = input.trim();
    final looksJson =
        (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'));
    if (!looksJson) return input;
    try {
      return _jsonEncoder.convert(jsonDecode(trimmed));
    } catch (_) {
      return input;
    }
  }

  static Object? _toStringFallback(dynamic object) => object.toString();

  static String _chunkLines(String text, int maxLength) {
    final lines = <String>[];
    for (final line in text.split('\n')) {
      if (line.length <= maxLength) {
        lines.add(line);
        continue;
      }
      for (var i = 0; i < line.length; i += maxLength) {
        final end = i + maxLength < line.length ? i + maxLength : line.length;
        lines.add(line.substring(i, end));
      }
    }
    return lines.join('\n');
  }
}
