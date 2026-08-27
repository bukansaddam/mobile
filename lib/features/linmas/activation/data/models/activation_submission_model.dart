import 'package:freezed_annotation/freezed_annotation.dart';

part 'activation_submission_model.freezed.dart';
part 'activation_submission_model.g.dart';

@freezed
abstract class ActivationAttachmentModel with _$ActivationAttachmentModel {
  const ActivationAttachmentModel._();

  const factory ActivationAttachmentModel({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "submission_id") int? submissionId,
    @JsonKey(name: "file_name") String? fileName,
    @JsonKey(name: "saved_at") String? savedAt,
    @JsonKey(name: "mime_type") String? mimeType,
    @JsonKey(name: "size") num? size,
    @JsonKey(name: "file_path") String? filePath,
    @JsonKey(name: "file_url") String? fileUrl,
    @JsonKey(name: "metadata") dynamic metadata,
  }) = _ActivationAttachmentModel;

  factory ActivationAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$ActivationAttachmentModelFromJson(json);
}

@freezed
abstract class ActivationSubmissionDataModel
    with _$ActivationSubmissionDataModel {
  const ActivationSubmissionDataModel._();

  const factory ActivationSubmissionDataModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "receiver_nik") String? receiverNik,
    @JsonKey(name: "receiver_name") String? receiverName,
    @JsonKey(name: "notes") String? notes,
    @JsonKey(name: "creator") dynamic creator,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "attachments")
    @Default([])
    List<ActivationAttachmentModel> attachments,
  }) = _ActivationSubmissionDataModel;

  factory ActivationSubmissionDataModel.fromJson(Map<String, dynamic> json) =>
      _$ActivationSubmissionDataModelFromJson(json);
}

@freezed
abstract class ActivationSubmissionMetaModel
    with _$ActivationSubmissionMetaModel {
  const ActivationSubmissionMetaModel._();

  const factory ActivationSubmissionMetaModel({
    @JsonKey(name: "total_target") int? totalTarget,
    @JsonKey(name: "target_done") int? targetDone,
  }) = _ActivationSubmissionMetaModel;

  factory ActivationSubmissionMetaModel.fromJson(Map<String, dynamic> json) =>
      _$ActivationSubmissionMetaModelFromJson(json);
}

@freezed
abstract class ActivationSubmissionResponseModel
    with _$ActivationSubmissionResponseModel {
  const ActivationSubmissionResponseModel._();

  const factory ActivationSubmissionResponseModel({
    @JsonKey(name: "success") @Default(false) bool success,
    @JsonKey(name: "data") ActivationSubmissionDataModel? data,
    @JsonKey(name: "meta") ActivationSubmissionMetaModel? meta,
    @JsonKey(name: "message") String? message,
  }) = _ActivationSubmissionResponseModel;

  factory ActivationSubmissionResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ActivationSubmissionResponseModelFromJson(json);
}
