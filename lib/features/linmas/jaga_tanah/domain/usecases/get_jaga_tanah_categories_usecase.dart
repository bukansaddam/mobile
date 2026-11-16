import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/repositories/jaga_tanah_repository.dart';

class GetJagaTanahCategoriesUsecase {
  final JagaTanahRepository _repository;

  const GetJagaTanahCategoriesUsecase(this._repository);

  Future<Either<Failure, List<JagaTanahCategoryEntity>>> call() {
    return _repository.getCategories();
  }
}
