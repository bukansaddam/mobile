import 'dart:io';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_entity.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';

abstract class ActivationRepository {
  Future<List<ActivationRunEntity>> getActivationRuns({
    int? page,
    int? perPage,
    String? status,
  });

  Future<ActivationSubmissionEntity> submitActivationReport({
    required String participantId,
    required File file,
    String? notes,
    String? receiverNik,
    String? receiverName,
  });
}
