import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_category_option.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/complaint_repository.dart';

class GetIncidentCategoriesUsecase {
  final ComplaintRepository repository;

  const GetIncidentCategoriesUsecase(this.repository);

  Future<Either<Failure, List<ComplaintCategoryOption>>> call() {
    return repository.getIncidentCategories();
  }
}
