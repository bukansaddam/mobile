// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ktp_ocr_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KtpOcrEntity {

 String get nik; String get name; String get birthPlace; DateTime? get birthDate; String get address;
/// Create a copy of KtpOcrEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KtpOcrEntityCopyWith<KtpOcrEntity> get copyWith => _$KtpOcrEntityCopyWithImpl<KtpOcrEntity>(this as KtpOcrEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KtpOcrEntity&&(identical(other.nik, nik) || other.nik == nik)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,nik,name,birthPlace,birthDate,address);

@override
String toString() {
  return 'KtpOcrEntity(nik: $nik, name: $name, birthPlace: $birthPlace, birthDate: $birthDate, address: $address)';
}


}

/// @nodoc
abstract mixin class $KtpOcrEntityCopyWith<$Res>  {
  factory $KtpOcrEntityCopyWith(KtpOcrEntity value, $Res Function(KtpOcrEntity) _then) = _$KtpOcrEntityCopyWithImpl;
@useResult
$Res call({
 String nik, String name, String birthPlace, DateTime? birthDate, String address
});




}
/// @nodoc
class _$KtpOcrEntityCopyWithImpl<$Res>
    implements $KtpOcrEntityCopyWith<$Res> {
  _$KtpOcrEntityCopyWithImpl(this._self, this._then);

  final KtpOcrEntity _self;
  final $Res Function(KtpOcrEntity) _then;

/// Create a copy of KtpOcrEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nik = null,Object? name = null,Object? birthPlace = null,Object? birthDate = freezed,Object? address = null,}) {
  return _then(_self.copyWith(
nik: null == nik ? _self.nik : nik // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthPlace: null == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KtpOcrEntity].
extension KtpOcrEntityPatterns on KtpOcrEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KtpOcrEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KtpOcrEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KtpOcrEntity value)  $default,){
final _that = this;
switch (_that) {
case _KtpOcrEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KtpOcrEntity value)?  $default,){
final _that = this;
switch (_that) {
case _KtpOcrEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nik,  String name,  String birthPlace,  DateTime? birthDate,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KtpOcrEntity() when $default != null:
return $default(_that.nik,_that.name,_that.birthPlace,_that.birthDate,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nik,  String name,  String birthPlace,  DateTime? birthDate,  String address)  $default,) {final _that = this;
switch (_that) {
case _KtpOcrEntity():
return $default(_that.nik,_that.name,_that.birthPlace,_that.birthDate,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nik,  String name,  String birthPlace,  DateTime? birthDate,  String address)?  $default,) {final _that = this;
switch (_that) {
case _KtpOcrEntity() when $default != null:
return $default(_that.nik,_that.name,_that.birthPlace,_that.birthDate,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _KtpOcrEntity implements KtpOcrEntity {
  const _KtpOcrEntity({this.nik = '', this.name = '', this.birthPlace = '', this.birthDate, this.address = ''});
  

@override@JsonKey() final  String nik;
@override@JsonKey() final  String name;
@override@JsonKey() final  String birthPlace;
@override final  DateTime? birthDate;
@override@JsonKey() final  String address;

/// Create a copy of KtpOcrEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KtpOcrEntityCopyWith<_KtpOcrEntity> get copyWith => __$KtpOcrEntityCopyWithImpl<_KtpOcrEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KtpOcrEntity&&(identical(other.nik, nik) || other.nik == nik)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,nik,name,birthPlace,birthDate,address);

@override
String toString() {
  return 'KtpOcrEntity(nik: $nik, name: $name, birthPlace: $birthPlace, birthDate: $birthDate, address: $address)';
}


}

/// @nodoc
abstract mixin class _$KtpOcrEntityCopyWith<$Res> implements $KtpOcrEntityCopyWith<$Res> {
  factory _$KtpOcrEntityCopyWith(_KtpOcrEntity value, $Res Function(_KtpOcrEntity) _then) = __$KtpOcrEntityCopyWithImpl;
@override @useResult
$Res call({
 String nik, String name, String birthPlace, DateTime? birthDate, String address
});




}
/// @nodoc
class __$KtpOcrEntityCopyWithImpl<$Res>
    implements _$KtpOcrEntityCopyWith<$Res> {
  __$KtpOcrEntityCopyWithImpl(this._self, this._then);

  final _KtpOcrEntity _self;
  final $Res Function(_KtpOcrEntity) _then;

/// Create a copy of KtpOcrEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nik = null,Object? name = null,Object? birthPlace = null,Object? birthDate = freezed,Object? address = null,}) {
  return _then(_KtpOcrEntity(
nik: null == nik ? _self.nik : nik // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthPlace: null == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
