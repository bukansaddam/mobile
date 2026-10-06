import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_entity.dart';
import 'package:akar/features/linmas/activation/domain/repositories/activation_repository.dart';

class GetActivationRunsUsecase {
  final ActivationRepository repository;

  GetActivationRunsUsecase(this.repository);

  Future<Either<Failure, List<ActivationRunEntity>>> call({
    int? page,
    int? perPage,
    String? status,
  }) => repository.getActivationRuns(
    page: page,
    perPage: perPage,
    status: status,
  );
}
