import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';

class GetSavedUserUsecase {
  final AuthRepository repository;

  GetSavedUserUsecase(this.repository);

  Future<Either<Failure, UserEntity?>> call() => repository.getSavedUser();
}
