import '../../../../core/errors/failures.dart';
import '../entities/tokoh_entity.dart';
import '../repositories/demografi_repository.dart';

class AddTokohUsecase {
  final DemografiRepository repository;

  AddTokohUsecase(this.repository);

  Future<Either<Failure, TokohEntity>> call(TokohEntity entity) {
    return repository.addTokoh(entity);
  }
}
