import 'package:akar/core/errors/failures.dart';
import '../entities/institusi_entity.dart';
import '../repositories/institusi_repository.dart';

class GetInstitusiListUsecase {
  final InstitusiRepository repository;

  GetInstitusiListUsecase(this.repository);

  Future<Either<Failure, InstitusiPaginatedEntity>> call({
    int? page,
    int? perPage,
    String? scope,
    String? name,
    String? label,
  }) {
    return repository.getInstitusiList(
      page: page,
      perPage: perPage,
      scope: scope,
      name: name,
      label: label,
    );
  }
}
