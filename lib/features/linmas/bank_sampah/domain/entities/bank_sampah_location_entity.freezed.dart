// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_sampah_location_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BankSampahLocationEntity {

 String get id; String get nama; String get alamat; String get kelurahan; String get pengelola; String get kontak; double? get latitude; double? get longitude; double? get latOffset; double? get lngOffset; double? get distanceMeters;
/// Create a copy of BankSampahLocationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahLocationEntityCopyWith<BankSampahLocationEntity> get copyWith => _$BankSampahLocationEntityCopyWithImpl<BankSampahLocationEntity>(this as BankSampahLocationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahLocationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.alamat, alamat) || other.alamat == alamat)&&(identical(other.kelurahan, kelurahan) || other.kelurahan == kelurahan)&&(identical(other.pengelola, pengelola) || other.pengelola == pengelola)&&(identical(other.kontak, kontak) || other.kontak == kontak)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.latOffset, latOffset) || other.latOffset == latOffset)&&(identical(other.lngOffset, lngOffset) || other.lngOffset == lngOffset)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters));
}


@override
int get hashCode => Object.hash(runtimeType,id,nama,alamat,kelurahan,pengelola,kontak,latitude,longitude,latOffset,lngOffset,distanceMeters);

@override
String toString() {
  return 'BankSampahLocationEntity(id: $id, nama: $nama, alamat: $alamat, kelurahan: $kelurahan, pengelola: $pengelola, kontak: $kontak, latitude: $latitude, longitude: $longitude, latOffset: $latOffset, lngOffset: $lngOffset, distanceMeters: $distanceMeters)';
}


}

/// @nodoc
abstract mixin class $BankSampahLocationEntityCopyWith<$Res>  {
  factory $BankSampahLocationEntityCopyWith(BankSampahLocationEntity value, $Res Function(BankSampahLocationEntity) _then) = _$BankSampahLocationEntityCopyWithImpl;
@useResult
$Res call({
 String id, String nama, String alamat, String kelurahan, String pengelola, String kontak, double? latitude, double? longitude, double? latOffset, double? lngOffset, double? distanceMeters
});




}
/// @nodoc
class _$BankSampahLocationEntityCopyWithImpl<$Res>
    implements $BankSampahLocationEntityCopyWith<$Res> {
  _$BankSampahLocationEntityCopyWithImpl(this._self, this._then);

  final BankSampahLocationEntity _self;
  final $Res Function(BankSampahLocationEntity) _then;

/// Create a copy of BankSampahLocationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nama = null,Object? alamat = null,Object? kelurahan = null,Object? pengelola = null,Object? kontak = null,Object? latitude = freezed,Object? longitude = freezed,Object? latOffset = freezed,Object? lngOffset = freezed,Object? distanceMeters = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,alamat: null == alamat ? _self.alamat : alamat // ignore: cast_nullable_to_non_nullable
as String,kelurahan: null == kelurahan ? _self.kelurahan : kelurahan // ignore: cast_nullable_to_non_nullable
as String,pengelola: null == pengelola ? _self.pengelola : pengelola // ignore: cast_nullable_to_non_nullable
as String,kontak: null == kontak ? _self.kontak : kontak // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,latOffset: freezed == latOffset ? _self.latOffset : latOffset // ignore: cast_nullable_to_non_nullable
as double?,lngOffset: freezed == lngOffset ? _self.lngOffset : lngOffset // ignore: cast_nullable_to_non_nullable
as double?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [BankSampahLocationEntity].
extension BankSampahLocationEntityPatterns on BankSampahLocationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahLocationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahLocationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahLocationEntity value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahLocationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahLocationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahLocationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nama,  String alamat,  String kelurahan,  String pengelola,  String kontak,  double? latitude,  double? longitude,  double? latOffset,  double? lngOffset,  double? distanceMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahLocationEntity() when $default != null:
return $default(_that.id,_that.nama,_that.alamat,_that.kelurahan,_that.pengelola,_that.kontak,_that.latitude,_that.longitude,_that.latOffset,_that.lngOffset,_that.distanceMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nama,  String alamat,  String kelurahan,  String pengelola,  String kontak,  double? latitude,  double? longitude,  double? latOffset,  double? lngOffset,  double? distanceMeters)  $default,) {final _that = this;
switch (_that) {
case _BankSampahLocationEntity():
return $default(_that.id,_that.nama,_that.alamat,_that.kelurahan,_that.pengelola,_that.kontak,_that.latitude,_that.longitude,_that.latOffset,_that.lngOffset,_that.distanceMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nama,  String alamat,  String kelurahan,  String pengelola,  String kontak,  double? latitude,  double? longitude,  double? latOffset,  double? lngOffset,  double? distanceMeters)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahLocationEntity() when $default != null:
return $default(_that.id,_that.nama,_that.alamat,_that.kelurahan,_that.pengelola,_that.kontak,_that.latitude,_that.longitude,_that.latOffset,_that.lngOffset,_that.distanceMeters);case _:
  return null;

}
}

}

/// @nodoc


class _BankSampahLocationEntity extends BankSampahLocationEntity {
  const _BankSampahLocationEntity({required this.id, required this.nama, required this.alamat, this.kelurahan = '', this.pengelola = '', this.kontak = '', this.latitude, this.longitude, this.latOffset, this.lngOffset, this.distanceMeters}): super._();
  

@override final  String id;
@override final  String nama;
@override final  String alamat;
@override@JsonKey() final  String kelurahan;
@override@JsonKey() final  String pengelola;
@override@JsonKey() final  String kontak;
@override final  double? latitude;
@override final  double? longitude;
@override final  double? latOffset;
@override final  double? lngOffset;
@override final  double? distanceMeters;

/// Create a copy of BankSampahLocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahLocationEntityCopyWith<_BankSampahLocationEntity> get copyWith => __$BankSampahLocationEntityCopyWithImpl<_BankSampahLocationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahLocationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.alamat, alamat) || other.alamat == alamat)&&(identical(other.kelurahan, kelurahan) || other.kelurahan == kelurahan)&&(identical(other.pengelola, pengelola) || other.pengelola == pengelola)&&(identical(other.kontak, kontak) || other.kontak == kontak)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.latOffset, latOffset) || other.latOffset == latOffset)&&(identical(other.lngOffset, lngOffset) || other.lngOffset == lngOffset)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters));
}


@override
int get hashCode => Object.hash(runtimeType,id,nama,alamat,kelurahan,pengelola,kontak,latitude,longitude,latOffset,lngOffset,distanceMeters);

@override
String toString() {
  return 'BankSampahLocationEntity(id: $id, nama: $nama, alamat: $alamat, kelurahan: $kelurahan, pengelola: $pengelola, kontak: $kontak, latitude: $latitude, longitude: $longitude, latOffset: $latOffset, lngOffset: $lngOffset, distanceMeters: $distanceMeters)';
}


}

/// @nodoc
abstract mixin class _$BankSampahLocationEntityCopyWith<$Res> implements $BankSampahLocationEntityCopyWith<$Res> {
  factory _$BankSampahLocationEntityCopyWith(_BankSampahLocationEntity value, $Res Function(_BankSampahLocationEntity) _then) = __$BankSampahLocationEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String nama, String alamat, String kelurahan, String pengelola, String kontak, double? latitude, double? longitude, double? latOffset, double? lngOffset, double? distanceMeters
});




}
/// @nodoc
class __$BankSampahLocationEntityCopyWithImpl<$Res>
    implements _$BankSampahLocationEntityCopyWith<$Res> {
  __$BankSampahLocationEntityCopyWithImpl(this._self, this._then);

  final _BankSampahLocationEntity _self;
  final $Res Function(_BankSampahLocationEntity) _then;

/// Create a copy of BankSampahLocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nama = null,Object? alamat = null,Object? kelurahan = null,Object? pengelola = null,Object? kontak = null,Object? latitude = freezed,Object? longitude = freezed,Object? latOffset = freezed,Object? lngOffset = freezed,Object? distanceMeters = freezed,}) {
  return _then(_BankSampahLocationEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,alamat: null == alamat ? _self.alamat : alamat // ignore: cast_nullable_to_non_nullable
as String,kelurahan: null == kelurahan ? _self.kelurahan : kelurahan // ignore: cast_nullable_to_non_nullable
as String,pengelola: null == pengelola ? _self.pengelola : pengelola // ignore: cast_nullable_to_non_nullable
as String,kontak: null == kontak ? _self.kontak : kontak // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,latOffset: freezed == latOffset ? _self.latOffset : latOffset // ignore: cast_nullable_to_non_nullable
as double?,lngOffset: freezed == lngOffset ? _self.lngOffset : lngOffset // ignore: cast_nullable_to_non_nullable
as double?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
