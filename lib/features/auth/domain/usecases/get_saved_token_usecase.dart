import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';

class GetSavedTokenUsecase {
  final AuthRepository repository;

  GetSavedTokenUsecase(this.repository);

  Future<Either<Failure, String?>> call() => repository.getSavedToken();
}
