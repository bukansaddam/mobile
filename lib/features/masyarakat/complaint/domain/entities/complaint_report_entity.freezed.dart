// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complaint_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComplaintAttachmentEntity {

 String get mimeType; String get url;
/// Create a copy of ComplaintAttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintAttachmentEntityCopyWith<ComplaintAttachmentEntity> get copyWith => _$ComplaintAttachmentEntityCopyWithImpl<ComplaintAttachmentEntity>(this as ComplaintAttachmentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintAttachmentEntity&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,mimeType,url);

@override
String toString() {
  return 'ComplaintAttachmentEntity(mimeType: $mimeType, url: $url)';
}


}

/// @nodoc
abstract mixin class $ComplaintAttachmentEntityCopyWith<$Res>  {
  factory $ComplaintAttachmentEntityCopyWith(ComplaintAttachmentEntity value, $Res Function(ComplaintAttachmentEntity) _then) = _$ComplaintAttachmentEntityCopyWithImpl;
@useResult
$Res call({
 String mimeType, String url
});




}
/// @nodoc
class _$ComplaintAttachmentEntityCopyWithImpl<$Res>
    implements $ComplaintAttachmentEntityCopyWith<$Res> {
  _$ComplaintAttachmentEntityCopyWithImpl(this._self, this._then);

  final ComplaintAttachmentEntity _self;
  final $Res Function(ComplaintAttachmentEntity) _then;

/// Create a copy of ComplaintAttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mimeType = null,Object? url = null,}) {
  return _then(_self.copyWith(
mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintAttachmentEntity].
extension ComplaintAttachmentEntityPatterns on ComplaintAttachmentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintAttachmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintAttachmentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintAttachmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintAttachmentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintAttachmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintAttachmentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mimeType,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintAttachmentEntity() when $default != null:
return $default(_that.mimeType,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mimeType,  String url)  $default,) {final _that = this;
switch (_that) {
case _ComplaintAttachmentEntity():
return $default(_that.mimeType,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mimeType,  String url)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintAttachmentEntity() when $default != null:
return $default(_that.mimeType,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _ComplaintAttachmentEntity extends ComplaintAttachmentEntity {
  const _ComplaintAttachmentEntity({this.mimeType = '', this.url = ''}): super._();
  

@override@JsonKey() final  String mimeType;
@override@JsonKey() final  String url;

/// Create a copy of ComplaintAttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintAttachmentEntityCopyWith<_ComplaintAttachmentEntity> get copyWith => __$ComplaintAttachmentEntityCopyWithImpl<_ComplaintAttachmentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintAttachmentEntity&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,mimeType,url);

@override
String toString() {
  return 'ComplaintAttachmentEntity(mimeType: $mimeType, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ComplaintAttachmentEntityCopyWith<$Res> implements $ComplaintAttachmentEntityCopyWith<$Res> {
  factory _$ComplaintAttachmentEntityCopyWith(_ComplaintAttachmentEntity value, $Res Function(_ComplaintAttachmentEntity) _then) = __$ComplaintAttachmentEntityCopyWithImpl;
@override @useResult
$Res call({
 String mimeType, String url
});




}
/// @nodoc
class __$ComplaintAttachmentEntityCopyWithImpl<$Res>
    implements _$ComplaintAttachmentEntityCopyWith<$Res> {
  __$ComplaintAttachmentEntityCopyWithImpl(this._self, this._then);

  final _ComplaintAttachmentEntity _self;
  final $Res Function(_ComplaintAttachmentEntity) _then;

/// Create a copy of ComplaintAttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mimeType = null,Object? url = null,}) {
  return _then(_ComplaintAttachmentEntity(
mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ComplaintSlaEntity {

 String get stageLabel; int get remainingMinutes; int get progressPct; String get state;
/// Create a copy of ComplaintSlaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintSlaEntityCopyWith<ComplaintSlaEntity> get copyWith => _$ComplaintSlaEntityCopyWithImpl<ComplaintSlaEntity>(this as ComplaintSlaEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintSlaEntity&&(identical(other.stageLabel, stageLabel) || other.stageLabel == stageLabel)&&(identical(other.remainingMinutes, remainingMinutes) || other.remainingMinutes == remainingMinutes)&&(identical(other.progressPct, progressPct) || other.progressPct == progressPct)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,stageLabel,remainingMinutes,progressPct,state);

@override
String toString() {
  return 'ComplaintSlaEntity(stageLabel: $stageLabel, remainingMinutes: $remainingMinutes, progressPct: $progressPct, state: $state)';
}


}

/// @nodoc
abstract mixin class $ComplaintSlaEntityCopyWith<$Res>  {
  factory $ComplaintSlaEntityCopyWith(ComplaintSlaEntity value, $Res Function(ComplaintSlaEntity) _then) = _$ComplaintSlaEntityCopyWithImpl;
@useResult
$Res call({
 String stageLabel, int remainingMinutes, int progressPct, String state
});




}
/// @nodoc
class _$ComplaintSlaEntityCopyWithImpl<$Res>
    implements $ComplaintSlaEntityCopyWith<$Res> {
  _$ComplaintSlaEntityCopyWithImpl(this._self, this._then);

  final ComplaintSlaEntity _self;
  final $Res Function(ComplaintSlaEntity) _then;

/// Create a copy of ComplaintSlaEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stageLabel = null,Object? remainingMinutes = null,Object? progressPct = null,Object? state = null,}) {
  return _then(_self.copyWith(
stageLabel: null == stageLabel ? _self.stageLabel : stageLabel // ignore: cast_nullable_to_non_nullable
as String,remainingMinutes: null == remainingMinutes ? _self.remainingMinutes : remainingMinutes // ignore: cast_nullable_to_non_nullable
as int,progressPct: null == progressPct ? _self.progressPct : progressPct // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintSlaEntity].
extension ComplaintSlaEntityPatterns on ComplaintSlaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintSlaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintSlaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintSlaEntity value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintSlaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintSlaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintSlaEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stageLabel,  int remainingMinutes,  int progressPct,  String state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintSlaEntity() when $default != null:
return $default(_that.stageLabel,_that.remainingMinutes,_that.progressPct,_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stageLabel,  int remainingMinutes,  int progressPct,  String state)  $default,) {final _that = this;
switch (_that) {
case _ComplaintSlaEntity():
return $default(_that.stageLabel,_that.remainingMinutes,_that.progressPct,_that.state);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stageLabel,  int remainingMinutes,  int progressPct,  String state)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintSlaEntity() when $default != null:
return $default(_that.stageLabel,_that.remainingMinutes,_that.progressPct,_that.state);case _:
  return null;

}
}

}

/// @nodoc


class _ComplaintSlaEntity implements ComplaintSlaEntity {
  const _ComplaintSlaEntity({this.stageLabel = '', this.remainingMinutes = 0, this.progressPct = 0, this.state = ''});
  

@override@JsonKey() final  String stageLabel;
@override@JsonKey() final  int remainingMinutes;
@override@JsonKey() final  int progressPct;
@override@JsonKey() final  String state;

/// Create a copy of ComplaintSlaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintSlaEntityCopyWith<_ComplaintSlaEntity> get copyWith => __$ComplaintSlaEntityCopyWithImpl<_ComplaintSlaEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintSlaEntity&&(identical(other.stageLabel, stageLabel) || other.stageLabel == stageLabel)&&(identical(other.remainingMinutes, remainingMinutes) || other.remainingMinutes == remainingMinutes)&&(identical(other.progressPct, progressPct) || other.progressPct == progressPct)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,stageLabel,remainingMinutes,progressPct,state);

@override
String toString() {
  return 'ComplaintSlaEntity(stageLabel: $stageLabel, remainingMinutes: $remainingMinutes, progressPct: $progressPct, state: $state)';
}


}

/// @nodoc
abstract mixin class _$ComplaintSlaEntityCopyWith<$Res> implements $ComplaintSlaEntityCopyWith<$Res> {
  factory _$ComplaintSlaEntityCopyWith(_ComplaintSlaEntity value, $Res Function(_ComplaintSlaEntity) _then) = __$ComplaintSlaEntityCopyWithImpl;
@override @useResult
$Res call({
 String stageLabel, int remainingMinutes, int progressPct, String state
});




}
/// @nodoc
class __$ComplaintSlaEntityCopyWithImpl<$Res>
    implements _$ComplaintSlaEntityCopyWith<$Res> {
  __$ComplaintSlaEntityCopyWithImpl(this._self, this._then);

  final _ComplaintSlaEntity _self;
  final $Res Function(_ComplaintSlaEntity) _then;

/// Create a copy of ComplaintSlaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stageLabel = null,Object? remainingMinutes = null,Object? progressPct = null,Object? state = null,}) {
  return _then(_ComplaintSlaEntity(
stageLabel: null == stageLabel ? _self.stageLabel : stageLabel // ignore: cast_nullable_to_non_nullable
as String,remainingMinutes: null == remainingMinutes ? _self.remainingMinutes : remainingMinutes // ignore: cast_nullable_to_non_nullable
as int,progressPct: null == progressPct ? _self.progressPct : progressPct // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ComplaintTimelineEntity {

 String get type; String get description; String get actorName; DateTime? get createdAt;
/// Create a copy of ComplaintTimelineEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintTimelineEntityCopyWith<ComplaintTimelineEntity> get copyWith => _$ComplaintTimelineEntityCopyWithImpl<ComplaintTimelineEntity>(this as ComplaintTimelineEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintTimelineEntity&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,description,actorName,createdAt);

@override
String toString() {
  return 'ComplaintTimelineEntity(type: $type, description: $description, actorName: $actorName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ComplaintTimelineEntityCopyWith<$Res>  {
  factory $ComplaintTimelineEntityCopyWith(ComplaintTimelineEntity value, $Res Function(ComplaintTimelineEntity) _then) = _$ComplaintTimelineEntityCopyWithImpl;
@useResult
$Res call({
 String type, String description, String actorName, DateTime? createdAt
});




}
/// @nodoc
class _$ComplaintTimelineEntityCopyWithImpl<$Res>
    implements $ComplaintTimelineEntityCopyWith<$Res> {
  _$ComplaintTimelineEntityCopyWithImpl(this._self, this._then);

  final ComplaintTimelineEntity _self;
  final $Res Function(ComplaintTimelineEntity) _then;

/// Create a copy of ComplaintTimelineEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? description = null,Object? actorName = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,actorName: null == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintTimelineEntity].
extension ComplaintTimelineEntityPatterns on ComplaintTimelineEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintTimelineEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintTimelineEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintTimelineEntity value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintTimelineEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintTimelineEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintTimelineEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String description,  String actorName,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintTimelineEntity() when $default != null:
return $default(_that.type,_that.description,_that.actorName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String description,  String actorName,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ComplaintTimelineEntity():
return $default(_that.type,_that.description,_that.actorName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String description,  String actorName,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintTimelineEntity() when $default != null:
return $default(_that.type,_that.description,_that.actorName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ComplaintTimelineEntity implements ComplaintTimelineEntity {
  const _ComplaintTimelineEntity({this.type = '', this.description = '', this.actorName = '', this.createdAt});
  

@override@JsonKey() final  String type;
@override@JsonKey() final  String description;
@override@JsonKey() final  String actorName;
@override final  DateTime? createdAt;

/// Create a copy of ComplaintTimelineEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintTimelineEntityCopyWith<_ComplaintTimelineEntity> get copyWith => __$ComplaintTimelineEntityCopyWithImpl<_ComplaintTimelineEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintTimelineEntity&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,description,actorName,createdAt);

@override
String toString() {
  return 'ComplaintTimelineEntity(type: $type, description: $description, actorName: $actorName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ComplaintTimelineEntityCopyWith<$Res> implements $ComplaintTimelineEntityCopyWith<$Res> {
  factory _$ComplaintTimelineEntityCopyWith(_ComplaintTimelineEntity value, $Res Function(_ComplaintTimelineEntity) _then) = __$ComplaintTimelineEntityCopyWithImpl;
@override @useResult
$Res call({
 String type, String description, String actorName, DateTime? createdAt
});




}
/// @nodoc
class __$ComplaintTimelineEntityCopyWithImpl<$Res>
    implements _$ComplaintTimelineEntityCopyWith<$Res> {
  __$ComplaintTimelineEntityCopyWithImpl(this._self, this._then);

  final _ComplaintTimelineEntity _self;
  final $Res Function(_ComplaintTimelineEntity) _then;

/// Create a copy of ComplaintTimelineEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? description = null,Object? actorName = null,Object? createdAt = freezed,}) {
  return _then(_ComplaintTimelineEntity(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,actorName: null == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ComplaintReportEntity {

 String get id; String get ticketNumber; String get title; String get description; String get status; String get statusLabel; String get category; String get address; double? get latitude; double? get longitude; DateTime? get reportedAt; List<ComplaintAttachmentEntity> get attachments; ComplaintSlaEntity? get sla; List<ComplaintTimelineEntity> get timeline;
/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintReportEntityCopyWith<ComplaintReportEntity> get copyWith => _$ComplaintReportEntityCopyWithImpl<ComplaintReportEntity>(this as ComplaintReportEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintReportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.category, category) || other.category == category)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.reportedAt, reportedAt) || other.reportedAt == reportedAt)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.sla, sla) || other.sla == sla)&&const DeepCollectionEquality().equals(other.timeline, timeline));
}


@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,title,description,status,statusLabel,category,address,latitude,longitude,reportedAt,const DeepCollectionEquality().hash(attachments),sla,const DeepCollectionEquality().hash(timeline));

@override
String toString() {
  return 'ComplaintReportEntity(id: $id, ticketNumber: $ticketNumber, title: $title, description: $description, status: $status, statusLabel: $statusLabel, category: $category, address: $address, latitude: $latitude, longitude: $longitude, reportedAt: $reportedAt, attachments: $attachments, sla: $sla, timeline: $timeline)';
}


}

/// @nodoc
abstract mixin class $ComplaintReportEntityCopyWith<$Res>  {
  factory $ComplaintReportEntityCopyWith(ComplaintReportEntity value, $Res Function(ComplaintReportEntity) _then) = _$ComplaintReportEntityCopyWithImpl;
@useResult
$Res call({
 String id, String ticketNumber, String title, String description, String status, String statusLabel, String category, String address, double? latitude, double? longitude, DateTime? reportedAt, List<ComplaintAttachmentEntity> attachments, ComplaintSlaEntity? sla, List<ComplaintTimelineEntity> timeline
});


$ComplaintSlaEntityCopyWith<$Res>? get sla;

}
/// @nodoc
class _$ComplaintReportEntityCopyWithImpl<$Res>
    implements $ComplaintReportEntityCopyWith<$Res> {
  _$ComplaintReportEntityCopyWithImpl(this._self, this._then);

  final ComplaintReportEntity _self;
  final $Res Function(ComplaintReportEntity) _then;

/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ticketNumber = null,Object? title = null,Object? description = null,Object? status = null,Object? statusLabel = null,Object? category = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,Object? reportedAt = freezed,Object? attachments = null,Object? sla = freezed,Object? timeline = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,reportedAt: freezed == reportedAt ? _self.reportedAt : reportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ComplaintAttachmentEntity>,sla: freezed == sla ? _self.sla : sla // ignore: cast_nullable_to_non_nullable
as ComplaintSlaEntity?,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<ComplaintTimelineEntity>,
  ));
}
/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintSlaEntityCopyWith<$Res>? get sla {
    if (_self.sla == null) {
    return null;
  }

  return $ComplaintSlaEntityCopyWith<$Res>(_self.sla!, (value) {
    return _then(_self.copyWith(sla: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComplaintReportEntity].
extension ComplaintReportEntityPatterns on ComplaintReportEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintReportEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintReportEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintReportEntity value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintReportEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ticketNumber,  String title,  String description,  String status,  String statusLabel,  String category,  String address,  double? latitude,  double? longitude,  DateTime? reportedAt,  List<ComplaintAttachmentEntity> attachments,  ComplaintSlaEntity? sla,  List<ComplaintTimelineEntity> timeline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintReportEntity() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.title,_that.description,_that.status,_that.statusLabel,_that.category,_that.address,_that.latitude,_that.longitude,_that.reportedAt,_that.attachments,_that.sla,_that.timeline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ticketNumber,  String title,  String description,  String status,  String statusLabel,  String category,  String address,  double? latitude,  double? longitude,  DateTime? reportedAt,  List<ComplaintAttachmentEntity> attachments,  ComplaintSlaEntity? sla,  List<ComplaintTimelineEntity> timeline)  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportEntity():
return $default(_that.id,_that.ticketNumber,_that.title,_that.description,_that.status,_that.statusLabel,_that.category,_that.address,_that.latitude,_that.longitude,_that.reportedAt,_that.attachments,_that.sla,_that.timeline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ticketNumber,  String title,  String description,  String status,  String statusLabel,  String category,  String address,  double? latitude,  double? longitude,  DateTime? reportedAt,  List<ComplaintAttachmentEntity> attachments,  ComplaintSlaEntity? sla,  List<ComplaintTimelineEntity> timeline)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportEntity() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.title,_that.description,_that.status,_that.statusLabel,_that.category,_that.address,_that.latitude,_that.longitude,_that.reportedAt,_that.attachments,_that.sla,_that.timeline);case _:
  return null;

}
}

}

/// @nodoc


class _ComplaintReportEntity extends ComplaintReportEntity {
  const _ComplaintReportEntity({this.id = '', this.ticketNumber = '', this.title = '', this.description = '', this.status = '', this.statusLabel = '', this.category = '', this.address = '', this.latitude, this.longitude, this.reportedAt, final  List<ComplaintAttachmentEntity> attachments = const [], this.sla, final  List<ComplaintTimelineEntity> timeline = const []}): _attachments = attachments,_timeline = timeline,super._();
  

@override@JsonKey() final  String id;
@override@JsonKey() final  String ticketNumber;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String status;
@override@JsonKey() final  String statusLabel;
@override@JsonKey() final  String category;
@override@JsonKey() final  String address;
@override final  double? latitude;
@override final  double? longitude;
@override final  DateTime? reportedAt;
 final  List<ComplaintAttachmentEntity> _attachments;
@override@JsonKey() List<ComplaintAttachmentEntity> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  ComplaintSlaEntity? sla;
 final  List<ComplaintTimelineEntity> _timeline;
@override@JsonKey() List<ComplaintTimelineEntity> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}


/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintReportEntityCopyWith<_ComplaintReportEntity> get copyWith => __$ComplaintReportEntityCopyWithImpl<_ComplaintReportEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintReportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.category, category) || other.category == category)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.reportedAt, reportedAt) || other.reportedAt == reportedAt)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.sla, sla) || other.sla == sla)&&const DeepCollectionEquality().equals(other._timeline, _timeline));
}


@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,title,description,status,statusLabel,category,address,latitude,longitude,reportedAt,const DeepCollectionEquality().hash(_attachments),sla,const DeepCollectionEquality().hash(_timeline));

@override
String toString() {
  return 'ComplaintReportEntity(id: $id, ticketNumber: $ticketNumber, title: $title, description: $description, status: $status, statusLabel: $statusLabel, category: $category, address: $address, latitude: $latitude, longitude: $longitude, reportedAt: $reportedAt, attachments: $attachments, sla: $sla, timeline: $timeline)';
}


}

/// @nodoc
abstract mixin class _$ComplaintReportEntityCopyWith<$Res> implements $ComplaintReportEntityCopyWith<$Res> {
  factory _$ComplaintReportEntityCopyWith(_ComplaintReportEntity value, $Res Function(_ComplaintReportEntity) _then) = __$ComplaintReportEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String ticketNumber, String title, String description, String status, String statusLabel, String category, String address, double? latitude, double? longitude, DateTime? reportedAt, List<ComplaintAttachmentEntity> attachments, ComplaintSlaEntity? sla, List<ComplaintTimelineEntity> timeline
});


@override $ComplaintSlaEntityCopyWith<$Res>? get sla;

}
/// @nodoc
class __$ComplaintReportEntityCopyWithImpl<$Res>
    implements _$ComplaintReportEntityCopyWith<$Res> {
  __$ComplaintReportEntityCopyWithImpl(this._self, this._then);

  final _ComplaintReportEntity _self;
  final $Res Function(_ComplaintReportEntity) _then;

/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ticketNumber = null,Object? title = null,Object? description = null,Object? status = null,Object? statusLabel = null,Object? category = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,Object? reportedAt = freezed,Object? attachments = null,Object? sla = freezed,Object? timeline = null,}) {
  return _then(_ComplaintReportEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,reportedAt: freezed == reportedAt ? _self.reportedAt : reportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ComplaintAttachmentEntity>,sla: freezed == sla ? _self.sla : sla // ignore: cast_nullable_to_non_nullable
as ComplaintSlaEntity?,timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<ComplaintTimelineEntity>,
  ));
}

/// Create a copy of ComplaintReportEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintSlaEntityCopyWith<$Res>? get sla {
    if (_self.sla == null) {
    return null;
  }

  return $ComplaintSlaEntityCopyWith<$Res>(_self.sla!, (value) {
    return _then(_self.copyWith(sla: value));
  });
}
}

/// @nodoc
mixin _$ComplaintPaginatedEntity {

 List<ComplaintReportEntity> get data; int get currentPage; int get lastPage; int get total;
/// Create a copy of ComplaintPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintPaginatedEntityCopyWith<ComplaintPaginatedEntity> get copyWith => _$ComplaintPaginatedEntityCopyWithImpl<ComplaintPaginatedEntity>(this as ComplaintPaginatedEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintPaginatedEntity&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),currentPage,lastPage,total);

@override
String toString() {
  return 'ComplaintPaginatedEntity(data: $data, currentPage: $currentPage, lastPage: $lastPage, total: $total)';
}


}

/// @nodoc
abstract mixin class $ComplaintPaginatedEntityCopyWith<$Res>  {
  factory $ComplaintPaginatedEntityCopyWith(ComplaintPaginatedEntity value, $Res Function(ComplaintPaginatedEntity) _then) = _$ComplaintPaginatedEntityCopyWithImpl;
@useResult
$Res call({
 List<ComplaintReportEntity> data, int currentPage, int lastPage, int total
});




}
/// @nodoc
class _$ComplaintPaginatedEntityCopyWithImpl<$Res>
    implements $ComplaintPaginatedEntityCopyWith<$Res> {
  _$ComplaintPaginatedEntityCopyWithImpl(this._self, this._then);

  final ComplaintPaginatedEntity _self;
  final $Res Function(ComplaintPaginatedEntity) _then;

/// Create a copy of ComplaintPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? currentPage = null,Object? lastPage = null,Object? total = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ComplaintReportEntity>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintPaginatedEntity].
extension ComplaintPaginatedEntityPatterns on ComplaintPaginatedEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintPaginatedEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintPaginatedEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintPaginatedEntity value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintPaginatedEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintPaginatedEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintPaginatedEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ComplaintReportEntity> data,  int currentPage,  int lastPage,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintPaginatedEntity() when $default != null:
return $default(_that.data,_that.currentPage,_that.lastPage,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ComplaintReportEntity> data,  int currentPage,  int lastPage,  int total)  $default,) {final _that = this;
switch (_that) {
case _ComplaintPaginatedEntity():
return $default(_that.data,_that.currentPage,_that.lastPage,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ComplaintReportEntity> data,  int currentPage,  int lastPage,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintPaginatedEntity() when $default != null:
return $default(_that.data,_that.currentPage,_that.lastPage,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _ComplaintPaginatedEntity implements ComplaintPaginatedEntity {
  const _ComplaintPaginatedEntity({final  List<ComplaintReportEntity> data = const [], this.currentPage = 1, this.lastPage = 1, this.total = 0}): _data = data;
  

 final  List<ComplaintReportEntity> _data;
@override@JsonKey() List<ComplaintReportEntity> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int lastPage;
@override@JsonKey() final  int total;

/// Create a copy of ComplaintPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintPaginatedEntityCopyWith<_ComplaintPaginatedEntity> get copyWith => __$ComplaintPaginatedEntityCopyWithImpl<_ComplaintPaginatedEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintPaginatedEntity&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),currentPage,lastPage,total);

@override
String toString() {
  return 'ComplaintPaginatedEntity(data: $data, currentPage: $currentPage, lastPage: $lastPage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ComplaintPaginatedEntityCopyWith<$Res> implements $ComplaintPaginatedEntityCopyWith<$Res> {
  factory _$ComplaintPaginatedEntityCopyWith(_ComplaintPaginatedEntity value, $Res Function(_ComplaintPaginatedEntity) _then) = __$ComplaintPaginatedEntityCopyWithImpl;
@override @useResult
$Res call({
 List<ComplaintReportEntity> data, int currentPage, int lastPage, int total
});




}
/// @nodoc
class __$ComplaintPaginatedEntityCopyWithImpl<$Res>
    implements _$ComplaintPaginatedEntityCopyWith<$Res> {
  __$ComplaintPaginatedEntityCopyWithImpl(this._self, this._then);

  final _ComplaintPaginatedEntity _self;
  final $Res Function(_ComplaintPaginatedEntity) _then;

/// Create a copy of ComplaintPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? currentPage = null,Object? lastPage = null,Object? total = null,}) {
  return _then(_ComplaintPaginatedEntity(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ComplaintReportEntity>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
