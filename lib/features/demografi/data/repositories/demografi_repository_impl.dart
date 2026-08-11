import '../../../../core/errors/failures.dart';
import '../../../../core/utils/error_utils.dart';
import '../../domain/entities/tokoh_entity.dart';
import '../../domain/entities/institusi_entity.dart';
import '../../domain/entities/organisasi_entity.dart';
import '../../domain/repositories/demografi_repository.dart';
import '../datasources/demografi_remote_datasource.dart';
import '../models/tokoh_model.dart';
import '../models/institusi_model.dart';
import '../models/organisasi_model.dart';

class DemografiRepositoryImpl implements DemografiRepository {
  final DemografiRemoteDatasource remoteDatasource;

  DemografiRepositoryImpl({required this.remoteDatasource});

  // ------------------ Tokoh ------------------
  @override
  Future<Either<Failure, List<TokohEntity>>> getTokohList() async {
    try {
      final list = await remoteDatasource.getTokohList();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, TokohEntity>> addTokoh(TokohEntity entity) async {
    try {
      final model = TokohModel.fromEntity(entity);
      final result = await remoteDatasource.addTokoh(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  // ------------------ Institusi ------------------
  @override
  Future<Either<Failure, List<InstitusiEntity>>> getInstitusiList() async {
    try {
      final list = await remoteDatasource.getInstitusiList();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, InstitusiEntity>> addInstitusi(
    InstitusiEntity entity,
  ) async {
    try {
      final model = InstitusiModel.fromEntity(entity);
      final result = await remoteDatasource.addInstitusi(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  // ------------------ Organisasi ------------------
  @override
  Future<Either<Failure, List<OrganisasiEntity>>> getOrganisasiList() async {
    try {
      final list = await remoteDatasource.getOrganisasiList();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, OrganisasiEntity>> addOrganisasi(
    OrganisasiEntity entity,
  ) async {
    try {
      final model = OrganisasiModel.fromEntity(entity);
      final result = await remoteDatasource.addOrganisasi(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
