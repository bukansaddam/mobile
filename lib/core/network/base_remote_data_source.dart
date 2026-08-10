import 'package:akar/core/utils/error_utils.dart';
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
      final data = response.data;
      Map<String, dynamic>? dataMap;
      if (data is Map<String, dynamic>) {
        dataMap = data;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message =
            (dataMap?['message'] ?? dataMap?['meta']?['message']) as String?;
        return ApiResponse<T>(
          success: true,
          data: dataMap != null && fromJson != null
              ? fromJson(dataMap['data'] ?? dataMap)
              : null,
          message: message,
          statusCode: response.statusCode,
        );
      }

      final msg =
          dataMap?['message'] as String? ??
          dataMap?['meta']?['message'] as String?;
      return ApiResponse<T>(
        success: false,
        message: msg != null && msg.isNotEmpty ? msg : 'Terjadi Kesalahan',
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
      return ApiResponse<T>(
        success: false,
        message: ErrorUtils.parseErrorMessage(e),
      );
    }
  }

  String _parseDioError(DioException e) {
    return ErrorUtils.parseErrorMessage(e);
  }
}
