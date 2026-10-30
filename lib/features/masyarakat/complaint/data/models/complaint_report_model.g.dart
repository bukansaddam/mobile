// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ComplaintAttachmentModel _$ComplaintAttachmentModelFromJson(
  Map<String, dynamic> json,
) => _ComplaintAttachmentModel(
  mimeType: _readMimeType(json, 'mime_type') as String? ?? '',
  url: _readFileUrl(json, 'file_url') as String? ?? '',
);

Map<String, dynamic> _$ComplaintAttachmentModelToJson(
  _ComplaintAttachmentModel instance,
) => <String, dynamic>{
  'mime_type': instance.mimeType,
  'file_url': instance.url,
};

_ComplaintSlaModel _$ComplaintSlaModelFromJson(Map<String, dynamic> json) =>
    _ComplaintSlaModel(
      stageLabel: json['stageLabel'] as String? ?? '',
      remainingMinutes: json['remainingMinutes'] as num?,
      progressPct: json['progressPct'] as num?,
      state: json['state'] as String? ?? '',
    );

Map<String, dynamic> _$ComplaintSlaModelToJson(_ComplaintSlaModel instance) =>
    <String, dynamic>{
      'stageLabel': instance.stageLabel,
      'remainingMinutes': instance.remainingMinutes,
      'progressPct': instance.progressPct,
      'state': instance.state,
    };

_ComplaintActorModel _$ComplaintActorModelFromJson(Map<String, dynamic> json) =>
    _ComplaintActorModel(name: json['name'] as String? ?? '');

Map<String, dynamic> _$ComplaintActorModelToJson(
  _ComplaintActorModel instance,
) => <String, dynamic>{'name': instance.name};

_ComplaintTimelineModel _$ComplaintTimelineModelFromJson(
  Map<String, dynamic> json,
) => _ComplaintTimelineModel(
  type: json['type'] as String? ?? '',
  description: json['description'] as String? ?? '',
  actor: json['actor'] == null
      ? null
      : ComplaintActorModel.fromJson(json['actor'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ComplaintTimelineModelToJson(
  _ComplaintTimelineModel instance,
) => <String, dynamic>{
  'type': instance.type,
  'description': instance.description,
  'actor': instance.actor,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_ComplaintReportModel _$ComplaintReportModelFromJson(
  Map<String, dynamic> json,
) => _ComplaintReportModel(
  id: (json['id'] as num?)?.toInt(),
  ticketNumber: _readTicketNumber(json, 'ticketNumber') as String? ?? '',
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  status: json['status'] as String? ?? '',
  statusLabel: _readStatusLabel(json, 'statusLabel') as String? ?? '',
  category: _readCategory(json, 'category') as String? ?? '',
  address: json['address'] as String? ?? '',
  latitude: json['latitude'] as num?,
  longitude: json['longitude'] as num?,
  reportedAt: json['reportedAt'] == null
      ? null
      : DateTime.parse(json['reportedAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map(
            (e) => ComplaintAttachmentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  sla: json['sla'] == null
      ? null
      : ComplaintSlaModel.fromJson(json['sla'] as Map<String, dynamic>),
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map(
            (e) => ComplaintTimelineModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$ComplaintReportModelToJson(
  _ComplaintReportModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'ticketNumber': instance.ticketNumber,
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'statusLabel': instance.statusLabel,
  'category': instance.category,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'reportedAt': instance.reportedAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'attachments': instance.attachments,
  'sla': instance.sla,
  'timeline': instance.timeline,
};

_ComplaintLocationModel _$ComplaintLocationModelFromJson(
  Map<String, dynamic> json,
) => _ComplaintLocationModel(
  address: json['address'] as String? ?? '',
  village: json['village'] as String?,
  district: json['district'] as String?,
  regency: json['regency'] as String?,
  province: json['province'] as String?,
  latitude: json['latitude'] as num?,
  longitude: json['longitude'] as num?,
);

Map<String, dynamic> _$ComplaintLocationModelToJson(
  _ComplaintLocationModel instance,
) => <String, dynamic>{
  'address': instance.address,
  'village': instance.village,
  'district': instance.district,
  'regency': instance.regency,
  'province': instance.province,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

_ComplaintReportDetailModel _$ComplaintReportDetailModelFromJson(
  Map<String, dynamic> json,
) => _ComplaintReportDetailModel(
  complaint: json['complaint'] == null
      ? const ComplaintReportModel()
      : ComplaintReportModel.fromJson(
          json['complaint'] as Map<String, dynamic>,
        ),
  location: json['location'] == null
      ? null
      : ComplaintLocationModel.fromJson(
          json['location'] as Map<String, dynamic>,
        ),
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map(
            (e) => ComplaintAttachmentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  sla: json['sla'] == null
      ? null
      : ComplaintSlaModel.fromJson(json['sla'] as Map<String, dynamic>),
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map(
            (e) => ComplaintTimelineModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$ComplaintReportDetailModelToJson(
  _ComplaintReportDetailModel instance,
) => <String, dynamic>{
  'complaint': instance.complaint,
  'location': instance.location,
  'attachments': instance.attachments,
  'sla': instance.sla,
  'timeline': instance.timeline,
};

_ComplaintMetaModel _$ComplaintMetaModelFromJson(Map<String, dynamic> json) =>
    _ComplaintMetaModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ComplaintMetaModelToJson(_ComplaintMetaModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };

_ComplaintPaginatedModel _$ComplaintPaginatedModelFromJson(
  Map<String, dynamic> json,
) => _ComplaintPaginatedModel(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => ComplaintReportModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  meta: json['meta'] == null
      ? null
      : ComplaintMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ComplaintPaginatedModelToJson(
  _ComplaintPaginatedModel instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
