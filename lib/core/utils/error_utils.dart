import 'package:dio/dio.dart';

class ErrorUtils {
  ErrorUtils._();

  /// Mengubah berbagai jenis error/exception (seperti DioException status 500, HTML response,
  /// timeout, dsb) menjadi pesan ringkas yang ramah pengguna.
  /// Jika terjadi error 500 / HTML response / server error, me-return "Terjadi Kesalahan".
  static String parseErrorMessage(dynamic error) {
    if (error == null) return "Terjadi Kesalahan";

    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      // Status code 5xx Server Error -> Terjadi Kesalahan
      if (statusCode != null && statusCode >= 500) {
        return "Terjadi Kesalahan";
      }

      final rawData = error.response?.data;

      // Bila response data berupa HTML string -> Terjadi Kesalahan
      if (rawData is String && _isHtml(rawData)) {
        return "Terjadi Kesalahan";
      }

      // Bila response data berupa JSON Map
      if (rawData is Map<String, dynamic>) {
        final serverMsg = (rawData['message'] ?? rawData['meta']?['message'])
            ?.toString();
        if (serverMsg != null && serverMsg.trim().isNotEmpty) {
          if (_isHtml(serverMsg) || _isTechnicalError(serverMsg)) {
            return "Terjadi Kesalahan";
          }
          return serverMsg;
        }
      }

      if (statusCode == 401) {
        return "Sesi telah berakhir, silakan login ulang";
      }

      if (statusCode == 422) {
        return "Format data tidak valid";
      }

      // Exception message atau string representation check
      final errStr = error.toString();
      if (_isHtml(errStr) || _isTechnicalError(errStr)) {
        return "Terjadi Kesalahan";
      }

      return "Terjadi Kesalahan";
    }

    if (error is String) {
      if (_isHtml(error) || _isTechnicalError(error)) {
        return "Terjadi Kesalahan";
      }
      return error;
    }

    final str = error.toString();
    if (_isHtml(str) || _isTechnicalError(str)) {
      return "Terjadi Kesalahan";
    }

    final cleaned = str.replaceAll('Exception: ', '').trim();
    if (cleaned.isEmpty || _isTechnicalError(cleaned)) {
      return "Terjadi Kesalahan";
    }

    return cleaned;
  }

  static bool _isHtml(String text) {
    final lower = text.toLowerCase();
    return lower.contains('<html') ||
        lower.contains('<!doctype html') ||
        lower.contains('<head') ||
        lower.contains('<body') ||
        lower.contains('<title') ||
        lower.contains('<div') ||
        lower.contains('<p>');
  }

  static bool _isTechnicalError(String text) {
    final lower = text.toLowerCase();
    return lower.contains('status code of 500') ||
        lower.contains('status code of 5') ||
        lower.contains('validatestatus') ||
        lower.contains('dioexception') ||
        lower.contains('server error') ||
        lower.contains('internal server error') ||
        lower.contains('requestoptions');
  }
}
