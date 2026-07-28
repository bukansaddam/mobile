import 'dart:convert';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearSession();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;

  static const String tokenKey = 'CACHED_AUTH_TOKEN';
  static const String userKey = 'CACHED_USER_DATA';

  AuthLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(tokenKey);
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
    await sharedPreferences.remove(userKey);
  }
}
