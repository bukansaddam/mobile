import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  // final PaginationModel? pagination;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    // this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message'] as String?,
      statusCode: json['code'] as int?,
      // pagination: json['pagination'] != null
      //     ? PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>)
      //     : null,
    );
  }
}

/// Base class untuk semua remote data source.
/// Menyediakan helper [handleRequest] dengan error handling terpusat.
abstract class BaseRemoteDataSource {
  final Dio dio = DioClient.instance;

  Future<ApiResponse<T>> handleRequest<T>(
    Future<Response> Function() request, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await request();
      final data = response.data as Map<String, dynamic>?;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message =
            (data?['message'] ?? data?['meta']?['message']) as String?;
        return ApiResponse<T>(
          success: true,
          data: data != null && fromJson != null
              ? fromJson(data['data'] ?? data)
              : null,
          message: message,
          statusCode: response.statusCode,
          // pagination: data?['pagination'] != null
          //     ? PaginationModel.fromJson(
          //         data!['pagination'] as Map<String, dynamic>,
          //       )
          //     : null,
        );
      }
      return ApiResponse<T>(
        success: false,
        message:
            data?['message'] as String? ??
            data?['meta']?['message'] as String? ??
            'Unknown error',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      AppLogger.e('[BASE_DS] DioException: ${e.message}', e, e.stackTrace);
      return ApiResponse<T>(
        success: false,
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e, s) {
      AppLogger.e('[BASE_DS] Unexpected error', e, s);
      return ApiResponse<T>(success: false, message: "error");
    }
  }

  String _parseDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "timeout";
      case DioExceptionType.connectionError:
        return "error";
      case DioExceptionType.badResponse:
        final msg = e.response?.data?['message'] as String?;
        if (msg != null && msg.isNotEmpty) return msg;
        if (e.response?.statusCode == 401) return "unauthorized";
        if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
          return "error";
        }
        return "error";
      default:
        return "error";
    }
  }
}
