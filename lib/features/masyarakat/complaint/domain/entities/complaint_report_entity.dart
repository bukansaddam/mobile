import 'package:freezed_annotation/freezed_annotation.dart';

part 'complaint_report_entity.freezed.dart';

@freezed
abstract class ComplaintAttachmentEntity with _$ComplaintAttachmentEntity {
  const ComplaintAttachmentEntity._();

  const factory ComplaintAttachmentEntity({
    @Default('') String mimeType,
    @Default('') String url,
  }) = _ComplaintAttachmentEntity;

  bool get isVideo => mimeType.startsWith('video/');
}

@freezed
abstract class ComplaintSlaEntity with _$ComplaintSlaEntity {
  const factory ComplaintSlaEntity({
    @Default('') String stageLabel,
    @Default(0) int remainingMinutes,
    @Default(0) int progressPct,
    @Default('') String state,
  }) = _ComplaintSlaEntity;
}

@freezed
abstract class ComplaintTimelineEntity with _$ComplaintTimelineEntity {
  const factory ComplaintTimelineEntity({
    @Default('') String type,
    @Default('') String description,
    @Default('') String actorName,
    DateTime? createdAt,
  }) = _ComplaintTimelineEntity;
}

@freezed
abstract class ComplaintReportEntity with _$ComplaintReportEntity {
  const ComplaintReportEntity._();

  const factory ComplaintReportEntity({
    @Default('') String id,
    @Default('') String ticketNumber,
    @Default('') String title,
    @Default('') String description,
    @Default('') String status,
    @Default('') String statusLabel,
    @Default('') String category,
    @Default('') String address,
    double? latitude,
    double? longitude,
    DateTime? reportedAt,
    @Default([]) List<ComplaintAttachmentEntity> attachments,
    ComplaintSlaEntity? sla,
    @Default([]) List<ComplaintTimelineEntity> timeline,
  }) = _ComplaintReportEntity;
}

@freezed
abstract class ComplaintPaginatedEntity with _$ComplaintPaginatedEntity {
  const factory ComplaintPaginatedEntity({
    @Default([]) List<ComplaintReportEntity> data,
    @Default(1) int currentPage,
    @Default(1) int lastPage,
    @Default(0) int total,
  }) = _ComplaintPaginatedEntity;
}
