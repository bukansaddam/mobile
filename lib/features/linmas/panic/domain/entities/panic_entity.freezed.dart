// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panic_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NearbyMemberEntity {

 String get id; String get name; String get role; String get distanceText; double get latitude; double get longitude; String get phone; bool get isOnline;
/// Create a copy of NearbyMemberEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyMemberEntityCopyWith<NearbyMemberEntity> get copyWith => _$NearbyMemberEntityCopyWithImpl<NearbyMemberEntity>(this as NearbyMemberEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyMemberEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,role,distanceText,latitude,longitude,phone,isOnline);

@override
String toString() {
  return 'NearbyMemberEntity(id: $id, name: $name, role: $role, distanceText: $distanceText, latitude: $latitude, longitude: $longitude, phone: $phone, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class $NearbyMemberEntityCopyWith<$Res>  {
  factory $NearbyMemberEntityCopyWith(NearbyMemberEntity value, $Res Function(NearbyMemberEntity) _then) = _$NearbyMemberEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String role, String distanceText, double latitude, double longitude, String phone, bool isOnline
});




}
/// @nodoc
class _$NearbyMemberEntityCopyWithImpl<$Res>
    implements $NearbyMemberEntityCopyWith<$Res> {
  _$NearbyMemberEntityCopyWithImpl(this._self, this._then);

  final NearbyMemberEntity _self;
  final $Res Function(NearbyMemberEntity) _then;

/// Create a copy of NearbyMemberEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? distanceText = null,Object? latitude = null,Object? longitude = null,Object? phone = null,Object? isOnline = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NearbyMemberEntity].
extension NearbyMemberEntityPatterns on NearbyMemberEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyMemberEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyMemberEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyMemberEntity value)  $default,){
final _that = this;
switch (_that) {
case _NearbyMemberEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyMemberEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyMemberEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String role,  String distanceText,  double latitude,  double longitude,  String phone,  bool isOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyMemberEntity() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.distanceText,_that.latitude,_that.longitude,_that.phone,_that.isOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String role,  String distanceText,  double latitude,  double longitude,  String phone,  bool isOnline)  $default,) {final _that = this;
switch (_that) {
case _NearbyMemberEntity():
return $default(_that.id,_that.name,_that.role,_that.distanceText,_that.latitude,_that.longitude,_that.phone,_that.isOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String role,  String distanceText,  double latitude,  double longitude,  String phone,  bool isOnline)?  $default,) {final _that = this;
switch (_that) {
case _NearbyMemberEntity() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.distanceText,_that.latitude,_that.longitude,_that.phone,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc


class _NearbyMemberEntity extends NearbyMemberEntity {
  const _NearbyMemberEntity({required this.id, required this.name, required this.role, this.distanceText = '', this.latitude = 0.0, this.longitude = 0.0, this.phone = '', this.isOnline = true}): super._();
  

@override final  String id;
@override final  String name;
@override final  String role;
@override@JsonKey() final  String distanceText;
@override@JsonKey() final  double latitude;
@override@JsonKey() final  double longitude;
@override@JsonKey() final  String phone;
@override@JsonKey() final  bool isOnline;

/// Create a copy of NearbyMemberEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyMemberEntityCopyWith<_NearbyMemberEntity> get copyWith => __$NearbyMemberEntityCopyWithImpl<_NearbyMemberEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyMemberEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,role,distanceText,latitude,longitude,phone,isOnline);

@override
String toString() {
  return 'NearbyMemberEntity(id: $id, name: $name, role: $role, distanceText: $distanceText, latitude: $latitude, longitude: $longitude, phone: $phone, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$NearbyMemberEntityCopyWith<$Res> implements $NearbyMemberEntityCopyWith<$Res> {
  factory _$NearbyMemberEntityCopyWith(_NearbyMemberEntity value, $Res Function(_NearbyMemberEntity) _then) = __$NearbyMemberEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String role, String distanceText, double latitude, double longitude, String phone, bool isOnline
});




}
/// @nodoc
class __$NearbyMemberEntityCopyWithImpl<$Res>
    implements _$NearbyMemberEntityCopyWith<$Res> {
  __$NearbyMemberEntityCopyWithImpl(this._self, this._then);

  final _NearbyMemberEntity _self;
  final $Res Function(_NearbyMemberEntity) _then;

/// Create a copy of NearbyMemberEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? distanceText = null,Object? latitude = null,Object? longitude = null,Object? phone = null,Object? isOnline = null,}) {
  return _then(_NearbyMemberEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PanicAlertResultEntity {

 bool get isSuccess; String get alertId; DateTime get timestamp; String get message;
/// Create a copy of PanicAlertResultEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanicAlertResultEntityCopyWith<PanicAlertResultEntity> get copyWith => _$PanicAlertResultEntityCopyWithImpl<PanicAlertResultEntity>(this as PanicAlertResultEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicAlertResultEntity&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isSuccess,alertId,timestamp,message);

@override
String toString() {
  return 'PanicAlertResultEntity(isSuccess: $isSuccess, alertId: $alertId, timestamp: $timestamp, message: $message)';
}


}

/// @nodoc
abstract mixin class $PanicAlertResultEntityCopyWith<$Res>  {
  factory $PanicAlertResultEntityCopyWith(PanicAlertResultEntity value, $Res Function(PanicAlertResultEntity) _then) = _$PanicAlertResultEntityCopyWithImpl;
@useResult
$Res call({
 bool isSuccess, String alertId, DateTime timestamp, String message
});




}
/// @nodoc
class _$PanicAlertResultEntityCopyWithImpl<$Res>
    implements $PanicAlertResultEntityCopyWith<$Res> {
  _$PanicAlertResultEntityCopyWithImpl(this._self, this._then);

  final PanicAlertResultEntity _self;
  final $Res Function(PanicAlertResultEntity) _then;

/// Create a copy of PanicAlertResultEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSuccess = null,Object? alertId = null,Object? timestamp = null,Object? message = null,}) {
  return _then(_self.copyWith(
isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PanicAlertResultEntity].
extension PanicAlertResultEntityPatterns on PanicAlertResultEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanicAlertResultEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanicAlertResultEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanicAlertResultEntity value)  $default,){
final _that = this;
switch (_that) {
case _PanicAlertResultEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanicAlertResultEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PanicAlertResultEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSuccess,  String alertId,  DateTime timestamp,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanicAlertResultEntity() when $default != null:
return $default(_that.isSuccess,_that.alertId,_that.timestamp,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSuccess,  String alertId,  DateTime timestamp,  String message)  $default,) {final _that = this;
switch (_that) {
case _PanicAlertResultEntity():
return $default(_that.isSuccess,_that.alertId,_that.timestamp,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSuccess,  String alertId,  DateTime timestamp,  String message)?  $default,) {final _that = this;
switch (_that) {
case _PanicAlertResultEntity() when $default != null:
return $default(_that.isSuccess,_that.alertId,_that.timestamp,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _PanicAlertResultEntity extends PanicAlertResultEntity {
  const _PanicAlertResultEntity({this.isSuccess = true, required this.alertId, required this.timestamp, required this.message}): super._();
  

@override@JsonKey() final  bool isSuccess;
@override final  String alertId;
@override final  DateTime timestamp;
@override final  String message;

/// Create a copy of PanicAlertResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanicAlertResultEntityCopyWith<_PanicAlertResultEntity> get copyWith => __$PanicAlertResultEntityCopyWithImpl<_PanicAlertResultEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanicAlertResultEntity&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isSuccess,alertId,timestamp,message);

@override
String toString() {
  return 'PanicAlertResultEntity(isSuccess: $isSuccess, alertId: $alertId, timestamp: $timestamp, message: $message)';
}


}

/// @nodoc
abstract mixin class _$PanicAlertResultEntityCopyWith<$Res> implements $PanicAlertResultEntityCopyWith<$Res> {
  factory _$PanicAlertResultEntityCopyWith(_PanicAlertResultEntity value, $Res Function(_PanicAlertResultEntity) _then) = __$PanicAlertResultEntityCopyWithImpl;
@override @useResult
$Res call({
 bool isSuccess, String alertId, DateTime timestamp, String message
});




}
/// @nodoc
class __$PanicAlertResultEntityCopyWithImpl<$Res>
    implements _$PanicAlertResultEntityCopyWith<$Res> {
  __$PanicAlertResultEntityCopyWithImpl(this._self, this._then);

  final _PanicAlertResultEntity _self;
  final $Res Function(_PanicAlertResultEntity) _then;

/// Create a copy of PanicAlertResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSuccess = null,Object? alertId = null,Object? timestamp = null,Object? message = null,}) {
  return _then(_PanicAlertResultEntity(
isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
