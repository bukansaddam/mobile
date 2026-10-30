import 'package:akar/features/masyarakat/complaint/data/models/complaint_report_model.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

export 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';

extension ComplaintReportModelMapper on ComplaintReportModel {
  ComplaintReportEntity toDomain() => ComplaintReportEntity(
    id: id,
    ticketNumber: ticketNumber,
    status: status,
    createdAt: createdAt,
  );
}

extension ComplaintReportEntityMapper on ComplaintReportEntity {
  ComplaintReportModel toModel() => ComplaintReportModel.fromEntity(this);
}
