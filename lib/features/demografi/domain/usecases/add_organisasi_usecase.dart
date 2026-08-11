import '../../../../core/errors/failures.dart';
import '../entities/organisasi_entity.dart';
import '../repositories/demografi_repository.dart';

class AddOrganisasiUsecase {
  final DemografiRepository repository;

  AddOrganisasiUsecase(this.repository);

  Future<Either<Failure, OrganisasiEntity>> call(OrganisasiEntity entity) {
    return repository.addOrganisasi(entity);
  }
}
