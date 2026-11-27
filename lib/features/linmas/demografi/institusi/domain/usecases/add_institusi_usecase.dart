import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/repositories/institusi_repository.dart';

class AddInstitusiUsecase {
  final InstitusiRepository repository;

  AddInstitusiUsecase(this.repository);

  Future<Either<Failure, InstitusiEntity>> call(InstitusiEntity entity) {
    return repository.addInstitusi(entity);
  }
}
