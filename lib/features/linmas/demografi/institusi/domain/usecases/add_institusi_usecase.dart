import 'package:akar/core/errors/failures.dart';
import '../entities/institusi_entity.dart';
import '../repositories/institusi_repository.dart';

class AddInstitusiUsecase {
  final InstitusiRepository repository;

  AddInstitusiUsecase(this.repository);

  Future<Either<Failure, InstitusiEntity>> call(InstitusiEntity entity) {
    return repository.addInstitusi(entity);
  }
}
