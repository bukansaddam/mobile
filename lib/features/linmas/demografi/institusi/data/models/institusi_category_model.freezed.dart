// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institusi_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstitusiCategoryModel {

@JsonKey(name: 'id', readValue: _readId) int? get id;@JsonKey(name: 'label', readValue: _readLabel) String get label;@JsonKey(name: 'code') String? get code;@JsonKey(name: 'is_active', readValue: _readIsActive) bool get isActive;@JsonKey(name: 'domain') String? get domain;@JsonKey(name: 'color') String? get color;
/// Create a copy of InstitusiCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiCategoryModelCopyWith<InstitusiCategoryModel> get copyWith => _$InstitusiCategoryModelCopyWithImpl<InstitusiCategoryModel>(this as InstitusiCategoryModel, _$identity);

  /// Serializes this InstitusiCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.code, code) || other.code == code)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,code,isActive,domain,color);

@override
String toString() {
  return 'InstitusiCategoryModel(id: $id, label: $label, code: $code, isActive: $isActive, domain: $domain, color: $color)';
}


}

/// @nodoc
abstract mixin class $InstitusiCategoryModelCopyWith<$Res>  {
  factory $InstitusiCategoryModelCopyWith(InstitusiCategoryModel value, $Res Function(InstitusiCategoryModel) _then) = _$InstitusiCategoryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) int? id,@JsonKey(name: 'label', readValue: _readLabel) String label,@JsonKey(name: 'code') String? code,@JsonKey(name: 'is_active', readValue: _readIsActive) bool isActive,@JsonKey(name: 'domain') String? domain,@JsonKey(name: 'color') String? color
});




}
/// @nodoc
class _$InstitusiCategoryModelCopyWithImpl<$Res>
    implements $InstitusiCategoryModelCopyWith<$Res> {
  _$InstitusiCategoryModelCopyWithImpl(this._self, this._then);

  final InstitusiCategoryModel _self;
  final $Res Function(InstitusiCategoryModel) _then;

/// Create a copy of InstitusiCategoryModel
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


/// Adds pattern-matching-related methods to [InstitusiCategoryModel].
extension InstitusiCategoryModelPatterns on InstitusiCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  int? id, @JsonKey(name: 'label', readValue: _readLabel)  String label, @JsonKey(name: 'code')  String? code, @JsonKey(name: 'is_active', readValue: _readIsActive)  bool isActive, @JsonKey(name: 'domain')  String? domain, @JsonKey(name: 'color')  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitusiCategoryModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  int? id, @JsonKey(name: 'label', readValue: _readLabel)  String label, @JsonKey(name: 'code')  String? code, @JsonKey(name: 'is_active', readValue: _readIsActive)  bool isActive, @JsonKey(name: 'domain')  String? domain, @JsonKey(name: 'color')  String? color)  $default,) {final _that = this;
switch (_that) {
case _InstitusiCategoryModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  int? id, @JsonKey(name: 'label', readValue: _readLabel)  String label, @JsonKey(name: 'code')  String? code, @JsonKey(name: 'is_active', readValue: _readIsActive)  bool isActive, @JsonKey(name: 'domain')  String? domain, @JsonKey(name: 'color')  String? color)?  $default,) {final _that = this;
switch (_that) {
case _InstitusiCategoryModel() when $default != null:
return $default(_that.id,_that.label,_that.code,_that.isActive,_that.domain,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstitusiCategoryModel extends InstitusiCategoryModel {
  const _InstitusiCategoryModel({@JsonKey(name: 'id', readValue: _readId) this.id, @JsonKey(name: 'label', readValue: _readLabel) required this.label, @JsonKey(name: 'code') this.code, @JsonKey(name: 'is_active', readValue: _readIsActive) this.isActive = true, @JsonKey(name: 'domain') this.domain, @JsonKey(name: 'color') this.color}): super._();
  factory _InstitusiCategoryModel.fromJson(Map<String, dynamic> json) => _$InstitusiCategoryModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  int? id;
@override@JsonKey(name: 'label', readValue: _readLabel) final  String label;
@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'is_active', readValue: _readIsActive) final  bool isActive;
@override@JsonKey(name: 'domain') final  String? domain;
@override@JsonKey(name: 'color') final  String? color;

/// Create a copy of InstitusiCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiCategoryModelCopyWith<_InstitusiCategoryModel> get copyWith => __$InstitusiCategoryModelCopyWithImpl<_InstitusiCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstitusiCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.code, code) || other.code == code)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,code,isActive,domain,color);

@override
String toString() {
  return 'InstitusiCategoryModel(id: $id, label: $label, code: $code, isActive: $isActive, domain: $domain, color: $color)';
}


}

/// @nodoc
abstract mixin class _$InstitusiCategoryModelCopyWith<$Res> implements $InstitusiCategoryModelCopyWith<$Res> {
  factory _$InstitusiCategoryModelCopyWith(_InstitusiCategoryModel value, $Res Function(_InstitusiCategoryModel) _then) = __$InstitusiCategoryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) int? id,@JsonKey(name: 'label', readValue: _readLabel) String label,@JsonKey(name: 'code') String? code,@JsonKey(name: 'is_active', readValue: _readIsActive) bool isActive,@JsonKey(name: 'domain') String? domain,@JsonKey(name: 'color') String? color
});




}
/// @nodoc
class __$InstitusiCategoryModelCopyWithImpl<$Res>
    implements _$InstitusiCategoryModelCopyWith<$Res> {
  __$InstitusiCategoryModelCopyWithImpl(this._self, this._then);

  final _InstitusiCategoryModel _self;
  final $Res Function(_InstitusiCategoryModel) _then;

/// Create a copy of InstitusiCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? label = null,Object? code = freezed,Object? isActive = null,Object? domain = freezed,Object? color = freezed,}) {
  return _then(_InstitusiCategoryModel(
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
