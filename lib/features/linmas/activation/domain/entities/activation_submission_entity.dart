import 'package:freezed_annotation/freezed_annotation.dart';

part 'activation_submission_entity.freezed.dart';

@freezed
abstract class ActivationAttachmentEntity with _$ActivationAttachmentEntity {
  const ActivationAttachmentEntity._();

  const factory ActivationAttachmentEntity({
    int? id,
    int? submissionId,
    String? fileName,
    String? mimeType,
    num? size,
    String? filePath,
    String? fileUrl,
  }) = _ActivationAttachmentEntity;
}

@freezed
abstract class ActivationSubmissionEntity with _$ActivationSubmissionEntity {
  const ActivationSubmissionEntity._();

  const factory ActivationSubmissionEntity({
    required int id,
    String? receiverNik,
    String? receiverName,
    String? notes,
    String? createdAt,
    @Default([]) List<ActivationAttachmentEntity> attachments,
    int? totalTarget,
    int? targetDone,
  }) = _ActivationSubmissionEntity;
}
