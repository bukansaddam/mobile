import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemote extends Fake implements AuthRemoteDatasource {
  bool fail = false;
  String? receivedRefreshToken;

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    receivedRefreshToken = refreshToken;
    if (fail) {
      throw Exception('Refresh token tidak valid');
    }
    return AuthModel.fromJson({
      'message': 'Token berhasil diperbarui',
      'access_token': 'new-access',
      'token_type': 'Bearer',
      'user': {'id': 250420, 'name': 'Agus Sunandar', 'role': 'officer'},
    });
  }
}

class _FakeLocal extends Fake implements AuthLocalDatasource {
  String? token;
  DateTime? lastActivityAt;
  String? refreshToken;
  UserModel? user;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> saveToken(String value) async {
    token = value;
    await touchActivity();
  }

  @override
  Future<DateTime?> getLastActivityAt() async => lastActivityAt;

  @override
  Future<void> touchActivity() async {
    lastActivityAt = DateTime.now();
  }

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> saveRefreshToken(String value) async => refreshToken = value;

  @override
  Future<UserModel?> getUser() async => user;

  @override
  Future<void> saveUser(UserModel value) async => user = value;
}

void main() {
  group('AuthRepository refreshToken', () {
    late _FakeRemote remote;
    late _FakeLocal local;
    late AuthRepositoryImpl repository;

    setUp(() {
      remote = _FakeRemote();
      local = _FakeLocal()
        ..token = 'old-access'
        ..lastActivityAt = DateTime.now().subtract(const Duration(hours: 13))
        ..refreshToken = 'old-refresh'
        ..user = UserModel.fromJson({'id': 250420, 'name': 'Nama Lama'});
      repository = AuthRepositoryImpl(
        remoteDatasource: remote,
        localDatasource: local,
      );
    });

    test('menyimpan access token dan user dari respons refresh', () async {
      final result = await repository.refreshToken();

      expect(result.isRight, isTrue);
      expect(result.right.accessToken, 'new-access');
      expect(result.right.user.name, 'Agus Sunandar');
      expect(local.token, 'new-access');
      expect(local.user?.name, 'Agus Sunandar');
      expect(remote.receivedRefreshToken, 'old-refresh');
    });

    test(
      'mempertahankan refresh token lama bila respons tidak mengirimnya',
      () async {
        await repository.refreshToken();

        expect(local.refreshToken, 'old-refresh');
      },
    );

    test('tidak memanggil refresh bila token belum 12 jam', () async {
      local.lastActivityAt = DateTime.now().subtract(const Duration(hours: 11));

      final result = await repository.refreshToken();

      expect(result.right.accessToken, 'old-access');
      expect(local.token, 'old-access');
      expect(remote.receivedRefreshToken, isNull);
    });

    test('memakai sesi tersimpan bila refresh token belum ada', () async {
      local.refreshToken = null;

      final result = await repository.refreshToken();

      expect(result.right.accessToken, 'old-access');
      expect(result.right.user.name, 'Nama Lama');
      expect(remote.receivedRefreshToken, isNull);
    });

    test('mengembalikan failure saat refresh ditolak', () async {
      remote.fail = true;

      final result = await repository.refreshToken();

      expect(result.isLeft, isTrue);
      expect(local.token, 'old-access');
      expect(local.refreshToken, 'old-refresh');
    });
  });
}
