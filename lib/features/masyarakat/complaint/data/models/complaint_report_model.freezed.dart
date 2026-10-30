// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complaint_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComplaintReportModel {

@JsonKey(name: 'id', readValue: _readId) String get id;@JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) String get ticketNumber;@JsonKey(name: 'status') String get status;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get createdAt;
/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintReportModelCopyWith<ComplaintReportModel> get copyWith => _$ComplaintReportModelCopyWithImpl<ComplaintReportModel>(this as ComplaintReportModel, _$identity);

  /// Serializes this ComplaintReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,status,createdAt);

@override
String toString() {
  return 'ComplaintReportModel(id: $id, ticketNumber: $ticketNumber, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ComplaintReportModelCopyWith<$Res>  {
  factory $ComplaintReportModelCopyWith(ComplaintReportModel value, $Res Function(ComplaintReportModel) _then) = _$ComplaintReportModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) String ticketNumber,@JsonKey(name: 'status') String status,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class _$ComplaintReportModelCopyWithImpl<$Res>
    implements $ComplaintReportModelCopyWith<$Res> {
  _$ComplaintReportModelCopyWithImpl(this._self, this._then);

  final ComplaintReportModel _self;
  final $Res Function(ComplaintReportModel) _then;

/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ticketNumber = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintReportModel].
extension ComplaintReportModelPatterns on ComplaintReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintReportModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber)  String ticketNumber, @JsonKey(name: 'status')  String status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintReportModel() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber)  String ticketNumber, @JsonKey(name: 'status')  String status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportModel():
return $default(_that.id,_that.ticketNumber,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber)  String ticketNumber, @JsonKey(name: 'status')  String status, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportModel() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintReportModel extends ComplaintReportModel {
  const _ComplaintReportModel({@JsonKey(name: 'id', readValue: _readId) this.id = '', @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) this.ticketNumber = '', @JsonKey(name: 'status') this.status = '', @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.createdAt}): super._();
  factory _ComplaintReportModel.fromJson(Map<String, dynamic> json) => _$ComplaintReportModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  String id;
@override@JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) final  String ticketNumber;
@override@JsonKey(name: 'status') final  String status;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? createdAt;

/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintReportModelCopyWith<_ComplaintReportModel> get copyWith => __$ComplaintReportModelCopyWithImpl<_ComplaintReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,status,createdAt);

@override
String toString() {
  return 'ComplaintReportModel(id: $id, ticketNumber: $ticketNumber, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ComplaintReportModelCopyWith<$Res> implements $ComplaintReportModelCopyWith<$Res> {
  factory _$ComplaintReportModelCopyWith(_ComplaintReportModel value, $Res Function(_ComplaintReportModel) _then) = __$ComplaintReportModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) String ticketNumber,@JsonKey(name: 'status') String status,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class __$ComplaintReportModelCopyWithImpl<$Res>
    implements _$ComplaintReportModelCopyWith<$Res> {
  __$ComplaintReportModelCopyWithImpl(this._self, this._then);

  final _ComplaintReportModel _self;
  final $Res Function(_ComplaintReportModel) _then;

/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ticketNumber = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_ComplaintReportModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
