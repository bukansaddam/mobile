import 'package:akar/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'logging_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        sendTimeout: const Duration(milliseconds: AppConstants.sendTimeout),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([LoggingInterceptor()]);

    return dio;
  }

  static void reset() => _dio = null;
}
