import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/profile/domain/entities/update_profile_params.dart';
import 'package:akar/features/profile/domain/repositories/profile_repository.dart';
import 'package:akar/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:akar/features/profile/domain/usecases/update_profile_usecase.dart';

class MockProfileRepository implements ProfileRepository {
  Either<Failure, UserEntity>? getProfileResult;
  Either<Failure, UserEntity>? updateProfileResult;

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    return getProfileResult ??
        const Left(ServerFailure('Mock failure'));
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    return updateProfileResult ??
        const Left(ServerFailure('Mock failure'));
  }
}

void main() {
  const testUser = UserEntity(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    username: 'johndoe',
    phoneNumber: '081234567890',
    nik: '3201234567890001',
    birthDate: '1995-01-01',
    address: 'Jl. Merdeka No. 10',
    profilePic: 'https://example.com/photo.webp',
  );

  group('GetProfileUsecase Tests', () {
    late MockProfileRepository repository;
    late GetProfileUsecase usecase;

    setUp(() {
      repository = MockProfileRepository();
      usecase = GetProfileUsecase(repository);
    });

    test('should return UserEntity on successful profile fetch', () async {
      repository.getProfileResult = const Right(testUser);

      final result = await usecase();

      expect(result.isRight, true);
      expect(result.right, testUser);
    });

    test('should return ServerFailure when getProfile fails', () async {
      repository.getProfileResult =
          const Left(ServerFailure('Gagal memuat profil'));

      final result = await usecase();

      expect(result.isLeft, true);
      expect(result.left.message, 'Gagal memuat profil');
    });
  });

  group('UpdateProfileUsecase Tests', () {
    late MockProfileRepository repository;
    late UpdateProfileUsecase usecase;

    setUp(() {
      repository = MockProfileRepository();
      usecase = UpdateProfileUsecase(repository);
    });

    test('should return UserEntity on successful profile update', () async {
      repository.updateProfileResult = const Right(testUser);

      const params = UpdateProfileParams(
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        phone: '081234567890',
        nik: '3201234567890001',
        birthDate: '1995-01-01',
        address: 'Jl. Merdeka No. 10',
      );

      final result = await usecase(params);

      expect(result.isRight, true);
      expect(result.right, testUser);
    });

    test('should return ServerFailure when updateProfile fails', () async {
      repository.updateProfileResult =
          const Left(ServerFailure('Gagal memperbarui profil'));

      const params = UpdateProfileParams(
        name: 'John Doe',
        username: 'johndoe',
      );

      final result = await usecase(params);

      expect(result.isLeft, true);
      expect(result.left.message, 'Gagal memperbarui profil');
    });
  });
}
