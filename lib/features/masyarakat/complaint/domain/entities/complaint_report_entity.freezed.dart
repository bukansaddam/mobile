// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complaint_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComplaintReportEntity {

 String get id; String get ticketNumber; String get status; DateTime? get createdAt;
/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintReportEntityCopyWith<ComplaintReportEntity> get copyWith => _$ComplaintReportEntityCopyWithImpl<ComplaintReportEntity>(this as ComplaintReportEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintReportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,status,createdAt);

@override
String toString() {
  return 'ComplaintReportEntity(id: $id, ticketNumber: $ticketNumber, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ComplaintReportEntityCopyWith<$Res>  {
  factory $ComplaintReportEntityCopyWith(ComplaintReportEntity value, $Res Function(ComplaintReportEntity) _then) = _$ComplaintReportEntityCopyWithImpl;
@useResult
$Res call({
 String id, String ticketNumber, String status, DateTime? createdAt
});




}
/// @nodoc
class _$ComplaintReportEntityCopyWithImpl<$Res>
    implements $ComplaintReportEntityCopyWith<$Res> {
  _$ComplaintReportEntityCopyWithImpl(this._self, this._then);

  final ComplaintReportEntity _self;
  final $Res Function(ComplaintReportEntity) _then;

/// Create a copy of ComplaintReportEntity
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


/// Adds pattern-matching-related methods to [ComplaintReportEntity].
extension ComplaintReportEntityPatterns on ComplaintReportEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintReportEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintReportEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintReportEntity value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintReportEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ticketNumber,  String status,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintReportEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ticketNumber,  String status,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ticketNumber,  String status,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportEntity() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ComplaintReportEntity extends ComplaintReportEntity {
  const _ComplaintReportEntity({this.id = '', this.ticketNumber = '', this.status = '', this.createdAt}): super._();
  

@override@JsonKey() final  String id;
@override@JsonKey() final  String ticketNumber;
@override@JsonKey() final  String status;
@override final  DateTime? createdAt;

/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintReportEntityCopyWith<_ComplaintReportEntity> get copyWith => __$ComplaintReportEntityCopyWithImpl<_ComplaintReportEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintReportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,status,createdAt);

@override
String toString() {
  return 'ComplaintReportEntity(id: $id, ticketNumber: $ticketNumber, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ComplaintReportEntityCopyWith<$Res> implements $ComplaintReportEntityCopyWith<$Res> {
  factory _$ComplaintReportEntityCopyWith(_ComplaintReportEntity value, $Res Function(_ComplaintReportEntity) _then) = __$ComplaintReportEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String ticketNumber, String status, DateTime? createdAt
});




}
/// @nodoc
class __$ComplaintReportEntityCopyWithImpl<$Res>
    implements _$ComplaintReportEntityCopyWith<$Res> {
  __$ComplaintReportEntityCopyWithImpl(this._self, this._then);

  final _ComplaintReportEntity _self;
  final $Res Function(_ComplaintReportEntity) _then;

/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ticketNumber = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_ComplaintReportEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
