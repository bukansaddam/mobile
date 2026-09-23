import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../../domain/entities/institusi_category_entity.dart';
import '../../domain/entities/institusi_mapper.dart';
import '../../domain/repositories/institusi_repository.dart';
import '../datasources/institusi_remote_datasource.dart';

class InstitusiRepositoryImpl implements InstitusiRepository {
  final InstitusiRemoteDatasource remoteDatasource;

  InstitusiRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, InstitusiPaginatedEntity>> getInstitusiList({
    int? page,
    int? perPage,
    String? scope,
    String? name,
    String? label,
  }) async {
    try {
      final res = await remoteDatasource.getInstitusiList(
        page: page,
        perPage: perPage,
        scope: scope,
        name: name,
        label: label,
      );
      return Right(res.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, InstitusiEntity>> addInstitusi(
    InstitusiEntity entity,
  ) async {
    try {
      final model = entity.toModel();
      final result = await remoteDatasource.addInstitusi(model);
      return Right(result.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, InstitusiEntity>> updateInstitusi(
    String id,
    InstitusiEntity entity,
  ) async {
    try {
      final model = entity.toModel();
      final result = await remoteDatasource.updateInstitusi(id, model);
      return Right(result.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<InstitusiCategoryEntity>>> getCategories({
    String domain = 'institution',
  }) async {
    try {
      final result = await remoteDatasource.getCategories(domain: domain);
      return Right(result.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
