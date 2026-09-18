import 'package:akar/core/errors/failures.dart';
import '../entities/organisasi_entity.dart';
import '../repositories/organisasi_repository.dart';

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
