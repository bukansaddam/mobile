import 'dart:convert';

import 'package:akar/core/security/secure_token_storage.dart';
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
  String? getCachedUserId();
  Future<void> clearSession();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;
  final SecureTokenStorage tokenStorage;

  static const String tokenKey = SecureTokenStorage.accessTokenKey;
  static const String lastActivityAtKey = 'CACHED_LAST_ACTIVITY_AT';
  static const String refreshTokenKey = SecureTokenStorage.refreshTokenKey;
  static const String userKey = 'CACHED_USER_DATA';

  AuthLocalDatasourceImpl({
    required this.sharedPreferences,
    SecureTokenStorage? tokenStorage,
  }) : tokenStorage = tokenStorage ?? const SecureTokenStorage();

  @override
  Future<void> saveToken(String token) async {
    await tokenStorage.writeAccessToken(token);
    if (sharedPreferences.containsKey(tokenKey)) {
      await sharedPreferences.remove(tokenKey);
    }
    await touchActivity();
  }

  @override
  Future<String?> getToken() async {
    final secureToken = await tokenStorage.readAccessToken();
    if (secureToken != null && secureToken.isNotEmpty) {
      return secureToken;
    }

    // Migrasi one-shot dari penyimpanan legacy agar sesi user lama tidak terputus.
    final legacyToken = sharedPreferences.getString(tokenKey);
    if (legacyToken != null && legacyToken.isNotEmpty) {
      await tokenStorage.writeAccessToken(legacyToken);
      await sharedPreferences.remove(tokenKey);
      return legacyToken;
    }
    return null;
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
    await tokenStorage.writeRefreshToken(token);
    if (sharedPreferences.containsKey(refreshTokenKey)) {
      await sharedPreferences.remove(refreshTokenKey);
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    final secureRefresh = await tokenStorage.readRefreshToken();
    if (secureRefresh != null && secureRefresh.isNotEmpty) {
      return secureRefresh;
    }

    // Migrasi one-shot dari penyimpanan legacy.
    final legacyRefresh = sharedPreferences.getString(refreshTokenKey);
    if (legacyRefresh != null && legacyRefresh.isNotEmpty) {
      await tokenStorage.writeRefreshToken(legacyRefresh);
      await sharedPreferences.remove(refreshTokenKey);
      return legacyRefresh;
    }
    return null;
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
  String? getCachedUserId() {
    final userJsonString = sharedPreferences.getString(userKey);
    if (userJsonString != null && userJsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(userJsonString);
        return jsonMap['id']?.toString();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearSession() async {
    await tokenStorage.clearTokens();
    await sharedPreferences.remove(tokenKey);
    await sharedPreferences.remove(lastActivityAtKey);
    await sharedPreferences.remove(refreshTokenKey);
    await sharedPreferences.remove(userKey);
  }
}
