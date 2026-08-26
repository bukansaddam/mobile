// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_submission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivationAttachmentModel _$ActivationAttachmentModelFromJson(
  Map<String, dynamic> json,
) => _ActivationAttachmentModel(
  id: (json['id'] as num?)?.toInt(),
  submissionId: (json['submission_id'] as num?)?.toInt(),
  fileName: json['file_name'] as String?,
  savedAt: json['saved_at'] as String?,
  mimeType: json['mime_type'] as String?,
  size: json['size'] as num?,
  filePath: json['file_path'] as String?,
  fileUrl: json['file_url'] as String?,
  metadata: json['metadata'],
);

Map<String, dynamic> _$ActivationAttachmentModelToJson(
  _ActivationAttachmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'submission_id': instance.submissionId,
  'file_name': instance.fileName,
  'saved_at': instance.savedAt,
  'mime_type': instance.mimeType,
  'size': instance.size,
  'file_path': instance.filePath,
  'file_url': instance.fileUrl,
  'metadata': instance.metadata,
};

_ActivationSubmissionDataModel _$ActivationSubmissionDataModelFromJson(
  Map<String, dynamic> json,
) => _ActivationSubmissionDataModel(
  id: (json['id'] as num).toInt(),
  receiverNik: json['receiver_nik'] as String?,
  receiverName: json['receiver_name'] as String?,
  notes: json['notes'] as String?,
  creator: json['creator'],
  createdAt: json['created_at'] as String?,
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map(
            (e) =>
                ActivationAttachmentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$ActivationSubmissionDataModelToJson(
  _ActivationSubmissionDataModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'receiver_nik': instance.receiverNik,
  'receiver_name': instance.receiverName,
  'notes': instance.notes,
  'creator': instance.creator,
  'created_at': instance.createdAt,
  'attachments': instance.attachments,
};

_ActivationSubmissionMetaModel _$ActivationSubmissionMetaModelFromJson(
  Map<String, dynamic> json,
) => _ActivationSubmissionMetaModel(
  totalTarget: (json['total_target'] as num?)?.toInt(),
  targetDone: (json['target_done'] as num?)?.toInt(),
);

Map<String, dynamic> _$ActivationSubmissionMetaModelToJson(
  _ActivationSubmissionMetaModel instance,
) => <String, dynamic>{
  'total_target': instance.totalTarget,
  'target_done': instance.targetDone,
};

_ActivationSubmissionResponseModel _$ActivationSubmissionResponseModelFromJson(
  Map<String, dynamic> json,
) => _ActivationSubmissionResponseModel(
  success: json['success'] as bool? ?? false,
  data: json['data'] == null
      ? null
      : ActivationSubmissionDataModel.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  meta: json['meta'] == null
      ? null
      : ActivationSubmissionMetaModel.fromJson(
          json['meta'] as Map<String, dynamic>,
        ),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ActivationSubmissionResponseModelToJson(
  _ActivationSubmissionResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};
