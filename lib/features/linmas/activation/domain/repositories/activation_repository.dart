import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_entity.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';

abstract class ActivationRepository {
  Future<Either<Failure, List<ActivationRunEntity>>> getActivationRuns({
    int? page,
    int? perPage,
    String? status,
  });

  Future<Either<Failure, ActivationSubmissionEntity>> submitActivationReport({
    required String participantId,
    required File file,
    String? notes,
    String? receiverNik,
    String? receiverName,
  });
}
