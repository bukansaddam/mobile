import '../../../../core/errors/failures.dart';
import '../entities/organisasi_entity.dart';
import '../repositories/demografi_repository.dart';

class GetOrganisasiListUsecase {
  final DemografiRepository repository;

  GetOrganisasiListUsecase(this.repository);

  Future<Either<Failure, List<OrganisasiEntity>>> call() {
    return repository.getOrganisasiList();
  }
}
