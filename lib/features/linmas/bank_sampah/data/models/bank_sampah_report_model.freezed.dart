// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_sampah_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BankSampahSummaryModel {

@JsonKey(name: 'total_kg') double get totalKg;@JsonKey(name: 'total_pendapatan') double get totalPendapatan;@JsonKey(name: 'total_setoran') int get totalSetoran;@JsonKey(name: 'verified_kg') double get verifiedKg;@JsonKey(name: 'verified_pendapatan') double get verifiedPendapatan;@JsonKey(name: 'pending_kg') double get pendingKg;@JsonKey(name: 'pending_pendapatan') double get pendingPendapatan;@JsonKey(name: 'conversion_price_per_kg') double get conversionPricePerKg;
/// Create a copy of BankSampahSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahSummaryModelCopyWith<BankSampahSummaryModel> get copyWith => _$BankSampahSummaryModelCopyWithImpl<BankSampahSummaryModel>(this as BankSampahSummaryModel, _$identity);

  /// Serializes this BankSampahSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahSummaryModel&&(identical(other.totalKg, totalKg) || other.totalKg == totalKg)&&(identical(other.totalPendapatan, totalPendapatan) || other.totalPendapatan == totalPendapatan)&&(identical(other.totalSetoran, totalSetoran) || other.totalSetoran == totalSetoran)&&(identical(other.verifiedKg, verifiedKg) || other.verifiedKg == verifiedKg)&&(identical(other.verifiedPendapatan, verifiedPendapatan) || other.verifiedPendapatan == verifiedPendapatan)&&(identical(other.pendingKg, pendingKg) || other.pendingKg == pendingKg)&&(identical(other.pendingPendapatan, pendingPendapatan) || other.pendingPendapatan == pendingPendapatan)&&(identical(other.conversionPricePerKg, conversionPricePerKg) || other.conversionPricePerKg == conversionPricePerKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalKg,totalPendapatan,totalSetoran,verifiedKg,verifiedPendapatan,pendingKg,pendingPendapatan,conversionPricePerKg);

@override
String toString() {
  return 'BankSampahSummaryModel(totalKg: $totalKg, totalPendapatan: $totalPendapatan, totalSetoran: $totalSetoran, verifiedKg: $verifiedKg, verifiedPendapatan: $verifiedPendapatan, pendingKg: $pendingKg, pendingPendapatan: $pendingPendapatan, conversionPricePerKg: $conversionPricePerKg)';
}


}

/// @nodoc
abstract mixin class $BankSampahSummaryModelCopyWith<$Res>  {
  factory $BankSampahSummaryModelCopyWith(BankSampahSummaryModel value, $Res Function(BankSampahSummaryModel) _then) = _$BankSampahSummaryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_kg') double totalKg,@JsonKey(name: 'total_pendapatan') double totalPendapatan,@JsonKey(name: 'total_setoran') int totalSetoran,@JsonKey(name: 'verified_kg') double verifiedKg,@JsonKey(name: 'verified_pendapatan') double verifiedPendapatan,@JsonKey(name: 'pending_kg') double pendingKg,@JsonKey(name: 'pending_pendapatan') double pendingPendapatan,@JsonKey(name: 'conversion_price_per_kg') double conversionPricePerKg
});




}
/// @nodoc
class _$BankSampahSummaryModelCopyWithImpl<$Res>
    implements $BankSampahSummaryModelCopyWith<$Res> {
  _$BankSampahSummaryModelCopyWithImpl(this._self, this._then);

  final BankSampahSummaryModel _self;
  final $Res Function(BankSampahSummaryModel) _then;

/// Create a copy of BankSampahSummaryModel
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


/// Adds pattern-matching-related methods to [BankSampahSummaryModel].
extension BankSampahSummaryModelPatterns on BankSampahSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_kg')  double totalKg, @JsonKey(name: 'total_pendapatan')  double totalPendapatan, @JsonKey(name: 'total_setoran')  int totalSetoran, @JsonKey(name: 'verified_kg')  double verifiedKg, @JsonKey(name: 'verified_pendapatan')  double verifiedPendapatan, @JsonKey(name: 'pending_kg')  double pendingKg, @JsonKey(name: 'pending_pendapatan')  double pendingPendapatan, @JsonKey(name: 'conversion_price_per_kg')  double conversionPricePerKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahSummaryModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_kg')  double totalKg, @JsonKey(name: 'total_pendapatan')  double totalPendapatan, @JsonKey(name: 'total_setoran')  int totalSetoran, @JsonKey(name: 'verified_kg')  double verifiedKg, @JsonKey(name: 'verified_pendapatan')  double verifiedPendapatan, @JsonKey(name: 'pending_kg')  double pendingKg, @JsonKey(name: 'pending_pendapatan')  double pendingPendapatan, @JsonKey(name: 'conversion_price_per_kg')  double conversionPricePerKg)  $default,) {final _that = this;
switch (_that) {
case _BankSampahSummaryModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_kg')  double totalKg, @JsonKey(name: 'total_pendapatan')  double totalPendapatan, @JsonKey(name: 'total_setoran')  int totalSetoran, @JsonKey(name: 'verified_kg')  double verifiedKg, @JsonKey(name: 'verified_pendapatan')  double verifiedPendapatan, @JsonKey(name: 'pending_kg')  double pendingKg, @JsonKey(name: 'pending_pendapatan')  double pendingPendapatan, @JsonKey(name: 'conversion_price_per_kg')  double conversionPricePerKg)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahSummaryModel() when $default != null:
return $default(_that.totalKg,_that.totalPendapatan,_that.totalSetoran,_that.verifiedKg,_that.verifiedPendapatan,_that.pendingKg,_that.pendingPendapatan,_that.conversionPricePerKg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BankSampahSummaryModel extends BankSampahSummaryModel {
  const _BankSampahSummaryModel({@JsonKey(name: 'total_kg') this.totalKg = 0.0, @JsonKey(name: 'total_pendapatan') this.totalPendapatan = 0.0, @JsonKey(name: 'total_setoran') this.totalSetoran = 0, @JsonKey(name: 'verified_kg') this.verifiedKg = 0.0, @JsonKey(name: 'verified_pendapatan') this.verifiedPendapatan = 0.0, @JsonKey(name: 'pending_kg') this.pendingKg = 0.0, @JsonKey(name: 'pending_pendapatan') this.pendingPendapatan = 0.0, @JsonKey(name: 'conversion_price_per_kg') this.conversionPricePerKg = 5000.0}): super._();
  factory _BankSampahSummaryModel.fromJson(Map<String, dynamic> json) => _$BankSampahSummaryModelFromJson(json);

@override@JsonKey(name: 'total_kg') final  double totalKg;
@override@JsonKey(name: 'total_pendapatan') final  double totalPendapatan;
@override@JsonKey(name: 'total_setoran') final  int totalSetoran;
@override@JsonKey(name: 'verified_kg') final  double verifiedKg;
@override@JsonKey(name: 'verified_pendapatan') final  double verifiedPendapatan;
@override@JsonKey(name: 'pending_kg') final  double pendingKg;
@override@JsonKey(name: 'pending_pendapatan') final  double pendingPendapatan;
@override@JsonKey(name: 'conversion_price_per_kg') final  double conversionPricePerKg;

/// Create a copy of BankSampahSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahSummaryModelCopyWith<_BankSampahSummaryModel> get copyWith => __$BankSampahSummaryModelCopyWithImpl<_BankSampahSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankSampahSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahSummaryModel&&(identical(other.totalKg, totalKg) || other.totalKg == totalKg)&&(identical(other.totalPendapatan, totalPendapatan) || other.totalPendapatan == totalPendapatan)&&(identical(other.totalSetoran, totalSetoran) || other.totalSetoran == totalSetoran)&&(identical(other.verifiedKg, verifiedKg) || other.verifiedKg == verifiedKg)&&(identical(other.verifiedPendapatan, verifiedPendapatan) || other.verifiedPendapatan == verifiedPendapatan)&&(identical(other.pendingKg, pendingKg) || other.pendingKg == pendingKg)&&(identical(other.pendingPendapatan, pendingPendapatan) || other.pendingPendapatan == pendingPendapatan)&&(identical(other.conversionPricePerKg, conversionPricePerKg) || other.conversionPricePerKg == conversionPricePerKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalKg,totalPendapatan,totalSetoran,verifiedKg,verifiedPendapatan,pendingKg,pendingPendapatan,conversionPricePerKg);

@override
String toString() {
  return 'BankSampahSummaryModel(totalKg: $totalKg, totalPendapatan: $totalPendapatan, totalSetoran: $totalSetoran, verifiedKg: $verifiedKg, verifiedPendapatan: $verifiedPendapatan, pendingKg: $pendingKg, pendingPendapatan: $pendingPendapatan, conversionPricePerKg: $conversionPricePerKg)';
}


}

/// @nodoc
abstract mixin class _$BankSampahSummaryModelCopyWith<$Res> implements $BankSampahSummaryModelCopyWith<$Res> {
  factory _$BankSampahSummaryModelCopyWith(_BankSampahSummaryModel value, $Res Function(_BankSampahSummaryModel) _then) = __$BankSampahSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_kg') double totalKg,@JsonKey(name: 'total_pendapatan') double totalPendapatan,@JsonKey(name: 'total_setoran') int totalSetoran,@JsonKey(name: 'verified_kg') double verifiedKg,@JsonKey(name: 'verified_pendapatan') double verifiedPendapatan,@JsonKey(name: 'pending_kg') double pendingKg,@JsonKey(name: 'pending_pendapatan') double pendingPendapatan,@JsonKey(name: 'conversion_price_per_kg') double conversionPricePerKg
});




}
/// @nodoc
class __$BankSampahSummaryModelCopyWithImpl<$Res>
    implements _$BankSampahSummaryModelCopyWith<$Res> {
  __$BankSampahSummaryModelCopyWithImpl(this._self, this._then);

  final _BankSampahSummaryModel _self;
  final $Res Function(_BankSampahSummaryModel) _then;

/// Create a copy of BankSampahSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalKg = null,Object? totalPendapatan = null,Object? totalSetoran = null,Object? verifiedKg = null,Object? verifiedPendapatan = null,Object? pendingKg = null,Object? pendingPendapatan = null,Object? conversionPricePerKg = null,}) {
  return _then(_BankSampahSummaryModel(
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
mixin _$BankSampahMetaModel {

@JsonKey(name: 'total') int get total;@JsonKey(name: 'current_page') int get currentPage;@JsonKey(name: 'per_page') int get perPage;@JsonKey(name: 'last_page') int get lastPage;
/// Create a copy of BankSampahMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahMetaModelCopyWith<BankSampahMetaModel> get copyWith => _$BankSampahMetaModelCopyWithImpl<BankSampahMetaModel>(this as BankSampahMetaModel, _$identity);

  /// Serializes this BankSampahMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahMetaModel&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,currentPage,perPage,lastPage);

@override
String toString() {
  return 'BankSampahMetaModel(total: $total, currentPage: $currentPage, perPage: $perPage, lastPage: $lastPage)';
}


}

/// @nodoc
abstract mixin class $BankSampahMetaModelCopyWith<$Res>  {
  factory $BankSampahMetaModelCopyWith(BankSampahMetaModel value, $Res Function(BankSampahMetaModel) _then) = _$BankSampahMetaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total') int total,@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'last_page') int lastPage
});




}
/// @nodoc
class _$BankSampahMetaModelCopyWithImpl<$Res>
    implements $BankSampahMetaModelCopyWith<$Res> {
  _$BankSampahMetaModelCopyWithImpl(this._self, this._then);

  final BankSampahMetaModel _self;
  final $Res Function(BankSampahMetaModel) _then;

/// Create a copy of BankSampahMetaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? currentPage = null,Object? perPage = null,Object? lastPage = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BankSampahMetaModel].
extension BankSampahMetaModelPatterns on BankSampahMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahMetaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total')  int total, @JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'last_page')  int lastPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahMetaModel() when $default != null:
return $default(_that.total,_that.currentPage,_that.perPage,_that.lastPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total')  int total, @JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'last_page')  int lastPage)  $default,) {final _that = this;
switch (_that) {
case _BankSampahMetaModel():
return $default(_that.total,_that.currentPage,_that.perPage,_that.lastPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total')  int total, @JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'last_page')  int lastPage)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahMetaModel() when $default != null:
return $default(_that.total,_that.currentPage,_that.perPage,_that.lastPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BankSampahMetaModel implements BankSampahMetaModel {
  const _BankSampahMetaModel({@JsonKey(name: 'total') this.total = 0, @JsonKey(name: 'current_page') this.currentPage = 1, @JsonKey(name: 'per_page') this.perPage = 20, @JsonKey(name: 'last_page') this.lastPage = 1});
  factory _BankSampahMetaModel.fromJson(Map<String, dynamic> json) => _$BankSampahMetaModelFromJson(json);

@override@JsonKey(name: 'total') final  int total;
@override@JsonKey(name: 'current_page') final  int currentPage;
@override@JsonKey(name: 'per_page') final  int perPage;
@override@JsonKey(name: 'last_page') final  int lastPage;

/// Create a copy of BankSampahMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahMetaModelCopyWith<_BankSampahMetaModel> get copyWith => __$BankSampahMetaModelCopyWithImpl<_BankSampahMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankSampahMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahMetaModel&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,currentPage,perPage,lastPage);

@override
String toString() {
  return 'BankSampahMetaModel(total: $total, currentPage: $currentPage, perPage: $perPage, lastPage: $lastPage)';
}


}

/// @nodoc
abstract mixin class _$BankSampahMetaModelCopyWith<$Res> implements $BankSampahMetaModelCopyWith<$Res> {
  factory _$BankSampahMetaModelCopyWith(_BankSampahMetaModel value, $Res Function(_BankSampahMetaModel) _then) = __$BankSampahMetaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total') int total,@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'last_page') int lastPage
});




}
/// @nodoc
class __$BankSampahMetaModelCopyWithImpl<$Res>
    implements _$BankSampahMetaModelCopyWith<$Res> {
  __$BankSampahMetaModelCopyWithImpl(this._self, this._then);

  final _BankSampahMetaModel _self;
  final $Res Function(_BankSampahMetaModel) _then;

/// Create a copy of BankSampahMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? currentPage = null,Object? perPage = null,Object? lastPage = null,}) {
  return _then(_BankSampahMetaModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BankSampahReportModel {

@JsonKey(name: 'id', readValue: _readId) String get id;@JsonKey(name: 'bankSampahId', readValue: _readBankSampahId) String get bankSampahId;@JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama) String get bankSampahNama;@JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion) String get bankSampahRegion;@JsonKey(name: 'jenisSampah', readValue: _readJenisSampah) String get jenisSampah;@JsonKey(name: 'beratKg', readValue: _readBeratKg) double get beratKg;@JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah) double get nilaiRupiah;@JsonKey(name: 'status', readValue: _readStatus) String get status;@JsonKey(name: 'statusLabel', readValue: _readStatusLabel) String get statusLabel;@JsonKey(name: 'fotoPath') String? get fotoPath;@JsonKey(name: 'fotoUrl', readValue: _readFotoUrl) String? get fotoUrl;@JsonKey(name: 'catatan', readValue: _readCatatan) String get catatan;@JsonKey(name: 'petugasNama') String get petugasNama;@JsonKey(name: 'createdAt', readValue: _readCreatedAt, toJson: _dateTimeToJson) DateTime get createdAt;
/// Create a copy of BankSampahReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahReportModelCopyWith<BankSampahReportModel> get copyWith => _$BankSampahReportModelCopyWithImpl<BankSampahReportModel>(this as BankSampahReportModel, _$identity);

  /// Serializes this BankSampahReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bankSampahId, bankSampahId) || other.bankSampahId == bankSampahId)&&(identical(other.bankSampahNama, bankSampahNama) || other.bankSampahNama == bankSampahNama)&&(identical(other.bankSampahRegion, bankSampahRegion) || other.bankSampahRegion == bankSampahRegion)&&(identical(other.jenisSampah, jenisSampah) || other.jenisSampah == jenisSampah)&&(identical(other.beratKg, beratKg) || other.beratKg == beratKg)&&(identical(other.nilaiRupiah, nilaiRupiah) || other.nilaiRupiah == nilaiRupiah)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.fotoPath, fotoPath) || other.fotoPath == fotoPath)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.petugasNama, petugasNama) || other.petugasNama == petugasNama)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bankSampahId,bankSampahNama,bankSampahRegion,jenisSampah,beratKg,nilaiRupiah,status,statusLabel,fotoPath,fotoUrl,catatan,petugasNama,createdAt);

@override
String toString() {
  return 'BankSampahReportModel(id: $id, bankSampahId: $bankSampahId, bankSampahNama: $bankSampahNama, bankSampahRegion: $bankSampahRegion, jenisSampah: $jenisSampah, beratKg: $beratKg, nilaiRupiah: $nilaiRupiah, status: $status, statusLabel: $statusLabel, fotoPath: $fotoPath, fotoUrl: $fotoUrl, catatan: $catatan, petugasNama: $petugasNama, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BankSampahReportModelCopyWith<$Res>  {
  factory $BankSampahReportModelCopyWith(BankSampahReportModel value, $Res Function(BankSampahReportModel) _then) = _$BankSampahReportModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'bankSampahId', readValue: _readBankSampahId) String bankSampahId,@JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama) String bankSampahNama,@JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion) String bankSampahRegion,@JsonKey(name: 'jenisSampah', readValue: _readJenisSampah) String jenisSampah,@JsonKey(name: 'beratKg', readValue: _readBeratKg) double beratKg,@JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah) double nilaiRupiah,@JsonKey(name: 'status', readValue: _readStatus) String status,@JsonKey(name: 'statusLabel', readValue: _readStatusLabel) String statusLabel,@JsonKey(name: 'fotoPath') String? fotoPath,@JsonKey(name: 'fotoUrl', readValue: _readFotoUrl) String? fotoUrl,@JsonKey(name: 'catatan', readValue: _readCatatan) String catatan,@JsonKey(name: 'petugasNama') String petugasNama,@JsonKey(name: 'createdAt', readValue: _readCreatedAt, toJson: _dateTimeToJson) DateTime createdAt
});




}
/// @nodoc
class _$BankSampahReportModelCopyWithImpl<$Res>
    implements $BankSampahReportModelCopyWith<$Res> {
  _$BankSampahReportModelCopyWithImpl(this._self, this._then);

  final BankSampahReportModel _self;
  final $Res Function(BankSampahReportModel) _then;

/// Create a copy of BankSampahReportModel
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


/// Adds pattern-matching-related methods to [BankSampahReportModel].
extension BankSampahReportModelPatterns on BankSampahReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahReportModel value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'bankSampahId', readValue: _readBankSampahId)  String bankSampahId, @JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama)  String bankSampahNama, @JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion)  String bankSampahRegion, @JsonKey(name: 'jenisSampah', readValue: _readJenisSampah)  String jenisSampah, @JsonKey(name: 'beratKg', readValue: _readBeratKg)  double beratKg, @JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah)  double nilaiRupiah, @JsonKey(name: 'status', readValue: _readStatus)  String status, @JsonKey(name: 'statusLabel', readValue: _readStatusLabel)  String statusLabel, @JsonKey(name: 'fotoPath')  String? fotoPath, @JsonKey(name: 'fotoUrl', readValue: _readFotoUrl)  String? fotoUrl, @JsonKey(name: 'catatan', readValue: _readCatatan)  String catatan, @JsonKey(name: 'petugasNama')  String petugasNama, @JsonKey(name: 'createdAt', readValue: _readCreatedAt, toJson: _dateTimeToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahReportModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'bankSampahId', readValue: _readBankSampahId)  String bankSampahId, @JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama)  String bankSampahNama, @JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion)  String bankSampahRegion, @JsonKey(name: 'jenisSampah', readValue: _readJenisSampah)  String jenisSampah, @JsonKey(name: 'beratKg', readValue: _readBeratKg)  double beratKg, @JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah)  double nilaiRupiah, @JsonKey(name: 'status', readValue: _readStatus)  String status, @JsonKey(name: 'statusLabel', readValue: _readStatusLabel)  String statusLabel, @JsonKey(name: 'fotoPath')  String? fotoPath, @JsonKey(name: 'fotoUrl', readValue: _readFotoUrl)  String? fotoUrl, @JsonKey(name: 'catatan', readValue: _readCatatan)  String catatan, @JsonKey(name: 'petugasNama')  String petugasNama, @JsonKey(name: 'createdAt', readValue: _readCreatedAt, toJson: _dateTimeToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BankSampahReportModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'bankSampahId', readValue: _readBankSampahId)  String bankSampahId, @JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama)  String bankSampahNama, @JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion)  String bankSampahRegion, @JsonKey(name: 'jenisSampah', readValue: _readJenisSampah)  String jenisSampah, @JsonKey(name: 'beratKg', readValue: _readBeratKg)  double beratKg, @JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah)  double nilaiRupiah, @JsonKey(name: 'status', readValue: _readStatus)  String status, @JsonKey(name: 'statusLabel', readValue: _readStatusLabel)  String statusLabel, @JsonKey(name: 'fotoPath')  String? fotoPath, @JsonKey(name: 'fotoUrl', readValue: _readFotoUrl)  String? fotoUrl, @JsonKey(name: 'catatan', readValue: _readCatatan)  String catatan, @JsonKey(name: 'petugasNama')  String petugasNama, @JsonKey(name: 'createdAt', readValue: _readCreatedAt, toJson: _dateTimeToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahReportModel() when $default != null:
return $default(_that.id,_that.bankSampahId,_that.bankSampahNama,_that.bankSampahRegion,_that.jenisSampah,_that.beratKg,_that.nilaiRupiah,_that.status,_that.statusLabel,_that.fotoPath,_that.fotoUrl,_that.catatan,_that.petugasNama,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BankSampahReportModel extends BankSampahReportModel {
  const _BankSampahReportModel({@JsonKey(name: 'id', readValue: _readId) required this.id, @JsonKey(name: 'bankSampahId', readValue: _readBankSampahId) this.bankSampahId = '', @JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama) required this.bankSampahNama, @JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion) this.bankSampahRegion = '', @JsonKey(name: 'jenisSampah', readValue: _readJenisSampah) required this.jenisSampah, @JsonKey(name: 'beratKg', readValue: _readBeratKg) required this.beratKg, @JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah) required this.nilaiRupiah, @JsonKey(name: 'status', readValue: _readStatus) this.status = 'verified', @JsonKey(name: 'statusLabel', readValue: _readStatusLabel) this.statusLabel = 'Terverifikasi', @JsonKey(name: 'fotoPath') this.fotoPath, @JsonKey(name: 'fotoUrl', readValue: _readFotoUrl) this.fotoUrl, @JsonKey(name: 'catatan', readValue: _readCatatan) this.catatan = '', @JsonKey(name: 'petugasNama') this.petugasNama = '', @JsonKey(name: 'createdAt', readValue: _readCreatedAt, toJson: _dateTimeToJson) required this.createdAt}): super._();
  factory _BankSampahReportModel.fromJson(Map<String, dynamic> json) => _$BankSampahReportModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  String id;
@override@JsonKey(name: 'bankSampahId', readValue: _readBankSampahId) final  String bankSampahId;
@override@JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama) final  String bankSampahNama;
@override@JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion) final  String bankSampahRegion;
@override@JsonKey(name: 'jenisSampah', readValue: _readJenisSampah) final  String jenisSampah;
@override@JsonKey(name: 'beratKg', readValue: _readBeratKg) final  double beratKg;
@override@JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah) final  double nilaiRupiah;
@override@JsonKey(name: 'status', readValue: _readStatus) final  String status;
@override@JsonKey(name: 'statusLabel', readValue: _readStatusLabel) final  String statusLabel;
@override@JsonKey(name: 'fotoPath') final  String? fotoPath;
@override@JsonKey(name: 'fotoUrl', readValue: _readFotoUrl) final  String? fotoUrl;
@override@JsonKey(name: 'catatan', readValue: _readCatatan) final  String catatan;
@override@JsonKey(name: 'petugasNama') final  String petugasNama;
@override@JsonKey(name: 'createdAt', readValue: _readCreatedAt, toJson: _dateTimeToJson) final  DateTime createdAt;

/// Create a copy of BankSampahReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahReportModelCopyWith<_BankSampahReportModel> get copyWith => __$BankSampahReportModelCopyWithImpl<_BankSampahReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankSampahReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bankSampahId, bankSampahId) || other.bankSampahId == bankSampahId)&&(identical(other.bankSampahNama, bankSampahNama) || other.bankSampahNama == bankSampahNama)&&(identical(other.bankSampahRegion, bankSampahRegion) || other.bankSampahRegion == bankSampahRegion)&&(identical(other.jenisSampah, jenisSampah) || other.jenisSampah == jenisSampah)&&(identical(other.beratKg, beratKg) || other.beratKg == beratKg)&&(identical(other.nilaiRupiah, nilaiRupiah) || other.nilaiRupiah == nilaiRupiah)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.fotoPath, fotoPath) || other.fotoPath == fotoPath)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.petugasNama, petugasNama) || other.petugasNama == petugasNama)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bankSampahId,bankSampahNama,bankSampahRegion,jenisSampah,beratKg,nilaiRupiah,status,statusLabel,fotoPath,fotoUrl,catatan,petugasNama,createdAt);

@override
String toString() {
  return 'BankSampahReportModel(id: $id, bankSampahId: $bankSampahId, bankSampahNama: $bankSampahNama, bankSampahRegion: $bankSampahRegion, jenisSampah: $jenisSampah, beratKg: $beratKg, nilaiRupiah: $nilaiRupiah, status: $status, statusLabel: $statusLabel, fotoPath: $fotoPath, fotoUrl: $fotoUrl, catatan: $catatan, petugasNama: $petugasNama, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BankSampahReportModelCopyWith<$Res> implements $BankSampahReportModelCopyWith<$Res> {
  factory _$BankSampahReportModelCopyWith(_BankSampahReportModel value, $Res Function(_BankSampahReportModel) _then) = __$BankSampahReportModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'bankSampahId', readValue: _readBankSampahId) String bankSampahId,@JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama) String bankSampahNama,@JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion) String bankSampahRegion,@JsonKey(name: 'jenisSampah', readValue: _readJenisSampah) String jenisSampah,@JsonKey(name: 'beratKg', readValue: _readBeratKg) double beratKg,@JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah) double nilaiRupiah,@JsonKey(name: 'status', readValue: _readStatus) String status,@JsonKey(name: 'statusLabel', readValue: _readStatusLabel) String statusLabel,@JsonKey(name: 'fotoPath') String? fotoPath,@JsonKey(name: 'fotoUrl', readValue: _readFotoUrl) String? fotoUrl,@JsonKey(name: 'catatan', readValue: _readCatatan) String catatan,@JsonKey(name: 'petugasNama') String petugasNama,@JsonKey(name: 'createdAt', readValue: _readCreatedAt, toJson: _dateTimeToJson) DateTime createdAt
});




}
/// @nodoc
class __$BankSampahReportModelCopyWithImpl<$Res>
    implements _$BankSampahReportModelCopyWith<$Res> {
  __$BankSampahReportModelCopyWithImpl(this._self, this._then);

  final _BankSampahReportModel _self;
  final $Res Function(_BankSampahReportModel) _then;

/// Create a copy of BankSampahReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bankSampahId = null,Object? bankSampahNama = null,Object? bankSampahRegion = null,Object? jenisSampah = null,Object? beratKg = null,Object? nilaiRupiah = null,Object? status = null,Object? statusLabel = null,Object? fotoPath = freezed,Object? fotoUrl = freezed,Object? catatan = null,Object? petugasNama = null,Object? createdAt = null,}) {
  return _then(_BankSampahReportModel(
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
mixin _$BankSampahMyDepositsResponseModel {

@JsonKey(name: 'success') bool get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') List<BankSampahReportModel> get data;@JsonKey(name: 'summary') BankSampahSummaryModel? get summary;@JsonKey(name: 'meta') BankSampahMetaModel? get meta;
/// Create a copy of BankSampahMyDepositsResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSampahMyDepositsResponseModelCopyWith<BankSampahMyDepositsResponseModel> get copyWith => _$BankSampahMyDepositsResponseModelCopyWithImpl<BankSampahMyDepositsResponseModel>(this as BankSampahMyDepositsResponseModel, _$identity);

  /// Serializes this BankSampahMyDepositsResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSampahMyDepositsResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),summary,meta);

@override
String toString() {
  return 'BankSampahMyDepositsResponseModel(success: $success, message: $message, data: $data, summary: $summary, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $BankSampahMyDepositsResponseModelCopyWith<$Res>  {
  factory $BankSampahMyDepositsResponseModelCopyWith(BankSampahMyDepositsResponseModel value, $Res Function(BankSampahMyDepositsResponseModel) _then) = _$BankSampahMyDepositsResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<BankSampahReportModel> data,@JsonKey(name: 'summary') BankSampahSummaryModel? summary,@JsonKey(name: 'meta') BankSampahMetaModel? meta
});


$BankSampahSummaryModelCopyWith<$Res>? get summary;$BankSampahMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class _$BankSampahMyDepositsResponseModelCopyWithImpl<$Res>
    implements $BankSampahMyDepositsResponseModelCopyWith<$Res> {
  _$BankSampahMyDepositsResponseModelCopyWithImpl(this._self, this._then);

  final BankSampahMyDepositsResponseModel _self;
  final $Res Function(BankSampahMyDepositsResponseModel) _then;

/// Create a copy of BankSampahMyDepositsResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = freezed,Object? data = null,Object? summary = freezed,Object? meta = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<BankSampahReportModel>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as BankSampahSummaryModel?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as BankSampahMetaModel?,
  ));
}
/// Create a copy of BankSampahMyDepositsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankSampahSummaryModelCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $BankSampahSummaryModelCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of BankSampahMyDepositsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankSampahMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $BankSampahMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [BankSampahMyDepositsResponseModel].
extension BankSampahMyDepositsResponseModelPatterns on BankSampahMyDepositsResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BankSampahMyDepositsResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BankSampahMyDepositsResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BankSampahMyDepositsResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _BankSampahMyDepositsResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BankSampahMyDepositsResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _BankSampahMyDepositsResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<BankSampahReportModel> data, @JsonKey(name: 'summary')  BankSampahSummaryModel? summary, @JsonKey(name: 'meta')  BankSampahMetaModel? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BankSampahMyDepositsResponseModel() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.summary,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<BankSampahReportModel> data, @JsonKey(name: 'summary')  BankSampahSummaryModel? summary, @JsonKey(name: 'meta')  BankSampahMetaModel? meta)  $default,) {final _that = this;
switch (_that) {
case _BankSampahMyDepositsResponseModel():
return $default(_that.success,_that.message,_that.data,_that.summary,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<BankSampahReportModel> data, @JsonKey(name: 'summary')  BankSampahSummaryModel? summary, @JsonKey(name: 'meta')  BankSampahMetaModel? meta)?  $default,) {final _that = this;
switch (_that) {
case _BankSampahMyDepositsResponseModel() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.summary,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BankSampahMyDepositsResponseModel extends BankSampahMyDepositsResponseModel {
  const _BankSampahMyDepositsResponseModel({@JsonKey(name: 'success') this.success = false, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') final  List<BankSampahReportModel> data = const [], @JsonKey(name: 'summary') this.summary, @JsonKey(name: 'meta') this.meta}): _data = data,super._();
  factory _BankSampahMyDepositsResponseModel.fromJson(Map<String, dynamic> json) => _$BankSampahMyDepositsResponseModelFromJson(json);

@override@JsonKey(name: 'success') final  bool success;
@override@JsonKey(name: 'message') final  String? message;
 final  List<BankSampahReportModel> _data;
@override@JsonKey(name: 'data') List<BankSampahReportModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: 'summary') final  BankSampahSummaryModel? summary;
@override@JsonKey(name: 'meta') final  BankSampahMetaModel? meta;

/// Create a copy of BankSampahMyDepositsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BankSampahMyDepositsResponseModelCopyWith<_BankSampahMyDepositsResponseModel> get copyWith => __$BankSampahMyDepositsResponseModelCopyWithImpl<_BankSampahMyDepositsResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankSampahMyDepositsResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BankSampahMyDepositsResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),summary,meta);

@override
String toString() {
  return 'BankSampahMyDepositsResponseModel(success: $success, message: $message, data: $data, summary: $summary, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$BankSampahMyDepositsResponseModelCopyWith<$Res> implements $BankSampahMyDepositsResponseModelCopyWith<$Res> {
  factory _$BankSampahMyDepositsResponseModelCopyWith(_BankSampahMyDepositsResponseModel value, $Res Function(_BankSampahMyDepositsResponseModel) _then) = __$BankSampahMyDepositsResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<BankSampahReportModel> data,@JsonKey(name: 'summary') BankSampahSummaryModel? summary,@JsonKey(name: 'meta') BankSampahMetaModel? meta
});


@override $BankSampahSummaryModelCopyWith<$Res>? get summary;@override $BankSampahMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class __$BankSampahMyDepositsResponseModelCopyWithImpl<$Res>
    implements _$BankSampahMyDepositsResponseModelCopyWith<$Res> {
  __$BankSampahMyDepositsResponseModelCopyWithImpl(this._self, this._then);

  final _BankSampahMyDepositsResponseModel _self;
  final $Res Function(_BankSampahMyDepositsResponseModel) _then;

/// Create a copy of BankSampahMyDepositsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = freezed,Object? data = null,Object? summary = freezed,Object? meta = freezed,}) {
  return _then(_BankSampahMyDepositsResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<BankSampahReportModel>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as BankSampahSummaryModel?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as BankSampahMetaModel?,
  ));
}

/// Create a copy of BankSampahMyDepositsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankSampahSummaryModelCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $BankSampahSummaryModelCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of BankSampahMyDepositsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BankSampahMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $BankSampahMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
