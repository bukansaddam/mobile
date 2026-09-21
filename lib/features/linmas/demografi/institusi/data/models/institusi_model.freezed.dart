// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institusi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstitusiRegionModel {

@JsonKey(name: 'id') int? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'code') String? get code;
/// Create a copy of InstitusiRegionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<InstitusiRegionModel> get copyWith => _$InstitusiRegionModelCopyWithImpl<InstitusiRegionModel>(this as InstitusiRegionModel, _$identity);

  /// Serializes this InstitusiRegionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiRegionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code);

@override
String toString() {
  return 'InstitusiRegionModel(id: $id, name: $name, code: $code)';
}


}

/// @nodoc
abstract mixin class $InstitusiRegionModelCopyWith<$Res>  {
  factory $InstitusiRegionModelCopyWith(InstitusiRegionModel value, $Res Function(InstitusiRegionModel) _then) = _$InstitusiRegionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'code') String? code
});




}
/// @nodoc
class _$InstitusiRegionModelCopyWithImpl<$Res>
    implements $InstitusiRegionModelCopyWith<$Res> {
  _$InstitusiRegionModelCopyWithImpl(this._self, this._then);

  final InstitusiRegionModel _self;
  final $Res Function(InstitusiRegionModel) _then;

/// Create a copy of InstitusiRegionModel
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


/// Adds pattern-matching-related methods to [InstitusiRegionModel].
extension InstitusiRegionModelPatterns on InstitusiRegionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiRegionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiRegionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiRegionModel value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiRegionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiRegionModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiRegionModel() when $default != null:
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
case _InstitusiRegionModel() when $default != null:
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
case _InstitusiRegionModel():
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
case _InstitusiRegionModel() when $default != null:
return $default(_that.id,_that.name,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstitusiRegionModel extends InstitusiRegionModel {
  const _InstitusiRegionModel({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'code') this.code}): super._();
  factory _InstitusiRegionModel.fromJson(Map<String, dynamic> json) => _$InstitusiRegionModelFromJson(json);

@override@JsonKey(name: 'id') final  int? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'code') final  String? code;

/// Create a copy of InstitusiRegionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiRegionModelCopyWith<_InstitusiRegionModel> get copyWith => __$InstitusiRegionModelCopyWithImpl<_InstitusiRegionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstitusiRegionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiRegionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code);

@override
String toString() {
  return 'InstitusiRegionModel(id: $id, name: $name, code: $code)';
}


}

/// @nodoc
abstract mixin class _$InstitusiRegionModelCopyWith<$Res> implements $InstitusiRegionModelCopyWith<$Res> {
  factory _$InstitusiRegionModelCopyWith(_InstitusiRegionModel value, $Res Function(_InstitusiRegionModel) _then) = __$InstitusiRegionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'code') String? code
});




}
/// @nodoc
class __$InstitusiRegionModelCopyWithImpl<$Res>
    implements _$InstitusiRegionModelCopyWith<$Res> {
  __$InstitusiRegionModelCopyWithImpl(this._self, this._then);

  final _InstitusiRegionModel _self;
  final $Res Function(_InstitusiRegionModel) _then;

/// Create a copy of InstitusiRegionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? code = freezed,}) {
  return _then(_InstitusiRegionModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InstitusiMetaModel {

@JsonKey(name: 'current_page') int get currentPage;@JsonKey(name: 'last_page') int get lastPage;@JsonKey(name: 'per_page') int get perPage;@JsonKey(name: 'total') int get total;
/// Create a copy of InstitusiMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiMetaModelCopyWith<InstitusiMetaModel> get copyWith => _$InstitusiMetaModelCopyWithImpl<InstitusiMetaModel>(this as InstitusiMetaModel, _$identity);

  /// Serializes this InstitusiMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'InstitusiMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class $InstitusiMetaModelCopyWith<$Res>  {
  factory $InstitusiMetaModelCopyWith(InstitusiMetaModel value, $Res Function(InstitusiMetaModel) _then) = _$InstitusiMetaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'total') int total
});




}
/// @nodoc
class _$InstitusiMetaModelCopyWithImpl<$Res>
    implements $InstitusiMetaModelCopyWith<$Res> {
  _$InstitusiMetaModelCopyWithImpl(this._self, this._then);

  final InstitusiMetaModel _self;
  final $Res Function(InstitusiMetaModel) _then;

/// Create a copy of InstitusiMetaModel
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


/// Adds pattern-matching-related methods to [InstitusiMetaModel].
extension InstitusiMetaModelPatterns on InstitusiMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiMetaModel() when $default != null:
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
case _InstitusiMetaModel() when $default != null:
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
case _InstitusiMetaModel():
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
case _InstitusiMetaModel() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstitusiMetaModel implements InstitusiMetaModel {
  const _InstitusiMetaModel({@JsonKey(name: 'current_page') this.currentPage = 1, @JsonKey(name: 'last_page') this.lastPage = 1, @JsonKey(name: 'per_page') this.perPage = 10, @JsonKey(name: 'total') this.total = 0});
  factory _InstitusiMetaModel.fromJson(Map<String, dynamic> json) => _$InstitusiMetaModelFromJson(json);

@override@JsonKey(name: 'current_page') final  int currentPage;
@override@JsonKey(name: 'last_page') final  int lastPage;
@override@JsonKey(name: 'per_page') final  int perPage;
@override@JsonKey(name: 'total') final  int total;

/// Create a copy of InstitusiMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiMetaModelCopyWith<_InstitusiMetaModel> get copyWith => __$InstitusiMetaModelCopyWithImpl<_InstitusiMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstitusiMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'InstitusiMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$InstitusiMetaModelCopyWith<$Res> implements $InstitusiMetaModelCopyWith<$Res> {
  factory _$InstitusiMetaModelCopyWith(_InstitusiMetaModel value, $Res Function(_InstitusiMetaModel) _then) = __$InstitusiMetaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage,@JsonKey(name: 'total') int total
});




}
/// @nodoc
class __$InstitusiMetaModelCopyWithImpl<$Res>
    implements _$InstitusiMetaModelCopyWith<$Res> {
  __$InstitusiMetaModelCopyWithImpl(this._self, this._then);

  final _InstitusiMetaModel _self;
  final $Res Function(_InstitusiMetaModel) _then;

/// Create a copy of InstitusiMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(_InstitusiMetaModel(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InstitusiResponseModel {

@JsonKey(name: 'success') bool get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') List<InstitusiModel> get data;@JsonKey(name: 'meta') InstitusiMetaModel? get meta;
/// Create a copy of InstitusiResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiResponseModelCopyWith<InstitusiResponseModel> get copyWith => _$InstitusiResponseModelCopyWithImpl<InstitusiResponseModel>(this as InstitusiResponseModel, _$identity);

  /// Serializes this InstitusiResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'InstitusiResponseModel(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $InstitusiResponseModelCopyWith<$Res>  {
  factory $InstitusiResponseModelCopyWith(InstitusiResponseModel value, $Res Function(InstitusiResponseModel) _then) = _$InstitusiResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<InstitusiModel> data,@JsonKey(name: 'meta') InstitusiMetaModel? meta
});


$InstitusiMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class _$InstitusiResponseModelCopyWithImpl<$Res>
    implements $InstitusiResponseModelCopyWith<$Res> {
  _$InstitusiResponseModelCopyWithImpl(this._self, this._then);

  final InstitusiResponseModel _self;
  final $Res Function(InstitusiResponseModel) _then;

/// Create a copy of InstitusiResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = freezed,Object? data = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<InstitusiModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as InstitusiMetaModel?,
  ));
}
/// Create a copy of InstitusiResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $InstitusiMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [InstitusiResponseModel].
extension InstitusiResponseModelPatterns on InstitusiResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<InstitusiModel> data, @JsonKey(name: 'meta')  InstitusiMetaModel? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitusiResponseModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<InstitusiModel> data, @JsonKey(name: 'meta')  InstitusiMetaModel? meta)  $default,) {final _that = this;
switch (_that) {
case _InstitusiResponseModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<InstitusiModel> data, @JsonKey(name: 'meta')  InstitusiMetaModel? meta)?  $default,) {final _that = this;
switch (_that) {
case _InstitusiResponseModel() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstitusiResponseModel extends InstitusiResponseModel {
  const _InstitusiResponseModel({@JsonKey(name: 'success') this.success = false, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') final  List<InstitusiModel> data = const [], @JsonKey(name: 'meta') this.meta}): _data = data,super._();
  factory _InstitusiResponseModel.fromJson(Map<String, dynamic> json) => _$InstitusiResponseModelFromJson(json);

@override@JsonKey(name: 'success') final  bool success;
@override@JsonKey(name: 'message') final  String? message;
 final  List<InstitusiModel> _data;
@override@JsonKey(name: 'data') List<InstitusiModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: 'meta') final  InstitusiMetaModel? meta;

/// Create a copy of InstitusiResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiResponseModelCopyWith<_InstitusiResponseModel> get copyWith => __$InstitusiResponseModelCopyWithImpl<_InstitusiResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstitusiResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'InstitusiResponseModel(success: $success, message: $message, data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$InstitusiResponseModelCopyWith<$Res> implements $InstitusiResponseModelCopyWith<$Res> {
  factory _$InstitusiResponseModelCopyWith(_InstitusiResponseModel value, $Res Function(_InstitusiResponseModel) _then) = __$InstitusiResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<InstitusiModel> data,@JsonKey(name: 'meta') InstitusiMetaModel? meta
});


@override $InstitusiMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class __$InstitusiResponseModelCopyWithImpl<$Res>
    implements _$InstitusiResponseModelCopyWith<$Res> {
  __$InstitusiResponseModelCopyWithImpl(this._self, this._then);

  final _InstitusiResponseModel _self;
  final $Res Function(_InstitusiResponseModel) _then;

/// Create a copy of InstitusiResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = freezed,Object? data = null,Object? meta = freezed,}) {
  return _then(_InstitusiResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<InstitusiModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as InstitusiMetaModel?,
  ));
}

/// Create a copy of InstitusiResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $InstitusiMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$InstitusiModel {

@JsonKey(name: 'id', readValue: _readId) String? get id;@JsonKey(name: 'name', readValue: _readNama) String get nama;@JsonKey(name: 'scope', readValue: _readScope) String get scope;@JsonKey(name: 'category', readValue: _readKategori) String? get kategori;@JsonKey(name: 'category_id', readValue: _readCategoryId) int? get categoryId;@JsonKey(name: 'address', readValue: _readAlamat) String? get alamat;@JsonKey(name: 'province_id') int? get provinceId;@JsonKey(name: 'regency_id') int? get regencyId;@JsonKey(name: 'district_id') int? get districtId;@JsonKey(name: 'village_id') int? get villageId;@JsonKey(name: 'figures_count') int? get figuresCount;@JsonKey(name: 'province', readValue: _readRegion) InstitusiRegionModel? get province;@JsonKey(name: 'regency', readValue: _readRegion) InstitusiRegionModel? get regency;@JsonKey(name: 'district', readValue: _readRegion) InstitusiRegionModel? get district;@JsonKey(name: 'village', readValue: _readRegion) InstitusiRegionModel? get village;@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get updatedAt;
/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitusiModelCopyWith<InstitusiModel> get copyWith => _$InstitusiModelCopyWithImpl<InstitusiModel>(this as InstitusiModel, _$identity);

  /// Serializes this InstitusiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitusiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.kategori, kategori) || other.kategori == kategori)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.alamat, alamat) || other.alamat == alamat)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.figuresCount, figuresCount) || other.figuresCount == figuresCount)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.district, district) || other.district == district)&&(identical(other.village, village) || other.village == village)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,scope,kategori,categoryId,alamat,provinceId,regencyId,districtId,villageId,figuresCount,province,regency,district,village,createdAt,updatedAt);

@override
String toString() {
  return 'InstitusiModel(id: $id, nama: $nama, scope: $scope, kategori: $kategori, categoryId: $categoryId, alamat: $alamat, provinceId: $provinceId, regencyId: $regencyId, districtId: $districtId, villageId: $villageId, figuresCount: $figuresCount, province: $province, regency: $regency, district: $district, village: $village, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InstitusiModelCopyWith<$Res>  {
  factory $InstitusiModelCopyWith(InstitusiModel value, $Res Function(InstitusiModel) _then) = _$InstitusiModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String? id,@JsonKey(name: 'name', readValue: _readNama) String nama,@JsonKey(name: 'scope', readValue: _readScope) String scope,@JsonKey(name: 'category', readValue: _readKategori) String? kategori,@JsonKey(name: 'category_id', readValue: _readCategoryId) int? categoryId,@JsonKey(name: 'address', readValue: _readAlamat) String? alamat,@JsonKey(name: 'province_id') int? provinceId,@JsonKey(name: 'regency_id') int? regencyId,@JsonKey(name: 'district_id') int? districtId,@JsonKey(name: 'village_id') int? villageId,@JsonKey(name: 'figures_count') int? figuresCount,@JsonKey(name: 'province', readValue: _readRegion) InstitusiRegionModel? province,@JsonKey(name: 'regency', readValue: _readRegion) InstitusiRegionModel? regency,@JsonKey(name: 'district', readValue: _readRegion) InstitusiRegionModel? district,@JsonKey(name: 'village', readValue: _readRegion) InstitusiRegionModel? village,@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt,@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? updatedAt
});


$InstitusiRegionModelCopyWith<$Res>? get province;$InstitusiRegionModelCopyWith<$Res>? get regency;$InstitusiRegionModelCopyWith<$Res>? get district;$InstitusiRegionModelCopyWith<$Res>? get village;

}
/// @nodoc
class _$InstitusiModelCopyWithImpl<$Res>
    implements $InstitusiModelCopyWith<$Res> {
  _$InstitusiModelCopyWithImpl(this._self, this._then);

  final InstitusiModel _self;
  final $Res Function(InstitusiModel) _then;

/// Create a copy of InstitusiModel
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
as InstitusiRegionModel?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as InstitusiRegionModel?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as InstitusiRegionModel?,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as InstitusiRegionModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<$Res>? get province {
    if (_self.province == null) {
    return null;
  }

  return $InstitusiRegionModelCopyWith<$Res>(_self.province!, (value) {
    return _then(_self.copyWith(province: value));
  });
}/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<$Res>? get regency {
    if (_self.regency == null) {
    return null;
  }

  return $InstitusiRegionModelCopyWith<$Res>(_self.regency!, (value) {
    return _then(_self.copyWith(regency: value));
  });
}/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<$Res>? get district {
    if (_self.district == null) {
    return null;
  }

  return $InstitusiRegionModelCopyWith<$Res>(_self.district!, (value) {
    return _then(_self.copyWith(district: value));
  });
}/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<$Res>? get village {
    if (_self.village == null) {
    return null;
  }

  return $InstitusiRegionModelCopyWith<$Res>(_self.village!, (value) {
    return _then(_self.copyWith(village: value));
  });
}
}


/// Adds pattern-matching-related methods to [InstitusiModel].
extension InstitusiModelPatterns on InstitusiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstitusiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitusiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstitusiModel value)  $default,){
final _that = this;
switch (_that) {
case _InstitusiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstitusiModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstitusiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'scope', readValue: _readScope)  String scope, @JsonKey(name: 'category', readValue: _readKategori)  String? kategori, @JsonKey(name: 'category_id', readValue: _readCategoryId)  int? categoryId, @JsonKey(name: 'address', readValue: _readAlamat)  String? alamat, @JsonKey(name: 'province_id')  int? provinceId, @JsonKey(name: 'regency_id')  int? regencyId, @JsonKey(name: 'district_id')  int? districtId, @JsonKey(name: 'village_id')  int? villageId, @JsonKey(name: 'figures_count')  int? figuresCount, @JsonKey(name: 'province', readValue: _readRegion)  InstitusiRegionModel? province, @JsonKey(name: 'regency', readValue: _readRegion)  InstitusiRegionModel? regency, @JsonKey(name: 'district', readValue: _readRegion)  InstitusiRegionModel? district, @JsonKey(name: 'village', readValue: _readRegion)  InstitusiRegionModel? village, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitusiModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'scope', readValue: _readScope)  String scope, @JsonKey(name: 'category', readValue: _readKategori)  String? kategori, @JsonKey(name: 'category_id', readValue: _readCategoryId)  int? categoryId, @JsonKey(name: 'address', readValue: _readAlamat)  String? alamat, @JsonKey(name: 'province_id')  int? provinceId, @JsonKey(name: 'regency_id')  int? regencyId, @JsonKey(name: 'district_id')  int? districtId, @JsonKey(name: 'village_id')  int? villageId, @JsonKey(name: 'figures_count')  int? figuresCount, @JsonKey(name: 'province', readValue: _readRegion)  InstitusiRegionModel? province, @JsonKey(name: 'regency', readValue: _readRegion)  InstitusiRegionModel? regency, @JsonKey(name: 'district', readValue: _readRegion)  InstitusiRegionModel? district, @JsonKey(name: 'village', readValue: _readRegion)  InstitusiRegionModel? village, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _InstitusiModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  String? id, @JsonKey(name: 'name', readValue: _readNama)  String nama, @JsonKey(name: 'scope', readValue: _readScope)  String scope, @JsonKey(name: 'category', readValue: _readKategori)  String? kategori, @JsonKey(name: 'category_id', readValue: _readCategoryId)  int? categoryId, @JsonKey(name: 'address', readValue: _readAlamat)  String? alamat, @JsonKey(name: 'province_id')  int? provinceId, @JsonKey(name: 'regency_id')  int? regencyId, @JsonKey(name: 'district_id')  int? districtId, @JsonKey(name: 'village_id')  int? villageId, @JsonKey(name: 'figures_count')  int? figuresCount, @JsonKey(name: 'province', readValue: _readRegion)  InstitusiRegionModel? province, @JsonKey(name: 'regency', readValue: _readRegion)  InstitusiRegionModel? regency, @JsonKey(name: 'district', readValue: _readRegion)  InstitusiRegionModel? district, @JsonKey(name: 'village', readValue: _readRegion)  InstitusiRegionModel? village, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _InstitusiModel() when $default != null:
return $default(_that.id,_that.nama,_that.scope,_that.kategori,_that.categoryId,_that.alamat,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.figuresCount,_that.province,_that.regency,_that.district,_that.village,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstitusiModel extends InstitusiModel {
  const _InstitusiModel({@JsonKey(name: 'id', readValue: _readId) this.id, @JsonKey(name: 'name', readValue: _readNama) required this.nama, @JsonKey(name: 'scope', readValue: _readScope) required this.scope, @JsonKey(name: 'category', readValue: _readKategori) this.kategori, @JsonKey(name: 'category_id', readValue: _readCategoryId) this.categoryId, @JsonKey(name: 'address', readValue: _readAlamat) this.alamat, @JsonKey(name: 'province_id') this.provinceId, @JsonKey(name: 'regency_id') this.regencyId, @JsonKey(name: 'district_id') this.districtId, @JsonKey(name: 'village_id') this.villageId, @JsonKey(name: 'figures_count') this.figuresCount, @JsonKey(name: 'province', readValue: _readRegion) this.province, @JsonKey(name: 'regency', readValue: _readRegion) this.regency, @JsonKey(name: 'district', readValue: _readRegion) this.district, @JsonKey(name: 'village', readValue: _readRegion) this.village, @JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.createdAt, @JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.updatedAt}): super._();
  factory _InstitusiModel.fromJson(Map<String, dynamic> json) => _$InstitusiModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  String? id;
@override@JsonKey(name: 'name', readValue: _readNama) final  String nama;
@override@JsonKey(name: 'scope', readValue: _readScope) final  String scope;
@override@JsonKey(name: 'category', readValue: _readKategori) final  String? kategori;
@override@JsonKey(name: 'category_id', readValue: _readCategoryId) final  int? categoryId;
@override@JsonKey(name: 'address', readValue: _readAlamat) final  String? alamat;
@override@JsonKey(name: 'province_id') final  int? provinceId;
@override@JsonKey(name: 'regency_id') final  int? regencyId;
@override@JsonKey(name: 'district_id') final  int? districtId;
@override@JsonKey(name: 'village_id') final  int? villageId;
@override@JsonKey(name: 'figures_count') final  int? figuresCount;
@override@JsonKey(name: 'province', readValue: _readRegion) final  InstitusiRegionModel? province;
@override@JsonKey(name: 'regency', readValue: _readRegion) final  InstitusiRegionModel? regency;
@override@JsonKey(name: 'district', readValue: _readRegion) final  InstitusiRegionModel? district;
@override@JsonKey(name: 'village', readValue: _readRegion) final  InstitusiRegionModel? village;
@override@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitusiModelCopyWith<_InstitusiModel> get copyWith => __$InstitusiModelCopyWithImpl<_InstitusiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstitusiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitusiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.kategori, kategori) || other.kategori == kategori)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.alamat, alamat) || other.alamat == alamat)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.figuresCount, figuresCount) || other.figuresCount == figuresCount)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.district, district) || other.district == district)&&(identical(other.village, village) || other.village == village)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,scope,kategori,categoryId,alamat,provinceId,regencyId,districtId,villageId,figuresCount,province,regency,district,village,createdAt,updatedAt);

@override
String toString() {
  return 'InstitusiModel(id: $id, nama: $nama, scope: $scope, kategori: $kategori, categoryId: $categoryId, alamat: $alamat, provinceId: $provinceId, regencyId: $regencyId, districtId: $districtId, villageId: $villageId, figuresCount: $figuresCount, province: $province, regency: $regency, district: $district, village: $village, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InstitusiModelCopyWith<$Res> implements $InstitusiModelCopyWith<$Res> {
  factory _$InstitusiModelCopyWith(_InstitusiModel value, $Res Function(_InstitusiModel) _then) = __$InstitusiModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String? id,@JsonKey(name: 'name', readValue: _readNama) String nama,@JsonKey(name: 'scope', readValue: _readScope) String scope,@JsonKey(name: 'category', readValue: _readKategori) String? kategori,@JsonKey(name: 'category_id', readValue: _readCategoryId) int? categoryId,@JsonKey(name: 'address', readValue: _readAlamat) String? alamat,@JsonKey(name: 'province_id') int? provinceId,@JsonKey(name: 'regency_id') int? regencyId,@JsonKey(name: 'district_id') int? districtId,@JsonKey(name: 'village_id') int? villageId,@JsonKey(name: 'figures_count') int? figuresCount,@JsonKey(name: 'province', readValue: _readRegion) InstitusiRegionModel? province,@JsonKey(name: 'regency', readValue: _readRegion) InstitusiRegionModel? regency,@JsonKey(name: 'district', readValue: _readRegion) InstitusiRegionModel? district,@JsonKey(name: 'village', readValue: _readRegion) InstitusiRegionModel? village,@JsonKey(name: 'created_at', readValue: _readCreatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt,@JsonKey(name: 'updated_at', readValue: _readUpdatedAt, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? updatedAt
});


@override $InstitusiRegionModelCopyWith<$Res>? get province;@override $InstitusiRegionModelCopyWith<$Res>? get regency;@override $InstitusiRegionModelCopyWith<$Res>? get district;@override $InstitusiRegionModelCopyWith<$Res>? get village;

}
/// @nodoc
class __$InstitusiModelCopyWithImpl<$Res>
    implements _$InstitusiModelCopyWith<$Res> {
  __$InstitusiModelCopyWithImpl(this._self, this._then);

  final _InstitusiModel _self;
  final $Res Function(_InstitusiModel) _then;

/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nama = null,Object? scope = null,Object? kategori = freezed,Object? categoryId = freezed,Object? alamat = freezed,Object? provinceId = freezed,Object? regencyId = freezed,Object? districtId = freezed,Object? villageId = freezed,Object? figuresCount = freezed,Object? province = freezed,Object? regency = freezed,Object? district = freezed,Object? village = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_InstitusiModel(
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
as InstitusiRegionModel?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as InstitusiRegionModel?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as InstitusiRegionModel?,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as InstitusiRegionModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<$Res>? get province {
    if (_self.province == null) {
    return null;
  }

  return $InstitusiRegionModelCopyWith<$Res>(_self.province!, (value) {
    return _then(_self.copyWith(province: value));
  });
}/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<$Res>? get regency {
    if (_self.regency == null) {
    return null;
  }

  return $InstitusiRegionModelCopyWith<$Res>(_self.regency!, (value) {
    return _then(_self.copyWith(regency: value));
  });
}/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<$Res>? get district {
    if (_self.district == null) {
    return null;
  }

  return $InstitusiRegionModelCopyWith<$Res>(_self.district!, (value) {
    return _then(_self.copyWith(district: value));
  });
}/// Create a copy of InstitusiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstitusiRegionModelCopyWith<$Res>? get village {
    if (_self.village == null) {
    return null;
  }

  return $InstitusiRegionModelCopyWith<$Res>(_self.village!, (value) {
    return _then(_self.copyWith(village: value));
  });
}
}

// dart format on
