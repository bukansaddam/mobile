import 'package:freezed_annotation/freezed_annotation.dart';

part 'complaint_report_model.freezed.dart';
part 'complaint_report_model.g.dart';

Object? _readTicketNumber(Map json, String key) =>
    (json['ticketNumber'] ?? json['ticket_number'])?.toString() ?? '';

Object? _readCategory(Map json, String key) {
  final category = json['category'];
  if (category is Map) return category['label']?.toString() ?? '';
  return category?.toString() ?? '';
}

Object? _readStatusLabel(Map json, String key) =>
    (json['statusLabel'] ?? json['status_label'])?.toString() ?? '';

Object? _readMimeType(Map json, String key) =>
    (json['mimeType'] ?? json['mime_type'] ?? '').toString();

Object? _readFileUrl(Map json, String key) =>
    (json['fileUrl'] ?? json['file_url'] ?? '').toString();

@freezed
abstract class ComplaintAttachmentModel with _$ComplaintAttachmentModel {
  const factory ComplaintAttachmentModel({
    @JsonKey(name: 'mime_type', readValue: _readMimeType)
    @Default('')
    String mimeType,
    @JsonKey(name: 'file_url', readValue: _readFileUrl) @Default('') String url,
  }) = _ComplaintAttachmentModel;

  factory ComplaintAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintAttachmentModelFromJson(json);
}

@freezed
abstract class ComplaintSlaModel with _$ComplaintSlaModel {
  const factory ComplaintSlaModel({
    @Default('') String stageLabel,
    num? remainingMinutes,
    num? progressPct,
    @Default('') String state,
  }) = _ComplaintSlaModel;

  factory ComplaintSlaModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintSlaModelFromJson(json);
}

@freezed
abstract class ComplaintActorModel with _$ComplaintActorModel {
  const factory ComplaintActorModel({@Default('') String name}) =
      _ComplaintActorModel;

  factory ComplaintActorModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintActorModelFromJson(json);
}

@freezed
abstract class ComplaintTimelineModel with _$ComplaintTimelineModel {
  const factory ComplaintTimelineModel({
    @Default('') String type,
    @Default('') String description,
    ComplaintActorModel? actor,
    DateTime? createdAt,
  }) = _ComplaintTimelineModel;

  factory ComplaintTimelineModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintTimelineModelFromJson(json);
}

@freezed
abstract class ComplaintReportModel with _$ComplaintReportModel {
  const ComplaintReportModel._();

  const factory ComplaintReportModel({
    int? id,
    @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber)
    @Default('')
    String ticketNumber,
    @Default('') String title,
    @Default('') String description,
    @Default('') String status,
    @JsonKey(name: 'statusLabel', readValue: _readStatusLabel)
    @Default('')
    String statusLabel,
    @JsonKey(name: 'category', readValue: _readCategory)
    @Default('')
    String category,
    @Default('') String address,
    num? latitude,
    num? longitude,
    DateTime? reportedAt,
    DateTime? updatedAt,
    @Default([]) List<ComplaintAttachmentModel> attachments,
    ComplaintSlaModel? sla,
    @Default([]) List<ComplaintTimelineModel> timeline,
  }) = _ComplaintReportModel;

  factory ComplaintReportModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintReportModelFromJson(json);
}

@freezed
abstract class ComplaintLocationModel with _$ComplaintLocationModel {
  const factory ComplaintLocationModel({
    @Default('') String address,
    String? village,
    String? district,
    String? regency,
    String? province,
    num? latitude,
    num? longitude,
  }) = _ComplaintLocationModel;

  factory ComplaintLocationModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintLocationModelFromJson(json);
}

@freezed
abstract class ComplaintReportDetailModel with _$ComplaintReportDetailModel {
  const factory ComplaintReportDetailModel({
    @Default(ComplaintReportModel()) ComplaintReportModel complaint,
    ComplaintLocationModel? location,
    @Default([]) List<ComplaintAttachmentModel> attachments,
    ComplaintSlaModel? sla,
    @Default([]) List<ComplaintTimelineModel> timeline,
  }) = _ComplaintReportDetailModel;

  factory ComplaintReportDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintReportDetailModelFromJson(json);
}

@freezed
abstract class ComplaintMetaModel with _$ComplaintMetaModel {
  const factory ComplaintMetaModel({
    @JsonKey(name: 'current_page') @Default(1) int currentPage,
    @JsonKey(name: 'last_page') @Default(1) int lastPage,
    @JsonKey(name: 'per_page') @Default(15) int perPage,
    @Default(0) int total,
  }) = _ComplaintMetaModel;

  factory ComplaintMetaModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintMetaModelFromJson(json);
}

@freezed
abstract class ComplaintPaginatedModel with _$ComplaintPaginatedModel {
  const factory ComplaintPaginatedModel({
    @Default([]) List<ComplaintReportModel> data,
    ComplaintMetaModel? meta,
  }) = _ComplaintPaginatedModel;

  factory ComplaintPaginatedModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintPaginatedModelFromJson(json);
}
