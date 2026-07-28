import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String username,
    required String password,
  });
  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String phoneNumber,
    required String nik,
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
  Future<Either<Failure, UserEntity?>> getSavedUser();
  Future<Either<Failure, String?>> getSavedToken();
  Future<Either<Failure, void>> logout();
}
