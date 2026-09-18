// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organisasi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrganisasiRegionModel {

@JsonKey(name: 'id') int? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'code') String? get code;
/// Create a copy of OrganisasiRegionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<OrganisasiRegionModel> get copyWith => _$OrganisasiRegionModelCopyWithImpl<OrganisasiRegionModel>(this as OrganisasiRegionModel, _$identity);

  /// Serializes this OrganisasiRegionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganisasiRegionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code);

@override
String toString() {
  return 'OrganisasiRegionModel(id: $id, name: $name, code: $code)';
}


}

/// @nodoc
abstract mixin class $OrganisasiRegionModelCopyWith<$Res>  {
  factory $OrganisasiRegionModelCopyWith(OrganisasiRegionModel value, $Res Function(OrganisasiRegionModel) _then) = _$OrganisasiRegionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'code') String? code
});




}
/// @nodoc
class _$OrganisasiRegionModelCopyWithImpl<$Res>
    implements $OrganisasiRegionModelCopyWith<$Res> {
  _$OrganisasiRegionModelCopyWithImpl(this._self, this._then);

  final OrganisasiRegionModel _self;
  final $Res Function(OrganisasiRegionModel) _then;

/// Create a copy of OrganisasiRegionModel
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


/// Adds pattern-matching-related methods to [OrganisasiRegionModel].
extension OrganisasiRegionModelPatterns on OrganisasiRegionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganisasiRegionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganisasiRegionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganisasiRegionModel value)  $default,){
final _that = this;
switch (_that) {
case _OrganisasiRegionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganisasiRegionModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrganisasiRegionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'code')  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganisasiRegionModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'code')  String? code)  $default,) {final _that = this;
switch (_that) {
case _OrganisasiRegionModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'code')  String? code)?  $default,) {final _that = this;
switch (_that) {
case _OrganisasiRegionModel() when $default != null:
return $default(_that.id,_that.name,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganisasiRegionModel extends OrganisasiRegionModel {
  const _OrganisasiRegionModel({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'code') this.code}): super._();
  factory _OrganisasiRegionModel.fromJson(Map<String, dynamic> json) => _$OrganisasiRegionModelFromJson(json);

@override@JsonKey(name: 'id') final  int? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'code') final  String? code;

/// Create a copy of OrganisasiRegionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganisasiRegionModelCopyWith<_OrganisasiRegionModel> get copyWith => __$OrganisasiRegionModelCopyWithImpl<_OrganisasiRegionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganisasiRegionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganisasiRegionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code);

@override
String toString() {
  return 'OrganisasiRegionModel(id: $id, name: $name, code: $code)';
}


}

/// @nodoc
abstract mixin class _$OrganisasiRegionModelCopyWith<$Res> implements $OrganisasiRegionModelCopyWith<$Res> {
  factory _$OrganisasiRegionModelCopyWith(_OrganisasiRegionModel value, $Res Function(_OrganisasiRegionModel) _then) = __$OrganisasiRegionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'code') String? code
});




}
/// @nodoc
class __$OrganisasiRegionModelCopyWithImpl<$Res>
    implements _$OrganisasiRegionModelCopyWith<$Res> {
  __$OrganisasiRegionModelCopyWithImpl(this._self, this._then);

  final _OrganisasiRegionModel _self;
  final $Res Function(_OrganisasiRegionModel) _then;

/// Create a copy of OrganisasiRegionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? code = freezed,}) {
  return _then(_OrganisasiRegionModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OrganisasiMetaModel {

@JsonKey(name: 'current_page') int get currentPage;@JsonKey(name: 'last_page') int get lastPage;@JsonKey(name: 'per_page') int get perPage;@JsonKey(name: 'total') int get total;
/// Create a copy of OrganisasiMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganisasiMetaModelCopyWith<OrganisasiMetaModel> get copyWith => _$OrganisasiMetaModelCopyWithImpl<OrganisasiMetaModel>(this as OrganisasiMetaModel, _$identity);

  /// Serializes this OrganisasiMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganisasiMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'OrganisasiMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class $OrganisasiMetaModelCopyWith<$Res>  {
  factory $OrganisasiMetaModelCopyWith(OrganisasiMetaModel value, $Res Function(OrganisasiMetaModel) _then) = _$OrganisasiMetaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'total') int total
});




}
/// @nodoc
class _$OrganisasiMetaModelCopyWithImpl<$Res>
    implements $OrganisasiMetaModelCopyWith<$Res> {
  _$OrganisasiMetaModelCopyWithImpl(this._self, this._then);

  final OrganisasiMetaModel _self;
  final $Res Function(OrganisasiMetaModel) _then;

/// Create a copy of OrganisasiMetaModel
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


/// Adds pattern-matching-related methods to [OrganisasiMetaModel].
extension OrganisasiMetaModelPatterns on OrganisasiMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganisasiMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganisasiMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganisasiMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _OrganisasiMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganisasiMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrganisasiMetaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total')  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganisasiMetaModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total')  int total)  $default,) {final _that = this;
switch (_that) {
case _OrganisasiMetaModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage, @JsonKey(name: 'total')  int total)?  $default,) {final _that = this;
switch (_that) {
case _OrganisasiMetaModel() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganisasiMetaModel implements OrganisasiMetaModel {
  const _OrganisasiMetaModel({@JsonKey(name: 'current_page') this.currentPage = 1, @JsonKey(name: 'last_page') this.lastPage = 1, @JsonKey(name: 'per_page') this.perPage = 10, @JsonKey(name: 'total') this.total = 0});
  factory _OrganisasiMetaModel.fromJson(Map<String, dynamic> json) => _$OrganisasiMetaModelFromJson(json);

@override@JsonKey(name: 'current_page') final  int currentPage;
@override@JsonKey(name: 'last_page') final  int lastPage;
@override@JsonKey(name: 'per_page') final  int perPage;
@override@JsonKey(name: 'total') final  int total;

/// Create a copy of OrganisasiMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganisasiMetaModelCopyWith<_OrganisasiMetaModel> get copyWith => __$OrganisasiMetaModelCopyWithImpl<_OrganisasiMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganisasiMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganisasiMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'OrganisasiMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$OrganisasiMetaModelCopyWith<$Res> implements $OrganisasiMetaModelCopyWith<$Res> {
  factory _$OrganisasiMetaModelCopyWith(_OrganisasiMetaModel value, $Res Function(_OrganisasiMetaModel) _then) = __$OrganisasiMetaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'total') int total
});




}
/// @nodoc
class __$OrganisasiMetaModelCopyWithImpl<$Res>
    implements _$OrganisasiMetaModelCopyWith<$Res> {
  __$OrganisasiMetaModelCopyWithImpl(this._self, this._then);

  final _OrganisasiMetaModel _self;
  final $Res Function(_OrganisasiMetaModel) _then;

/// Create a copy of OrganisasiMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(_OrganisasiMetaModel(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OrganisasiResponseModel {

@JsonKey(name: 'success') bool get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') List<OrganisasiModel> get data;@JsonKey(name: 'meta') OrganisasiMetaModel? get meta;
/// Create a copy of OrganisasiResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganisasiResponseModelCopyWith<OrganisasiResponseModel> get copyWith => _$OrganisasiResponseModelCopyWithImpl<OrganisasiResponseModel>(this as OrganisasiResponseModel, _$identity);

  /// Serializes this OrganisasiResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganisasiResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'OrganisasiResponseModel(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $OrganisasiResponseModelCopyWith<$Res>  {
  factory $OrganisasiResponseModelCopyWith(OrganisasiResponseModel value, $Res Function(OrganisasiResponseModel) _then) = _$OrganisasiResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<OrganisasiModel> data,@JsonKey(name: 'meta') OrganisasiMetaModel? meta
});


$OrganisasiMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class _$OrganisasiResponseModelCopyWithImpl<$Res>
    implements $OrganisasiResponseModelCopyWith<$Res> {
  _$OrganisasiResponseModelCopyWithImpl(this._self, this._then);

  final OrganisasiResponseModel _self;
  final $Res Function(OrganisasiResponseModel) _then;

/// Create a copy of OrganisasiResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = freezed,Object? data = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<OrganisasiModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as OrganisasiMetaModel?,
  ));
}
/// Create a copy of OrganisasiResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $OrganisasiMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrganisasiResponseModel].
extension OrganisasiResponseModelPatterns on OrganisasiResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganisasiResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganisasiResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganisasiResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _OrganisasiResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganisasiResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrganisasiResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<OrganisasiModel> data, @JsonKey(name: 'meta')  OrganisasiMetaModel? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganisasiResponseModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<OrganisasiModel> data, @JsonKey(name: 'meta')  OrganisasiMetaModel? meta)  $default,) {final _that = this;
switch (_that) {
case _OrganisasiResponseModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<OrganisasiModel> data, @JsonKey(name: 'meta')  OrganisasiMetaModel? meta)?  $default,) {final _that = this;
switch (_that) {
case _OrganisasiResponseModel() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganisasiResponseModel extends OrganisasiResponseModel {
  const _OrganisasiResponseModel({@JsonKey(name: 'success') this.success = false, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') final  List<OrganisasiModel> data = const [], @JsonKey(name: 'meta') this.meta}): _data = data,super._();
  factory _OrganisasiResponseModel.fromJson(Map<String, dynamic> json) => _$OrganisasiResponseModelFromJson(json);

@override@JsonKey(name: 'success') final  bool success;
@override@JsonKey(name: 'message') final  String? message;
 final  List<OrganisasiModel> _data;
@override@JsonKey(name: 'data') List<OrganisasiModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: 'meta') final  OrganisasiMetaModel? meta;

/// Create a copy of OrganisasiResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganisasiResponseModelCopyWith<_OrganisasiResponseModel> get copyWith => __$OrganisasiResponseModelCopyWithImpl<_OrganisasiResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganisasiResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganisasiResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'OrganisasiResponseModel(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$OrganisasiResponseModelCopyWith<$Res> implements $OrganisasiResponseModelCopyWith<$Res> {
  factory _$OrganisasiResponseModelCopyWith(_OrganisasiResponseModel value, $Res Function(_OrganisasiResponseModel) _then) = __$OrganisasiResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<OrganisasiModel> data,@JsonKey(name: 'meta') OrganisasiMetaModel? meta
});


@override $OrganisasiMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class __$OrganisasiResponseModelCopyWithImpl<$Res>
    implements _$OrganisasiResponseModelCopyWith<$Res> {
  __$OrganisasiResponseModelCopyWithImpl(this._self, this._then);

  final _OrganisasiResponseModel _self;
  final $Res Function(_OrganisasiResponseModel) _then;

/// Create a copy of OrganisasiResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = freezed,Object? data = null,Object? meta = freezed,}) {
  return _then(_OrganisasiResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<OrganisasiModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as OrganisasiMetaModel?,
  ));
}

/// Create a copy of OrganisasiResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $OrganisasiMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$OrganisasiModel {

@JsonKey(name: 'id', readValue: _readId) String? get id;@JsonKey(name: 'name', readValue: _readNama) String get nama;@JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota) int get jumlahAnggota;@JsonKey(name: 'field', readValue: _readBidang) String get bidang;@JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat) String? get alamatSekretariat;@JsonKey(name: 'province_id') int? get provinceId;@JsonKey(name: 'regency_id') int? get regencyId;@JsonKey(name: 'district_id') int? get districtId;@JsonKey(name: 'village_id') int? get villageId;@JsonKey(name: 'figures_count') int? get figuresCount;@JsonKey(name: 'province', readValue: _readRegion) OrganisasiRegionModel? get province;@JsonKey(name: 'regency', readValue: _readRegion) OrganisasiRegionModel? get regency;@JsonKey(name: 'district', readValue: _readRegion) OrganisasiRegionModel? get district;@JsonKey(name: 'village', readValue: _readRegion) OrganisasiRegionModel? get village;@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get updatedAt;
/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganisasiModelCopyWith<OrganisasiModel> get copyWith => _$OrganisasiModelCopyWithImpl<OrganisasiModel>(this as OrganisasiModel, _$identity);

  /// Serializes this OrganisasiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganisasiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.jumlahAnggota, jumlahAnggota) || other.jumlahAnggota == jumlahAnggota)&&(identical(other.bidang, bidang) || other.bidang == bidang)&&(identical(other.alamatSekretariat, alamatSekretariat) || other.alamatSekretariat == alamatSekretariat)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.figuresCount, figuresCount) || other.figuresCount == figuresCount)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.district, district) || other.district == district)&&(identical(other.village, village) || other.village == village)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,jumlahAnggota,bidang,alamatSekretariat,provinceId,regencyId,districtId,villageId,figuresCount,province,regency,district,village,createdAt,updatedAt);

@override
String toString() {
  return 'OrganisasiModel(id: $id, nama: $nama, jumlahAnggota: $jumlahAnggota, bidang: $bidang, alamatSekretariat: $alamatSekretariat, provinceId: $provinceId, regencyId: $regencyId, districtId: $districtId, villageId: $villageId, figuresCount: $figuresCount, province: $province, regency: $regency, district: $district, village: $village, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrganisasiModelCopyWith<$Res>  {
  factory $OrganisasiModelCopyWith(OrganisasiModel value, $Res Function(OrganisasiModel) _then) = _$OrganisasiModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String? id,@JsonKey(name: 'name', readValue: _readNama) String nama,@JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota) int jumlahAnggota,@JsonKey(name: 'field', readValue: _readBidang) String bidang,@JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat) String? alamatSekretariat,@JsonKey(name: 'province_id') int? provinceId,@JsonKey(name: 'regency_id') int? regencyId,@JsonKey(name: 'district_id') int? districtId,@JsonKey(name: 'village_id') int? villageId,@JsonKey(name: 'figures_count') int? figuresCount,@JsonKey(name: 'province', readValue: _readRegion) OrganisasiRegionModel? province,@JsonKey(name: 'regency', readValue: _readRegion) OrganisasiRegionModel? regency,@JsonKey(name: 'district', readValue: _readRegion) OrganisasiRegionModel? district,@JsonKey(name: 'village', readValue: _readRegion) OrganisasiRegionModel? village,@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt,@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? updatedAt
});


$OrganisasiRegionModelCopyWith<$Res>? get province;$OrganisasiRegionModelCopyWith<$Res>? get regency;$OrganisasiRegionModelCopyWith<$Res>? get district;$OrganisasiRegionModelCopyWith<$Res>? get village;

}
/// @nodoc
class _$OrganisasiModelCopyWithImpl<$Res>
    implements $OrganisasiModelCopyWith<$Res> {
  _$OrganisasiModelCopyWithImpl(this._self, this._then);

  final OrganisasiModel _self;
  final $Res Function(OrganisasiModel) _then;

/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? nama = null,Object? jumlahAnggota = null,Object? bidang = null,Object? alamatSekretariat = freezed,Object? provinceId = freezed,Object? regencyId = freezed,Object? districtId = freezed,Object? villageId = freezed,Object? figuresCount = freezed,Object? province = freezed,Object? regency = freezed,Object? district = freezed,Object? village = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,jumlahAnggota: null == jumlahAnggota ? _self.jumlahAnggota : jumlahAnggota // ignore: cast_nullable_to_non_nullable
as int,bidang: null == bidang ? _self.bidang : bidang // ignore: cast_nullable_to_non_nullable
as String,alamatSekretariat: freezed == alamatSekretariat ? _self.alamatSekretariat : alamatSekretariat // ignore: cast_nullable_to_non_nullable
as String?,provinceId: freezed == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int?,regencyId: freezed == regencyId ? _self.regencyId : regencyId // ignore: cast_nullable_to_non_nullable
as int?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as int?,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as int?,figuresCount: freezed == figuresCount ? _self.figuresCount : figuresCount // ignore: cast_nullable_to_non_nullable
as int?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as OrganisasiRegionModel?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as OrganisasiRegionModel?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as OrganisasiRegionModel?,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as OrganisasiRegionModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<$Res>? get province {
    if (_self.province == null) {
    return null;
  }

  return $OrganisasiRegionModelCopyWith<$Res>(_self.province!, (value) {
    return _then(_self.copyWith(province: value));
  });
}/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<$Res>? get regency {
    if (_self.regency == null) {
    return null;
  }

  return $OrganisasiRegionModelCopyWith<$Res>(_self.regency!, (value) {
    return _then(_self.copyWith(regency: value));
  });
}/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<$Res>? get district {
    if (_self.district == null) {
    return null;
  }

  return $OrganisasiRegionModelCopyWith<$Res>(_self.district!, (value) {
    return _then(_self.copyWith(district: value));
  });
}/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<$Res>? get village {
    if (_self.village == null) {
    return null;
  }

  return $OrganisasiRegionModelCopyWith<$Res>(_self.village!, (value) {
    return _then(_self.copyWith(village: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrganisasiModel].
extension OrganisasiModelPatterns on OrganisasiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganisasiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganisasiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganisasiModel value)  $default,){
final _that = this;
switch (_that) {
case _OrganisasiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganisasiModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrganisasiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota)  int jumlahAnggota, @JsonKey(name: 'field', readValue: _readBidang)  String bidang, @JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat)  String? alamatSekretariat, @JsonKey(name: 'province_id')  int? provinceId, @JsonKey(name: 'regency_id')  int? regencyId, @JsonKey(name: 'district_id')  int? districtId, @JsonKey(name: 'village_id')  int? villageId, @JsonKey(name: 'figures_count')  int? figuresCount, @JsonKey(name: 'province', readValue: _readRegion)  OrganisasiRegionModel? province, @JsonKey(name: 'regency', readValue: _readRegion)  OrganisasiRegionModel? regency, @JsonKey(name: 'district', readValue: _readRegion)  OrganisasiRegionModel? district, @JsonKey(name: 'village', readValue: _readRegion)  OrganisasiRegionModel? village, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganisasiModel() when $default != null:
return $default(_that.id,_that.nama,_that.jumlahAnggota,_that.bidang,_that.alamatSekretariat,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.figuresCount,_that.province,_that.regency,_that.district,_that.village,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota)  int jumlahAnggota, @JsonKey(name: 'field', readValue: _readBidang)  String bidang, @JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat)  String? alamatSekretariat, @JsonKey(name: 'province_id')  int? provinceId, @JsonKey(name: 'regency_id')  int? regencyId, @JsonKey(name: 'district_id')  int? districtId, @JsonKey(name: 'village_id')  int? villageId, @JsonKey(name: 'figures_count')  int? figuresCount, @JsonKey(name: 'province', readValue: _readRegion)  OrganisasiRegionModel? province, @JsonKey(name: 'regency', readValue: _readRegion)  OrganisasiRegionModel? regency, @JsonKey(name: 'district', readValue: _readRegion)  OrganisasiRegionModel? district, @JsonKey(name: 'village', readValue: _readRegion)  OrganisasiRegionModel? village, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OrganisasiModel():
return $default(_that.id,_that.nama,_that.jumlahAnggota,_that.bidang,_that.alamatSekretariat,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.figuresCount,_that.province,_that.regency,_that.district,_that.village,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota)  int jumlahAnggota, @JsonKey(name: 'field', readValue: _readBidang)  String bidang, @JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat)  String? alamatSekretariat, @JsonKey(name: 'province_id')  int? provinceId, @JsonKey(name: 'regency_id')  int? regencyId, @JsonKey(name: 'district_id')  int? districtId, @JsonKey(name: 'village_id')  int? villageId, @JsonKey(name: 'figures_count')  int? figuresCount, @JsonKey(name: 'province', readValue: _readRegion)  OrganisasiRegionModel? province, @JsonKey(name: 'regency', readValue: _readRegion)  OrganisasiRegionModel? regency, @JsonKey(name: 'district', readValue: _readRegion)  OrganisasiRegionModel? district, @JsonKey(name: 'village', readValue: _readRegion)  OrganisasiRegionModel? village, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrganisasiModel() when $default != null:
return $default(_that.id,_that.nama,_that.jumlahAnggota,_that.bidang,_that.alamatSekretariat,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.figuresCount,_that.province,_that.regency,_that.district,_that.village,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganisasiModel extends OrganisasiModel {
  const _OrganisasiModel({@JsonKey(name: 'id', readValue: _readId) this.id, @JsonKey(name: 'name', readValue: _readNama) required this.nama, @JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota) required this.jumlahAnggota, @JsonKey(name: 'field', readValue: _readBidang) required this.bidang, @JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat) this.alamatSekretariat, @JsonKey(name: 'province_id') this.provinceId, @JsonKey(name: 'regency_id') this.regencyId, @JsonKey(name: 'district_id') this.districtId, @JsonKey(name: 'village_id') this.villageId, @JsonKey(name: 'figures_count') this.figuresCount, @JsonKey(name: 'province', readValue: _readRegion) this.province, @JsonKey(name: 'regency', readValue: _readRegion) this.regency, @JsonKey(name: 'district', readValue: _readRegion) this.district, @JsonKey(name: 'village', readValue: _readRegion) this.village, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.updatedAt}): super._();
  factory _OrganisasiModel.fromJson(Map<String, dynamic> json) => _$OrganisasiModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  String? id;
@override@JsonKey(name: 'name', readValue: _readNama) final  String nama;
@override@JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota) final  int jumlahAnggota;
@override@JsonKey(name: 'field', readValue: _readBidang) final  String bidang;
@override@JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat) final  String? alamatSekretariat;
@override@JsonKey(name: 'province_id') final  int? provinceId;
@override@JsonKey(name: 'regency_id') final  int? regencyId;
@override@JsonKey(name: 'district_id') final  int? districtId;
@override@JsonKey(name: 'village_id') final  int? villageId;
@override@JsonKey(name: 'figures_count') final  int? figuresCount;
@override@JsonKey(name: 'province', readValue: _readRegion) final  OrganisasiRegionModel? province;
@override@JsonKey(name: 'regency', readValue: _readRegion) final  OrganisasiRegionModel? regency;
@override@JsonKey(name: 'district', readValue: _readRegion) final  OrganisasiRegionModel? district;
@override@JsonKey(name: 'village', readValue: _readRegion) final  OrganisasiRegionModel? village;
@override@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganisasiModelCopyWith<_OrganisasiModel> get copyWith => __$OrganisasiModelCopyWithImpl<_OrganisasiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganisasiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganisasiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.jumlahAnggota, jumlahAnggota) || other.jumlahAnggota == jumlahAnggota)&&(identical(other.bidang, bidang) || other.bidang == bidang)&&(identical(other.alamatSekretariat, alamatSekretariat) || other.alamatSekretariat == alamatSekretariat)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.figuresCount, figuresCount) || other.figuresCount == figuresCount)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.district, district) || other.district == district)&&(identical(other.village, village) || other.village == village)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,jumlahAnggota,bidang,alamatSekretariat,provinceId,regencyId,districtId,villageId,figuresCount,province,regency,district,village,createdAt,updatedAt);

@override
String toString() {
  return 'OrganisasiModel(id: $id, nama: $nama, jumlahAnggota: $jumlahAnggota, bidang: $bidang, alamatSekretariat: $alamatSekretariat, provinceId: $provinceId, regencyId: $regencyId, districtId: $districtId, villageId: $villageId, figuresCount: $figuresCount, province: $province, regency: $regency, district: $district, village: $village, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrganisasiModelCopyWith<$Res> implements $OrganisasiModelCopyWith<$Res> {
  factory _$OrganisasiModelCopyWith(_OrganisasiModel value, $Res Function(_OrganisasiModel) _then) = __$OrganisasiModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String? id,@JsonKey(name: 'name', readValue: _readNama) String nama,@JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota) int jumlahAnggota,@JsonKey(name: 'field', readValue: _readBidang) String bidang,@JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat) String? alamatSekretariat,@JsonKey(name: 'province_id') int? provinceId,@JsonKey(name: 'regency_id') int? regencyId,@JsonKey(name: 'district_id') int? districtId,@JsonKey(name: 'village_id') int? villageId,@JsonKey(name: 'figures_count') int? figuresCount,@JsonKey(name: 'province', readValue: _readRegion) OrganisasiRegionModel? province,@JsonKey(name: 'regency', readValue: _readRegion) OrganisasiRegionModel? regency,@JsonKey(name: 'district', readValue: _readRegion) OrganisasiRegionModel? district,@JsonKey(name: 'village', readValue: _readRegion) OrganisasiRegionModel? village,@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt,@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? updatedAt
});


@override $OrganisasiRegionModelCopyWith<$Res>? get province;@override $OrganisasiRegionModelCopyWith<$Res>? get regency;@override $OrganisasiRegionModelCopyWith<$Res>? get district;@override $OrganisasiRegionModelCopyWith<$Res>? get village;

}
/// @nodoc
class __$OrganisasiModelCopyWithImpl<$Res>
    implements _$OrganisasiModelCopyWith<$Res> {
  __$OrganisasiModelCopyWithImpl(this._self, this._then);

  final _OrganisasiModel _self;
  final $Res Function(_OrganisasiModel) _then;

/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nama = null,Object? jumlahAnggota = null,Object? bidang = null,Object? alamatSekretariat = freezed,Object? provinceId = freezed,Object? regencyId = freezed,Object? districtId = freezed,Object? villageId = freezed,Object? figuresCount = freezed,Object? province = freezed,Object? regency = freezed,Object? district = freezed,Object? village = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_OrganisasiModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,jumlahAnggota: null == jumlahAnggota ? _self.jumlahAnggota : jumlahAnggota // ignore: cast_nullable_to_non_nullable
as int,bidang: null == bidang ? _self.bidang : bidang // ignore: cast_nullable_to_non_nullable
as String,alamatSekretariat: freezed == alamatSekretariat ? _self.alamatSekretariat : alamatSekretariat // ignore: cast_nullable_to_non_nullable
as String?,provinceId: freezed == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int?,regencyId: freezed == regencyId ? _self.regencyId : regencyId // ignore: cast_nullable_to_non_nullable
as int?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as int?,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as int?,figuresCount: freezed == figuresCount ? _self.figuresCount : figuresCount // ignore: cast_nullable_to_non_nullable
as int?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as OrganisasiRegionModel?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as OrganisasiRegionModel?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as OrganisasiRegionModel?,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as OrganisasiRegionModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<$Res>? get province {
    if (_self.province == null) {
    return null;
  }

  return $OrganisasiRegionModelCopyWith<$Res>(_self.province!, (value) {
    return _then(_self.copyWith(province: value));
  });
}/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<$Res>? get regency {
    if (_self.regency == null) {
    return null;
  }

  return $OrganisasiRegionModelCopyWith<$Res>(_self.regency!, (value) {
    return _then(_self.copyWith(regency: value));
  });
}/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<$Res>? get district {
    if (_self.district == null) {
    return null;
  }

  return $OrganisasiRegionModelCopyWith<$Res>(_self.district!, (value) {
    return _then(_self.copyWith(district: value));
  });
}/// Create a copy of OrganisasiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganisasiRegionModelCopyWith<$Res>? get village {
    if (_self.village == null) {
    return null;
  }

  return $OrganisasiRegionModelCopyWith<$Res>(_self.village!, (value) {
    return _then(_self.copyWith(village: value));
  });
}
}

// dart format on
