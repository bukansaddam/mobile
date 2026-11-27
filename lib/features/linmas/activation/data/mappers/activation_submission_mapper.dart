import 'package:akar/features/linmas/activation/data/models/activation_submission_model.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';

export 'package:akar/features/linmas/activation/domain/entities/activation_submission_entity.dart';

extension ActivationAttachmentModelMapper on ActivationAttachmentModel {
  ActivationAttachmentEntity toDomain() {
    return ActivationAttachmentEntity(
      id: id,
      submissionId: submissionId,
      fileName: fileName,
      mimeType: mimeType,
      size: size,
      filePath: filePath,
      fileUrl: fileUrl,
    );
  }
}

extension ActivationSubmissionDataModelMapper on ActivationSubmissionDataModel {
  ActivationSubmissionEntity toDomain() {
    return ActivationSubmissionEntity(
      id: id,
      receiverNik: receiverNik,
      receiverName: receiverName,
      notes: notes,
      createdAt: createdAt,
      attachments: attachments.map((a) => a.toDomain()).toList(),
    );
  }
}

extension ActivationSubmissionResponseModelMapper
    on ActivationSubmissionResponseModel {
  ActivationSubmissionEntity toDomain() {
    final subData = data;
    if (subData == null) {
      return const ActivationSubmissionEntity(id: 0);
    }
    return subData.toDomain().copyWith(
      totalTarget: meta?.totalTarget,
      targetDone: meta?.targetDone,
    );
  }
}
