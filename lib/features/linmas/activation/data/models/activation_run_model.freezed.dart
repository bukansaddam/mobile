// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_run_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivationRunModel {

@JsonKey(name: "id") int get id;@JsonKey(name: "province_id") int? get provinceId;@JsonKey(name: "province") String? get province;@JsonKey(name: "regency_id") int? get regencyId;@JsonKey(name: "regency") String? get regency;@JsonKey(name: "district_id") int? get districtId;@JsonKey(name: "district") String? get district;@JsonKey(name: "village_id") int? get villageId;@JsonKey(name: "village") String? get village;@JsonKey(name: "report_id") dynamic get reportId;@JsonKey(name: "report") dynamic get report;@JsonKey(name: "title") String get title;@JsonKey(name: "description") String? get description;@JsonKey(name: "owner") String? get owner;@JsonKey(name: "source_priority") String? get sourcePriority;@JsonKey(name: "source_category") String? get sourceCategory;@JsonKey(name: "source_approach") String? get sourceApproach;@JsonKey(name: "start_date") String? get startDate;@JsonKey(name: "due_date") String? get dueDate;@JsonKey(name: "completed_at") String? get completedAt;@JsonKey(name: "updated_at") String? get updatedAt;@JsonKey(name: "status") String? get status;@JsonKey(name: "progress_pct") num get progressPct;@JsonKey(name: "target_participants") int? get targetParticipants;@JsonKey(name: "target_quota") int? get targetQuota;@JsonKey(name: "participants_count") int? get participantsCount;@JsonKey(name: "budget") num? get budget;@JsonKey(name: "budget_plan") num? get budgetPlan;@JsonKey(name: "notes") String? get notes;@JsonKey(name: "days_until_due") int? get daysUntilDue;@JsonKey(name: "is_overdue") bool get isOverdue;@JsonKey(name: "is_warning") bool get isWarning;@JsonKey(name: "is_active") bool get isActive;@JsonKey(name: "warning_level") String? get warningLevel;
/// Create a copy of ActivationRunModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationRunModelCopyWith<ActivationRunModel> get copyWith => _$ActivationRunModelCopyWithImpl<ActivationRunModel>(this as ActivationRunModel, _$identity);

  /// Serializes this ActivationRunModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationRunModel&&(identical(other.id, id) || other.id == id)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.province, province) || other.province == province)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.district, district) || other.district == district)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.village, village) || other.village == village)&&const DeepCollectionEquality().equals(other.reportId, reportId)&&const DeepCollectionEquality().equals(other.report, report)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.sourcePriority, sourcePriority) || other.sourcePriority == sourcePriority)&&(identical(other.sourceCategory, sourceCategory) || other.sourceCategory == sourceCategory)&&(identical(other.sourceApproach, sourceApproach) || other.sourceApproach == sourceApproach)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.progressPct, progressPct) || other.progressPct == progressPct)&&(identical(other.targetParticipants, targetParticipants) || other.targetParticipants == targetParticipants)&&(identical(other.targetQuota, targetQuota) || other.targetQuota == targetQuota)&&(identical(other.participantsCount, participantsCount) || other.participantsCount == participantsCount)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.budgetPlan, budgetPlan) || other.budgetPlan == budgetPlan)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.daysUntilDue, daysUntilDue) || other.daysUntilDue == daysUntilDue)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.isWarning, isWarning) || other.isWarning == isWarning)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.warningLevel, warningLevel) || other.warningLevel == warningLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,provinceId,province,regencyId,regency,districtId,district,villageId,village,const DeepCollectionEquality().hash(reportId),const DeepCollectionEquality().hash(report),title,description,owner,sourcePriority,sourceCategory,sourceApproach,startDate,dueDate,completedAt,updatedAt,status,progressPct,targetParticipants,targetQuota,participantsCount,budget,budgetPlan,notes,daysUntilDue,isOverdue,isWarning,isActive,warningLevel]);

@override
String toString() {
  return 'ActivationRunModel(id: $id, provinceId: $provinceId, province: $province, regencyId: $regencyId, regency: $regency, districtId: $districtId, district: $district, villageId: $villageId, village: $village, reportId: $reportId, report: $report, title: $title, description: $description, owner: $owner, sourcePriority: $sourcePriority, sourceCategory: $sourceCategory, sourceApproach: $sourceApproach, startDate: $startDate, dueDate: $dueDate, completedAt: $completedAt, updatedAt: $updatedAt, status: $status, progressPct: $progressPct, targetParticipants: $targetParticipants, targetQuota: $targetQuota, participantsCount: $participantsCount, budget: $budget, budgetPlan: $budgetPlan, notes: $notes, daysUntilDue: $daysUntilDue, isOverdue: $isOverdue, isWarning: $isWarning, isActive: $isActive, warningLevel: $warningLevel)';
}


}

/// @nodoc
abstract mixin class $ActivationRunModelCopyWith<$Res>  {
  factory $ActivationRunModelCopyWith(ActivationRunModel value, $Res Function(ActivationRunModel) _then) = _$ActivationRunModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "province_id") int? provinceId,@JsonKey(name: "province") String? province,@JsonKey(name: "regency_id") int? regencyId,@JsonKey(name: "regency") String? regency,@JsonKey(name: "district_id") int? districtId,@JsonKey(name: "district") String? district,@JsonKey(name: "village_id") int? villageId,@JsonKey(name: "village") String? village,@JsonKey(name: "report_id") dynamic reportId,@JsonKey(name: "report") dynamic report,@JsonKey(name: "title") String title,@JsonKey(name: "description") String? description,@JsonKey(name: "owner") String? owner,@JsonKey(name: "source_priority") String? sourcePriority,@JsonKey(name: "source_category") String? sourceCategory,@JsonKey(name: "source_approach") String? sourceApproach,@JsonKey(name: "start_date") String? startDate,@JsonKey(name: "due_date") String? dueDate,@JsonKey(name: "completed_at") String? completedAt,@JsonKey(name: "updated_at") String? updatedAt,@JsonKey(name: "status") String? status,@JsonKey(name: "progress_pct") num progressPct,@JsonKey(name: "target_participants") int? targetParticipants,@JsonKey(name: "target_quota") int? targetQuota,@JsonKey(name: "participants_count") int? participantsCount,@JsonKey(name: "budget") num? budget,@JsonKey(name: "budget_plan") num? budgetPlan,@JsonKey(name: "notes") String? notes,@JsonKey(name: "days_until_due") int? daysUntilDue,@JsonKey(name: "is_overdue") bool isOverdue,@JsonKey(name: "is_warning") bool isWarning,@JsonKey(name: "is_active") bool isActive,@JsonKey(name: "warning_level") String? warningLevel
});




}
/// @nodoc
class _$ActivationRunModelCopyWithImpl<$Res>
    implements $ActivationRunModelCopyWith<$Res> {
  _$ActivationRunModelCopyWithImpl(this._self, this._then);

  final ActivationRunModel _self;
  final $Res Function(ActivationRunModel) _then;

/// Create a copy of ActivationRunModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? provinceId = freezed,Object? province = freezed,Object? regencyId = freezed,Object? regency = freezed,Object? districtId = freezed,Object? district = freezed,Object? villageId = freezed,Object? village = freezed,Object? reportId = freezed,Object? report = freezed,Object? title = null,Object? description = freezed,Object? owner = freezed,Object? sourcePriority = freezed,Object? sourceCategory = freezed,Object? sourceApproach = freezed,Object? startDate = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? updatedAt = freezed,Object? status = freezed,Object? progressPct = null,Object? targetParticipants = freezed,Object? targetQuota = freezed,Object? participantsCount = freezed,Object? budget = freezed,Object? budgetPlan = freezed,Object? notes = freezed,Object? daysUntilDue = freezed,Object? isOverdue = null,Object? isWarning = null,Object? isActive = null,Object? warningLevel = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,provinceId: freezed == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,regencyId: freezed == regencyId ? _self.regencyId : regencyId // ignore: cast_nullable_to_non_nullable
as int?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as int?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as int?,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as String?,reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as dynamic,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as dynamic,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,sourcePriority: freezed == sourcePriority ? _self.sourcePriority : sourcePriority // ignore: cast_nullable_to_non_nullable
as String?,sourceCategory: freezed == sourceCategory ? _self.sourceCategory : sourceCategory // ignore: cast_nullable_to_non_nullable
as String?,sourceApproach: freezed == sourceApproach ? _self.sourceApproach : sourceApproach // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,progressPct: null == progressPct ? _self.progressPct : progressPct // ignore: cast_nullable_to_non_nullable
as num,targetParticipants: freezed == targetParticipants ? _self.targetParticipants : targetParticipants // ignore: cast_nullable_to_non_nullable
as int?,targetQuota: freezed == targetQuota ? _self.targetQuota : targetQuota // ignore: cast_nullable_to_non_nullable
as int?,participantsCount: freezed == participantsCount ? _self.participantsCount : participantsCount // ignore: cast_nullable_to_non_nullable
as int?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as num?,budgetPlan: freezed == budgetPlan ? _self.budgetPlan : budgetPlan // ignore: cast_nullable_to_non_nullable
as num?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,daysUntilDue: freezed == daysUntilDue ? _self.daysUntilDue : daysUntilDue // ignore: cast_nullable_to_non_nullable
as int?,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,isWarning: null == isWarning ? _self.isWarning : isWarning // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,warningLevel: freezed == warningLevel ? _self.warningLevel : warningLevel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationRunModel].
extension ActivationRunModelPatterns on ActivationRunModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationRunModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationRunModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationRunModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationRunModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationRunModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationRunModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "province_id")  int? provinceId, @JsonKey(name: "province")  String? province, @JsonKey(name: "regency_id")  int? regencyId, @JsonKey(name: "regency")  String? regency, @JsonKey(name: "district_id")  int? districtId, @JsonKey(name: "district")  String? district, @JsonKey(name: "village_id")  int? villageId, @JsonKey(name: "village")  String? village, @JsonKey(name: "report_id")  dynamic reportId, @JsonKey(name: "report")  dynamic report, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String? description, @JsonKey(name: "owner")  String? owner, @JsonKey(name: "source_priority")  String? sourcePriority, @JsonKey(name: "source_category")  String? sourceCategory, @JsonKey(name: "source_approach")  String? sourceApproach, @JsonKey(name: "start_date")  String? startDate, @JsonKey(name: "due_date")  String? dueDate, @JsonKey(name: "completed_at")  String? completedAt, @JsonKey(name: "updated_at")  String? updatedAt, @JsonKey(name: "status")  String? status, @JsonKey(name: "progress_pct")  num progressPct, @JsonKey(name: "target_participants")  int? targetParticipants, @JsonKey(name: "target_quota")  int? targetQuota, @JsonKey(name: "participants_count")  int? participantsCount, @JsonKey(name: "budget")  num? budget, @JsonKey(name: "budget_plan")  num? budgetPlan, @JsonKey(name: "notes")  String? notes, @JsonKey(name: "days_until_due")  int? daysUntilDue, @JsonKey(name: "is_overdue")  bool isOverdue, @JsonKey(name: "is_warning")  bool isWarning, @JsonKey(name: "is_active")  bool isActive, @JsonKey(name: "warning_level")  String? warningLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationRunModel() when $default != null:
return $default(_that.id,_that.provinceId,_that.province,_that.regencyId,_that.regency,_that.districtId,_that.district,_that.villageId,_that.village,_that.reportId,_that.report,_that.title,_that.description,_that.owner,_that.sourcePriority,_that.sourceCategory,_that.sourceApproach,_that.startDate,_that.dueDate,_that.completedAt,_that.updatedAt,_that.status,_that.progressPct,_that.targetParticipants,_that.targetQuota,_that.participantsCount,_that.budget,_that.budgetPlan,_that.notes,_that.daysUntilDue,_that.isOverdue,_that.isWarning,_that.isActive,_that.warningLevel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "province_id")  int? provinceId, @JsonKey(name: "province")  String? province, @JsonKey(name: "regency_id")  int? regencyId, @JsonKey(name: "regency")  String? regency, @JsonKey(name: "district_id")  int? districtId, @JsonKey(name: "district")  String? district, @JsonKey(name: "village_id")  int? villageId, @JsonKey(name: "village")  String? village, @JsonKey(name: "report_id")  dynamic reportId, @JsonKey(name: "report")  dynamic report, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String? description, @JsonKey(name: "owner")  String? owner, @JsonKey(name: "source_priority")  String? sourcePriority, @JsonKey(name: "source_category")  String? sourceCategory, @JsonKey(name: "source_approach")  String? sourceApproach, @JsonKey(name: "start_date")  String? startDate, @JsonKey(name: "due_date")  String? dueDate, @JsonKey(name: "completed_at")  String? completedAt, @JsonKey(name: "updated_at")  String? updatedAt, @JsonKey(name: "status")  String? status, @JsonKey(name: "progress_pct")  num progressPct, @JsonKey(name: "target_participants")  int? targetParticipants, @JsonKey(name: "target_quota")  int? targetQuota, @JsonKey(name: "participants_count")  int? participantsCount, @JsonKey(name: "budget")  num? budget, @JsonKey(name: "budget_plan")  num? budgetPlan, @JsonKey(name: "notes")  String? notes, @JsonKey(name: "days_until_due")  int? daysUntilDue, @JsonKey(name: "is_overdue")  bool isOverdue, @JsonKey(name: "is_warning")  bool isWarning, @JsonKey(name: "is_active")  bool isActive, @JsonKey(name: "warning_level")  String? warningLevel)  $default,) {final _that = this;
switch (_that) {
case _ActivationRunModel():
return $default(_that.id,_that.provinceId,_that.province,_that.regencyId,_that.regency,_that.districtId,_that.district,_that.villageId,_that.village,_that.reportId,_that.report,_that.title,_that.description,_that.owner,_that.sourcePriority,_that.sourceCategory,_that.sourceApproach,_that.startDate,_that.dueDate,_that.completedAt,_that.updatedAt,_that.status,_that.progressPct,_that.targetParticipants,_that.targetQuota,_that.participantsCount,_that.budget,_that.budgetPlan,_that.notes,_that.daysUntilDue,_that.isOverdue,_that.isWarning,_that.isActive,_that.warningLevel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "province_id")  int? provinceId, @JsonKey(name: "province")  String? province, @JsonKey(name: "regency_id")  int? regencyId, @JsonKey(name: "regency")  String? regency, @JsonKey(name: "district_id")  int? districtId, @JsonKey(name: "district")  String? district, @JsonKey(name: "village_id")  int? villageId, @JsonKey(name: "village")  String? village, @JsonKey(name: "report_id")  dynamic reportId, @JsonKey(name: "report")  dynamic report, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String? description, @JsonKey(name: "owner")  String? owner, @JsonKey(name: "source_priority")  String? sourcePriority, @JsonKey(name: "source_category")  String? sourceCategory, @JsonKey(name: "source_approach")  String? sourceApproach, @JsonKey(name: "start_date")  String? startDate, @JsonKey(name: "due_date")  String? dueDate, @JsonKey(name: "completed_at")  String? completedAt, @JsonKey(name: "updated_at")  String? updatedAt, @JsonKey(name: "status")  String? status, @JsonKey(name: "progress_pct")  num progressPct, @JsonKey(name: "target_participants")  int? targetParticipants, @JsonKey(name: "target_quota")  int? targetQuota, @JsonKey(name: "participants_count")  int? participantsCount, @JsonKey(name: "budget")  num? budget, @JsonKey(name: "budget_plan")  num? budgetPlan, @JsonKey(name: "notes")  String? notes, @JsonKey(name: "days_until_due")  int? daysUntilDue, @JsonKey(name: "is_overdue")  bool isOverdue, @JsonKey(name: "is_warning")  bool isWarning, @JsonKey(name: "is_active")  bool isActive, @JsonKey(name: "warning_level")  String? warningLevel)?  $default,) {final _that = this;
switch (_that) {
case _ActivationRunModel() when $default != null:
return $default(_that.id,_that.provinceId,_that.province,_that.regencyId,_that.regency,_that.districtId,_that.district,_that.villageId,_that.village,_that.reportId,_that.report,_that.title,_that.description,_that.owner,_that.sourcePriority,_that.sourceCategory,_that.sourceApproach,_that.startDate,_that.dueDate,_that.completedAt,_that.updatedAt,_that.status,_that.progressPct,_that.targetParticipants,_that.targetQuota,_that.participantsCount,_that.budget,_that.budgetPlan,_that.notes,_that.daysUntilDue,_that.isOverdue,_that.isWarning,_that.isActive,_that.warningLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationRunModel extends ActivationRunModel {
  const _ActivationRunModel({@JsonKey(name: "id") required this.id, @JsonKey(name: "province_id") this.provinceId, @JsonKey(name: "province") this.province, @JsonKey(name: "regency_id") this.regencyId, @JsonKey(name: "regency") this.regency, @JsonKey(name: "district_id") this.districtId, @JsonKey(name: "district") this.district, @JsonKey(name: "village_id") this.villageId, @JsonKey(name: "village") this.village, @JsonKey(name: "report_id") this.reportId, @JsonKey(name: "report") this.report, @JsonKey(name: "title") required this.title, @JsonKey(name: "description") this.description, @JsonKey(name: "owner") this.owner, @JsonKey(name: "source_priority") this.sourcePriority, @JsonKey(name: "source_category") this.sourceCategory, @JsonKey(name: "source_approach") this.sourceApproach, @JsonKey(name: "start_date") this.startDate, @JsonKey(name: "due_date") this.dueDate, @JsonKey(name: "completed_at") this.completedAt, @JsonKey(name: "updated_at") this.updatedAt, @JsonKey(name: "status") this.status, @JsonKey(name: "progress_pct") this.progressPct = 0, @JsonKey(name: "target_participants") this.targetParticipants, @JsonKey(name: "target_quota") this.targetQuota, @JsonKey(name: "participants_count") this.participantsCount, @JsonKey(name: "budget") this.budget, @JsonKey(name: "budget_plan") this.budgetPlan, @JsonKey(name: "notes") this.notes, @JsonKey(name: "days_until_due") this.daysUntilDue, @JsonKey(name: "is_overdue") this.isOverdue = false, @JsonKey(name: "is_warning") this.isWarning = false, @JsonKey(name: "is_active") this.isActive = true, @JsonKey(name: "warning_level") this.warningLevel}): super._();
  factory _ActivationRunModel.fromJson(Map<String, dynamic> json) => _$ActivationRunModelFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "province_id") final  int? provinceId;
@override@JsonKey(name: "province") final  String? province;
@override@JsonKey(name: "regency_id") final  int? regencyId;
@override@JsonKey(name: "regency") final  String? regency;
@override@JsonKey(name: "district_id") final  int? districtId;
@override@JsonKey(name: "district") final  String? district;
@override@JsonKey(name: "village_id") final  int? villageId;
@override@JsonKey(name: "village") final  String? village;
@override@JsonKey(name: "report_id") final  dynamic reportId;
@override@JsonKey(name: "report") final  dynamic report;
@override@JsonKey(name: "title") final  String title;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "owner") final  String? owner;
@override@JsonKey(name: "source_priority") final  String? sourcePriority;
@override@JsonKey(name: "source_category") final  String? sourceCategory;
@override@JsonKey(name: "source_approach") final  String? sourceApproach;
@override@JsonKey(name: "start_date") final  String? startDate;
@override@JsonKey(name: "due_date") final  String? dueDate;
@override@JsonKey(name: "completed_at") final  String? completedAt;
@override@JsonKey(name: "updated_at") final  String? updatedAt;
@override@JsonKey(name: "status") final  String? status;
@override@JsonKey(name: "progress_pct") final  num progressPct;
@override@JsonKey(name: "target_participants") final  int? targetParticipants;
@override@JsonKey(name: "target_quota") final  int? targetQuota;
@override@JsonKey(name: "participants_count") final  int? participantsCount;
@override@JsonKey(name: "budget") final  num? budget;
@override@JsonKey(name: "budget_plan") final  num? budgetPlan;
@override@JsonKey(name: "notes") final  String? notes;
@override@JsonKey(name: "days_until_due") final  int? daysUntilDue;
@override@JsonKey(name: "is_overdue") final  bool isOverdue;
@override@JsonKey(name: "is_warning") final  bool isWarning;
@override@JsonKey(name: "is_active") final  bool isActive;
@override@JsonKey(name: "warning_level") final  String? warningLevel;

/// Create a copy of ActivationRunModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationRunModelCopyWith<_ActivationRunModel> get copyWith => __$ActivationRunModelCopyWithImpl<_ActivationRunModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationRunModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationRunModel&&(identical(other.id, id) || other.id == id)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.province, province) || other.province == province)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.district, district) || other.district == district)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.village, village) || other.village == village)&&const DeepCollectionEquality().equals(other.reportId, reportId)&&const DeepCollectionEquality().equals(other.report, report)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.sourcePriority, sourcePriority) || other.sourcePriority == sourcePriority)&&(identical(other.sourceCategory, sourceCategory) || other.sourceCategory == sourceCategory)&&(identical(other.sourceApproach, sourceApproach) || other.sourceApproach == sourceApproach)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.progressPct, progressPct) || other.progressPct == progressPct)&&(identical(other.targetParticipants, targetParticipants) || other.targetParticipants == targetParticipants)&&(identical(other.targetQuota, targetQuota) || other.targetQuota == targetQuota)&&(identical(other.participantsCount, participantsCount) || other.participantsCount == participantsCount)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.budgetPlan, budgetPlan) || other.budgetPlan == budgetPlan)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.daysUntilDue, daysUntilDue) || other.daysUntilDue == daysUntilDue)&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.isWarning, isWarning) || other.isWarning == isWarning)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.warningLevel, warningLevel) || other.warningLevel == warningLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,provinceId,province,regencyId,regency,districtId,district,villageId,village,const DeepCollectionEquality().hash(reportId),const DeepCollectionEquality().hash(report),title,description,owner,sourcePriority,sourceCategory,sourceApproach,startDate,dueDate,completedAt,updatedAt,status,progressPct,targetParticipants,targetQuota,participantsCount,budget,budgetPlan,notes,daysUntilDue,isOverdue,isWarning,isActive,warningLevel]);

@override
String toString() {
  return 'ActivationRunModel(id: $id, provinceId: $provinceId, province: $province, regencyId: $regencyId, regency: $regency, districtId: $districtId, district: $district, villageId: $villageId, village: $village, reportId: $reportId, report: $report, title: $title, description: $description, owner: $owner, sourcePriority: $sourcePriority, sourceCategory: $sourceCategory, sourceApproach: $sourceApproach, startDate: $startDate, dueDate: $dueDate, completedAt: $completedAt, updatedAt: $updatedAt, status: $status, progressPct: $progressPct, targetParticipants: $targetParticipants, targetQuota: $targetQuota, participantsCount: $participantsCount, budget: $budget, budgetPlan: $budgetPlan, notes: $notes, daysUntilDue: $daysUntilDue, isOverdue: $isOverdue, isWarning: $isWarning, isActive: $isActive, warningLevel: $warningLevel)';
}


}

/// @nodoc
abstract mixin class _$ActivationRunModelCopyWith<$Res> implements $ActivationRunModelCopyWith<$Res> {
  factory _$ActivationRunModelCopyWith(_ActivationRunModel value, $Res Function(_ActivationRunModel) _then) = __$ActivationRunModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "province_id") int? provinceId,@JsonKey(name: "province") String? province,@JsonKey(name: "regency_id") int? regencyId,@JsonKey(name: "regency") String? regency,@JsonKey(name: "district_id") int? districtId,@JsonKey(name: "district") String? district,@JsonKey(name: "village_id") int? villageId,@JsonKey(name: "village") String? village,@JsonKey(name: "report_id") dynamic reportId,@JsonKey(name: "report") dynamic report,@JsonKey(name: "title") String title,@JsonKey(name: "description") String? description,@JsonKey(name: "owner") String? owner,@JsonKey(name: "source_priority") String? sourcePriority,@JsonKey(name: "source_category") String? sourceCategory,@JsonKey(name: "source_approach") String? sourceApproach,@JsonKey(name: "start_date") String? startDate,@JsonKey(name: "due_date") String? dueDate,@JsonKey(name: "completed_at") String? completedAt,@JsonKey(name: "updated_at") String? updatedAt,@JsonKey(name: "status") String? status,@JsonKey(name: "progress_pct") num progressPct,@JsonKey(name: "target_participants") int? targetParticipants,@JsonKey(name: "target_quota") int? targetQuota,@JsonKey(name: "participants_count") int? participantsCount,@JsonKey(name: "budget") num? budget,@JsonKey(name: "budget_plan") num? budgetPlan,@JsonKey(name: "notes") String? notes,@JsonKey(name: "days_until_due") int? daysUntilDue,@JsonKey(name: "is_overdue") bool isOverdue,@JsonKey(name: "is_warning") bool isWarning,@JsonKey(name: "is_active") bool isActive,@JsonKey(name: "warning_level") String? warningLevel
});




}
/// @nodoc
class __$ActivationRunModelCopyWithImpl<$Res>
    implements _$ActivationRunModelCopyWith<$Res> {
  __$ActivationRunModelCopyWithImpl(this._self, this._then);

  final _ActivationRunModel _self;
  final $Res Function(_ActivationRunModel) _then;

/// Create a copy of ActivationRunModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? provinceId = freezed,Object? province = freezed,Object? regencyId = freezed,Object? regency = freezed,Object? districtId = freezed,Object? district = freezed,Object? villageId = freezed,Object? village = freezed,Object? reportId = freezed,Object? report = freezed,Object? title = null,Object? description = freezed,Object? owner = freezed,Object? sourcePriority = freezed,Object? sourceCategory = freezed,Object? sourceApproach = freezed,Object? startDate = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? updatedAt = freezed,Object? status = freezed,Object? progressPct = null,Object? targetParticipants = freezed,Object? targetQuota = freezed,Object? participantsCount = freezed,Object? budget = freezed,Object? budgetPlan = freezed,Object? notes = freezed,Object? daysUntilDue = freezed,Object? isOverdue = null,Object? isWarning = null,Object? isActive = null,Object? warningLevel = freezed,}) {
  return _then(_ActivationRunModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,provinceId: freezed == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,regencyId: freezed == regencyId ? _self.regencyId : regencyId // ignore: cast_nullable_to_non_nullable
as int?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as int?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as int?,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as String?,reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as dynamic,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as dynamic,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,sourcePriority: freezed == sourcePriority ? _self.sourcePriority : sourcePriority // ignore: cast_nullable_to_non_nullable
as String?,sourceCategory: freezed == sourceCategory ? _self.sourceCategory : sourceCategory // ignore: cast_nullable_to_non_nullable
as String?,sourceApproach: freezed == sourceApproach ? _self.sourceApproach : sourceApproach // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,progressPct: null == progressPct ? _self.progressPct : progressPct // ignore: cast_nullable_to_non_nullable
as num,targetParticipants: freezed == targetParticipants ? _self.targetParticipants : targetParticipants // ignore: cast_nullable_to_non_nullable
as int?,targetQuota: freezed == targetQuota ? _self.targetQuota : targetQuota // ignore: cast_nullable_to_non_nullable
as int?,participantsCount: freezed == participantsCount ? _self.participantsCount : participantsCount // ignore: cast_nullable_to_non_nullable
as int?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as num?,budgetPlan: freezed == budgetPlan ? _self.budgetPlan : budgetPlan // ignore: cast_nullable_to_non_nullable
as num?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,daysUntilDue: freezed == daysUntilDue ? _self.daysUntilDue : daysUntilDue // ignore: cast_nullable_to_non_nullable
as int?,isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,isWarning: null == isWarning ? _self.isWarning : isWarning // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,warningLevel: freezed == warningLevel ? _self.warningLevel : warningLevel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ActivationRunMetaModel {

@JsonKey(name: "current_page") int? get currentPage;@JsonKey(name: "last_page") int? get lastPage;@JsonKey(name: "per_page") int? get perPage;@JsonKey(name: "total") int? get total;@JsonKey(name: "has_more") bool? get hasMore;@JsonKey(name: "next_page_url") String? get nextPageUrl;@JsonKey(name: "prev_page_url") String? get prevPageUrl;@JsonKey(name: "today") String? get today;@JsonKey(name: "warning_days") int? get warningDays;
/// Create a copy of ActivationRunMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationRunMetaModelCopyWith<ActivationRunMetaModel> get copyWith => _$ActivationRunMetaModelCopyWithImpl<ActivationRunMetaModel>(this as ActivationRunMetaModel, _$identity);

  /// Serializes this ActivationRunMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationRunMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextPageUrl, nextPageUrl) || other.nextPageUrl == nextPageUrl)&&(identical(other.prevPageUrl, prevPageUrl) || other.prevPageUrl == prevPageUrl)&&(identical(other.today, today) || other.today == today)&&(identical(other.warningDays, warningDays) || other.warningDays == warningDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total,hasMore,nextPageUrl,prevPageUrl,today,warningDays);

@override
String toString() {
  return 'ActivationRunMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, hasMore: $hasMore, nextPageUrl: $nextPageUrl, prevPageUrl: $prevPageUrl, today: $today, warningDays: $warningDays)';
}


}

/// @nodoc
abstract mixin class $ActivationRunMetaModelCopyWith<$Res>  {
  factory $ActivationRunMetaModelCopyWith(ActivationRunMetaModel value, $Res Function(ActivationRunMetaModel) _then) = _$ActivationRunMetaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "current_page") int? currentPage,@JsonKey(name: "last_page") int? lastPage,@JsonKey(name: "per_page") int? perPage,@JsonKey(name: "total") int? total,@JsonKey(name: "has_more") bool? hasMore,@JsonKey(name: "next_page_url") String? nextPageUrl,@JsonKey(name: "prev_page_url") String? prevPageUrl,@JsonKey(name: "today") String? today,@JsonKey(name: "warning_days") int? warningDays
});




}
/// @nodoc
class _$ActivationRunMetaModelCopyWithImpl<$Res>
    implements $ActivationRunMetaModelCopyWith<$Res> {
  _$ActivationRunMetaModelCopyWithImpl(this._self, this._then);

  final ActivationRunMetaModel _self;
  final $Res Function(ActivationRunMetaModel) _then;

/// Create a copy of ActivationRunMetaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = freezed,Object? lastPage = freezed,Object? perPage = freezed,Object? total = freezed,Object? hasMore = freezed,Object? nextPageUrl = freezed,Object? prevPageUrl = freezed,Object? today = freezed,Object? warningDays = freezed,}) {
  return _then(_self.copyWith(
currentPage: freezed == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int?,lastPage: freezed == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int?,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,hasMore: freezed == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool?,nextPageUrl: freezed == nextPageUrl ? _self.nextPageUrl : nextPageUrl // ignore: cast_nullable_to_non_nullable
as String?,prevPageUrl: freezed == prevPageUrl ? _self.prevPageUrl : prevPageUrl // ignore: cast_nullable_to_non_nullable
as String?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as String?,warningDays: freezed == warningDays ? _self.warningDays : warningDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationRunMetaModel].
extension ActivationRunMetaModelPatterns on ActivationRunMetaModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationRunMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationRunMetaModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationRunMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationRunMetaModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationRunMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationRunMetaModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "current_page")  int? currentPage, @JsonKey(name: "last_page")  int? lastPage, @JsonKey(name: "per_page")  int? perPage, @JsonKey(name: "total")  int? total, @JsonKey(name: "has_more")  bool? hasMore, @JsonKey(name: "next_page_url")  String? nextPageUrl, @JsonKey(name: "prev_page_url")  String? prevPageUrl, @JsonKey(name: "today")  String? today, @JsonKey(name: "warning_days")  int? warningDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationRunMetaModel() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.hasMore,_that.nextPageUrl,_that.prevPageUrl,_that.today,_that.warningDays);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "current_page")  int? currentPage, @JsonKey(name: "last_page")  int? lastPage, @JsonKey(name: "per_page")  int? perPage, @JsonKey(name: "total")  int? total, @JsonKey(name: "has_more")  bool? hasMore, @JsonKey(name: "next_page_url")  String? nextPageUrl, @JsonKey(name: "prev_page_url")  String? prevPageUrl, @JsonKey(name: "today")  String? today, @JsonKey(name: "warning_days")  int? warningDays)  $default,) {final _that = this;
switch (_that) {
case _ActivationRunMetaModel():
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.hasMore,_that.nextPageUrl,_that.prevPageUrl,_that.today,_that.warningDays);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "current_page")  int? currentPage, @JsonKey(name: "last_page")  int? lastPage, @JsonKey(name: "per_page")  int? perPage, @JsonKey(name: "total")  int? total, @JsonKey(name: "has_more")  bool? hasMore, @JsonKey(name: "next_page_url")  String? nextPageUrl, @JsonKey(name: "prev_page_url")  String? prevPageUrl, @JsonKey(name: "today")  String? today, @JsonKey(name: "warning_days")  int? warningDays)?  $default,) {final _that = this;
switch (_that) {
case _ActivationRunMetaModel() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.hasMore,_that.nextPageUrl,_that.prevPageUrl,_that.today,_that.warningDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationRunMetaModel extends ActivationRunMetaModel {
  const _ActivationRunMetaModel({@JsonKey(name: "current_page") this.currentPage, @JsonKey(name: "last_page") this.lastPage, @JsonKey(name: "per_page") this.perPage, @JsonKey(name: "total") this.total, @JsonKey(name: "has_more") this.hasMore, @JsonKey(name: "next_page_url") this.nextPageUrl, @JsonKey(name: "prev_page_url") this.prevPageUrl, @JsonKey(name: "today") this.today, @JsonKey(name: "warning_days") this.warningDays}): super._();
  factory _ActivationRunMetaModel.fromJson(Map<String, dynamic> json) => _$ActivationRunMetaModelFromJson(json);

@override@JsonKey(name: "current_page") final  int? currentPage;
@override@JsonKey(name: "last_page") final  int? lastPage;
@override@JsonKey(name: "per_page") final  int? perPage;
@override@JsonKey(name: "total") final  int? total;
@override@JsonKey(name: "has_more") final  bool? hasMore;
@override@JsonKey(name: "next_page_url") final  String? nextPageUrl;
@override@JsonKey(name: "prev_page_url") final  String? prevPageUrl;
@override@JsonKey(name: "today") final  String? today;
@override@JsonKey(name: "warning_days") final  int? warningDays;

/// Create a copy of ActivationRunMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationRunMetaModelCopyWith<_ActivationRunMetaModel> get copyWith => __$ActivationRunMetaModelCopyWithImpl<_ActivationRunMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationRunMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationRunMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextPageUrl, nextPageUrl) || other.nextPageUrl == nextPageUrl)&&(identical(other.prevPageUrl, prevPageUrl) || other.prevPageUrl == prevPageUrl)&&(identical(other.today, today) || other.today == today)&&(identical(other.warningDays, warningDays) || other.warningDays == warningDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total,hasMore,nextPageUrl,prevPageUrl,today,warningDays);

@override
String toString() {
  return 'ActivationRunMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, hasMore: $hasMore, nextPageUrl: $nextPageUrl, prevPageUrl: $prevPageUrl, today: $today, warningDays: $warningDays)';
}


}

/// @nodoc
abstract mixin class _$ActivationRunMetaModelCopyWith<$Res> implements $ActivationRunMetaModelCopyWith<$Res> {
  factory _$ActivationRunMetaModelCopyWith(_ActivationRunMetaModel value, $Res Function(_ActivationRunMetaModel) _then) = __$ActivationRunMetaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "current_page") int? currentPage,@JsonKey(name: "last_page") int? lastPage,@JsonKey(name: "per_page") int? perPage,@JsonKey(name: "total") int? total,@JsonKey(name: "has_more") bool? hasMore,@JsonKey(name: "next_page_url") String? nextPageUrl,@JsonKey(name: "prev_page_url") String? prevPageUrl,@JsonKey(name: "today") String? today,@JsonKey(name: "warning_days") int? warningDays
});




}
/// @nodoc
class __$ActivationRunMetaModelCopyWithImpl<$Res>
    implements _$ActivationRunMetaModelCopyWith<$Res> {
  __$ActivationRunMetaModelCopyWithImpl(this._self, this._then);

  final _ActivationRunMetaModel _self;
  final $Res Function(_ActivationRunMetaModel) _then;

/// Create a copy of ActivationRunMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = freezed,Object? lastPage = freezed,Object? perPage = freezed,Object? total = freezed,Object? hasMore = freezed,Object? nextPageUrl = freezed,Object? prevPageUrl = freezed,Object? today = freezed,Object? warningDays = freezed,}) {
  return _then(_ActivationRunMetaModel(
currentPage: freezed == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int?,lastPage: freezed == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int?,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,hasMore: freezed == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool?,nextPageUrl: freezed == nextPageUrl ? _self.nextPageUrl : nextPageUrl // ignore: cast_nullable_to_non_nullable
as String?,prevPageUrl: freezed == prevPageUrl ? _self.prevPageUrl : prevPageUrl // ignore: cast_nullable_to_non_nullable
as String?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as String?,warningDays: freezed == warningDays ? _self.warningDays : warningDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ActivationRunResponseModel {

@JsonKey(name: "success") bool get success;@JsonKey(name: "data") List<ActivationRunModel> get data;@JsonKey(name: "meta") ActivationRunMetaModel? get meta;@JsonKey(name: "message") String? get message;
/// Create a copy of ActivationRunResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationRunResponseModelCopyWith<ActivationRunResponseModel> get copyWith => _$ActivationRunResponseModelCopyWithImpl<ActivationRunResponseModel>(this as ActivationRunResponseModel, _$identity);

  /// Serializes this ActivationRunResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationRunResponseModel&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),meta,message);

@override
String toString() {
  return 'ActivationRunResponseModel(success: $success, data: $data, meta: $meta, message: $message)';
}


}

/// @nodoc
abstract mixin class $ActivationRunResponseModelCopyWith<$Res>  {
  factory $ActivationRunResponseModelCopyWith(ActivationRunResponseModel value, $Res Function(ActivationRunResponseModel) _then) = _$ActivationRunResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "data") List<ActivationRunModel> data,@JsonKey(name: "meta") ActivationRunMetaModel? meta,@JsonKey(name: "message") String? message
});


$ActivationRunMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class _$ActivationRunResponseModelCopyWithImpl<$Res>
    implements $ActivationRunResponseModelCopyWith<$Res> {
  _$ActivationRunResponseModelCopyWithImpl(this._self, this._then);

  final ActivationRunResponseModel _self;
  final $Res Function(ActivationRunResponseModel) _then;

/// Create a copy of ActivationRunResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? meta = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ActivationRunModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ActivationRunMetaModel?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ActivationRunResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationRunMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ActivationRunMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivationRunResponseModel].
extension ActivationRunResponseModelPatterns on ActivationRunResponseModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationRunResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationRunResponseModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationRunResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationRunResponseModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationRunResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationRunResponseModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  List<ActivationRunModel> data, @JsonKey(name: "meta")  ActivationRunMetaModel? meta, @JsonKey(name: "message")  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationRunResponseModel() when $default != null:
return $default(_that.success,_that.data,_that.meta,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  List<ActivationRunModel> data, @JsonKey(name: "meta")  ActivationRunMetaModel? meta, @JsonKey(name: "message")  String? message)  $default,) {final _that = this;
switch (_that) {
case _ActivationRunResponseModel():
return $default(_that.success,_that.data,_that.meta,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  List<ActivationRunModel> data, @JsonKey(name: "meta")  ActivationRunMetaModel? meta, @JsonKey(name: "message")  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ActivationRunResponseModel() when $default != null:
return $default(_that.success,_that.data,_that.meta,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationRunResponseModel extends ActivationRunResponseModel {
  const _ActivationRunResponseModel({@JsonKey(name: "success") this.success = false, @JsonKey(name: "data") final  List<ActivationRunModel> data = const [], @JsonKey(name: "meta") this.meta, @JsonKey(name: "message") this.message}): _data = data,super._();
  factory _ActivationRunResponseModel.fromJson(Map<String, dynamic> json) => _$ActivationRunResponseModelFromJson(json);

@override@JsonKey(name: "success") final  bool success;
 final  List<ActivationRunModel> _data;
@override@JsonKey(name: "data") List<ActivationRunModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: "meta") final  ActivationRunMetaModel? meta;
@override@JsonKey(name: "message") final  String? message;

/// Create a copy of ActivationRunResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationRunResponseModelCopyWith<_ActivationRunResponseModel> get copyWith => __$ActivationRunResponseModelCopyWithImpl<_ActivationRunResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationRunResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationRunResponseModel&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),meta,message);

@override
String toString() {
  return 'ActivationRunResponseModel(success: $success, data: $data, meta: $meta, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActivationRunResponseModelCopyWith<$Res> implements $ActivationRunResponseModelCopyWith<$Res> {
  factory _$ActivationRunResponseModelCopyWith(_ActivationRunResponseModel value, $Res Function(_ActivationRunResponseModel) _then) = __$ActivationRunResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "data") List<ActivationRunModel> data,@JsonKey(name: "meta") ActivationRunMetaModel? meta,@JsonKey(name: "message") String? message
});


@override $ActivationRunMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class __$ActivationRunResponseModelCopyWithImpl<$Res>
    implements _$ActivationRunResponseModelCopyWith<$Res> {
  __$ActivationRunResponseModelCopyWithImpl(this._self, this._then);

  final _ActivationRunResponseModel _self;
  final $Res Function(_ActivationRunResponseModel) _then;

/// Create a copy of ActivationRunResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? meta = freezed,Object? message = freezed,}) {
  return _then(_ActivationRunResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ActivationRunModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ActivationRunMetaModel?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ActivationRunResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationRunMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ActivationRunMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
