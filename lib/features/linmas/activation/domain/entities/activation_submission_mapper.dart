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

extension ActivationSubmissionResponseModelMapper on ActivationSubmissionResponseModel {
  ActivationSubmissionEntity toDomain() {
    final subData = data;
    return ActivationSubmissionEntity(
      id: subData?.id ?? 0,
      receiverNik: subData?.receiverNik,
      receiverName: subData?.receiverName,
      notes: subData?.notes,
      createdAt: subData?.createdAt,
      attachments: subData?.attachments.map((a) => a.toDomain()).toList() ?? [],
      totalTarget: meta?.totalTarget,
      targetDone: meta?.targetDone,
    );
  }
}
