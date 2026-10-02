// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_sampah_location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BankSampahLocationModel {

@JsonKey(name: 'id', readValue: _readId) String get id;@JsonKey(name: 'nama', readValue: _readNama) String get nama;@JsonKey(name: 'alamat', readValue: _readAlamat) String get alamat;@JsonKey(name: 'kelurahan', readValue: _readKelurahan) String get kelurahan;@JsonKey(name: 'pengelola', readValue: _readPengelola) String get pengelola;@JsonKey(name: 'kontak', readValue: _readKontak) String get kontak;@JsonKey(name: 'latitude', readValue: _readLatitude) double? get latitude;@JsonKey(name: 'longitude', readValue: _readLongitude) double? get longitude;@JsonKey(name: 'latOffset', readValue: _readLatOffset) double? get latOffset;@JsonKey(name: 'lngOffset', readValue: _readLngOffset) double? get lngOffset;@JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters) double? get distanceMeters;
/// Create a copy of BankSampahLocationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahLocationModelCopyWith<BankSampahLocationModel> get copyWith => _$BankSampahLocationModelCopyWithImpl<BankSampahLocationModel>(this as BankSampahLocationModel, _$identity);

  /// Serializes this BankSampahLocationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahLocationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.alamat, alamat) || other.alamat == alamat)&&(identical(other.kelurahan, kelurahan) || other.kelurahan == kelurahan)&&(identical(other.pengelola, pengelola) || other.pengelola == pengelola)&&(identical(other.kontak, kontak) || other.kontak == kontak)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.latOffset, latOffset) || other.latOffset == latOffset)&&(identical(other.lngOffset, lngOffset) || other.lngOffset == lngOffset)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,alamat,kelurahan,pengelola,kontak,latitude,longitude,latOffset,lngOffset,distanceMeters);

@override
String toString() {
  return 'BankSampahLocationModel(id: $id, nama: $nama, alamat: $alamat, kelurahan: $kelurahan, pengelola: $pengelola, kontak: $kontak, latitude: $latitude, longitude: $longitude, latOffset: $latOffset, lngOffset: $lngOffset, distanceMeters: $distanceMeters)';
}


}

/// @nodoc
abstract mixin class $BankSampahLocationModelCopyWith<$Res>  {
  factory $BankSampahLocationModelCopyWith(BankSampahLocationModel value, $Res Function(BankSampahLocationModel) _then) = _$BankSampahLocationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'nama', readValue: _readNama) String nama,@JsonKey(name: 'alamat', readValue: _readAlamat) String alamat,@JsonKey(name: 'kelurahan', readValue: _readKelurahan) String kelurahan,@JsonKey(name: 'pengelola', readValue: _readPengelola) String pengelola,@JsonKey(name: 'kontak', readValue: _readKontak) String kontak,@JsonKey(name: 'latitude', readValue: _readLatitude) double? latitude,@JsonKey(name: 'longitude', readValue: _readLongitude) double? longitude,@JsonKey(name: 'latOffset', readValue: _readLatOffset) double? latOffset,@JsonKey(name: 'lngOffset', readValue: _readLngOffset) double? lngOffset,@JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters) double? distanceMeters
});




}
/// @nodoc
class _$BankSampahLocationModelCopyWithImpl<$Res>
    implements $BankSampahLocationModelCopyWith<$Res> {
  _$BankSampahLocationModelCopyWithImpl(this._self, this._then);

  final BankSampahLocationModel _self;
  final $Res Function(BankSampahLocationModel) _then;

/// Create a copy of BankSampahLocationModel
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


/// Adds pattern-matching-related methods to [BankSampahLocationModel].
extension BankSampahLocationModelPatterns on BankSampahLocationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahLocationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahLocationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahLocationModel value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahLocationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahLocationModel value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahLocationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'nama', readValue: _readNama)  String nama, @JsonKey(name: 'alamat', readValue: _readAlamat)  String alamat, @JsonKey(name: 'kelurahan', readValue: _readKelurahan)  String kelurahan, @JsonKey(name: 'pengelola', readValue: _readPengelola)  String pengelola, @JsonKey(name: 'kontak', readValue: _readKontak)  String kontak, @JsonKey(name: 'latitude', readValue: _readLatitude)  double? latitude, @JsonKey(name: 'longitude', readValue: _readLongitude)  double? longitude, @JsonKey(name: 'latOffset', readValue: _readLatOffset)  double? latOffset, @JsonKey(name: 'lngOffset', readValue: _readLngOffset)  double? lngOffset, @JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters)  double? distanceMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahLocationModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'nama', readValue: _readNama)  String nama, @JsonKey(name: 'alamat', readValue: _readAlamat)  String alamat, @JsonKey(name: 'kelurahan', readValue: _readKelurahan)  String kelurahan, @JsonKey(name: 'pengelola', readValue: _readPengelola)  String pengelola, @JsonKey(name: 'kontak', readValue: _readKontak)  String kontak, @JsonKey(name: 'latitude', readValue: _readLatitude)  double? latitude, @JsonKey(name: 'longitude', readValue: _readLongitude)  double? longitude, @JsonKey(name: 'latOffset', readValue: _readLatOffset)  double? latOffset, @JsonKey(name: 'lngOffset', readValue: _readLngOffset)  double? lngOffset, @JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters)  double? distanceMeters)  $default,) {final _that = this;
switch (_that) {
case _BankSampahLocationModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'nama', readValue: _readNama)  String nama, @JsonKey(name: 'alamat', readValue: _readAlamat)  String alamat, @JsonKey(name: 'kelurahan', readValue: _readKelurahan)  String kelurahan, @JsonKey(name: 'pengelola', readValue: _readPengelola)  String pengelola, @JsonKey(name: 'kontak', readValue: _readKontak)  String kontak, @JsonKey(name: 'latitude', readValue: _readLatitude)  double? latitude, @JsonKey(name: 'longitude', readValue: _readLongitude)  double? longitude, @JsonKey(name: 'latOffset', readValue: _readLatOffset)  double? latOffset, @JsonKey(name: 'lngOffset', readValue: _readLngOffset)  double? lngOffset, @JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters)  double? distanceMeters)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahLocationModel() when $default != null:
return $default(_that.id,_that.nama,_that.alamat,_that.kelurahan,_that.pengelola,_that.kontak,_that.latitude,_that.longitude,_that.latOffset,_that.lngOffset,_that.distanceMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BankSampahLocationModel extends BankSampahLocationModel {
  const _BankSampahLocationModel({@JsonKey(name: 'id', readValue: _readId) required this.id, @JsonKey(name: 'nama', readValue: _readNama) required this.nama, @JsonKey(name: 'alamat', readValue: _readAlamat) required this.alamat, @JsonKey(name: 'kelurahan', readValue: _readKelurahan) this.kelurahan = '', @JsonKey(name: 'pengelola', readValue: _readPengelola) this.pengelola = '', @JsonKey(name: 'kontak', readValue: _readKontak) this.kontak = '', @JsonKey(name: 'latitude', readValue: _readLatitude) this.latitude, @JsonKey(name: 'longitude', readValue: _readLongitude) this.longitude, @JsonKey(name: 'latOffset', readValue: _readLatOffset) this.latOffset, @JsonKey(name: 'lngOffset', readValue: _readLngOffset) this.lngOffset, @JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters) this.distanceMeters}): super._();
  factory _BankSampahLocationModel.fromJson(Map<String, dynamic> json) => _$BankSampahLocationModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  String id;
@override@JsonKey(name: 'nama', readValue: _readNama) final  String nama;
@override@JsonKey(name: 'alamat', readValue: _readAlamat) final  String alamat;
@override@JsonKey(name: 'kelurahan', readValue: _readKelurahan) final  String kelurahan;
@override@JsonKey(name: 'pengelola', readValue: _readPengelola) final  String pengelola;
@override@JsonKey(name: 'kontak', readValue: _readKontak) final  String kontak;
@override@JsonKey(name: 'latitude', readValue: _readLatitude) final  double? latitude;
@override@JsonKey(name: 'longitude', readValue: _readLongitude) final  double? longitude;
@override@JsonKey(name: 'latOffset', readValue: _readLatOffset) final  double? latOffset;
@override@JsonKey(name: 'lngOffset', readValue: _readLngOffset) final  double? lngOffset;
@override@JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters) final  double? distanceMeters;

/// Create a copy of BankSampahLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahLocationModelCopyWith<_BankSampahLocationModel> get copyWith => __$BankSampahLocationModelCopyWithImpl<_BankSampahLocationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankSampahLocationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahLocationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.alamat, alamat) || other.alamat == alamat)&&(identical(other.kelurahan, kelurahan) || other.kelurahan == kelurahan)&&(identical(other.pengelola, pengelola) || other.pengelola == pengelola)&&(identical(other.kontak, kontak) || other.kontak == kontak)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.latOffset, latOffset) || other.latOffset == latOffset)&&(identical(other.lngOffset, lngOffset) || other.lngOffset == lngOffset)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,alamat,kelurahan,pengelola,kontak,latitude,longitude,latOffset,lngOffset,distanceMeters);

@override
String toString() {
  return 'BankSampahLocationModel(id: $id, nama: $nama, alamat: $alamat, kelurahan: $kelurahan, pengelola: $pengelola, kontak: $kontak, latitude: $latitude, longitude: $longitude, latOffset: $latOffset, lngOffset: $lngOffset, distanceMeters: $distanceMeters)';
}


}

/// @nodoc
abstract mixin class _$BankSampahLocationModelCopyWith<$Res> implements $BankSampahLocationModelCopyWith<$Res> {
  factory _$BankSampahLocationModelCopyWith(_BankSampahLocationModel value, $Res Function(_BankSampahLocationModel) _then) = __$BankSampahLocationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'nama', readValue: _readNama) String nama,@JsonKey(name: 'alamat', readValue: _readAlamat) String alamat,@JsonKey(name: 'kelurahan', readValue: _readKelurahan) String kelurahan,@JsonKey(name: 'pengelola', readValue: _readPengelola) String pengelola,@JsonKey(name: 'kontak', readValue: _readKontak) String kontak,@JsonKey(name: 'latitude', readValue: _readLatitude) double? latitude,@JsonKey(name: 'longitude', readValue: _readLongitude) double? longitude,@JsonKey(name: 'latOffset', readValue: _readLatOffset) double? latOffset,@JsonKey(name: 'lngOffset', readValue: _readLngOffset) double? lngOffset,@JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters) double? distanceMeters
});




}
/// @nodoc
class __$BankSampahLocationModelCopyWithImpl<$Res>
    implements _$BankSampahLocationModelCopyWith<$Res> {
  __$BankSampahLocationModelCopyWithImpl(this._self, this._then);

  final _BankSampahLocationModel _self;
  final $Res Function(_BankSampahLocationModel) _then;

/// Create a copy of BankSampahLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nama = null,Object? alamat = null,Object? kelurahan = null,Object? pengelola = null,Object? kontak = null,Object? latitude = freezed,Object? longitude = freezed,Object? latOffset = freezed,Object? lngOffset = freezed,Object? distanceMeters = freezed,}) {
  return _then(_BankSampahLocationModel(
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
