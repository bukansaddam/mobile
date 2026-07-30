import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:dio/dio.dart';

/// Interceptor untuk mendeteksi error 401 Unauthorized (unauthenticated)
/// dan secara otomatis melempar pengguna ke halaman login.
class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;
      // Hindari auto-logout jika request berasal dari endpoint login atau register
      if (!path.contains(ApiConstants.login) &&
          !path.contains(ApiConstants.register)) {
        if (sl.isRegistered<AuthProvider>()) {
          sl<AuthProvider>().logout();
        }
      }
    }
    handler.next(err);
  }
}
