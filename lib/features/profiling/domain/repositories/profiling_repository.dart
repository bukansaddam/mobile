import '../../../../core/errors/failures.dart';
import '../entities/tokoh_entity.dart';

abstract class ProfilingRepository {
  Future<Either<Failure, List<TokohEntity>>> getTokohList();
  Future<Either<Failure, TokohEntity>> addTokoh(TokohEntity entity);
}
