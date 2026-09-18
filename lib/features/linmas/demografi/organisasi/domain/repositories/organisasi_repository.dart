import 'package:akar/core/errors/failures.dart';
import '../entities/organisasi_entity.dart';

abstract class OrganisasiRepository {
  Future<Either<Failure, OrganisasiPaginatedEntity>> getOrganisasiList({
    int? page,
    int? perPage,
    String? field,
    String? name,
  });

  Future<Either<Failure, OrganisasiEntity>> addOrganisasi(
    OrganisasiEntity entity,
  );

  Future<Either<Failure, OrganisasiEntity>> updateOrganisasi(
    String id,
    OrganisasiEntity entity,
  );
}
