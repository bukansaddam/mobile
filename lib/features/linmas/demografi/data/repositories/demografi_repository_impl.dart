import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../../domain/entities/institusi_mapper.dart';
import '../../domain/entities/tokoh_mapper.dart';
import '../../domain/repositories/demografi_repository.dart';
import '../datasources/demografi_remote_datasource.dart';

class DemografiRepositoryImpl implements DemografiRepository {
  final DemografiRemoteDatasource remoteDatasource;

  DemografiRepositoryImpl({required this.remoteDatasource});

  // ------------------ Tokoh ------------------
  @override
  Future<Either<Failure, List<TokohEntity>>> getTokohList() async {
    try {
      final list = await remoteDatasource.getTokohList();
      return Right(list.map((m) => m.toDomain()).toList());
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

  // ------------------ Institusi ------------------
  @override
  Future<Either<Failure, List<InstitusiEntity>>> getInstitusiList() async {
    try {
      final list = await remoteDatasource.getInstitusiList();
      return Right(list.map((m) => m.toDomain()).toList());
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
}
