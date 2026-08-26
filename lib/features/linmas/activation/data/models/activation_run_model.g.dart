// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_run_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivationRunModel _$ActivationRunModelFromJson(Map<String, dynamic> json) =>
    _ActivationRunModel(
      id: (json['id'] as num).toInt(),
      provinceId: (json['province_id'] as num?)?.toInt(),
      province: json['province'] as String?,
      regencyId: (json['regency_id'] as num?)?.toInt(),
      regency: json['regency'] as String?,
      districtId: (json['district_id'] as num?)?.toInt(),
      district: json['district'] as String?,
      villageId: (json['village_id'] as num?)?.toInt(),
      village: json['village'] as String?,
      reportId: json['report_id'],
      report: json['report'],
      title: json['title'] as String,
      description: json['description'] as String?,
      owner: json['owner'] as String?,
      sourcePriority: json['source_priority'] as String?,
      sourceCategory: json['source_category'] as String?,
      sourceApproach: json['source_approach'] as String?,
      startDate: json['start_date'] as String?,
      dueDate: json['due_date'] as String?,
      completedAt: json['completed_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      status: json['status'] as String?,
      progressPct: json['progress_pct'] as num? ?? 0,
      targetParticipants: (json['target_participants'] as num?)?.toInt(),
      targetQuota: (json['target_quota'] as num?)?.toInt(),
      participantsCount: (json['participants_count'] as num?)?.toInt(),
      budget: json['budget'] as num?,
      budgetPlan: json['budget_plan'] as num?,
      notes: json['notes'] as String?,
      daysUntilDue: (json['days_until_due'] as num?)?.toInt(),
      isOverdue: json['is_overdue'] as bool? ?? false,
      isWarning: json['is_warning'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      warningLevel: json['warning_level'] as String?,
    );

Map<String, dynamic> _$ActivationRunModelToJson(_ActivationRunModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'province_id': instance.provinceId,
      'province': instance.province,
      'regency_id': instance.regencyId,
      'regency': instance.regency,
      'district_id': instance.districtId,
      'district': instance.district,
      'village_id': instance.villageId,
      'village': instance.village,
      'report_id': instance.reportId,
      'report': instance.report,
      'title': instance.title,
      'description': instance.description,
      'owner': instance.owner,
      'source_priority': instance.sourcePriority,
      'source_category': instance.sourceCategory,
      'source_approach': instance.sourceApproach,
      'start_date': instance.startDate,
      'due_date': instance.dueDate,
      'completed_at': instance.completedAt,
      'updated_at': instance.updatedAt,
      'status': instance.status,
      'progress_pct': instance.progressPct,
      'target_participants': instance.targetParticipants,
      'target_quota': instance.targetQuota,
      'participants_count': instance.participantsCount,
      'budget': instance.budget,
      'budget_plan': instance.budgetPlan,
      'notes': instance.notes,
      'days_until_due': instance.daysUntilDue,
      'is_overdue': instance.isOverdue,
      'is_warning': instance.isWarning,
      'is_active': instance.isActive,
      'warning_level': instance.warningLevel,
    };

_ActivationRunMetaModel _$ActivationRunMetaModelFromJson(
  Map<String, dynamic> json,
) => _ActivationRunMetaModel(
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  hasMore: json['has_more'] as bool?,
  nextPageUrl: json['next_page_url'] as String?,
  prevPageUrl: json['prev_page_url'] as String?,
  today: json['today'] as String?,
  warningDays: (json['warning_days'] as num?)?.toInt(),
);

Map<String, dynamic> _$ActivationRunMetaModelToJson(
  _ActivationRunMetaModel instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'total': instance.total,
  'has_more': instance.hasMore,
  'next_page_url': instance.nextPageUrl,
  'prev_page_url': instance.prevPageUrl,
  'today': instance.today,
  'warning_days': instance.warningDays,
};

_ActivationRunResponseModel _$ActivationRunResponseModelFromJson(
  Map<String, dynamic> json,
) => _ActivationRunResponseModel(
  success: json['success'] as bool? ?? false,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => ActivationRunModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  meta: json['meta'] == null
      ? null
      : ActivationRunMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ActivationRunResponseModelToJson(
  _ActivationRunResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};
