import 'package:flutter/foundation.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Interceptor untuk logging semua network request dan response.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kReleaseMode) {
      AppLogger.d('''
╔════ REQUEST ════════════════════════════
║ ${options.method} ${options.uri}
║ Headers: ${options.headers}
║ Data: ${options.data}
╚═════════════════════════════════════════''');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kReleaseMode) {
      AppLogger.i('[API] sudah terkirim (Status: ${response.statusCode})');
    } else {
      AppLogger.i('''
╔════ RESPONSE ═══════════════════════════
║ Status: ${response.statusCode}
║ URL: ${response.requestOptions.uri}
║ Data: ${response.data}
╚═════════════════════════════════════════''');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kReleaseMode) {
      final status = err.response?.statusCode;
      AppLogger.e(
        '[API] : gagal terkirim (Status: ${status ?? err.type.name})',
      );
    } else {
      AppLogger.e(
        '''
╔════ ERROR ══════════════════════════════
║ Status: ${err.response?.statusCode}
║ URL: ${err.requestOptions.uri}
║ Message: ${err.message}
║ Data: ${err.response?.data}
╚═════════════════════════════════════════''',
        err,
        err.stackTrace,
      );
    }
    handler.next(err);
  }
}
