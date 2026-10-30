import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/features/masyarakat/complaint/data/models/complaint_report_model.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

export 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

String _absoluteUrl(String url) {
  if (url.isEmpty || url.startsWith('http')) return url;
  final base = Uri.tryParse(ApiConstants.baseUrl);
  return base == null ? url : base.resolve(url).toString();
}

extension ComplaintAttachmentModelMapper on ComplaintAttachmentModel {
  ComplaintAttachmentEntity toDomain() =>
      ComplaintAttachmentEntity(mimeType: mimeType, url: _absoluteUrl(url));
}

extension ComplaintSlaModelMapper on ComplaintSlaModel {
  ComplaintSlaEntity toDomain() => ComplaintSlaEntity(
    stageLabel: stageLabel,
    remainingMinutes: remainingMinutes?.toInt() ?? 0,
    progressPct: progressPct?.toInt() ?? 0,
    state: state,
  );
}

extension ComplaintTimelineModelMapper on ComplaintTimelineModel {
  ComplaintTimelineEntity toDomain() => ComplaintTimelineEntity(
    type: type,
    description: description,
    actorName: actor?.name ?? '',
    createdAt: createdAt?.toLocal(),
  );
}

extension ComplaintReportModelMapper on ComplaintReportModel {
  ComplaintReportEntity toDomain() => ComplaintReportEntity(
    id: id?.toString() ?? '',
    ticketNumber: ticketNumber,
    title: title,
    description: description,
    status: status,
    statusLabel: statusLabel,
    category: category,
    address: address,
    latitude: latitude?.toDouble(),
    longitude: longitude?.toDouble(),
    reportedAt: reportedAt?.toLocal(),
    attachments: attachments.map((item) => item.toDomain()).toList(),
    sla: sla?.toDomain(),
    timeline: timeline.map((item) => item.toDomain()).toList(),
  );
}

extension ComplaintReportDetailModelMapper on ComplaintReportDetailModel {
  ComplaintReportEntity toDomain() {
    final report = complaint.toDomain();
    return report.copyWith(
      address: location?.address ?? report.address,
      latitude: location?.latitude?.toDouble() ?? report.latitude,
      longitude: location?.longitude?.toDouble() ?? report.longitude,
      attachments: attachments.map((item) => item.toDomain()).toList(),
      sla: sla?.toDomain(),
      timeline: timeline.map((item) => item.toDomain()).toList(),
    );
  }
}

extension ComplaintPaginatedModelMapper on ComplaintPaginatedModel {
  ComplaintPaginatedEntity toDomain() => ComplaintPaginatedEntity(
    data: data.map((item) => item.toDomain()).toList(),
    currentPage: meta?.currentPage ?? 1,
    lastPage: meta?.lastPage ?? 1,
    total: meta?.total ?? data.length,
  );
}
