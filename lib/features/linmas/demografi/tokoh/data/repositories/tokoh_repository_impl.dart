import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';

import 'package:akar/features/linmas/demografi/tokoh/data/mappers/tokoh_mapper.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/repositories/tokoh_repository.dart';
import 'package:akar/features/linmas/demografi/tokoh/data/datasources/tokoh_remote_datasource.dart';

class TokohRepositoryImpl implements TokohRepository {
  final TokohRemoteDatasource remoteDatasource;

  TokohRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, TokohPaginatedEntity>> getTokohList({
    int? page,
    int? perPage,
    String? label,
    String? field,
    String? name,
    String? affiliations,
    String? professions,
  }) async {
    try {
      final res = await remoteDatasource.getTokohList(
        page: page,
        perPage: perPage,
        label: label,
        field: field,
        name: name,
        affiliations: affiliations,
        professions: professions,
      );
      return Right(res.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, TokohEntity>> addTokoh(TokohEntity entity) async {
    try {
      final model = entity.toModel();
      final result = await remoteDatasource.addTokoh(model);
      return Right(result.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, TokohEntity>> updateTokoh(
    String id,
    TokohEntity entity,
  ) async {
    try {
      final model = entity.toModel();
      final result = await remoteDatasource.updateTokoh(id, model);
      return Right(result.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
