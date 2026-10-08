import 'dart:io';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';
import 'package:akar/features/linmas/activation/domain/repositories/activation_repository.dart';

class SubmitActivationReportUsecase {
  final ActivationRepository repository;

  SubmitActivationReportUsecase(this.repository);

  Future<Either<Failure, ActivationSubmissionEntity>> call({
    required String participantId,
    required File file,
    String? notes,
    String? receiverNik,
    String? receiverName,
  }) => repository.submitActivationReport(
    participantId: participantId,
    file: file,
    notes: notes,
    receiverNik: receiverNik,
    receiverName: receiverName,
  );
}
