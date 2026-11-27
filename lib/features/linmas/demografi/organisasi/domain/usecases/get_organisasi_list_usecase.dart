import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/repositories/organisasi_repository.dart';

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
