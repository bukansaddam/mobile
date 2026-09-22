import 'package:akar/core/errors/failures.dart';
import '../entities/tokoh_entity.dart';
import '../repositories/tokoh_repository.dart';

class UpdateTokohUsecase {
  final TokohRepository repository;

  UpdateTokohUsecase(this.repository);

  Future<Either<Failure, TokohEntity>> call(
    String id,
    TokohEntity entity,
  ) async {
    return await repository.updateTokoh(id, entity);
  }
}
