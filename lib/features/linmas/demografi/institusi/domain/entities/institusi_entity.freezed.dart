// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institusi_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstitusiRegionEntity {

 int? get id; String? get name; String? get code;
/// Create a copy of InstitusiRegionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<InstitusiRegionEntity> get copyWith => _$InstitusiRegionEntityCopyWithImpl<InstitusiRegionEntity>(this as InstitusiRegionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiRegionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,code);

@override
String toString() {
  return 'InstitusiRegionEntity(id: $id, name: $name, code: $code)';
}


}

/// @nodoc
abstract mixin class $InstitusiRegionEntityCopyWith<$Res>  {
  factory $InstitusiRegionEntityCopyWith(InstitusiRegionEntity value, $Res Function(InstitusiRegionEntity) _then) = _$InstitusiRegionEntityCopyWithImpl;
@useResult
$Res call({
 int? id, String? name, String? code
});




}
/// @nodoc
class _$InstitusiRegionEntityCopyWithImpl<$Res>
    implements $InstitusiRegionEntityCopyWith<$Res> {
  _$InstitusiRegionEntityCopyWithImpl(this._self, this._then);

  final InstitusiRegionEntity _self;
  final $Res Function(InstitusiRegionEntity) _then;

/// Create a copy of InstitusiRegionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? code = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstitusiRegionEntity].
extension InstitusiRegionEntityPatterns on InstitusiRegionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiRegionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiRegionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiRegionEntity value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiRegionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiRegionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiRegionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? name,  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitusiRegionEntity() when $default != null:
return $default(_that.id,_that.name,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? name,  String? code)  $default,) {final _that = this;
switch (_that) {
case _InstitusiRegionEntity():
return $default(_that.id,_that.name,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? name,  String? code)?  $default,) {final _that = this;
switch (_that) {
case _InstitusiRegionEntity() when $default != null:
return $default(_that.id,_that.name,_that.code);case _:
  return null;

}
}

}

/// @nodoc


class _InstitusiRegionEntity implements InstitusiRegionEntity {
  const _InstitusiRegionEntity({this.id, this.name, this.code});
  

@override final  int? id;
@override final  String? name;
@override final  String? code;

/// Create a copy of InstitusiRegionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiRegionEntityCopyWith<_InstitusiRegionEntity> get copyWith => __$InstitusiRegionEntityCopyWithImpl<_InstitusiRegionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiRegionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,code);

@override
String toString() {
  return 'InstitusiRegionEntity(id: $id, name: $name, code: $code)';
}


}

/// @nodoc
abstract mixin class _$InstitusiRegionEntityCopyWith<$Res> implements $InstitusiRegionEntityCopyWith<$Res> {
  factory _$InstitusiRegionEntityCopyWith(_InstitusiRegionEntity value, $Res Function(_InstitusiRegionEntity) _then) = __$InstitusiRegionEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? name, String? code
});




}
/// @nodoc
class __$InstitusiRegionEntityCopyWithImpl<$Res>
    implements _$InstitusiRegionEntityCopyWith<$Res> {
  __$InstitusiRegionEntityCopyWithImpl(this._self, this._then);

  final _InstitusiRegionEntity _self;
  final $Res Function(_InstitusiRegionEntity) _then;

/// Create a copy of InstitusiRegionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? code = freezed,}) {
  return _then(_InstitusiRegionEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$InstitusiEntity {

 String? get id; String get nama; String get scope; String? get kategori; int? get categoryId; String? get alamat; int? get provinceId; int? get regencyId; int? get districtId; int? get villageId; int? get figuresCount; InstitusiRegionEntity? get province; InstitusiRegionEntity? get regency; InstitusiRegionEntity? get district; InstitusiRegionEntity? get village; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiEntityCopyWith<InstitusiEntity> get copyWith => _$InstitusiEntityCopyWithImpl<InstitusiEntity>(this as InstitusiEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.kategori, kategori) || other.kategori == kategori)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.alamat, alamat) || other.alamat == alamat)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.figuresCount, figuresCount) || other.figuresCount == figuresCount)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.district, district) || other.district == district)&&(identical(other.village, village) || other.village == village)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,nama,scope,kategori,categoryId,alamat,provinceId,regencyId,districtId,villageId,figuresCount,province,regency,district,village,createdAt,updatedAt);

@override
String toString() {
  return 'InstitusiEntity(id: $id, nama: $nama, scope: $scope, kategori: $kategori, categoryId: $categoryId, alamat: $alamat, provinceId: $provinceId, regencyId: $regencyId, districtId: $districtId, villageId: $villageId, figuresCount: $figuresCount, province: $province, regency: $regency, district: $district, village: $village, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InstitusiEntityCopyWith<$Res>  {
  factory $InstitusiEntityCopyWith(InstitusiEntity value, $Res Function(InstitusiEntity) _then) = _$InstitusiEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String nama, String scope, String? kategori, int? categoryId, String? alamat, int? provinceId, int? regencyId, int? districtId, int? villageId, int? figuresCount, InstitusiRegionEntity? province, InstitusiRegionEntity? regency, InstitusiRegionEntity? district, InstitusiRegionEntity? village, DateTime? createdAt, DateTime? updatedAt
});


$InstitusiRegionEntityCopyWith<$Res>? get province;$InstitusiRegionEntityCopyWith<$Res>? get regency;$InstitusiRegionEntityCopyWith<$Res>? get district;$InstitusiRegionEntityCopyWith<$Res>? get village;

}
/// @nodoc
class _$InstitusiEntityCopyWithImpl<$Res>
    implements $InstitusiEntityCopyWith<$Res> {
  _$InstitusiEntityCopyWithImpl(this._self, this._then);

  final InstitusiEntity _self;
  final $Res Function(InstitusiEntity) _then;

/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? nama = null,Object? scope = null,Object? kategori = freezed,Object? categoryId = freezed,Object? alamat = freezed,Object? provinceId = freezed,Object? regencyId = freezed,Object? districtId = freezed,Object? villageId = freezed,Object? figuresCount = freezed,Object? province = freezed,Object? regency = freezed,Object? district = freezed,Object? village = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,kategori: freezed == kategori ? _self.kategori : kategori // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,alamat: freezed == alamat ? _self.alamat : alamat // ignore: cast_nullable_to_non_nullable
as String?,provinceId: freezed == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int?,regencyId: freezed == regencyId ? _self.regencyId : regencyId // ignore: cast_nullable_to_non_nullable
as int?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as int?,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as int?,figuresCount: freezed == figuresCount ? _self.figuresCount : figuresCount // ignore: cast_nullable_to_non_nullable
as int?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as InstitusiRegionEntity?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as InstitusiRegionEntity?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as InstitusiRegionEntity?,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as InstitusiRegionEntity?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<$Res>? get province {
    if (_self.province == null) {
    return null;
  }

  return $InstitusiRegionEntityCopyWith<$Res>(_self.province!, (value) {
    return _then(_self.copyWith(province: value));
  });
}/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<$Res>? get regency {
    if (_self.regency == null) {
    return null;
  }

  return $InstitusiRegionEntityCopyWith<$Res>(_self.regency!, (value) {
    return _then(_self.copyWith(regency: value));
  });
}/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<$Res>? get district {
    if (_self.district == null) {
    return null;
  }

  return $InstitusiRegionEntityCopyWith<$Res>(_self.district!, (value) {
    return _then(_self.copyWith(district: value));
  });
}/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<$Res>? get village {
    if (_self.village == null) {
    return null;
  }

  return $InstitusiRegionEntityCopyWith<$Res>(_self.village!, (value) {
    return _then(_self.copyWith(village: value));
  });
}
}


/// Adds pattern-matching-related methods to [InstitusiEntity].
extension InstitusiEntityPatterns on InstitusiEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiEntity value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String nama,  String scope,  String? kategori,  int? categoryId,  String? alamat,  int? provinceId,  int? regencyId,  int? districtId,  int? villageId,  int? figuresCount,  InstitusiRegionEntity? province,  InstitusiRegionEntity? regency,  InstitusiRegionEntity? district,  InstitusiRegionEntity? village,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitusiEntity() when $default != null:
return $default(_that.id,_that.nama,_that.scope,_that.kategori,_that.categoryId,_that.alamat,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.figuresCount,_that.province,_that.regency,_that.district,_that.village,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String nama,  String scope,  String? kategori,  int? categoryId,  String? alamat,  int? provinceId,  int? regencyId,  int? districtId,  int? villageId,  int? figuresCount,  InstitusiRegionEntity? province,  InstitusiRegionEntity? regency,  InstitusiRegionEntity? district,  InstitusiRegionEntity? village,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _InstitusiEntity():
return $default(_that.id,_that.nama,_that.scope,_that.kategori,_that.categoryId,_that.alamat,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.figuresCount,_that.province,_that.regency,_that.district,_that.village,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String nama,  String scope,  String? kategori,  int? categoryId,  String? alamat,  int? provinceId,  int? regencyId,  int? districtId,  int? villageId,  int? figuresCount,  InstitusiRegionEntity? province,  InstitusiRegionEntity? regency,  InstitusiRegionEntity? district,  InstitusiRegionEntity? village,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _InstitusiEntity() when $default != null:
return $default(_that.id,_that.nama,_that.scope,_that.kategori,_that.categoryId,_that.alamat,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.figuresCount,_that.province,_that.regency,_that.district,_that.village,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _InstitusiEntity extends InstitusiEntity {
  const _InstitusiEntity({this.id, required this.nama, required this.scope, this.kategori, this.categoryId, this.alamat, this.provinceId, this.regencyId, this.districtId, this.villageId, this.figuresCount, this.province, this.regency, this.district, this.village, this.createdAt, this.updatedAt}): super._();
  

@override final  String? id;
@override final  String nama;
@override final  String scope;
@override final  String? kategori;
@override final  int? categoryId;
@override final  String? alamat;
@override final  int? provinceId;
@override final  int? regencyId;
@override final  int? districtId;
@override final  int? villageId;
@override final  int? figuresCount;
@override final  InstitusiRegionEntity? province;
@override final  InstitusiRegionEntity? regency;
@override final  InstitusiRegionEntity? district;
@override final  InstitusiRegionEntity? village;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiEntityCopyWith<_InstitusiEntity> get copyWith => __$InstitusiEntityCopyWithImpl<_InstitusiEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.kategori, kategori) || other.kategori == kategori)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.alamat, alamat) || other.alamat == alamat)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.figuresCount, figuresCount) || other.figuresCount == figuresCount)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.district, district) || other.district == district)&&(identical(other.village, village) || other.village == village)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,nama,scope,kategori,categoryId,alamat,provinceId,regencyId,districtId,villageId,figuresCount,province,regency,district,village,createdAt,updatedAt);

@override
String toString() {
  return 'InstitusiEntity(id: $id, nama: $nama, scope: $scope, kategori: $kategori, categoryId: $categoryId, alamat: $alamat, provinceId: $provinceId, regencyId: $regencyId, districtId: $districtId, villageId: $villageId, figuresCount: $figuresCount, province: $province, regency: $regency, district: $district, village: $village, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InstitusiEntityCopyWith<$Res> implements $InstitusiEntityCopyWith<$Res> {
  factory _$InstitusiEntityCopyWith(_InstitusiEntity value, $Res Function(_InstitusiEntity) _then) = __$InstitusiEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String nama, String scope, String? kategori, int? categoryId, String? alamat, int? provinceId, int? regencyId, int? districtId, int? villageId, int? figuresCount, InstitusiRegionEntity? province, InstitusiRegionEntity? regency, InstitusiRegionEntity? district, InstitusiRegionEntity? village, DateTime? createdAt, DateTime? updatedAt
});


@override $InstitusiRegionEntityCopyWith<$Res>? get province;@override $InstitusiRegionEntityCopyWith<$Res>? get regency;@override $InstitusiRegionEntityCopyWith<$Res>? get district;@override $InstitusiRegionEntityCopyWith<$Res>? get village;

}
/// @nodoc
class __$InstitusiEntityCopyWithImpl<$Res>
    implements _$InstitusiEntityCopyWith<$Res> {
  __$InstitusiEntityCopyWithImpl(this._self, this._then);

  final _InstitusiEntity _self;
  final $Res Function(_InstitusiEntity) _then;

/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nama = null,Object? scope = null,Object? kategori = freezed,Object? categoryId = freezed,Object? alamat = freezed,Object? provinceId = freezed,Object? regencyId = freezed,Object? districtId = freezed,Object? villageId = freezed,Object? figuresCount = freezed,Object? province = freezed,Object? regency = freezed,Object? district = freezed,Object? village = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_InstitusiEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,kategori: freezed == kategori ? _self.kategori : kategori // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,alamat: freezed == alamat ? _self.alamat : alamat // ignore: cast_nullable_to_non_nullable
as String?,provinceId: freezed == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int?,regencyId: freezed == regencyId ? _self.regencyId : regencyId // ignore: cast_nullable_to_non_nullable
as int?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as int?,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as int?,figuresCount: freezed == figuresCount ? _self.figuresCount : figuresCount // ignore: cast_nullable_to_non_nullable
as int?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as InstitusiRegionEntity?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as InstitusiRegionEntity?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as InstitusiRegionEntity?,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as InstitusiRegionEntity?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<$Res>? get province {
    if (_self.province == null) {
    return null;
  }

  return $InstitusiRegionEntityCopyWith<$Res>(_self.province!, (value) {
    return _then(_self.copyWith(province: value));
  });
}/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<$Res>? get regency {
    if (_self.regency == null) {
    return null;
  }

  return $InstitusiRegionEntityCopyWith<$Res>(_self.regency!, (value) {
    return _then(_self.copyWith(regency: value));
  });
}/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<$Res>? get district {
    if (_self.district == null) {
    return null;
  }

  return $InstitusiRegionEntityCopyWith<$Res>(_self.district!, (value) {
    return _then(_self.copyWith(district: value));
  });
}/// Create a copy of InstitusiEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionEntityCopyWith<$Res>? get village {
    if (_self.village == null) {
    return null;
  }

  return $InstitusiRegionEntityCopyWith<$Res>(_self.village!, (value) {
    return _then(_self.copyWith(village: value));
  });
}
}

/// @nodoc
mixin _$InstitusiPaginatedEntity {

 bool get success; int get total; int get currentPage; int get lastPage; int get perPage; List<InstitusiEntity> get data; String? get message;
/// Create a copy of InstitusiPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiPaginatedEntityCopyWith<InstitusiPaginatedEntity> get copyWith => _$InstitusiPaginatedEntityCopyWithImpl<InstitusiPaginatedEntity>(this as InstitusiPaginatedEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiPaginatedEntity&&(identical(other.success, success) || other.success == success)&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,success,total,currentPage,lastPage,perPage,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'InstitusiPaginatedEntity(success: $success, total: $total, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $InstitusiPaginatedEntityCopyWith<$Res>  {
  factory $InstitusiPaginatedEntityCopyWith(InstitusiPaginatedEntity value, $Res Function(InstitusiPaginatedEntity) _then) = _$InstitusiPaginatedEntityCopyWithImpl;
@useResult
$Res call({
 bool success, int total, int currentPage, int lastPage, int perPage, List<InstitusiEntity> data, String? message
});




}
/// @nodoc
class _$InstitusiPaginatedEntityCopyWithImpl<$Res>
    implements $InstitusiPaginatedEntityCopyWith<$Res> {
  _$InstitusiPaginatedEntityCopyWithImpl(this._self, this._then);

  final InstitusiPaginatedEntity _self;
  final $Res Function(InstitusiPaginatedEntity) _then;

/// Create a copy of InstitusiPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? total = null,Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? data = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<InstitusiEntity>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstitusiPaginatedEntity].
extension InstitusiPaginatedEntityPatterns on InstitusiPaginatedEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiPaginatedEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiPaginatedEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiPaginatedEntity value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiPaginatedEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiPaginatedEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiPaginatedEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int total,  int currentPage,  int lastPage,  int perPage,  List<InstitusiEntity> data,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitusiPaginatedEntity() when $default != null:
return $default(_that.success,_that.total,_that.currentPage,_that.lastPage,_that.perPage,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int total,  int currentPage,  int lastPage,  int perPage,  List<InstitusiEntity> data,  String? message)  $default,) {final _that = this;
switch (_that) {
case _InstitusiPaginatedEntity():
return $default(_that.success,_that.total,_that.currentPage,_that.lastPage,_that.perPage,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int total,  int currentPage,  int lastPage,  int perPage,  List<InstitusiEntity> data,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _InstitusiPaginatedEntity() when $default != null:
return $default(_that.success,_that.total,_that.currentPage,_that.lastPage,_that.perPage,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _InstitusiPaginatedEntity implements InstitusiPaginatedEntity {
  const _InstitusiPaginatedEntity({this.success = false, this.total = 0, this.currentPage = 1, this.lastPage = 1, this.perPage = 10, final  List<InstitusiEntity> data = const [], this.message}): _data = data;
  

@override@JsonKey() final  bool success;
@override@JsonKey() final  int total;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int lastPage;
@override@JsonKey() final  int perPage;
 final  List<InstitusiEntity> _data;
@override@JsonKey() List<InstitusiEntity> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  String? message;

/// Create a copy of InstitusiPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiPaginatedEntityCopyWith<_InstitusiPaginatedEntity> get copyWith => __$InstitusiPaginatedEntityCopyWithImpl<_InstitusiPaginatedEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiPaginatedEntity&&(identical(other.success, success) || other.success == success)&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,success,total,currentPage,lastPage,perPage,const DeepCollectionEquality().hash(_data),message);

@override
String toString() {
  return 'InstitusiPaginatedEntity(success: $success, total: $total, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$InstitusiPaginatedEntityCopyWith<$Res> implements $InstitusiPaginatedEntityCopyWith<$Res> {
  factory _$InstitusiPaginatedEntityCopyWith(_InstitusiPaginatedEntity value, $Res Function(_InstitusiPaginatedEntity) _then) = __$InstitusiPaginatedEntityCopyWithImpl;
@override @useResult
$Res call({
 bool success, int total, int currentPage, int lastPage, int perPage, List<InstitusiEntity> data, String? message
});




}
/// @nodoc
class __$InstitusiPaginatedEntityCopyWithImpl<$Res>
    implements _$InstitusiPaginatedEntityCopyWith<$Res> {
  __$InstitusiPaginatedEntityCopyWithImpl(this._self, this._then);

  final _InstitusiPaginatedEntity _self;
  final $Res Function(_InstitusiPaginatedEntity) _then;

/// Create a copy of InstitusiPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? total = null,Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? data = null,Object? message = freezed,}) {
  return _then(_InstitusiPaginatedEntity(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<InstitusiEntity>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
