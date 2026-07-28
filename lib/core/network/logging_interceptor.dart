import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Interceptor untuk logging semua network request dan response.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
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
    AppLogger.i('''
╔════ RESPONSE ═══════════════════════════
║ Status: ${response.statusCode}
║ URL: ${response.requestOptions.uri}
║ Data: ${response.data}
╚═════════════════════════════════════════''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
    handler.next(err);
  }
}
