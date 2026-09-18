import 'package:akar/core/errors/failures.dart';
import '../entities/organisasi_entity.dart';
import '../repositories/organisasi_repository.dart';

class AddOrganisasiUsecase {
  final OrganisasiRepository repository;

  AddOrganisasiUsecase(this.repository);

  Future<Either<Failure, OrganisasiEntity>> call(
    OrganisasiEntity entity,
  ) async {
    return await repository.addOrganisasi(entity);
  }
}
