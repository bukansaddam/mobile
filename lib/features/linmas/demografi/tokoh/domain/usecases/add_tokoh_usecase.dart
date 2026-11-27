import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/linmas/demografi/tokoh/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/repositories/tokoh_repository.dart';

class AddTokohUsecase {
  final TokohRepository repository;

  AddTokohUsecase(this.repository);

  Future<Either<Failure, TokohEntity>> call(TokohEntity entity) async {
    return await repository.addTokoh(entity);
  }
}
