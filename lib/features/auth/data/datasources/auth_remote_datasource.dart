import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/utils/app_logger.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> login({
    required String username,
    required String password,
    String? deviceId,
  });
  Future<AuthModel> refreshToken(String refreshToken);
  Future<AuthModel> register({
    required String name,
    required String phoneNumber,
    required String nik,
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceId,
  });
}

class AuthRemoteDatasourceImpl extends BaseRemoteDataSource
    implements AuthRemoteDatasource {
  @override
  Future<AuthModel> login({
    required String username,
    required String password,
    String? deviceId,
  }) async {
    final Map<String, dynamic> requestData = {
      'username': username,
      'password': password,
      if (deviceId != null && deviceId.isNotEmpty) 'device_id': deviceId,
    };

    try {
      final response = await handleRequest<AuthModel>(
        () => dio.post(ApiConstants.login, data: requestData),
        fromJson: _parseAuthModel,
      );

      if (response.success && response.data != null) {
        final authModel = response.data!;
        if (authModel.message == null && response.message != null) {
          return authModel.copyWith(message: response.message);
        }
        return authModel;
      } else {
        throw Exception(response.message ?? 'Login gagal');
      }
    } on DioException catch (e) {
      AppLogger.e('[AUTH_DS] DioException: ${e.message}', e, e.stackTrace);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[AUTH_DS] Unexpected error: $e', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    try {
      final response = await handleRequest<AuthModel>(
        () => dio.post(
          ApiConstants.refreshToken,
          data: {'refresh_token': refreshToken},
        ),
        fromJson: _parseAuthModel,
      );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw Exception(response.message ?? 'Refresh token gagal');
    } on DioException catch (e) {
      AppLogger.e(
        '[AUTH_DS] Refresh DioException: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[AUTH_DS] Refresh unexpected error: $e', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String phoneNumber,
    required String nik,
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceId,
  }) async {
    final Map<String, dynamic> requestData = {
      'name': name,
      'phone': phoneNumber,
      'nik': nik,
      'longitude': longitude,
      'latitude': latitude,
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (deviceId != null && deviceId.isNotEmpty) 'device_id': deviceId,
    };

    try {
      final response = await handleRequest<AuthModel>(
        () => dio.post(ApiConstants.register, data: requestData),
        fromJson: _parseAuthModel,
      );

      if (response.success && response.data != null) {
        final authModel = response.data!;
        if (authModel.message == null && response.message != null) {
          return authModel.copyWith(message: response.message);
        }
        return authModel;
      } else {
        throw Exception(response.message ?? 'Registrasi gagal');
      }
    } on DioException catch (e) {
      AppLogger.e('[AUTH_DS] DioException: ${e.message}', e, e.stackTrace);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[AUTH_DS] Unexpected error: $e', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }

  AuthModel _parseAuthModel(dynamic json) {
    final map = Map<String, dynamic>.from(json as Map);
    if (!map.containsKey('access_token') && map.containsKey('token')) {
      map['access_token'] = map['token'];
    }
    final rootCompleted = map['is_initial_quiz_completed'];
    final rootFilled = map['is_initial_quiz_filled'];
    if (map['user'] is Map) {
      final userMap = Map<String, dynamic>.from(map['user'] as Map);
      if (!userMap.containsKey('is_initial_quiz_completed') &&
          rootCompleted != null) {
        userMap['is_initial_quiz_completed'] = rootCompleted;
      }
      if (!userMap.containsKey('is_initial_quiz_filled') &&
          rootFilled != null) {
        userMap['is_initial_quiz_filled'] = rootFilled;
      }
      map['user'] = userMap;
    }
    return AuthModel.fromJson(map);
  }
}
