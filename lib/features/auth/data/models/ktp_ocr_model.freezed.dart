// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ktp_ocr_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KtpOcrModel {

 String get nik; String get name; String get birthPlace; String get birthDate; String get address;
/// Create a copy of KtpOcrModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KtpOcrModelCopyWith<KtpOcrModel> get copyWith => _$KtpOcrModelCopyWithImpl<KtpOcrModel>(this as KtpOcrModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KtpOcrModel&&(identical(other.nik, nik) || other.nik == nik)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,nik,name,birthPlace,birthDate,address);

@override
String toString() {
  return 'KtpOcrModel(nik: $nik, name: $name, birthPlace: $birthPlace, birthDate: $birthDate, address: $address)';
}


}

/// @nodoc
abstract mixin class $KtpOcrModelCopyWith<$Res>  {
  factory $KtpOcrModelCopyWith(KtpOcrModel value, $Res Function(KtpOcrModel) _then) = _$KtpOcrModelCopyWithImpl;
@useResult
$Res call({
 String nik, String name, String birthPlace, String birthDate, String address
});




}
/// @nodoc
class _$KtpOcrModelCopyWithImpl<$Res>
    implements $KtpOcrModelCopyWith<$Res> {
  _$KtpOcrModelCopyWithImpl(this._self, this._then);

  final KtpOcrModel _self;
  final $Res Function(KtpOcrModel) _then;

/// Create a copy of KtpOcrModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nik = null,Object? name = null,Object? birthPlace = null,Object? birthDate = null,Object? address = null,}) {
  return _then(_self.copyWith(
nik: null == nik ? _self.nik : nik // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthPlace: null == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KtpOcrModel].
extension KtpOcrModelPatterns on KtpOcrModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KtpOcrModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KtpOcrModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KtpOcrModel value)  $default,){
final _that = this;
switch (_that) {
case _KtpOcrModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KtpOcrModel value)?  $default,){
final _that = this;
switch (_that) {
case _KtpOcrModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nik,  String name,  String birthPlace,  String birthDate,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KtpOcrModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nik,  String name,  String birthPlace,  String birthDate,  String address)  $default,) {final _that = this;
switch (_that) {
case _KtpOcrModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nik,  String name,  String birthPlace,  String birthDate,  String address)?  $default,) {final _that = this;
switch (_that) {
case _KtpOcrModel() when $default != null:
return $default(_that.nik,_that.name,_that.birthPlace,_that.birthDate,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _KtpOcrModel implements KtpOcrModel {
  const _KtpOcrModel({this.nik = '', this.name = '', this.birthPlace = '', this.birthDate = '', this.address = ''});
  

@override@JsonKey() final  String nik;
@override@JsonKey() final  String name;
@override@JsonKey() final  String birthPlace;
@override@JsonKey() final  String birthDate;
@override@JsonKey() final  String address;

/// Create a copy of KtpOcrModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KtpOcrModelCopyWith<_KtpOcrModel> get copyWith => __$KtpOcrModelCopyWithImpl<_KtpOcrModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KtpOcrModel&&(identical(other.nik, nik) || other.nik == nik)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthPlace, birthPlace) || other.birthPlace == birthPlace)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,nik,name,birthPlace,birthDate,address);

@override
String toString() {
  return 'KtpOcrModel(nik: $nik, name: $name, birthPlace: $birthPlace, birthDate: $birthDate, address: $address)';
}


}

/// @nodoc
abstract mixin class _$KtpOcrModelCopyWith<$Res> implements $KtpOcrModelCopyWith<$Res> {
  factory _$KtpOcrModelCopyWith(_KtpOcrModel value, $Res Function(_KtpOcrModel) _then) = __$KtpOcrModelCopyWithImpl;
@override @useResult
$Res call({
 String nik, String name, String birthPlace, String birthDate, String address
});




}
/// @nodoc
class __$KtpOcrModelCopyWithImpl<$Res>
    implements _$KtpOcrModelCopyWith<$Res> {
  __$KtpOcrModelCopyWithImpl(this._self, this._then);

  final _KtpOcrModel _self;
  final $Res Function(_KtpOcrModel) _then;

/// Create a copy of KtpOcrModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nik = null,Object? name = null,Object? birthPlace = null,Object? birthDate = null,Object? address = null,}) {
  return _then(_KtpOcrModel(
nik: null == nik ? _self.nik : nik // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthPlace: null == birthPlace ? _self.birthPlace : birthPlace // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
