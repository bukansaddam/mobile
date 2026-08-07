import '../../../../core/errors/failures.dart';
import '../entities/tokoh_entity.dart';
import '../repositories/profiling_repository.dart';

class AddTokohUsecase {
  final ProfilingRepository repository;

  AddTokohUsecase(this.repository);

  Future<Either<Failure, TokohEntity>> call(TokohEntity entity) {
    return repository.addTokoh(entity);
  }
}
