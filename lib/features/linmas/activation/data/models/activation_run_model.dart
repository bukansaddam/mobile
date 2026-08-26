import 'package:freezed_annotation/freezed_annotation.dart';

part 'activation_run_model.freezed.dart';
part 'activation_run_model.g.dart';

@freezed
abstract class ActivationRunModel with _$ActivationRunModel {
  const ActivationRunModel._();

  const factory ActivationRunModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "province_id") int? provinceId,
    @JsonKey(name: "province") String? province,
    @JsonKey(name: "regency_id") int? regencyId,
    @JsonKey(name: "regency") String? regency,
    @JsonKey(name: "district_id") int? districtId,
    @JsonKey(name: "district") String? district,
    @JsonKey(name: "village_id") int? villageId,
    @JsonKey(name: "village") String? village,
    @JsonKey(name: "report_id") dynamic reportId,
    @JsonKey(name: "report") dynamic report,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "owner") String? owner,
    @JsonKey(name: "source_priority") String? sourcePriority,
    @JsonKey(name: "source_category") String? sourceCategory,
    @JsonKey(name: "source_approach") String? sourceApproach,
    @JsonKey(name: "start_date") String? startDate,
    @JsonKey(name: "due_date") String? dueDate,
    @JsonKey(name: "completed_at") String? completedAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "progress_pct") @Default(0) num progressPct,
    @JsonKey(name: "target_participants") int? targetParticipants,
    @JsonKey(name: "target_quota") int? targetQuota,
    @JsonKey(name: "participants_count") int? participantsCount,
    @JsonKey(name: "budget") num? budget,
    @JsonKey(name: "budget_plan") num? budgetPlan,
    @JsonKey(name: "notes") String? notes,
    @JsonKey(name: "days_until_due") int? daysUntilDue,
    @JsonKey(name: "is_overdue") @Default(false) bool isOverdue,
    @JsonKey(name: "is_warning") @Default(false) bool isWarning,
    @JsonKey(name: "is_active") @Default(true) bool isActive,
    @JsonKey(name: "warning_level") String? warningLevel,
  }) = _ActivationRunModel;

  factory ActivationRunModel.fromJson(Map<String, dynamic> json) =>
      _$ActivationRunModelFromJson(json);
}

@freezed
abstract class ActivationRunMetaModel with _$ActivationRunMetaModel {
  const ActivationRunMetaModel._();

  const factory ActivationRunMetaModel({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "has_more") bool? hasMore,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "today") String? today,
    @JsonKey(name: "warning_days") int? warningDays,
  }) = _ActivationRunMetaModel;

  factory ActivationRunMetaModel.fromJson(Map<String, dynamic> json) =>
      _$ActivationRunMetaModelFromJson(json);
}

@freezed
abstract class ActivationRunResponseModel with _$ActivationRunResponseModel {
  const ActivationRunResponseModel._();

  const factory ActivationRunResponseModel({
    @JsonKey(name: "success") @Default(false) bool success,
    @JsonKey(name: "data") @Default([]) List<ActivationRunModel> data,
    @JsonKey(name: "meta") ActivationRunMetaModel? meta,
    @JsonKey(name: "message") String? message,
  }) = _ActivationRunResponseModel;

  factory ActivationRunResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ActivationRunResponseModelFromJson(json);
}
