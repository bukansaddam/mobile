import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/repositories/organisasi_repository.dart';

class AddOrganisasiUsecase {
  final OrganisasiRepository repository;

  AddOrganisasiUsecase(this.repository);

  Future<Either<Failure, OrganisasiEntity>> call(
    OrganisasiEntity entity,
  ) async {
    return await repository.addOrganisasi(entity);
  }
}
