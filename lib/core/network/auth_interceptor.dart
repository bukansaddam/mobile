import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/utils/app_logger.dart';

/// Interceptor untuk mendeteksi error otentikasi & otorisasi:
/// - 401 Unauthorized (unauthenticated / session expired)
/// - 403 Forbidden (hak akses dicabut / peran tidak valid)
/// dan secara otomatis melempar pengguna ke halaman login serta membersihkan sesi.
class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      final path = err.requestOptions.path;
      // Hindari auto-logout jika request berasal dari endpoint login atau register
      if (!path.contains(ApiConstants.login) &&
          !path.contains(ApiConstants.register)) {
        AppLogger.w(
          'AuthInterceptor: Sesi dibatalkan karena kode HTTP $statusCode ($path). Memicu Logout.',
        );
        if (sl.isRegistered<AuthBloc>()) {
          sl<AuthBloc>().add(const LogoutEvent());
        }
      }
    }
    handler.next(err);
  }
}
