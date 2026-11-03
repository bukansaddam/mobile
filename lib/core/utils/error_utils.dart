import 'dart:convert';

import 'package:dio/dio.dart';

class ErrorUtils {
  ErrorUtils._();

  /// Membersihkan prefix teknis (Exception/Failure) dari pesan error.
  static String cleanExceptionMessage(String message) {
    var text = message.trim();
    final prefixRegex = RegExp(
      r'^(_?[A-Za-z0-9_]*Exception|Failure|ServerFailure|DioException(\s*\[[^\]]*\])?):\s*',
      caseSensitive: false,
    );
    while (prefixRegex.hasMatch(text)) {
      text = text.replaceFirst(prefixRegex, '').trim();
    }
    return text;
  }

  /// Mengubah berbagai jenis error/exception (seperti DioException status 500, HTML response,
  /// timeout, dsb) menjadi pesan ringkas yang ramah pengguna.
  /// Jika terjadi error 500 / HTML response / server error, me-return "Terjadi Kesalahan".
  static String parseErrorMessage(dynamic error) {
    if (error == null) return "Terjadi Kesalahan";

    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      if (statusCode != null && statusCode >= 500) {
        return "Terjadi Kesalahan";
      }

      dynamic rawData = error.response?.data;

      if (rawData is String) {
        if (_isHtml(rawData)) return "Terjadi Kesalahan";
        try {
          final decoded = jsonDecode(rawData);
          if (decoded is Map) rawData = decoded;
        } catch (_) {}
      }

      if (rawData is Map) {
        final mapData = Map<String, dynamic>.from(rawData);
        final validationErrors = _extractValidationErrors(mapData);
        final serverMsg = (mapData['message'] ?? mapData['meta']?['message'])
            ?.toString();

        if (validationErrors != null && validationErrors.isNotEmpty) {
          final cleanVal = cleanExceptionMessage(validationErrors);
          if (serverMsg != null &&
              serverMsg.trim().isNotEmpty &&
              !_isHtml(serverMsg) &&
              !_isTechnicalError(serverMsg) &&
              serverMsg.toLowerCase() != 'validation failed' &&
              serverMsg.toLowerCase() != 'the given data was invalid.' &&
              serverMsg.toLowerCase() != 'format data tidak valid') {
            return cleanExceptionMessage('$serverMsg: $cleanVal');
          }
          return cleanVal;
        }

        if (serverMsg != null && serverMsg.trim().isNotEmpty) {
          if (_isHtml(serverMsg) || _isTechnicalError(serverMsg)) {
            return "Terjadi Kesalahan";
          }
          return cleanExceptionMessage(serverMsg);
        }
      }

      if (statusCode == 401) {
        return "Sesi telah berakhir, silakan login ulang";
      }

      if (statusCode == 422) {
        return "Format data tidak valid";
      }

      final errStr = error.toString();
      if (_isHtml(errStr) || _isTechnicalError(errStr)) {
        return "Terjadi Kesalahan";
      }

      final cleanedErr = cleanExceptionMessage(errStr);
      if (cleanedErr.isNotEmpty && !_isTechnicalError(cleanedErr)) {
        return cleanedErr;
      }

      return "Terjadi Kesalahan";
    }

    if (error is Map) {
      final mapData = Map<String, dynamic>.from(error);
      final validationErrors = _extractValidationErrors(mapData);
      if (validationErrors != null && validationErrors.isNotEmpty) {
        return cleanExceptionMessage(validationErrors);
      }
      final msg = (mapData['message'] ?? mapData['meta']?['message'])
          ?.toString();
      if (msg != null && msg.trim().isNotEmpty) {
        return cleanExceptionMessage(msg);
      }
    }

    final str = error.toString();
    if (_isHtml(str) || _isTechnicalError(str)) {
      return "Terjadi Kesalahan";
    }

    final cleaned = cleanExceptionMessage(str);
    if (cleaned.isEmpty || _isTechnicalError(cleaned)) {
      return "Terjadi Kesalahan";
    }

    return cleaned;
  }

  static String? _extractValidationErrors(Map<String, dynamic> data) {
    dynamic errors =
        data['errors'] ??
        (data['data'] is Map ? (data['data'] as Map)['errors'] : null) ??
        (data['meta'] is Map ? (data['meta'] as Map)['errors'] : null);

    if (errors == null &&
        data['data'] is Map &&
        (data['data'] as Map)['errors'] == null) {
      final msg = data['message']?.toString().toLowerCase() ?? '';
      if (msg.contains('validat')) {
        errors = data['data'];
      }
    }

    if (errors == null) return null;

    if (errors is Map) {
      final List<String> messages = [];
      errors.forEach((key, val) {
        if (val is List) {
          for (final item in val) {
            if (item != null && item.toString().trim().isNotEmpty) {
              messages.add(item.toString().trim());
            }
          }
        } else if (val is String && val.trim().isNotEmpty) {
          messages.add(val.trim());
        } else if (val is Map) {
          val.forEach((_, subVal) {
            if (subVal != null && subVal.toString().trim().isNotEmpty) {
              messages.add(subVal.toString().trim());
            }
          });
        } else if (val != null) {
          messages.add(val.toString().trim());
        }
      });
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    } else if (errors is List) {
      final messages = errors
          .where((e) => e != null && e.toString().trim().isNotEmpty)
          .map((e) => e.toString().trim())
          .toList();
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    } else if (errors is String && errors.trim().isNotEmpty) {
      return errors.trim();
    }

    return null;
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
