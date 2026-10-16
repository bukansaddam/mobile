import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/profile/domain/entities/update_profile_params.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, UserEntity>> updateProfile(UpdateProfileParams params);
}
