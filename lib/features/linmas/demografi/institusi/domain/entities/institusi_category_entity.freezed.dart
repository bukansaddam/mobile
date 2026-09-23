// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institusi_category_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstitusiCategoryEntity {

 int? get id; String get label; String? get code; bool get isActive; String? get domain; String? get color;
/// Create a copy of InstitusiCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiCategoryEntityCopyWith<InstitusiCategoryEntity> get copyWith => _$InstitusiCategoryEntityCopyWithImpl<InstitusiCategoryEntity>(this as InstitusiCategoryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiCategoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.code, code) || other.code == code)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,code,isActive,domain,color);

@override
String toString() {
  return 'InstitusiCategoryEntity(id: $id, label: $label, code: $code, isActive: $isActive, domain: $domain, color: $color)';
}


}

/// @nodoc
abstract mixin class $InstitusiCategoryEntityCopyWith<$Res>  {
  factory $InstitusiCategoryEntityCopyWith(InstitusiCategoryEntity value, $Res Function(InstitusiCategoryEntity) _then) = _$InstitusiCategoryEntityCopyWithImpl;
@useResult
$Res call({
 int? id, String label, String? code, bool isActive, String? domain, String? color
});




}
/// @nodoc
class _$InstitusiCategoryEntityCopyWithImpl<$Res>
    implements $InstitusiCategoryEntityCopyWith<$Res> {
  _$InstitusiCategoryEntityCopyWithImpl(this._self, this._then);

  final InstitusiCategoryEntity _self;
  final $Res Function(InstitusiCategoryEntity) _then;

/// Create a copy of InstitusiCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? label = null,Object? code = freezed,Object? isActive = null,Object? domain = freezed,Object? color = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,domain: freezed == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstitusiCategoryEntity].
extension InstitusiCategoryEntityPatterns on InstitusiCategoryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiCategoryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiCategoryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiCategoryEntity value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiCategoryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiCategoryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiCategoryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String label,  String? code,  bool isActive,  String? domain,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitusiCategoryEntity() when $default != null:
return $default(_that.id,_that.label,_that.code,_that.isActive,_that.domain,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String label,  String? code,  bool isActive,  String? domain,  String? color)  $default,) {final _that = this;
switch (_that) {
case _InstitusiCategoryEntity():
return $default(_that.id,_that.label,_that.code,_that.isActive,_that.domain,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String label,  String? code,  bool isActive,  String? domain,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _InstitusiCategoryEntity() when $default != null:
return $default(_that.id,_that.label,_that.code,_that.isActive,_that.domain,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _InstitusiCategoryEntity implements InstitusiCategoryEntity {
  const _InstitusiCategoryEntity({this.id, required this.label, this.code, this.isActive = true, this.domain, this.color});
  

@override final  int? id;
@override final  String label;
@override final  String? code;
@override@JsonKey() final  bool isActive;
@override final  String? domain;
@override final  String? color;

/// Create a copy of InstitusiCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiCategoryEntityCopyWith<_InstitusiCategoryEntity> get copyWith => __$InstitusiCategoryEntityCopyWithImpl<_InstitusiCategoryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiCategoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.code, code) || other.code == code)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,code,isActive,domain,color);

@override
String toString() {
  return 'InstitusiCategoryEntity(id: $id, label: $label, code: $code, isActive: $isActive, domain: $domain, color: $color)';
}


}

/// @nodoc
abstract mixin class _$InstitusiCategoryEntityCopyWith<$Res> implements $InstitusiCategoryEntityCopyWith<$Res> {
  factory _$InstitusiCategoryEntityCopyWith(_InstitusiCategoryEntity value, $Res Function(_InstitusiCategoryEntity) _then) = __$InstitusiCategoryEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, String label, String? code, bool isActive, String? domain, String? color
});




}
/// @nodoc
class __$InstitusiCategoryEntityCopyWithImpl<$Res>
    implements _$InstitusiCategoryEntityCopyWith<$Res> {
  __$InstitusiCategoryEntityCopyWithImpl(this._self, this._then);

  final _InstitusiCategoryEntity _self;
  final $Res Function(_InstitusiCategoryEntity) _then;

/// Create a copy of InstitusiCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? label = null,Object? code = freezed,Object? isActive = null,Object? domain = freezed,Object? color = freezed,}) {
  return _then(_InstitusiCategoryEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,domain: freezed == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
