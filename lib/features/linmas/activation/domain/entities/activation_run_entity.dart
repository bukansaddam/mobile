import 'package:freezed_annotation/freezed_annotation.dart';

part 'activation_run_entity.freezed.dart';

@freezed
abstract class ActivationRunEntity with _$ActivationRunEntity {
  const ActivationRunEntity._();

  const factory ActivationRunEntity({
    required int id,
    int? provinceId,
    String? province,
    int? regencyId,
    String? regency,
    int? districtId,
    String? district,
    int? villageId,
    String? village,
    required String title,
    String? description,
    String? owner,
    String? sourcePriority,
    String? sourceCategory,
    String? sourceApproach,
    DateTime? startDate,
    DateTime? dueDate,
    DateTime? completedAt,
    DateTime? updatedAt,
    String? status,
    @Default(0) num progressPct,
    int? targetParticipants,
    int? targetQuota,
    int? participantsCount,
    num? budget,
    num? budgetPlan,
    String? notes,
    int? daysUntilDue,
    @Default(false) bool isOverdue,
    @Default(false) bool isWarning,
    @Default(true) bool isActive,
    String? warningLevel,
  }) = _ActivationRunEntity;
}
