import 'package:akar/core/errors/failures.dart';
import '../entities/tokoh_entity.dart';
import '../repositories/tokoh_repository.dart';

class AddTokohUsecase {
  final TokohRepository repository;

  AddTokohUsecase(this.repository);

  Future<Either<Failure, TokohEntity>> call(TokohEntity entity) async {
    return await repository.addTokoh(entity);
  }
}
