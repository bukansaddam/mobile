import 'package:akar/core/errors/failures.dart';
import '../entities/tokoh_entity.dart';

abstract class TokohRepository {
  Future<Either<Failure, TokohPaginatedEntity>> getTokohList({
    int? page,
    int? perPage,
    String? label,
    String? field,
    String? name,
    String? affiliations,
    String? professions,
  });

  Future<Either<Failure, TokohEntity>> addTokoh(TokohEntity entity);

  Future<Either<Failure, TokohEntity>> updateTokoh(
    String id,
    TokohEntity entity,
  );
}
