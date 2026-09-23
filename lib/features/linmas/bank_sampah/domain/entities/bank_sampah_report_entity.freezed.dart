// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_sampah_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BankSampahSummaryEntity {

 double get totalKg; double get totalPendapatan; int get totalSetoran; double get verifiedKg; double get verifiedPendapatan; double get pendingKg; double get pendingPendapatan; double get conversionPricePerKg;
/// Create a copy of BankSampahSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahSummaryEntityCopyWith<BankSampahSummaryEntity> get copyWith => _$BankSampahSummaryEntityCopyWithImpl<BankSampahSummaryEntity>(this as BankSampahSummaryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahSummaryEntity&&(identical(other.totalKg, totalKg) || other.totalKg == totalKg)&&(identical(other.totalPendapatan, totalPendapatan) || other.totalPendapatan == totalPendapatan)&&(identical(other.totalSetoran, totalSetoran) || other.totalSetoran == totalSetoran)&&(identical(other.verifiedKg, verifiedKg) || other.verifiedKg == verifiedKg)&&(identical(other.verifiedPendapatan, verifiedPendapatan) || other.verifiedPendapatan == verifiedPendapatan)&&(identical(other.pendingKg, pendingKg) || other.pendingKg == pendingKg)&&(identical(other.pendingPendapatan, pendingPendapatan) || other.pendingPendapatan == pendingPendapatan)&&(identical(other.conversionPricePerKg, conversionPricePerKg) || other.conversionPricePerKg == conversionPricePerKg));
}


@override
int get hashCode => Object.hash(runtimeType,totalKg,totalPendapatan,totalSetoran,verifiedKg,verifiedPendapatan,pendingKg,pendingPendapatan,conversionPricePerKg);

@override
String toString() {
  return 'BankSampahSummaryEntity(totalKg: $totalKg, totalPendapatan: $totalPendapatan, totalSetoran: $totalSetoran, verifiedKg: $verifiedKg, verifiedPendapatan: $verifiedPendapatan, pendingKg: $pendingKg, pendingPendapatan: $pendingPendapatan, conversionPricePerKg: $conversionPricePerKg)';
}


}

/// @nodoc
abstract mixin class $BankSampahSummaryEntityCopyWith<$Res>  {
  factory $BankSampahSummaryEntityCopyWith(BankSampahSummaryEntity value, $Res Function(BankSampahSummaryEntity) _then) = _$BankSampahSummaryEntityCopyWithImpl;
@useResult
$Res call({
 double totalKg, double totalPendapatan, int totalSetoran, double verifiedKg, double verifiedPendapatan, double pendingKg, double pendingPendapatan, double conversionPricePerKg
});




}
/// @nodoc
class _$BankSampahSummaryEntityCopyWithImpl<$Res>
    implements $BankSampahSummaryEntityCopyWith<$Res> {
  _$BankSampahSummaryEntityCopyWithImpl(this._self, this._then);

  final BankSampahSummaryEntity _self;
  final $Res Function(BankSampahSummaryEntity) _then;

/// Create a copy of BankSampahSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalKg = null,Object? totalPendapatan = null,Object? totalSetoran = null,Object? verifiedKg = null,Object? verifiedPendapatan = null,Object? pendingKg = null,Object? pendingPendapatan = null,Object? conversionPricePerKg = null,}) {
  return _then(_self.copyWith(
totalKg: null == totalKg ? _self.totalKg : totalKg // ignore: cast_nullable_to_non_nullable
as double,totalPendapatan: null == totalPendapatan ? _self.totalPendapatan : totalPendapatan // ignore: cast_nullable_to_non_nullable
as double,totalSetoran: null == totalSetoran ? _self.totalSetoran : totalSetoran // ignore: cast_nullable_to_non_nullable
as int,verifiedKg: null == verifiedKg ? _self.verifiedKg : verifiedKg // ignore: cast_nullable_to_non_nullable
as double,verifiedPendapatan: null == verifiedPendapatan ? _self.verifiedPendapatan : verifiedPendapatan // ignore: cast_nullable_to_non_nullable
as double,pendingKg: null == pendingKg ? _self.pendingKg : pendingKg // ignore: cast_nullable_to_non_nullable
as double,pendingPendapatan: null == pendingPendapatan ? _self.pendingPendapatan : pendingPendapatan // ignore: cast_nullable_to_non_nullable
as double,conversionPricePerKg: null == conversionPricePerKg ? _self.conversionPricePerKg : conversionPricePerKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BankSampahSummaryEntity].
extension BankSampahSummaryEntityPatterns on BankSampahSummaryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahSummaryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahSummaryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahSummaryEntity value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahSummaryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahSummaryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahSummaryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalKg,  double totalPendapatan,  int totalSetoran,  double verifiedKg,  double verifiedPendapatan,  double pendingKg,  double pendingPendapatan,  double conversionPricePerKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahSummaryEntity() when $default != null:
return $default(_that.totalKg,_that.totalPendapatan,_that.totalSetoran,_that.verifiedKg,_that.verifiedPendapatan,_that.pendingKg,_that.pendingPendapatan,_that.conversionPricePerKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalKg,  double totalPendapatan,  int totalSetoran,  double verifiedKg,  double verifiedPendapatan,  double pendingKg,  double pendingPendapatan,  double conversionPricePerKg)  $default,) {final _that = this;
switch (_that) {
case _BankSampahSummaryEntity():
return $default(_that.totalKg,_that.totalPendapatan,_that.totalSetoran,_that.verifiedKg,_that.verifiedPendapatan,_that.pendingKg,_that.pendingPendapatan,_that.conversionPricePerKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalKg,  double totalPendapatan,  int totalSetoran,  double verifiedKg,  double verifiedPendapatan,  double pendingKg,  double pendingPendapatan,  double conversionPricePerKg)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahSummaryEntity() when $default != null:
return $default(_that.totalKg,_that.totalPendapatan,_that.totalSetoran,_that.verifiedKg,_that.verifiedPendapatan,_that.pendingKg,_that.pendingPendapatan,_that.conversionPricePerKg);case _:
  return null;

}
}

}

/// @nodoc


class _BankSampahSummaryEntity implements BankSampahSummaryEntity {
  const _BankSampahSummaryEntity({this.totalKg = 0.0, this.totalPendapatan = 0.0, this.totalSetoran = 0, this.verifiedKg = 0.0, this.verifiedPendapatan = 0.0, this.pendingKg = 0.0, this.pendingPendapatan = 0.0, this.conversionPricePerKg = 5000.0});
  

@override@JsonKey() final  double totalKg;
@override@JsonKey() final  double totalPendapatan;
@override@JsonKey() final  int totalSetoran;
@override@JsonKey() final  double verifiedKg;
@override@JsonKey() final  double verifiedPendapatan;
@override@JsonKey() final  double pendingKg;
@override@JsonKey() final  double pendingPendapatan;
@override@JsonKey() final  double conversionPricePerKg;

/// Create a copy of BankSampahSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahSummaryEntityCopyWith<_BankSampahSummaryEntity> get copyWith => __$BankSampahSummaryEntityCopyWithImpl<_BankSampahSummaryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahSummaryEntity&&(identical(other.totalKg, totalKg) || other.totalKg == totalKg)&&(identical(other.totalPendapatan, totalPendapatan) || other.totalPendapatan == totalPendapatan)&&(identical(other.totalSetoran, totalSetoran) || other.totalSetoran == totalSetoran)&&(identical(other.verifiedKg, verifiedKg) || other.verifiedKg == verifiedKg)&&(identical(other.verifiedPendapatan, verifiedPendapatan) || other.verifiedPendapatan == verifiedPendapatan)&&(identical(other.pendingKg, pendingKg) || other.pendingKg == pendingKg)&&(identical(other.pendingPendapatan, pendingPendapatan) || other.pendingPendapatan == pendingPendapatan)&&(identical(other.conversionPricePerKg, conversionPricePerKg) || other.conversionPricePerKg == conversionPricePerKg));
}


@override
int get hashCode => Object.hash(runtimeType,totalKg,totalPendapatan,totalSetoran,verifiedKg,verifiedPendapatan,pendingKg,pendingPendapatan,conversionPricePerKg);

@override
String toString() {
  return 'BankSampahSummaryEntity(totalKg: $totalKg, totalPendapatan: $totalPendapatan, totalSetoran: $totalSetoran, verifiedKg: $verifiedKg, verifiedPendapatan: $verifiedPendapatan, pendingKg: $pendingKg, pendingPendapatan: $pendingPendapatan, conversionPricePerKg: $conversionPricePerKg)';
}


}

/// @nodoc
abstract mixin class _$BankSampahSummaryEntityCopyWith<$Res> implements $BankSampahSummaryEntityCopyWith<$Res> {
  factory _$BankSampahSummaryEntityCopyWith(_BankSampahSummaryEntity value, $Res Function(_BankSampahSummaryEntity) _then) = __$BankSampahSummaryEntityCopyWithImpl;
@override @useResult
$Res call({
 double totalKg, double totalPendapatan, int totalSetoran, double verifiedKg, double verifiedPendapatan, double pendingKg, double pendingPendapatan, double conversionPricePerKg
});




}
/// @nodoc
class __$BankSampahSummaryEntityCopyWithImpl<$Res>
    implements _$BankSampahSummaryEntityCopyWith<$Res> {
  __$BankSampahSummaryEntityCopyWithImpl(this._self, this._then);

  final _BankSampahSummaryEntity _self;
  final $Res Function(_BankSampahSummaryEntity) _then;

/// Create a copy of BankSampahSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalKg = null,Object? totalPendapatan = null,Object? totalSetoran = null,Object? verifiedKg = null,Object? verifiedPendapatan = null,Object? pendingKg = null,Object? pendingPendapatan = null,Object? conversionPricePerKg = null,}) {
  return _then(_BankSampahSummaryEntity(
totalKg: null == totalKg ? _self.totalKg : totalKg // ignore: cast_nullable_to_non_nullable
as double,totalPendapatan: null == totalPendapatan ? _self.totalPendapatan : totalPendapatan // ignore: cast_nullable_to_non_nullable
as double,totalSetoran: null == totalSetoran ? _self.totalSetoran : totalSetoran // ignore: cast_nullable_to_non_nullable
as int,verifiedKg: null == verifiedKg ? _self.verifiedKg : verifiedKg // ignore: cast_nullable_to_non_nullable
as double,verifiedPendapatan: null == verifiedPendapatan ? _self.verifiedPendapatan : verifiedPendapatan // ignore: cast_nullable_to_non_nullable
as double,pendingKg: null == pendingKg ? _self.pendingKg : pendingKg // ignore: cast_nullable_to_non_nullable
as double,pendingPendapatan: null == pendingPendapatan ? _self.pendingPendapatan : pendingPendapatan // ignore: cast_nullable_to_non_nullable
as double,conversionPricePerKg: null == conversionPricePerKg ? _self.conversionPricePerKg : conversionPricePerKg // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$BankSampahReportEntity {

 String get id; String get bankSampahId; String get bankSampahNama; String get bankSampahRegion; String get jenisSampah; double get beratKg; double get nilaiRupiah; String get status; String get statusLabel; String? get fotoPath; String? get fotoUrl; String get catatan; String get petugasNama; DateTime get createdAt;
/// Create a copy of BankSampahReportEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahReportEntityCopyWith<BankSampahReportEntity> get copyWith => _$BankSampahReportEntityCopyWithImpl<BankSampahReportEntity>(this as BankSampahReportEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahReportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bankSampahId, bankSampahId) || other.bankSampahId == bankSampahId)&&(identical(other.bankSampahNama, bankSampahNama) || other.bankSampahNama == bankSampahNama)&&(identical(other.bankSampahRegion, bankSampahRegion) || other.bankSampahRegion == bankSampahRegion)&&(identical(other.jenisSampah, jenisSampah) || other.jenisSampah == jenisSampah)&&(identical(other.beratKg, beratKg) || other.beratKg == beratKg)&&(identical(other.nilaiRupiah, nilaiRupiah) || other.nilaiRupiah == nilaiRupiah)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.fotoPath, fotoPath) || other.fotoPath == fotoPath)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.petugasNama, petugasNama) || other.petugasNama == petugasNama)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,bankSampahId,bankSampahNama,bankSampahRegion,jenisSampah,beratKg,nilaiRupiah,status,statusLabel,fotoPath,fotoUrl,catatan,petugasNama,createdAt);

@override
String toString() {
  return 'BankSampahReportEntity(id: $id, bankSampahId: $bankSampahId, bankSampahNama: $bankSampahNama, bankSampahRegion: $bankSampahRegion, jenisSampah: $jenisSampah, beratKg: $beratKg, nilaiRupiah: $nilaiRupiah, status: $status, statusLabel: $statusLabel, fotoPath: $fotoPath, fotoUrl: $fotoUrl, catatan: $catatan, petugasNama: $petugasNama, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BankSampahReportEntityCopyWith<$Res>  {
  factory $BankSampahReportEntityCopyWith(BankSampahReportEntity value, $Res Function(BankSampahReportEntity) _then) = _$BankSampahReportEntityCopyWithImpl;
@useResult
$Res call({
 String id, String bankSampahId, String bankSampahNama, String bankSampahRegion, String jenisSampah, double beratKg, double nilaiRupiah, String status, String statusLabel, String? fotoPath, String? fotoUrl, String catatan, String petugasNama, DateTime createdAt
});




}
/// @nodoc
class _$BankSampahReportEntityCopyWithImpl<$Res>
    implements $BankSampahReportEntityCopyWith<$Res> {
  _$BankSampahReportEntityCopyWithImpl(this._self, this._then);

  final BankSampahReportEntity _self;
  final $Res Function(BankSampahReportEntity) _then;

/// Create a copy of BankSampahReportEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bankSampahId = null,Object? bankSampahNama = null,Object? bankSampahRegion = null,Object? jenisSampah = null,Object? beratKg = null,Object? nilaiRupiah = null,Object? status = null,Object? statusLabel = null,Object? fotoPath = freezed,Object? fotoUrl = freezed,Object? catatan = null,Object? petugasNama = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankSampahId: null == bankSampahId ? _self.bankSampahId : bankSampahId // ignore: cast_nullable_to_non_nullable
as String,bankSampahNama: null == bankSampahNama ? _self.bankSampahNama : bankSampahNama // ignore: cast_nullable_to_non_nullable
as String,bankSampahRegion: null == bankSampahRegion ? _self.bankSampahRegion : bankSampahRegion // ignore: cast_nullable_to_non_nullable
as String,jenisSampah: null == jenisSampah ? _self.jenisSampah : jenisSampah // ignore: cast_nullable_to_non_nullable
as String,beratKg: null == beratKg ? _self.beratKg : beratKg // ignore: cast_nullable_to_non_nullable
as double,nilaiRupiah: null == nilaiRupiah ? _self.nilaiRupiah : nilaiRupiah // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,fotoPath: freezed == fotoPath ? _self.fotoPath : fotoPath // ignore: cast_nullable_to_non_nullable
as String?,fotoUrl: freezed == fotoUrl ? _self.fotoUrl : fotoUrl // ignore: cast_nullable_to_non_nullable
as String?,catatan: null == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String,petugasNama: null == petugasNama ? _self.petugasNama : petugasNama // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BankSampahReportEntity].
extension BankSampahReportEntityPatterns on BankSampahReportEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahReportEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahReportEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahReportEntity value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahReportEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahReportEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahReportEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bankSampahId,  String bankSampahNama,  String bankSampahRegion,  String jenisSampah,  double beratKg,  double nilaiRupiah,  String status,  String statusLabel,  String? fotoPath,  String? fotoUrl,  String catatan,  String petugasNama,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahReportEntity() when $default != null:
return $default(_that.id,_that.bankSampahId,_that.bankSampahNama,_that.bankSampahRegion,_that.jenisSampah,_that.beratKg,_that.nilaiRupiah,_that.status,_that.statusLabel,_that.fotoPath,_that.fotoUrl,_that.catatan,_that.petugasNama,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bankSampahId,  String bankSampahNama,  String bankSampahRegion,  String jenisSampah,  double beratKg,  double nilaiRupiah,  String status,  String statusLabel,  String? fotoPath,  String? fotoUrl,  String catatan,  String petugasNama,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BankSampahReportEntity():
return $default(_that.id,_that.bankSampahId,_that.bankSampahNama,_that.bankSampahRegion,_that.jenisSampah,_that.beratKg,_that.nilaiRupiah,_that.status,_that.statusLabel,_that.fotoPath,_that.fotoUrl,_that.catatan,_that.petugasNama,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bankSampahId,  String bankSampahNama,  String bankSampahRegion,  String jenisSampah,  double beratKg,  double nilaiRupiah,  String status,  String statusLabel,  String? fotoPath,  String? fotoUrl,  String catatan,  String petugasNama,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahReportEntity() when $default != null:
return $default(_that.id,_that.bankSampahId,_that.bankSampahNama,_that.bankSampahRegion,_that.jenisSampah,_that.beratKg,_that.nilaiRupiah,_that.status,_that.statusLabel,_that.fotoPath,_that.fotoUrl,_that.catatan,_that.petugasNama,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _BankSampahReportEntity extends BankSampahReportEntity {
  const _BankSampahReportEntity({required this.id, this.bankSampahId = '', required this.bankSampahNama, this.bankSampahRegion = '', required this.jenisSampah, required this.beratKg, required this.nilaiRupiah, this.status = 'verified', this.statusLabel = 'Terverifikasi', this.fotoPath, this.fotoUrl, this.catatan = '', this.petugasNama = '', required this.createdAt}): super._();
  

@override final  String id;
@override@JsonKey() final  String bankSampahId;
@override final  String bankSampahNama;
@override@JsonKey() final  String bankSampahRegion;
@override final  String jenisSampah;
@override final  double beratKg;
@override final  double nilaiRupiah;
@override@JsonKey() final  String status;
@override@JsonKey() final  String statusLabel;
@override final  String? fotoPath;
@override final  String? fotoUrl;
@override@JsonKey() final  String catatan;
@override@JsonKey() final  String petugasNama;
@override final  DateTime createdAt;

/// Create a copy of BankSampahReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahReportEntityCopyWith<_BankSampahReportEntity> get copyWith => __$BankSampahReportEntityCopyWithImpl<_BankSampahReportEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahReportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bankSampahId, bankSampahId) || other.bankSampahId == bankSampahId)&&(identical(other.bankSampahNama, bankSampahNama) || other.bankSampahNama == bankSampahNama)&&(identical(other.bankSampahRegion, bankSampahRegion) || other.bankSampahRegion == bankSampahRegion)&&(identical(other.jenisSampah, jenisSampah) || other.jenisSampah == jenisSampah)&&(identical(other.beratKg, beratKg) || other.beratKg == beratKg)&&(identical(other.nilaiRupiah, nilaiRupiah) || other.nilaiRupiah == nilaiRupiah)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.fotoPath, fotoPath) || other.fotoPath == fotoPath)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.petugasNama, petugasNama) || other.petugasNama == petugasNama)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,bankSampahId,bankSampahNama,bankSampahRegion,jenisSampah,beratKg,nilaiRupiah,status,statusLabel,fotoPath,fotoUrl,catatan,petugasNama,createdAt);

@override
String toString() {
  return 'BankSampahReportEntity(id: $id, bankSampahId: $bankSampahId, bankSampahNama: $bankSampahNama, bankSampahRegion: $bankSampahRegion, jenisSampah: $jenisSampah, beratKg: $beratKg, nilaiRupiah: $nilaiRupiah, status: $status, statusLabel: $statusLabel, fotoPath: $fotoPath, fotoUrl: $fotoUrl, catatan: $catatan, petugasNama: $petugasNama, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BankSampahReportEntityCopyWith<$Res> implements $BankSampahReportEntityCopyWith<$Res> {
  factory _$BankSampahReportEntityCopyWith(_BankSampahReportEntity value, $Res Function(_BankSampahReportEntity) _then) = __$BankSampahReportEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String bankSampahId, String bankSampahNama, String bankSampahRegion, String jenisSampah, double beratKg, double nilaiRupiah, String status, String statusLabel, String? fotoPath, String? fotoUrl, String catatan, String petugasNama, DateTime createdAt
});




}
/// @nodoc
class __$BankSampahReportEntityCopyWithImpl<$Res>
    implements _$BankSampahReportEntityCopyWith<$Res> {
  __$BankSampahReportEntityCopyWithImpl(this._self, this._then);

  final _BankSampahReportEntity _self;
  final $Res Function(_BankSampahReportEntity) _then;

/// Create a copy of BankSampahReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bankSampahId = null,Object? bankSampahNama = null,Object? bankSampahRegion = null,Object? jenisSampah = null,Object? beratKg = null,Object? nilaiRupiah = null,Object? status = null,Object? statusLabel = null,Object? fotoPath = freezed,Object? fotoUrl = freezed,Object? catatan = null,Object? petugasNama = null,Object? createdAt = null,}) {
  return _then(_BankSampahReportEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bankSampahId: null == bankSampahId ? _self.bankSampahId : bankSampahId // ignore: cast_nullable_to_non_nullable
as String,bankSampahNama: null == bankSampahNama ? _self.bankSampahNama : bankSampahNama // ignore: cast_nullable_to_non_nullable
as String,bankSampahRegion: null == bankSampahRegion ? _self.bankSampahRegion : bankSampahRegion // ignore: cast_nullable_to_non_nullable
as String,jenisSampah: null == jenisSampah ? _self.jenisSampah : jenisSampah // ignore: cast_nullable_to_non_nullable
as String,beratKg: null == beratKg ? _self.beratKg : beratKg // ignore: cast_nullable_to_non_nullable
as double,nilaiRupiah: null == nilaiRupiah ? _self.nilaiRupiah : nilaiRupiah // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,fotoPath: freezed == fotoPath ? _self.fotoPath : fotoPath // ignore: cast_nullable_to_non_nullable
as String?,fotoUrl: freezed == fotoUrl ? _self.fotoUrl : fotoUrl // ignore: cast_nullable_to_non_nullable
as String?,catatan: null == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String,petugasNama: null == petugasNama ? _self.petugasNama : petugasNama // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$BankSampahReportsDataEntity {

 List<BankSampahReportEntity> get reports; BankSampahSummaryEntity? get summary; int get total; int get currentPage; int get lastPage;
/// Create a copy of BankSampahReportsDataEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahReportsDataEntityCopyWith<BankSampahReportsDataEntity> get copyWith => _$BankSampahReportsDataEntityCopyWithImpl<BankSampahReportsDataEntity>(this as BankSampahReportsDataEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahReportsDataEntity&&const DeepCollectionEquality().equals(other.reports, reports)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(reports),summary,total,currentPage,lastPage);

@override
String toString() {
  return 'BankSampahReportsDataEntity(reports: $reports, summary: $summary, total: $total, currentPage: $currentPage, lastPage: $lastPage)';
}


}

/// @nodoc
abstract mixin class $BankSampahReportsDataEntityCopyWith<$Res>  {
  factory $BankSampahReportsDataEntityCopyWith(BankSampahReportsDataEntity value, $Res Function(BankSampahReportsDataEntity) _then) = _$BankSampahReportsDataEntityCopyWithImpl;
@useResult
$Res call({
 List<BankSampahReportEntity> reports, BankSampahSummaryEntity? summary, int total, int currentPage, int lastPage
});


$BankSampahSummaryEntityCopyWith<$Res>? get summary;

}
/// @nodoc
class _$BankSampahReportsDataEntityCopyWithImpl<$Res>
    implements $BankSampahReportsDataEntityCopyWith<$Res> {
  _$BankSampahReportsDataEntityCopyWithImpl(this._self, this._then);

  final BankSampahReportsDataEntity _self;
  final $Res Function(BankSampahReportsDataEntity) _then;

/// Create a copy of BankSampahReportsDataEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reports = null,Object? summary = freezed,Object? total = null,Object? currentPage = null,Object? lastPage = null,}) {
  return _then(_self.copyWith(
reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as List<BankSampahReportEntity>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as BankSampahSummaryEntity?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BankSampahReportsDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankSampahSummaryEntityCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $BankSampahSummaryEntityCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [BankSampahReportsDataEntity].
extension BankSampahReportsDataEntityPatterns on BankSampahReportsDataEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahReportsDataEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahReportsDataEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahReportsDataEntity value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahReportsDataEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahReportsDataEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahReportsDataEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BankSampahReportEntity> reports,  BankSampahSummaryEntity? summary,  int total,  int currentPage,  int lastPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahReportsDataEntity() when $default != null:
return $default(_that.reports,_that.summary,_that.total,_that.currentPage,_that.lastPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BankSampahReportEntity> reports,  BankSampahSummaryEntity? summary,  int total,  int currentPage,  int lastPage)  $default,) {final _that = this;
switch (_that) {
case _BankSampahReportsDataEntity():
return $default(_that.reports,_that.summary,_that.total,_that.currentPage,_that.lastPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BankSampahReportEntity> reports,  BankSampahSummaryEntity? summary,  int total,  int currentPage,  int lastPage)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahReportsDataEntity() when $default != null:
return $default(_that.reports,_that.summary,_that.total,_that.currentPage,_that.lastPage);case _:
  return null;

}
}

}

/// @nodoc


class _BankSampahReportsDataEntity implements BankSampahReportsDataEntity {
  const _BankSampahReportsDataEntity({final  List<BankSampahReportEntity> reports = const [], this.summary, this.total = 0, this.currentPage = 1, this.lastPage = 1}): _reports = reports;
  

 final  List<BankSampahReportEntity> _reports;
@override@JsonKey() List<BankSampahReportEntity> get reports {
  if (_reports is EqualUnmodifiableListView) return _reports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reports);
}

@override final  BankSampahSummaryEntity? summary;
@override@JsonKey() final  int total;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int lastPage;

/// Create a copy of BankSampahReportsDataEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahReportsDataEntityCopyWith<_BankSampahReportsDataEntity> get copyWith => __$BankSampahReportsDataEntityCopyWithImpl<_BankSampahReportsDataEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahReportsDataEntity&&const DeepCollectionEquality().equals(other._reports, _reports)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reports),summary,total,currentPage,lastPage);

@override
String toString() {
  return 'BankSampahReportsDataEntity(reports: $reports, summary: $summary, total: $total, currentPage: $currentPage, lastPage: $lastPage)';
}


}

/// @nodoc
abstract mixin class _$BankSampahReportsDataEntityCopyWith<$Res> implements $BankSampahReportsDataEntityCopyWith<$Res> {
  factory _$BankSampahReportsDataEntityCopyWith(_BankSampahReportsDataEntity value, $Res Function(_BankSampahReportsDataEntity) _then) = __$BankSampahReportsDataEntityCopyWithImpl;
@override @useResult
$Res call({
 List<BankSampahReportEntity> reports, BankSampahSummaryEntity? summary, int total, int currentPage, int lastPage
});


@override $BankSampahSummaryEntityCopyWith<$Res>? get summary;

}
/// @nodoc
class __$BankSampahReportsDataEntityCopyWithImpl<$Res>
    implements _$BankSampahReportsDataEntityCopyWith<$Res> {
  __$BankSampahReportsDataEntityCopyWithImpl(this._self, this._then);

  final _BankSampahReportsDataEntity _self;
  final $Res Function(_BankSampahReportsDataEntity) _then;

/// Create a copy of BankSampahReportsDataEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reports = null,Object? summary = freezed,Object? total = null,Object? currentPage = null,Object? lastPage = null,}) {
  return _then(_BankSampahReportsDataEntity(
reports: null == reports ? _self._reports : reports // ignore: cast_nullable_to_non_nullable
as List<BankSampahReportEntity>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as BankSampahSummaryEntity?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BankSampahReportsDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankSampahSummaryEntityCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $BankSampahSummaryEntityCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
