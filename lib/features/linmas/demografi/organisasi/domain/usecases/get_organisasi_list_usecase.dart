import 'package:akar/core/errors/failures.dart';
import '../entities/organisasi_entity.dart';
import '../repositories/organisasi_repository.dart';

class GetOrganisasiListUsecase {
  final OrganisasiRepository repository;

  GetOrganisasiListUsecase(this.repository);

  Future<Either<Failure, OrganisasiPaginatedEntity>> call({
    int? page,
    int? perPage,
    String? field,
    String? name,
  }) async {
    return await repository.getOrganisasiList(
      page: page,
      perPage: perPage,
      field: field,
      name: name,
    );
  }
}
