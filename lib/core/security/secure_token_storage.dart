import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Penyimpanan terenkripsi untuk token autentikasi (access & refresh token).
class SecureTokenStorage {
  static const String accessTokenKey = 'CACHED_AUTH_TOKEN';
  static const String refreshTokenKey = 'CACHED_REFRESH_TOKEN';

  static const FlutterSecureStorage _defaultStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final FlutterSecureStorage _storage;

  const SecureTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? _defaultStorage;

  Future<void> writeAccessToken(String token) =>
      _storage.write(key: accessTokenKey, value: token);

  Future<String?> readAccessToken() => _storage.read(key: accessTokenKey);

  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: refreshTokenKey, value: token);

  Future<String?> readRefreshToken() => _storage.read(key: refreshTokenKey);

  Future<void> clearTokens() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
  }
}
