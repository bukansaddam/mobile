import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';
import 'package:akar/features/linmas/activation/domain/repositories/activation_repository.dart';

class GetActivationSubmissionsUsecase {
  final ActivationRepository repository;

  GetActivationSubmissionsUsecase(this.repository);

  Future<Either<Failure, List<ActivationSubmissionEntity>>> call({
    required String participantId,
  }) => repository.getActivationSubmissions(participantId: participantId);
}
