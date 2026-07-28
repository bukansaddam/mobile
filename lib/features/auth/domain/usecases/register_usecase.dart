import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, AuthEntity>> call({
    required String name,
    required String phoneNumber,
    required String nik,
    required double longitude,
    required double latitude,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await repository.register(
      name: name,
      phoneNumber: phoneNumber,
      nik: nik,
      longitude: longitude,
      latitude: latitude,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
