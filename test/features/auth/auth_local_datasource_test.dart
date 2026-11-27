import 'package:akar/core/security/secure_token_storage.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AuthLocalDatasourceImpl secure token storage & migration', () {
    test(
      'stores access and refresh tokens in FlutterSecureStorage, not SharedPreferences',
      () async {
        final prefs = await SharedPreferences.getInstance();
        const tokenStorage = SecureTokenStorage();
        final datasource = AuthLocalDatasourceImpl(
          sharedPreferences: prefs,
          tokenStorage: tokenStorage,
        );

        await datasource.saveToken('access-jwt-1');
        await datasource.saveRefreshToken('refresh-jwt-1');

        expect(await datasource.getToken(), 'access-jwt-1');
        expect(await datasource.getRefreshToken(), 'refresh-jwt-1');
        expect(prefs.getString(AuthLocalDatasourceImpl.tokenKey), isNull);
        expect(
          prefs.getString(AuthLocalDatasourceImpl.refreshTokenKey),
          isNull,
        );
        expect(await tokenStorage.readAccessToken(), 'access-jwt-1');
        expect(await tokenStorage.readRefreshToken(), 'refresh-jwt-1');
      },
    );

    test(
      'migrates legacy SharedPreferences tokens one-shot and removes plaintext keys',
      () async {
        SharedPreferences.setMockInitialValues({
          AuthLocalDatasourceImpl.tokenKey: 'legacy-access',
          AuthLocalDatasourceImpl.refreshTokenKey: 'legacy-refresh',
        });
        FlutterSecureStorage.setMockInitialValues({});

        final prefs = await SharedPreferences.getInstance();
        const tokenStorage = SecureTokenStorage();
        final datasource = AuthLocalDatasourceImpl(
          sharedPreferences: prefs,
          tokenStorage: tokenStorage,
        );

        expect(await datasource.getToken(), 'legacy-access');
        expect(await datasource.getRefreshToken(), 'legacy-refresh');

        expect(prefs.getString(AuthLocalDatasourceImpl.tokenKey), isNull);
        expect(
          prefs.getString(AuthLocalDatasourceImpl.refreshTokenKey),
          isNull,
        );
        expect(await tokenStorage.readAccessToken(), 'legacy-access');
        expect(await tokenStorage.readRefreshToken(), 'legacy-refresh');
      },
    );

    test('clearSession clears tokens in secure storage and prefs', () async {
      final prefs = await SharedPreferences.getInstance();
      const tokenStorage = SecureTokenStorage();
      final datasource = AuthLocalDatasourceImpl(
        sharedPreferences: prefs,
        tokenStorage: tokenStorage,
      );

      await datasource.saveToken('access-jwt-2');
      await datasource.saveRefreshToken('refresh-jwt-2');
      await datasource.clearSession();

      expect(await datasource.getToken(), isNull);
      expect(await datasource.getRefreshToken(), isNull);
      expect(await tokenStorage.readAccessToken(), isNull);
      expect(await tokenStorage.readRefreshToken(), isNull);
      expect(await datasource.getLastActivityAt(), isNull);
    });
  });
}
