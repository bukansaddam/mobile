import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/repositories/organisasi_repository.dart';

class UpdateOrganisasiUsecase {
  final OrganisasiRepository repository;

  UpdateOrganisasiUsecase(this.repository);

  Future<Either<Failure, OrganisasiEntity>> call({
    required String id,
    required OrganisasiEntity entity,
  }) async {
    return await repository.updateOrganisasi(id, entity);
  }
}
