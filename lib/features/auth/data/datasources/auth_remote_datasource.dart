import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> login({
    required String username,
    required String password,
    String? deviceId,
  });
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
    };
    if (deviceId != null && deviceId.isNotEmpty) {
      requestData['device_id'] = deviceId;
    }

    debugPrint('[Debug] Login Request Data: ${requestData.toString()}');

    final response = await handleRequest<Map<String, dynamic>>(() async {
      return await dio.post(ApiConstants.login, data: requestData);
    }, fromJson: (json) => json as Map<String, dynamic>);

    if (response.success && response.data != null) {
      final map = Map<String, dynamic>.from(response.data!);
      if (!map.containsKey('access_token') && map.containsKey('token')) {
        map['access_token'] = map['token'];
      }
      if (!map.containsKey('message') && response.message != null) {
        map['message'] = response.message;
      }
      return AuthModel.fromJson(map);
    } else {
      throw Exception(response.message ?? 'Login gagal');
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
    };
    if (deviceId != null && deviceId.isNotEmpty) {
      requestData['device_id'] = deviceId;
    }

    final response = await handleRequest<Map<String, dynamic>>(() async {
      return await dio.post(ApiConstants.register, data: requestData);
    }, fromJson: (json) => json as Map<String, dynamic>);

    if (response.success && response.data != null) {
      final map = Map<String, dynamic>.from(response.data!);
      if (!map.containsKey('access_token') && map.containsKey('token')) {
        map['access_token'] = map['token'];
      }
      if (!map.containsKey('message') && response.message != null) {
        map['message'] = response.message;
      }
      return AuthModel.fromJson(map);
    } else {
      throw Exception(response.message ?? 'Registrasi gagal');
    }
  }
}
