import 'package:akar/core/errors/failures.dart';
import '../entities/tokoh_entity.dart';
import '../entities/institusi_entity.dart';

abstract class DemografiRepository {
  Future<Either<Failure, List<TokohEntity>>> getTokohList();
  Future<Either<Failure, TokohEntity>> addTokoh(TokohEntity entity);

  Future<Either<Failure, List<InstitusiEntity>>> getInstitusiList();
  Future<Either<Failure, InstitusiEntity>> addInstitusi(InstitusiEntity entity);
}
