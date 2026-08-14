import 'package:akar/core/errors/failures.dart';
import '../entities/institusi_entity.dart';
import '../repositories/demografi_repository.dart';

class GetInstitusiListUsecase {
  final DemografiRepository repository;

  GetInstitusiListUsecase(this.repository);

  Future<Either<Failure, List<InstitusiEntity>>> call() {
    return repository.getInstitusiList();
  }
}
