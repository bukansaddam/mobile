import 'package:akar/core/errors/failures.dart';
import '../entities/tokoh_entity.dart';
import '../repositories/tokoh_repository.dart';

class GetTokohListUsecase {
  final TokohRepository repository;

  GetTokohListUsecase(this.repository);

  Future<Either<Failure, TokohPaginatedEntity>> call({
    int? page,
    int? perPage,
    String? label,
    String? field,
    String? name,
    String? affiliations,
    String? professions,
  }) async {
    return await repository.getTokohList(
      page: page,
      perPage: perPage,
      label: label,
      field: field,
      name: name,
      affiliations: affiliations,
      professions: professions,
    );
  }
}
