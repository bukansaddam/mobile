import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/complaint_report_entity.dart';

part 'complaint_report_model.freezed.dart';
part 'complaint_report_model.g.dart';

Object? _readId(Map json, String key) => json['id']?.toString() ?? '';

Object? _readTicketNumber(Map json, String key) =>
    (json['ticketNumber'] ?? json['ticket_number'])?.toString() ?? '';

DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString())?.toLocal();
}

dynamic _dateTimeToJson(DateTime? value) => value?.toUtc().toIso8601String();

@freezed
abstract class ComplaintReportModel with _$ComplaintReportModel {
  const ComplaintReportModel._();

  const factory ComplaintReportModel({
    @JsonKey(name: 'id', readValue: _readId) @Default('') String id,
    @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber)
    @Default('')
    String ticketNumber,
    @JsonKey(name: 'status') @Default('') String status,
    @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    DateTime? createdAt,
  }) = _ComplaintReportModel;

  factory ComplaintReportModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintReportModelFromJson(json);

  factory ComplaintReportModel.fromEntity(ComplaintReportEntity entity) =>
      ComplaintReportModel(
        id: entity.id,
        ticketNumber: entity.ticketNumber,
        status: entity.status,
        createdAt: entity.createdAt,
      );
}
