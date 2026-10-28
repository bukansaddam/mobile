import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Refresh sekali untuk semua 401 yang menunggu (QueuedInterceptor), lalu
/// mengulang request aslinya. Gagal refresh diteruskan ke [AuthInterceptor].
class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({required this.dio, Dio? refreshDio})
    : _refreshDio = refreshDio ?? Dio(dio.options);

  final Dio dio;
  final Dio _refreshDio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        request.extra['retried'] == true ||
        _isAuthPath(request.path)) {
      return handler.next(err);
    }

    if (!sl.isRegistered<AuthLocalDatasource>()) {
      return handler.next(err);
    }

    final local = sl<AuthLocalDatasource>();
    final refreshToken = await local.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return handler.next(err);
    }

    final currentToken = await local.getToken();
    // 401 lain di antrean: token sudah diperbarui, cukup ulangi request.
    if (currentToken != null &&
        request.headers['Authorization'] != 'Bearer $currentToken') {
      return _retry(request, currentToken, handler);
    }

    try {
      final response = await _refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      final authModel = _parseAuthModel(response.data);

      await local.saveToken(authModel.accessToken);
      final nextRefreshToken = authModel.refreshToken;
      if (nextRefreshToken != null && nextRefreshToken.isNotEmpty) {
        await local.saveRefreshToken(nextRefreshToken);
      }
      await local.saveUser(authModel.user);

      dio.options.headers['Authorization'] = 'Bearer ${authModel.accessToken}';
      return await _retry(request, authModel.accessToken, handler);
    } catch (e) {
      AppLogger.w('TokenRefreshInterceptor: refresh gagal ($e)');
      return handler.next(err);
    }
  }

  Future<void> _retry(
    RequestOptions request,
    String accessToken,
    ErrorInterceptorHandler handler,
  ) async {
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.extra['retried'] = true;
    try {
      handler.resolve(await dio.fetch(request));
    } catch (e) {
      handler.next(
        e is DioException ? e : DioException(requestOptions: request, error: e),
      );
    }
  }

  bool _isAuthPath(String path) =>
      path.contains(ApiConstants.login) ||
      path.contains(ApiConstants.register) ||
      path.contains(ApiConstants.refreshToken);

  AuthModel _parseAuthModel(Object? data) {
    if (data is! Map) {
      throw const FormatException('Respons refresh tidak valid');
    }
    final map = Map<String, dynamic>.from(data);
    final nested = map['data'];
    return AuthModel.fromJson(
      nested is Map ? Map<String, dynamic>.from(nested) : map,
    );
  }
}
