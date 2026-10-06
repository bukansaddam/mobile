// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NearbyMemberModel {

@JsonKey(name: 'id', readValue: _readId) String get id;@JsonKey(name: 'name', readValue: _readName) String get name;@JsonKey(name: 'role', readValue: _readRole) String get role;@JsonKey(name: 'distance_text', readValue: _readDistanceText) String get distanceText;@JsonKey(name: 'latitude', readValue: _readLatitude) double get latitude;@JsonKey(name: 'longitude', readValue: _readLongitude) double get longitude;@JsonKey(name: 'phone', readValue: _readPhone) String get phone;@JsonKey(name: 'is_online', readValue: _readIsOnline) bool get isOnline;
/// Create a copy of NearbyMemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyMemberModelCopyWith<NearbyMemberModel> get copyWith => _$NearbyMemberModelCopyWithImpl<NearbyMemberModel>(this as NearbyMemberModel, _$identity);

  /// Serializes this NearbyMemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,distanceText,latitude,longitude,phone,isOnline);

@override
String toString() {
  return 'NearbyMemberModel(id: $id, name: $name, role: $role, distanceText: $distanceText, latitude: $latitude, longitude: $longitude, phone: $phone, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class $NearbyMemberModelCopyWith<$Res>  {
  factory $NearbyMemberModelCopyWith(NearbyMemberModel value, $Res Function(NearbyMemberModel) _then) = _$NearbyMemberModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'name', readValue: _readName) String name,@JsonKey(name: 'role', readValue: _readRole) String role,@JsonKey(name: 'distance_text', readValue: _readDistanceText) String distanceText,@JsonKey(name: 'latitude', readValue: _readLatitude) double latitude,@JsonKey(name: 'longitude', readValue: _readLongitude) double longitude,@JsonKey(name: 'phone', readValue: _readPhone) String phone,@JsonKey(name: 'is_online', readValue: _readIsOnline) bool isOnline
});




}
/// @nodoc
class _$NearbyMemberModelCopyWithImpl<$Res>
    implements $NearbyMemberModelCopyWith<$Res> {
  _$NearbyMemberModelCopyWithImpl(this._self, this._then);

  final NearbyMemberModel _self;
  final $Res Function(NearbyMemberModel) _then;

/// Create a copy of NearbyMemberModel
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


/// Adds pattern-matching-related methods to [NearbyMemberModel].
extension NearbyMemberModelPatterns on NearbyMemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyMemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyMemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyMemberModel value)  $default,){
final _that = this;
switch (_that) {
case _NearbyMemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyMemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyMemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'name', readValue: _readName)  String name, @JsonKey(name: 'role', readValue: _readRole)  String role, @JsonKey(name: 'distance_text', readValue: _readDistanceText)  String distanceText, @JsonKey(name: 'latitude', readValue: _readLatitude)  double latitude, @JsonKey(name: 'longitude', readValue: _readLongitude)  double longitude, @JsonKey(name: 'phone', readValue: _readPhone)  String phone, @JsonKey(name: 'is_online', readValue: _readIsOnline)  bool isOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyMemberModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'name', readValue: _readName)  String name, @JsonKey(name: 'role', readValue: _readRole)  String role, @JsonKey(name: 'distance_text', readValue: _readDistanceText)  String distanceText, @JsonKey(name: 'latitude', readValue: _readLatitude)  double latitude, @JsonKey(name: 'longitude', readValue: _readLongitude)  double longitude, @JsonKey(name: 'phone', readValue: _readPhone)  String phone, @JsonKey(name: 'is_online', readValue: _readIsOnline)  bool isOnline)  $default,) {final _that = this;
switch (_that) {
case _NearbyMemberModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'name', readValue: _readName)  String name, @JsonKey(name: 'role', readValue: _readRole)  String role, @JsonKey(name: 'distance_text', readValue: _readDistanceText)  String distanceText, @JsonKey(name: 'latitude', readValue: _readLatitude)  double latitude, @JsonKey(name: 'longitude', readValue: _readLongitude)  double longitude, @JsonKey(name: 'phone', readValue: _readPhone)  String phone, @JsonKey(name: 'is_online', readValue: _readIsOnline)  bool isOnline)?  $default,) {final _that = this;
switch (_that) {
case _NearbyMemberModel() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.distanceText,_that.latitude,_that.longitude,_that.phone,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearbyMemberModel extends NearbyMemberModel {
  const _NearbyMemberModel({@JsonKey(name: 'id', readValue: _readId) required this.id, @JsonKey(name: 'name', readValue: _readName) required this.name, @JsonKey(name: 'role', readValue: _readRole) required this.role, @JsonKey(name: 'distance_text', readValue: _readDistanceText) this.distanceText = '', @JsonKey(name: 'latitude', readValue: _readLatitude) this.latitude = 0.0, @JsonKey(name: 'longitude', readValue: _readLongitude) this.longitude = 0.0, @JsonKey(name: 'phone', readValue: _readPhone) this.phone = '', @JsonKey(name: 'is_online', readValue: _readIsOnline) this.isOnline = true}): super._();
  factory _NearbyMemberModel.fromJson(Map<String, dynamic> json) => _$NearbyMemberModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  String id;
@override@JsonKey(name: 'name', readValue: _readName) final  String name;
@override@JsonKey(name: 'role', readValue: _readRole) final  String role;
@override@JsonKey(name: 'distance_text', readValue: _readDistanceText) final  String distanceText;
@override@JsonKey(name: 'latitude', readValue: _readLatitude) final  double latitude;
@override@JsonKey(name: 'longitude', readValue: _readLongitude) final  double longitude;
@override@JsonKey(name: 'phone', readValue: _readPhone) final  String phone;
@override@JsonKey(name: 'is_online', readValue: _readIsOnline) final  bool isOnline;

/// Create a copy of NearbyMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyMemberModelCopyWith<_NearbyMemberModel> get copyWith => __$NearbyMemberModelCopyWithImpl<_NearbyMemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearbyMemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,distanceText,latitude,longitude,phone,isOnline);

@override
String toString() {
  return 'NearbyMemberModel(id: $id, name: $name, role: $role, distanceText: $distanceText, latitude: $latitude, longitude: $longitude, phone: $phone, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$NearbyMemberModelCopyWith<$Res> implements $NearbyMemberModelCopyWith<$Res> {
  factory _$NearbyMemberModelCopyWith(_NearbyMemberModel value, $Res Function(_NearbyMemberModel) _then) = __$NearbyMemberModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'name', readValue: _readName) String name,@JsonKey(name: 'role', readValue: _readRole) String role,@JsonKey(name: 'distance_text', readValue: _readDistanceText) String distanceText,@JsonKey(name: 'latitude', readValue: _readLatitude) double latitude,@JsonKey(name: 'longitude', readValue: _readLongitude) double longitude,@JsonKey(name: 'phone', readValue: _readPhone) String phone,@JsonKey(name: 'is_online', readValue: _readIsOnline) bool isOnline
});




}
/// @nodoc
class __$NearbyMemberModelCopyWithImpl<$Res>
    implements _$NearbyMemberModelCopyWith<$Res> {
  __$NearbyMemberModelCopyWithImpl(this._self, this._then);

  final _NearbyMemberModel _self;
  final $Res Function(_NearbyMemberModel) _then;

/// Create a copy of NearbyMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? distanceText = null,Object? latitude = null,Object? longitude = null,Object? phone = null,Object? isOnline = null,}) {
  return _then(_NearbyMemberModel(
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
mixin _$PanicAlertResultModel {

@JsonKey(name: 'is_success', readValue: _readIsSuccess) bool get isSuccess;@JsonKey(name: 'alert_id', readValue: _readAlertId) String get alertId;@JsonKey(name: 'timestamp', readValue: _readTimestamp, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime get timestamp;@JsonKey(name: 'message', readValue: _readMessage) String get message;
/// Create a copy of PanicAlertResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanicAlertResultModelCopyWith<PanicAlertResultModel> get copyWith => _$PanicAlertResultModelCopyWithImpl<PanicAlertResultModel>(this as PanicAlertResultModel, _$identity);

  /// Serializes this PanicAlertResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicAlertResultModel&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isSuccess,alertId,timestamp,message);

@override
String toString() {
  return 'PanicAlertResultModel(isSuccess: $isSuccess, alertId: $alertId, timestamp: $timestamp, message: $message)';
}


}

/// @nodoc
abstract mixin class $PanicAlertResultModelCopyWith<$Res>  {
  factory $PanicAlertResultModelCopyWith(PanicAlertResultModel value, $Res Function(PanicAlertResultModel) _then) = _$PanicAlertResultModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_success', readValue: _readIsSuccess) bool isSuccess,@JsonKey(name: 'alert_id', readValue: _readAlertId) String alertId,@JsonKey(name: 'timestamp', readValue: _readTimestamp, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime timestamp,@JsonKey(name: 'message', readValue: _readMessage) String message
});




}
/// @nodoc
class _$PanicAlertResultModelCopyWithImpl<$Res>
    implements $PanicAlertResultModelCopyWith<$Res> {
  _$PanicAlertResultModelCopyWithImpl(this._self, this._then);

  final PanicAlertResultModel _self;
  final $Res Function(PanicAlertResultModel) _then;

/// Create a copy of PanicAlertResultModel
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


/// Adds pattern-matching-related methods to [PanicAlertResultModel].
extension PanicAlertResultModelPatterns on PanicAlertResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanicAlertResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanicAlertResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanicAlertResultModel value)  $default,){
final _that = this;
switch (_that) {
case _PanicAlertResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanicAlertResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _PanicAlertResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_success', readValue: _readIsSuccess)  bool isSuccess, @JsonKey(name: 'alert_id', readValue: _readAlertId)  String alertId, @JsonKey(name: 'timestamp', readValue: _readTimestamp, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime timestamp, @JsonKey(name: 'message', readValue: _readMessage)  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanicAlertResultModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_success', readValue: _readIsSuccess)  bool isSuccess, @JsonKey(name: 'alert_id', readValue: _readAlertId)  String alertId, @JsonKey(name: 'timestamp', readValue: _readTimestamp, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime timestamp, @JsonKey(name: 'message', readValue: _readMessage)  String message)  $default,) {final _that = this;
switch (_that) {
case _PanicAlertResultModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_success', readValue: _readIsSuccess)  bool isSuccess, @JsonKey(name: 'alert_id', readValue: _readAlertId)  String alertId, @JsonKey(name: 'timestamp', readValue: _readTimestamp, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime timestamp, @JsonKey(name: 'message', readValue: _readMessage)  String message)?  $default,) {final _that = this;
switch (_that) {
case _PanicAlertResultModel() when $default != null:
return $default(_that.isSuccess,_that.alertId,_that.timestamp,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PanicAlertResultModel extends PanicAlertResultModel {
  const _PanicAlertResultModel({@JsonKey(name: 'is_success', readValue: _readIsSuccess) this.isSuccess = true, @JsonKey(name: 'alert_id', readValue: _readAlertId) required this.alertId, @JsonKey(name: 'timestamp', readValue: _readTimestamp, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) required this.timestamp, @JsonKey(name: 'message', readValue: _readMessage) required this.message}): super._();
  factory _PanicAlertResultModel.fromJson(Map<String, dynamic> json) => _$PanicAlertResultModelFromJson(json);

@override@JsonKey(name: 'is_success', readValue: _readIsSuccess) final  bool isSuccess;
@override@JsonKey(name: 'alert_id', readValue: _readAlertId) final  String alertId;
@override@JsonKey(name: 'timestamp', readValue: _readTimestamp, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime timestamp;
@override@JsonKey(name: 'message', readValue: _readMessage) final  String message;

/// Create a copy of PanicAlertResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanicAlertResultModelCopyWith<_PanicAlertResultModel> get copyWith => __$PanicAlertResultModelCopyWithImpl<_PanicAlertResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanicAlertResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanicAlertResultModel&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isSuccess,alertId,timestamp,message);

@override
String toString() {
  return 'PanicAlertResultModel(isSuccess: $isSuccess, alertId: $alertId, timestamp: $timestamp, message: $message)';
}


}

/// @nodoc
abstract mixin class _$PanicAlertResultModelCopyWith<$Res> implements $PanicAlertResultModelCopyWith<$Res> {
  factory _$PanicAlertResultModelCopyWith(_PanicAlertResultModel value, $Res Function(_PanicAlertResultModel) _then) = __$PanicAlertResultModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_success', readValue: _readIsSuccess) bool isSuccess,@JsonKey(name: 'alert_id', readValue: _readAlertId) String alertId,@JsonKey(name: 'timestamp', readValue: _readTimestamp, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime timestamp,@JsonKey(name: 'message', readValue: _readMessage) String message
});




}
/// @nodoc
class __$PanicAlertResultModelCopyWithImpl<$Res>
    implements _$PanicAlertResultModelCopyWith<$Res> {
  __$PanicAlertResultModelCopyWithImpl(this._self, this._then);

  final _PanicAlertResultModel _self;
  final $Res Function(_PanicAlertResultModel) _then;

/// Create a copy of PanicAlertResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSuccess = null,Object? alertId = null,Object? timestamp = null,Object? message = null,}) {
  return _then(_PanicAlertResultModel(
isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
