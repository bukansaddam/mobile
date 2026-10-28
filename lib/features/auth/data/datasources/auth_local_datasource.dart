import 'dart:convert';

import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<DateTime?> getLastActivityAt();
  Future<void> touchActivity();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearSession();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;

  static const String tokenKey = 'CACHED_AUTH_TOKEN';
  static const String lastActivityAtKey = 'CACHED_LAST_ACTIVITY_AT';
  static const String refreshTokenKey = 'CACHED_REFRESH_TOKEN';
  static const String userKey = 'CACHED_USER_DATA';

  AuthLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(tokenKey, token);
    await touchActivity();
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(tokenKey);
  }

  @override
  Future<DateTime?> getLastActivityAt() async {
    final millis = sharedPreferences.getInt(lastActivityAtKey);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  Future<void> touchActivity() async {
    await sharedPreferences.setInt(
      lastActivityAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await sharedPreferences.setString(refreshTokenKey, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(refreshTokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJsonString = jsonEncode(user.toJson());
    await sharedPreferences.setString(userKey, userJsonString);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJsonString = sharedPreferences.getString(userKey);
    if (userJsonString != null && userJsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(userJsonString);
        return UserModel.fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearSession() async {
    await sharedPreferences.remove(tokenKey);
    await sharedPreferences.remove(lastActivityAtKey);
    await sharedPreferences.remove(refreshTokenKey);
    await sharedPreferences.remove(userKey);
  }
}
