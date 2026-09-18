import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import '../../domain/entities/organisasi_mapper.dart';
import '../../domain/repositories/organisasi_repository.dart';
import '../datasources/organisasi_remote_datasource.dart';

class OrganisasiRepositoryImpl implements OrganisasiRepository {
  final OrganisasiRemoteDatasource remoteDatasource;

  OrganisasiRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, OrganisasiPaginatedEntity>> getOrganisasiList({
    int? page,
    int? perPage,
    String? field,
    String? name,
  }) async {
    try {
      final res = await remoteDatasource.getOrganisasiList(
        page: page,
        perPage: perPage,
        field: field,
        name: name,
      );
      return Right(res.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, OrganisasiEntity>> addOrganisasi(
    OrganisasiEntity entity,
  ) async {
    try {
      final model = entity.toModel();
      final result = await remoteDatasource.addOrganisasi(model);
      return Right(result.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, OrganisasiEntity>> updateOrganisasi(
    String id,
    OrganisasiEntity entity,
  ) async {
    try {
      final model = entity.toModel();
      final result = await remoteDatasource.updateOrganisasi(id, model);
      return Right(result.toDomain());
    } catch (e) {
      return Left(ServerFailure(ErrorUtils.parseErrorMessage(e)));
    }
  }
}
