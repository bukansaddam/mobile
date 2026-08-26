import 'dart:io';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';
import 'package:akar/features/linmas/activation/domain/repositories/activation_repository.dart';

class SubmitActivationReportUsecase {
  final ActivationRepository repository;

  SubmitActivationReportUsecase(this.repository);

  Future<ActivationSubmissionEntity> call({
    required String participantId,
    required File file,
    String? notes,
    String? receiverNik,
    String? receiverName,
  }) {
    return repository.submitActivationReport(
      participantId: participantId,
      file: file,
      notes: notes,
      receiverNik: receiverNik,
      receiverName: receiverName,
    );
  }
}
