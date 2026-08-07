import '../../../../core/errors/failures.dart';
import '../entities/tokoh_entity.dart';
import '../repositories/profiling_repository.dart';

class GetTokohListUsecase {
  final ProfilingRepository repository;

  GetTokohListUsecase(this.repository);

  Future<Either<Failure, List<TokohEntity>>> call() {
    return repository.getTokohList();
  }
}
