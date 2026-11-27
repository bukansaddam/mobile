import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_category_entity.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/repositories/institusi_repository.dart';

class GetInstitusiCategoriesUsecase {
  final InstitusiRepository repository;

  GetInstitusiCategoriesUsecase(this.repository);

  Future<Either<Failure, List<InstitusiCategoryEntity>>> call({
    String domain = 'institution',
  }) {
    return repository.getCategories(domain: domain);
  }
}
