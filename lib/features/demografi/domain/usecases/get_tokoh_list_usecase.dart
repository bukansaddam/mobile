import '../../../../core/errors/failures.dart';
import '../entities/tokoh_entity.dart';
import '../repositories/demografi_repository.dart';

class GetTokohListUsecase {
  final DemografiRepository repository;

  GetTokohListUsecase(this.repository);

  Future<Either<Failure, List<TokohEntity>>> call() {
    return repository.getTokohList();
  }
}
