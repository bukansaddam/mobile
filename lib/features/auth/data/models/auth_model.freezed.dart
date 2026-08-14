// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthModel {

@JsonKey(name: "message") String? get message;@JsonKey(name: "access_token") String get accessToken;@JsonKey(name: "token_type") String? get tokenType;@JsonKey(name: "user") UserModel get user;
/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthModelCopyWith<AuthModel> get copyWith => _$AuthModelCopyWithImpl<AuthModel>(this as AuthModel, _$identity);

  /// Serializes this AuthModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthModel&&(identical(other.message, message) || other.message == message)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,accessToken,tokenType,user);

@override
String toString() {
  return 'AuthModel(message: $message, accessToken: $accessToken, tokenType: $tokenType, user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthModelCopyWith<$Res>  {
  factory $AuthModelCopyWith(AuthModel value, $Res Function(AuthModel) _then) = _$AuthModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "access_token") String accessToken,@JsonKey(name: "token_type") String? tokenType,@JsonKey(name: "user") UserModel user
});


$UserModelCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthModelCopyWithImpl<$Res>
    implements $AuthModelCopyWith<$Res> {
  _$AuthModelCopyWithImpl(this._self, this._then);

  final AuthModel _self;
  final $Res Function(AuthModel) _then;

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,Object? accessToken = null,Object? tokenType = freezed,Object? user = null,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,tokenType: freezed == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String?,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}
/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthModel].
extension AuthModelPatterns on AuthModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "token_type")  String? tokenType, @JsonKey(name: "user")  UserModel user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthModel() when $default != null:
return $default(_that.message,_that.accessToken,_that.tokenType,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "token_type")  String? tokenType, @JsonKey(name: "user")  UserModel user)  $default,) {final _that = this;
switch (_that) {
case _AuthModel():
return $default(_that.message,_that.accessToken,_that.tokenType,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "token_type")  String? tokenType, @JsonKey(name: "user")  UserModel user)?  $default,) {final _that = this;
switch (_that) {
case _AuthModel() when $default != null:
return $default(_that.message,_that.accessToken,_that.tokenType,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthModel extends AuthModel {
  const _AuthModel({@JsonKey(name: "message") this.message, @JsonKey(name: "access_token") required this.accessToken, @JsonKey(name: "token_type") this.tokenType, @JsonKey(name: "user") required this.user}): super._();
  factory _AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

@override@JsonKey(name: "message") final  String? message;
@override@JsonKey(name: "access_token") final  String accessToken;
@override@JsonKey(name: "token_type") final  String? tokenType;
@override@JsonKey(name: "user") final  UserModel user;

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthModelCopyWith<_AuthModel> get copyWith => __$AuthModelCopyWithImpl<_AuthModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthModel&&(identical(other.message, message) || other.message == message)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,accessToken,tokenType,user);

@override
String toString() {
  return 'AuthModel(message: $message, accessToken: $accessToken, tokenType: $tokenType, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthModelCopyWith<$Res> implements $AuthModelCopyWith<$Res> {
  factory _$AuthModelCopyWith(_AuthModel value, $Res Function(_AuthModel) _then) = __$AuthModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "access_token") String accessToken,@JsonKey(name: "token_type") String? tokenType,@JsonKey(name: "user") UserModel user
});


@override $UserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthModelCopyWithImpl<$Res>
    implements _$AuthModelCopyWith<$Res> {
  __$AuthModelCopyWithImpl(this._self, this._then);

  final _AuthModel _self;
  final $Res Function(_AuthModel) _then;

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? accessToken = null,Object? tokenType = freezed,Object? user = null,}) {
  return _then(_AuthModel(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,tokenType: freezed == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String?,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$UserModel {

@JsonKey(name: "id") int get id;@JsonKey(name: "name") String? get name;@JsonKey(name: "email") String? get email;@JsonKey(name: "username") String? get username;@JsonKey(name: "phone", readValue: _readPhone) String? get phoneNumber;@JsonKey(name: "nik") String? get nik;@JsonKey(name: "latitude") double? get latitude;@JsonKey(name: "longitude") double? get longitude;@JsonKey(name: "email_verified_at") dynamic get emailVerifiedAt;@JsonKey(name: "created_at") DateTime? get createdAt;@JsonKey(name: "updated_at") DateTime? get updatedAt;@JsonKey(name: "village_members_id") int? get villageMembersId;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.nik, nik) || other.nik == nik)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other.emailVerifiedAt, emailVerifiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.villageMembersId, villageMembersId) || other.villageMembersId == villageMembersId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,username,phoneNumber,nik,latitude,longitude,const DeepCollectionEquality().hash(emailVerifiedAt),createdAt,updatedAt,villageMembersId);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, username: $username, phoneNumber: $phoneNumber, nik: $nik, latitude: $latitude, longitude: $longitude, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt, villageMembersId: $villageMembersId)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "name") String? name,@JsonKey(name: "email") String? email,@JsonKey(name: "username") String? username,@JsonKey(name: "phone", readValue: _readPhone) String? phoneNumber,@JsonKey(name: "nik") String? nik,@JsonKey(name: "latitude") double? latitude,@JsonKey(name: "longitude") double? longitude,@JsonKey(name: "email_verified_at") dynamic emailVerifiedAt,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt,@JsonKey(name: "village_members_id") int? villageMembersId
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? email = freezed,Object? username = freezed,Object? phoneNumber = freezed,Object? nik = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? emailVerifiedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? villageMembersId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,nik: freezed == nik ? _self.nik : nik // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,villageMembersId: freezed == villageMembersId ? _self.villageMembersId : villageMembersId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String? name, @JsonKey(name: "email")  String? email, @JsonKey(name: "username")  String? username, @JsonKey(name: "phone", readValue: _readPhone)  String? phoneNumber, @JsonKey(name: "nik")  String? nik, @JsonKey(name: "latitude")  double? latitude, @JsonKey(name: "longitude")  double? longitude, @JsonKey(name: "email_verified_at")  dynamic emailVerifiedAt, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "village_members_id")  int? villageMembersId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.username,_that.phoneNumber,_that.nik,_that.latitude,_that.longitude,_that.emailVerifiedAt,_that.createdAt,_that.updatedAt,_that.villageMembersId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String? name, @JsonKey(name: "email")  String? email, @JsonKey(name: "username")  String? username, @JsonKey(name: "phone", readValue: _readPhone)  String? phoneNumber, @JsonKey(name: "nik")  String? nik, @JsonKey(name: "latitude")  double? latitude, @JsonKey(name: "longitude")  double? longitude, @JsonKey(name: "email_verified_at")  dynamic emailVerifiedAt, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "village_members_id")  int? villageMembersId)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.name,_that.email,_that.username,_that.phoneNumber,_that.nik,_that.latitude,_that.longitude,_that.emailVerifiedAt,_that.createdAt,_that.updatedAt,_that.villageMembersId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String? name, @JsonKey(name: "email")  String? email, @JsonKey(name: "username")  String? username, @JsonKey(name: "phone", readValue: _readPhone)  String? phoneNumber, @JsonKey(name: "nik")  String? nik, @JsonKey(name: "latitude")  double? latitude, @JsonKey(name: "longitude")  double? longitude, @JsonKey(name: "email_verified_at")  dynamic emailVerifiedAt, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "village_members_id")  int? villageMembersId)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.username,_that.phoneNumber,_that.nik,_that.latitude,_that.longitude,_that.emailVerifiedAt,_that.createdAt,_that.updatedAt,_that.villageMembersId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") this.name, @JsonKey(name: "email") this.email, @JsonKey(name: "username") this.username, @JsonKey(name: "phone", readValue: _readPhone) this.phoneNumber, @JsonKey(name: "nik") this.nik, @JsonKey(name: "latitude") this.latitude, @JsonKey(name: "longitude") this.longitude, @JsonKey(name: "email_verified_at") this.emailVerifiedAt, @JsonKey(name: "created_at") this.createdAt, @JsonKey(name: "updated_at") this.updatedAt, @JsonKey(name: "village_members_id") this.villageMembersId}): super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "name") final  String? name;
@override@JsonKey(name: "email") final  String? email;
@override@JsonKey(name: "username") final  String? username;
@override@JsonKey(name: "phone", readValue: _readPhone) final  String? phoneNumber;
@override@JsonKey(name: "nik") final  String? nik;
@override@JsonKey(name: "latitude") final  double? latitude;
@override@JsonKey(name: "longitude") final  double? longitude;
@override@JsonKey(name: "email_verified_at") final  dynamic emailVerifiedAt;
@override@JsonKey(name: "created_at") final  DateTime? createdAt;
@override@JsonKey(name: "updated_at") final  DateTime? updatedAt;
@override@JsonKey(name: "village_members_id") final  int? villageMembersId;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.nik, nik) || other.nik == nik)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other.emailVerifiedAt, emailVerifiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.villageMembersId, villageMembersId) || other.villageMembersId == villageMembersId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,username,phoneNumber,nik,latitude,longitude,const DeepCollectionEquality().hash(emailVerifiedAt),createdAt,updatedAt,villageMembersId);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, email: $email, username: $username, phoneNumber: $phoneNumber, nik: $nik, latitude: $latitude, longitude: $longitude, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt, villageMembersId: $villageMembersId)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "name") String? name,@JsonKey(name: "email") String? email,@JsonKey(name: "username") String? username,@JsonKey(name: "phone", readValue: _readPhone) String? phoneNumber,@JsonKey(name: "nik") String? nik,@JsonKey(name: "latitude") double? latitude,@JsonKey(name: "longitude") double? longitude,@JsonKey(name: "email_verified_at") dynamic emailVerifiedAt,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt,@JsonKey(name: "village_members_id") int? villageMembersId
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? email = freezed,Object? username = freezed,Object? phoneNumber = freezed,Object? nik = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? emailVerifiedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? villageMembersId = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,nik: freezed == nik ? _self.nik : nik // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,villageMembersId: freezed == villageMembersId ? _self.villageMembersId : villageMembersId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
