import '../../../../core/errors/failures.dart';
import '../entities/tokoh_entity.dart';

abstract class DemografiRepository {
  Future<Either<Failure, List<TokohEntity>>> getTokohList();
  Future<Either<Failure, TokohEntity>> addTokoh(TokohEntity entity);
}
