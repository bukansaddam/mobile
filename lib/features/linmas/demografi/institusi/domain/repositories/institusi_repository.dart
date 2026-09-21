import 'package:akar/core/errors/failures.dart';
import '../entities/institusi_entity.dart';
import '../entities/institusi_category_entity.dart';

abstract class InstitusiRepository {
  Future<Either<Failure, InstitusiPaginatedEntity>> getInstitusiList({
    int? page,
    int? perPage,
    String? scope,
    String? name,
    String? label,
  });

  Future<Either<Failure, InstitusiEntity>> addInstitusi(InstitusiEntity entity);

  Future<Either<Failure, InstitusiEntity>> updateInstitusi(
    String id,
    InstitusiEntity entity,
  );

  Future<Either<Failure, List<InstitusiCategoryEntity>>> getCategories({
    String domain = 'institution',
  });
}
