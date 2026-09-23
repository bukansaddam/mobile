// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tokoh_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokohMetaModel {

@JsonKey(name: 'current_page', readValue: _readCurrentPage) int get currentPage;@JsonKey(name: 'last_page', readValue: _readLastPage) int get lastPage;@JsonKey(name: 'per_page', readValue: _readPerPage) int get perPage;@JsonKey(name: 'total', readValue: _readTotal) int get total;
/// Create a copy of TokohMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokohMetaModelCopyWith<TokohMetaModel> get copyWith => _$TokohMetaModelCopyWithImpl<TokohMetaModel>(this as TokohMetaModel, _$identity);

  /// Serializes this TokohMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokohMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'TokohMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class $TokohMetaModelCopyWith<$Res>  {
  factory $TokohMetaModelCopyWith(TokohMetaModel value, $Res Function(TokohMetaModel) _then) = _$TokohMetaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_page', readValue: _readCurrentPage) int currentPage,@JsonKey(name: 'last_page', readValue: _readLastPage) int lastPage,@JsonKey(name: 'per_page', readValue: _readPerPage) int perPage,@JsonKey(name: 'total', readValue: _readTotal) int total
});




}
/// @nodoc
class _$TokohMetaModelCopyWithImpl<$Res>
    implements $TokohMetaModelCopyWith<$Res> {
  _$TokohMetaModelCopyWithImpl(this._self, this._then);

  final TokohMetaModel _self;
  final $Res Function(TokohMetaModel) _then;

/// Create a copy of TokohMetaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TokohMetaModel].
extension TokohMetaModelPatterns on TokohMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokohMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokohMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokohMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _TokohMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokohMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _TokohMetaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page', readValue: _readCurrentPage)  int currentPage, @JsonKey(name: 'last_page', readValue: _readLastPage)  int lastPage, @JsonKey(name: 'per_page', readValue: _readPerPage)  int perPage, @JsonKey(name: 'total', readValue: _readTotal)  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokohMetaModel() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page', readValue: _readCurrentPage)  int currentPage, @JsonKey(name: 'last_page', readValue: _readLastPage)  int lastPage, @JsonKey(name: 'per_page', readValue: _readPerPage)  int perPage, @JsonKey(name: 'total', readValue: _readTotal)  int total)  $default,) {final _that = this;
switch (_that) {
case _TokohMetaModel():
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_page', readValue: _readCurrentPage)  int currentPage, @JsonKey(name: 'last_page', readValue: _readLastPage)  int lastPage, @JsonKey(name: 'per_page', readValue: _readPerPage)  int perPage, @JsonKey(name: 'total', readValue: _readTotal)  int total)?  $default,) {final _that = this;
switch (_that) {
case _TokohMetaModel() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokohMetaModel implements TokohMetaModel {
  const _TokohMetaModel({@JsonKey(name: 'current_page', readValue: _readCurrentPage) this.currentPage = 1, @JsonKey(name: 'last_page', readValue: _readLastPage) this.lastPage = 1, @JsonKey(name: 'per_page', readValue: _readPerPage) this.perPage = 10, @JsonKey(name: 'total', readValue: _readTotal) this.total = 0});
  factory _TokohMetaModel.fromJson(Map<String, dynamic> json) => _$TokohMetaModelFromJson(json);

@override@JsonKey(name: 'current_page', readValue: _readCurrentPage) final  int currentPage;
@override@JsonKey(name: 'last_page', readValue: _readLastPage) final  int lastPage;
@override@JsonKey(name: 'per_page', readValue: _readPerPage) final  int perPage;
@override@JsonKey(name: 'total', readValue: _readTotal) final  int total;

/// Create a copy of TokohMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokohMetaModelCopyWith<_TokohMetaModel> get copyWith => __$TokohMetaModelCopyWithImpl<_TokohMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokohMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokohMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'TokohMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$TokohMetaModelCopyWith<$Res> implements $TokohMetaModelCopyWith<$Res> {
  factory _$TokohMetaModelCopyWith(_TokohMetaModel value, $Res Function(_TokohMetaModel) _then) = __$TokohMetaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_page', readValue: _readCurrentPage) int currentPage,@JsonKey(name: 'last_page', readValue: _readLastPage) int lastPage,@JsonKey(name: 'per_page', readValue: _readPerPage) int perPage,@JsonKey(name: 'total', readValue: _readTotal) int total
});




}
/// @nodoc
class __$TokohMetaModelCopyWithImpl<$Res>
    implements _$TokohMetaModelCopyWith<$Res> {
  __$TokohMetaModelCopyWithImpl(this._self, this._then);

  final _TokohMetaModel _self;
  final $Res Function(_TokohMetaModel) _then;

/// Create a copy of TokohMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(_TokohMetaModel(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TokohResponseModel {

@JsonKey(name: 'success') bool get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data', readValue: _readDataList) List<TokohModel> get data;@JsonKey(name: 'meta', readValue: _readMeta) TokohMetaModel? get meta;
/// Create a copy of TokohResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokohResponseModelCopyWith<TokohResponseModel> get copyWith => _$TokohResponseModelCopyWithImpl<TokohResponseModel>(this as TokohResponseModel, _$identity);

  /// Serializes this TokohResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokohResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'TokohResponseModel(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $TokohResponseModelCopyWith<$Res>  {
  factory $TokohResponseModelCopyWith(TokohResponseModel value, $Res Function(TokohResponseModel) _then) = _$TokohResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data', readValue: _readDataList) List<TokohModel> data,@JsonKey(name: 'meta', readValue: _readMeta) TokohMetaModel? meta
});


$TokohMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class _$TokohResponseModelCopyWithImpl<$Res>
    implements $TokohResponseModelCopyWith<$Res> {
  _$TokohResponseModelCopyWithImpl(this._self, this._then);

  final TokohResponseModel _self;
  final $Res Function(TokohResponseModel) _then;

/// Create a copy of TokohResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = freezed,Object? data = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<TokohModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as TokohMetaModel?,
  ));
}
/// Create a copy of TokohResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokohMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $TokohMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [TokohResponseModel].
extension TokohResponseModelPatterns on TokohResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokohResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokohResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokohResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _TokohResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokohResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _TokohResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data', readValue: _readDataList)  List<TokohModel> data, @JsonKey(name: 'meta', readValue: _readMeta)  TokohMetaModel? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokohResponseModel() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data', readValue: _readDataList)  List<TokohModel> data, @JsonKey(name: 'meta', readValue: _readMeta)  TokohMetaModel? meta)  $default,) {final _that = this;
switch (_that) {
case _TokohResponseModel():
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data', readValue: _readDataList)  List<TokohModel> data, @JsonKey(name: 'meta', readValue: _readMeta)  TokohMetaModel? meta)?  $default,) {final _that = this;
switch (_that) {
case _TokohResponseModel() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokohResponseModel extends TokohResponseModel {
  const _TokohResponseModel({@JsonKey(name: 'success') this.success = false, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data', readValue: _readDataList) final  List<TokohModel> data = const [], @JsonKey(name: 'meta', readValue: _readMeta) this.meta}): _data = data,super._();
  factory _TokohResponseModel.fromJson(Map<String, dynamic> json) => _$TokohResponseModelFromJson(json);

@override@JsonKey(name: 'success') final  bool success;
@override@JsonKey(name: 'message') final  String? message;
 final  List<TokohModel> _data;
@override@JsonKey(name: 'data', readValue: _readDataList) List<TokohModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: 'meta', readValue: _readMeta) final  TokohMetaModel? meta;

/// Create a copy of TokohResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokohResponseModelCopyWith<_TokohResponseModel> get copyWith => __$TokohResponseModelCopyWithImpl<_TokohResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokohResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokohResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'TokohResponseModel(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$TokohResponseModelCopyWith<$Res> implements $TokohResponseModelCopyWith<$Res> {
  factory _$TokohResponseModelCopyWith(_TokohResponseModel value, $Res Function(_TokohResponseModel) _then) = __$TokohResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data', readValue: _readDataList) List<TokohModel> data,@JsonKey(name: 'meta', readValue: _readMeta) TokohMetaModel? meta
});


@override $TokohMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class __$TokohResponseModelCopyWithImpl<$Res>
    implements _$TokohResponseModelCopyWith<$Res> {
  __$TokohResponseModelCopyWithImpl(this._self, this._then);

  final _TokohResponseModel _self;
  final $Res Function(_TokohResponseModel) _then;

/// Create a copy of TokohResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = freezed,Object? data = null,Object? meta = freezed,}) {
  return _then(_TokohResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<TokohModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as TokohMetaModel?,
  ));
}

/// Create a copy of TokohResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokohMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $TokohMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$TokohModel {

@JsonKey(name: 'id', readValue: _readId) String? get id;@JsonKey(name: 'name', readValue: _readNama) String get nama;@JsonKey(name: 'phone', readValue: _readNoTelp) String get noTelp;@JsonKey(name: 'gender', readValue: _readGender) String get jenisKelamin;@JsonKey(name: 'professions', readValue: _readProfesi) String get profesi;@JsonKey(name: 'wilayah', readValue: _readWilayah) String get wilayah;@JsonKey(name: 'institute_id', readValue: _readInstituteId) int? get instituteId;@JsonKey(name: 'institute_name', readValue: _readNamaInstitusi) String get namaInstitusi;@JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi) String get jabatanInstitusi;@JsonKey(name: 'affiliations', readValue: _readAfiliasi) String get afiliasi;@JsonKey(name: 'organization_id', readValue: _readOrganizationId) int? get organizationId;@JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi) String get namaOrganisasi;@JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi) String get jabatanOrganisasi;@JsonKey(name: 'ethnic', readValue: _readSuku) String get suku;@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get updatedAt;
/// Create a copy of TokohModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokohModelCopyWith<TokohModel> get copyWith => _$TokohModelCopyWithImpl<TokohModel>(this as TokohModel, _$identity);

  /// Serializes this TokohModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokohModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.noTelp, noTelp) || other.noTelp == noTelp)&&(identical(other.jenisKelamin, jenisKelamin) || other.jenisKelamin == jenisKelamin)&&(identical(other.profesi, profesi) || other.profesi == profesi)&&(identical(other.wilayah, wilayah) || other.wilayah == wilayah)&&(identical(other.instituteId, instituteId) || other.instituteId == instituteId)&&(identical(other.namaInstitusi, namaInstitusi) || other.namaInstitusi == namaInstitusi)&&(identical(other.jabatanInstitusi, jabatanInstitusi) || other.jabatanInstitusi == jabatanInstitusi)&&(identical(other.afiliasi, afiliasi) || other.afiliasi == afiliasi)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.namaOrganisasi, namaOrganisasi) || other.namaOrganisasi == namaOrganisasi)&&(identical(other.jabatanOrganisasi, jabatanOrganisasi) || other.jabatanOrganisasi == jabatanOrganisasi)&&(identical(other.suku, suku) || other.suku == suku)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,noTelp,jenisKelamin,profesi,wilayah,instituteId,namaInstitusi,jabatanInstitusi,afiliasi,organizationId,namaOrganisasi,jabatanOrganisasi,suku,createdAt,updatedAt);

@override
String toString() {
  return 'TokohModel(id: $id, nama: $nama, noTelp: $noTelp, jenisKelamin: $jenisKelamin, profesi: $profesi, wilayah: $wilayah, instituteId: $instituteId, namaInstitusi: $namaInstitusi, jabatanInstitusi: $jabatanInstitusi, afiliasi: $afiliasi, organizationId: $organizationId, namaOrganisasi: $namaOrganisasi, jabatanOrganisasi: $jabatanOrganisasi, suku: $suku, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TokohModelCopyWith<$Res>  {
  factory $TokohModelCopyWith(TokohModel value, $Res Function(TokohModel) _then) = _$TokohModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String? id,@JsonKey(name: 'name', readValue: _readNama) String nama,@JsonKey(name: 'phone', readValue: _readNoTelp) String noTelp,@JsonKey(name: 'gender', readValue: _readGender) String jenisKelamin,@JsonKey(name: 'professions', readValue: _readProfesi) String profesi,@JsonKey(name: 'wilayah', readValue: _readWilayah) String wilayah,@JsonKey(name: 'institute_id', readValue: _readInstituteId) int? instituteId,@JsonKey(name: 'institute_name', readValue: _readNamaInstitusi) String namaInstitusi,@JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi) String jabatanInstitusi,@JsonKey(name: 'affiliations', readValue: _readAfiliasi) String afiliasi,@JsonKey(name: 'organization_id', readValue: _readOrganizationId) int? organizationId,@JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi) String namaOrganisasi,@JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi) String jabatanOrganisasi,@JsonKey(name: 'ethnic', readValue: _readSuku) String suku,@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt,@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$TokohModelCopyWithImpl<$Res>
    implements $TokohModelCopyWith<$Res> {
  _$TokohModelCopyWithImpl(this._self, this._then);

  final TokohModel _self;
  final $Res Function(TokohModel) _then;

/// Create a copy of TokohModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? nama = null,Object? noTelp = null,Object? jenisKelamin = null,Object? profesi = null,Object? wilayah = null,Object? instituteId = freezed,Object? namaInstitusi = null,Object? jabatanInstitusi = null,Object? afiliasi = null,Object? organizationId = freezed,Object? namaOrganisasi = null,Object? jabatanOrganisasi = null,Object? suku = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,noTelp: null == noTelp ? _self.noTelp : noTelp // ignore: cast_nullable_to_non_nullable
as String,jenisKelamin: null == jenisKelamin ? _self.jenisKelamin : jenisKelamin // ignore: cast_nullable_to_non_nullable
as String,profesi: null == profesi ? _self.profesi : profesi // ignore: cast_nullable_to_non_nullable
as String,wilayah: null == wilayah ? _self.wilayah : wilayah // ignore: cast_nullable_to_non_nullable
as String,instituteId: freezed == instituteId ? _self.instituteId : instituteId // ignore: cast_nullable_to_non_nullable
as int?,namaInstitusi: null == namaInstitusi ? _self.namaInstitusi : namaInstitusi // ignore: cast_nullable_to_non_nullable
as String,jabatanInstitusi: null == jabatanInstitusi ? _self.jabatanInstitusi : jabatanInstitusi // ignore: cast_nullable_to_non_nullable
as String,afiliasi: null == afiliasi ? _self.afiliasi : afiliasi // ignore: cast_nullable_to_non_nullable
as String,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as int?,namaOrganisasi: null == namaOrganisasi ? _self.namaOrganisasi : namaOrganisasi // ignore: cast_nullable_to_non_nullable
as String,jabatanOrganisasi: null == jabatanOrganisasi ? _self.jabatanOrganisasi : jabatanOrganisasi // ignore: cast_nullable_to_non_nullable
as String,suku: null == suku ? _self.suku : suku // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TokohModel].
extension TokohModelPatterns on TokohModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokohModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokohModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokohModel value)  $default,){
final _that = this;
switch (_that) {
case _TokohModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokohModel value)?  $default,){
final _that = this;
switch (_that) {
case _TokohModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'phone', readValue: _readNoTelp)  String noTelp, @JsonKey(name: 'gender', readValue: _readGender)  String jenisKelamin, @JsonKey(name: 'professions', readValue: _readProfesi)  String profesi, @JsonKey(name: 'wilayah', readValue: _readWilayah)  String wilayah, @JsonKey(name: 'institute_id', readValue: _readInstituteId)  int? instituteId, @JsonKey(name: 'institute_name', readValue: _readNamaInstitusi)  String namaInstitusi, @JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi)  String jabatanInstitusi, @JsonKey(name: 'affiliations', readValue: _readAfiliasi)  String afiliasi, @JsonKey(name: 'organization_id', readValue: _readOrganizationId)  int? organizationId, @JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi)  String namaOrganisasi, @JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi)  String jabatanOrganisasi, @JsonKey(name: 'ethnic', readValue: _readSuku)  String suku, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokohModel() when $default != null:
return $default(_that.id,_that.nama,_that.noTelp,_that.jenisKelamin,_that.profesi,_that.wilayah,_that.instituteId,_that.namaInstitusi,_that.jabatanInstitusi,_that.afiliasi,_that.organizationId,_that.namaOrganisasi,_that.jabatanOrganisasi,_that.suku,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'phone', readValue: _readNoTelp)  String noTelp, @JsonKey(name: 'gender', readValue: _readGender)  String jenisKelamin, @JsonKey(name: 'professions', readValue: _readProfesi)  String profesi, @JsonKey(name: 'wilayah', readValue: _readWilayah)  String wilayah, @JsonKey(name: 'institute_id', readValue: _readInstituteId)  int? instituteId, @JsonKey(name: 'institute_name', readValue: _readNamaInstitusi)  String namaInstitusi, @JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi)  String jabatanInstitusi, @JsonKey(name: 'affiliations', readValue: _readAfiliasi)  String afiliasi, @JsonKey(name: 'organization_id', readValue: _readOrganizationId)  int? organizationId, @JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi)  String namaOrganisasi, @JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi)  String jabatanOrganisasi, @JsonKey(name: 'ethnic', readValue: _readSuku)  String suku, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TokohModel():
return $default(_that.id,_that.nama,_that.noTelp,_that.jenisKelamin,_that.profesi,_that.wilayah,_that.instituteId,_that.namaInstitusi,_that.jabatanInstitusi,_that.afiliasi,_that.organizationId,_that.namaOrganisasi,_that.jabatanOrganisasi,_that.suku,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'phone', readValue: _readNoTelp)  String noTelp, @JsonKey(name: 'gender', readValue: _readGender)  String jenisKelamin, @JsonKey(name: 'professions', readValue: _readProfesi)  String profesi, @JsonKey(name: 'wilayah', readValue: _readWilayah)  String wilayah, @JsonKey(name: 'institute_id', readValue: _readInstituteId)  int? instituteId, @JsonKey(name: 'institute_name', readValue: _readNamaInstitusi)  String namaInstitusi, @JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi)  String jabatanInstitusi, @JsonKey(name: 'affiliations', readValue: _readAfiliasi)  String afiliasi, @JsonKey(name: 'organization_id', readValue: _readOrganizationId)  int? organizationId, @JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi)  String namaOrganisasi, @JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi)  String jabatanOrganisasi, @JsonKey(name: 'ethnic', readValue: _readSuku)  String suku, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TokohModel() when $default != null:
return $default(_that.id,_that.nama,_that.noTelp,_that.jenisKelamin,_that.profesi,_that.wilayah,_that.instituteId,_that.namaInstitusi,_that.jabatanInstitusi,_that.afiliasi,_that.organizationId,_that.namaOrganisasi,_that.jabatanOrganisasi,_that.suku,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokohModel extends TokohModel {
  const _TokohModel({@JsonKey(name: 'id', readValue: _readId) this.id, @JsonKey(name: 'name', readValue: _readNama) required this.nama, @JsonKey(name: 'phone', readValue: _readNoTelp) this.noTelp = '', @JsonKey(name: 'gender', readValue: _readGender) this.jenisKelamin = 'Laki-laki', @JsonKey(name: 'professions', readValue: _readProfesi) required this.profesi, @JsonKey(name: 'wilayah', readValue: _readWilayah) this.wilayah = 'Nasional', @JsonKey(name: 'institute_id', readValue: _readInstituteId) this.instituteId, @JsonKey(name: 'institute_name', readValue: _readNamaInstitusi) this.namaInstitusi = '', @JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi) this.jabatanInstitusi = '', @JsonKey(name: 'affiliations', readValue: _readAfiliasi) required this.afiliasi, @JsonKey(name: 'organization_id', readValue: _readOrganizationId) this.organizationId, @JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi) this.namaOrganisasi = '', @JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi) this.jabatanOrganisasi = '', @JsonKey(name: 'ethnic', readValue: _readSuku) required this.suku, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.updatedAt}): super._();
  factory _TokohModel.fromJson(Map<String, dynamic> json) => _$TokohModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  String? id;
@override@JsonKey(name: 'name', readValue: _readNama) final  String nama;
@override@JsonKey(name: 'phone', readValue: _readNoTelp) final  String noTelp;
@override@JsonKey(name: 'gender', readValue: _readGender) final  String jenisKelamin;
@override@JsonKey(name: 'professions', readValue: _readProfesi) final  String profesi;
@override@JsonKey(name: 'wilayah', readValue: _readWilayah) final  String wilayah;
@override@JsonKey(name: 'institute_id', readValue: _readInstituteId) final  int? instituteId;
@override@JsonKey(name: 'institute_name', readValue: _readNamaInstitusi) final  String namaInstitusi;
@override@JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi) final  String jabatanInstitusi;
@override@JsonKey(name: 'affiliations', readValue: _readAfiliasi) final  String afiliasi;
@override@JsonKey(name: 'organization_id', readValue: _readOrganizationId) final  int? organizationId;
@override@JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi) final  String namaOrganisasi;
@override@JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi) final  String jabatanOrganisasi;
@override@JsonKey(name: 'ethnic', readValue: _readSuku) final  String suku;
@override@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of TokohModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokohModelCopyWith<_TokohModel> get copyWith => __$TokohModelCopyWithImpl<_TokohModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokohModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokohModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.noTelp, noTelp) || other.noTelp == noTelp)&&(identical(other.jenisKelamin, jenisKelamin) || other.jenisKelamin == jenisKelamin)&&(identical(other.profesi, profesi) || other.profesi == profesi)&&(identical(other.wilayah, wilayah) || other.wilayah == wilayah)&&(identical(other.instituteId, instituteId) || other.instituteId == instituteId)&&(identical(other.namaInstitusi, namaInstitusi) || other.namaInstitusi == namaInstitusi)&&(identical(other.jabatanInstitusi, jabatanInstitusi) || other.jabatanInstitusi == jabatanInstitusi)&&(identical(other.afiliasi, afiliasi) || other.afiliasi == afiliasi)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.namaOrganisasi, namaOrganisasi) || other.namaOrganisasi == namaOrganisasi)&&(identical(other.jabatanOrganisasi, jabatanOrganisasi) || other.jabatanOrganisasi == jabatanOrganisasi)&&(identical(other.suku, suku) || other.suku == suku)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,noTelp,jenisKelamin,profesi,wilayah,instituteId,namaInstitusi,jabatanInstitusi,afiliasi,organizationId,namaOrganisasi,jabatanOrganisasi,suku,createdAt,updatedAt);

@override
String toString() {
  return 'TokohModel(id: $id, nama: $nama, noTelp: $noTelp, jenisKelamin: $jenisKelamin, profesi: $profesi, wilayah: $wilayah, instituteId: $instituteId, namaInstitusi: $namaInstitusi, jabatanInstitusi: $jabatanInstitusi, afiliasi: $afiliasi, organizationId: $organizationId, namaOrganisasi: $namaOrganisasi, jabatanOrganisasi: $jabatanOrganisasi, suku: $suku, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TokohModelCopyWith<$Res> implements $TokohModelCopyWith<$Res> {
  factory _$TokohModelCopyWith(_TokohModel value, $Res Function(_TokohModel) _then) = __$TokohModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String? id,@JsonKey(name: 'name', readValue: _readNama) String nama,@JsonKey(name: 'phone', readValue: _readNoTelp) String noTelp,@JsonKey(name: 'gender', readValue: _readGender) String jenisKelamin,@JsonKey(name: 'professions', readValue: _readProfesi) String profesi,@JsonKey(name: 'wilayah', readValue: _readWilayah) String wilayah,@JsonKey(name: 'institute_id', readValue: _readInstituteId) int? instituteId,@JsonKey(name: 'institute_name', readValue: _readNamaInstitusi) String namaInstitusi,@JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi) String jabatanInstitusi,@JsonKey(name: 'affiliations', readValue: _readAfiliasi) String afiliasi,@JsonKey(name: 'organization_id', readValue: _readOrganizationId) int? organizationId,@JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi) String namaOrganisasi,@JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi) String jabatanOrganisasi,@JsonKey(name: 'ethnic', readValue: _readSuku) String suku,@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt,@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$TokohModelCopyWithImpl<$Res>
    implements _$TokohModelCopyWith<$Res> {
  __$TokohModelCopyWithImpl(this._self, this._then);

  final _TokohModel _self;
  final $Res Function(_TokohModel) _then;

/// Create a copy of TokohModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nama = null,Object? noTelp = null,Object? jenisKelamin = null,Object? profesi = null,Object? wilayah = null,Object? instituteId = freezed,Object? namaInstitusi = null,Object? jabatanInstitusi = null,Object? afiliasi = null,Object? organizationId = freezed,Object? namaOrganisasi = null,Object? jabatanOrganisasi = null,Object? suku = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TokohModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,noTelp: null == noTelp ? _self.noTelp : noTelp // ignore: cast_nullable_to_non_nullable
as String,jenisKelamin: null == jenisKelamin ? _self.jenisKelamin : jenisKelamin // ignore: cast_nullable_to_non_nullable
as String,profesi: null == profesi ? _self.profesi : profesi // ignore: cast_nullable_to_non_nullable
as String,wilayah: null == wilayah ? _self.wilayah : wilayah // ignore: cast_nullable_to_non_nullable
as String,instituteId: freezed == instituteId ? _self.instituteId : instituteId // ignore: cast_nullable_to_non_nullable
as int?,namaInstitusi: null == namaInstitusi ? _self.namaInstitusi : namaInstitusi // ignore: cast_nullable_to_non_nullable
as String,jabatanInstitusi: null == jabatanInstitusi ? _self.jabatanInstitusi : jabatanInstitusi // ignore: cast_nullable_to_non_nullable
as String,afiliasi: null == afiliasi ? _self.afiliasi : afiliasi // ignore: cast_nullable_to_non_nullable
as String,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as int?,namaOrganisasi: null == namaOrganisasi ? _self.namaOrganisasi : namaOrganisasi // ignore: cast_nullable_to_non_nullable
as String,jabatanOrganisasi: null == jabatanOrganisasi ? _self.jabatanOrganisasi : jabatanOrganisasi // ignore: cast_nullable_to_non_nullable
as String,suku: null == suku ? _self.suku : suku // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
