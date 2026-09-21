import 'package:akar/core/errors/failures.dart';
import '../entities/institusi_entity.dart';
import '../repositories/institusi_repository.dart';

class UpdateInstitusiUsecase {
  final InstitusiRepository repository;

  UpdateInstitusiUsecase(this.repository);

  Future<Either<Failure, InstitusiEntity>> call({
    required String id,
    required InstitusiEntity entity,
  }) {
    return repository.updateInstitusi(id, entity);
  }
}
