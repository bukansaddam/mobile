// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ComplaintReportModel _$ComplaintReportModelFromJson(
  Map<String, dynamic> json,
) => _ComplaintReportModel(
  id: _readId(json, 'id') as String? ?? '',
  ticketNumber: _readTicketNumber(json, 'ticketNumber') as String? ?? '',
  status: json['status'] as String? ?? '',
  createdAt: _dateTimeFromJson(json['created_at']),
);

Map<String, dynamic> _$ComplaintReportModelToJson(
  _ComplaintReportModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'ticketNumber': instance.ticketNumber,
  'status': instance.status,
  'created_at': _dateTimeToJson(instance.createdAt),
};
