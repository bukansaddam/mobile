import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call() => repository.getProfile();
}
