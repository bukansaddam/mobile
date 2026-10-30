import 'package:freezed_annotation/freezed_annotation.dart';

part 'complaint_report_entity.freezed.dart';

@freezed
abstract class ComplaintReportEntity with _$ComplaintReportEntity {
  const ComplaintReportEntity._();

  const factory ComplaintReportEntity({
    @Default('') String id,
    @Default('') String ticketNumber,
    @Default('') String status,
    DateTime? createdAt,
  }) = _ComplaintReportEntity;
}
