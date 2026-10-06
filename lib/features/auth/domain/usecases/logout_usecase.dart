import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() => repository.logout();
}
