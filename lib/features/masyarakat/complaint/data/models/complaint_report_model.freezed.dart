// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complaint_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComplaintAttachmentModel {

@JsonKey(name: 'mime_type', readValue: _readMimeType) String get mimeType;@JsonKey(name: 'file_url', readValue: _readFileUrl) String get url;
/// Create a copy of ComplaintAttachmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintAttachmentModelCopyWith<ComplaintAttachmentModel> get copyWith => _$ComplaintAttachmentModelCopyWithImpl<ComplaintAttachmentModel>(this as ComplaintAttachmentModel, _$identity);

  /// Serializes this ComplaintAttachmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintAttachmentModel&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mimeType,url);

@override
String toString() {
  return 'ComplaintAttachmentModel(mimeType: $mimeType, url: $url)';
}


}

/// @nodoc
abstract mixin class $ComplaintAttachmentModelCopyWith<$Res>  {
  factory $ComplaintAttachmentModelCopyWith(ComplaintAttachmentModel value, $Res Function(ComplaintAttachmentModel) _then) = _$ComplaintAttachmentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mime_type', readValue: _readMimeType) String mimeType,@JsonKey(name: 'file_url', readValue: _readFileUrl) String url
});




}
/// @nodoc
class _$ComplaintAttachmentModelCopyWithImpl<$Res>
    implements $ComplaintAttachmentModelCopyWith<$Res> {
  _$ComplaintAttachmentModelCopyWithImpl(this._self, this._then);

  final ComplaintAttachmentModel _self;
  final $Res Function(ComplaintAttachmentModel) _then;

/// Create a copy of ComplaintAttachmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mimeType = null,Object? url = null,}) {
  return _then(_self.copyWith(
mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintAttachmentModel].
extension ComplaintAttachmentModelPatterns on ComplaintAttachmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintAttachmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintAttachmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintAttachmentModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintAttachmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintAttachmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintAttachmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'mime_type', readValue: _readMimeType)  String mimeType, @JsonKey(name: 'file_url', readValue: _readFileUrl)  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintAttachmentModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'mime_type', readValue: _readMimeType)  String mimeType, @JsonKey(name: 'file_url', readValue: _readFileUrl)  String url)  $default,) {final _that = this;
switch (_that) {
case _ComplaintAttachmentModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'mime_type', readValue: _readMimeType)  String mimeType, @JsonKey(name: 'file_url', readValue: _readFileUrl)  String url)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintAttachmentModel() when $default != null:
return $default(_that.mimeType,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintAttachmentModel implements ComplaintAttachmentModel {
  const _ComplaintAttachmentModel({@JsonKey(name: 'mime_type', readValue: _readMimeType) this.mimeType = '', @JsonKey(name: 'file_url', readValue: _readFileUrl) this.url = ''});
  factory _ComplaintAttachmentModel.fromJson(Map<String, dynamic> json) => _$ComplaintAttachmentModelFromJson(json);

@override@JsonKey(name: 'mime_type', readValue: _readMimeType) final  String mimeType;
@override@JsonKey(name: 'file_url', readValue: _readFileUrl) final  String url;

/// Create a copy of ComplaintAttachmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintAttachmentModelCopyWith<_ComplaintAttachmentModel> get copyWith => __$ComplaintAttachmentModelCopyWithImpl<_ComplaintAttachmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintAttachmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintAttachmentModel&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mimeType,url);

@override
String toString() {
  return 'ComplaintAttachmentModel(mimeType: $mimeType, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ComplaintAttachmentModelCopyWith<$Res> implements $ComplaintAttachmentModelCopyWith<$Res> {
  factory _$ComplaintAttachmentModelCopyWith(_ComplaintAttachmentModel value, $Res Function(_ComplaintAttachmentModel) _then) = __$ComplaintAttachmentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mime_type', readValue: _readMimeType) String mimeType,@JsonKey(name: 'file_url', readValue: _readFileUrl) String url
});




}
/// @nodoc
class __$ComplaintAttachmentModelCopyWithImpl<$Res>
    implements _$ComplaintAttachmentModelCopyWith<$Res> {
  __$ComplaintAttachmentModelCopyWithImpl(this._self, this._then);

  final _ComplaintAttachmentModel _self;
  final $Res Function(_ComplaintAttachmentModel) _then;

/// Create a copy of ComplaintAttachmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mimeType = null,Object? url = null,}) {
  return _then(_ComplaintAttachmentModel(
mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ComplaintSlaModel {

 String get stageLabel; num? get remainingMinutes; num? get progressPct; String get state;
/// Create a copy of ComplaintSlaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintSlaModelCopyWith<ComplaintSlaModel> get copyWith => _$ComplaintSlaModelCopyWithImpl<ComplaintSlaModel>(this as ComplaintSlaModel, _$identity);

  /// Serializes this ComplaintSlaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintSlaModel&&(identical(other.stageLabel, stageLabel) || other.stageLabel == stageLabel)&&(identical(other.remainingMinutes, remainingMinutes) || other.remainingMinutes == remainingMinutes)&&(identical(other.progressPct, progressPct) || other.progressPct == progressPct)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stageLabel,remainingMinutes,progressPct,state);

@override
String toString() {
  return 'ComplaintSlaModel(stageLabel: $stageLabel, remainingMinutes: $remainingMinutes, progressPct: $progressPct, state: $state)';
}


}

/// @nodoc
abstract mixin class $ComplaintSlaModelCopyWith<$Res>  {
  factory $ComplaintSlaModelCopyWith(ComplaintSlaModel value, $Res Function(ComplaintSlaModel) _then) = _$ComplaintSlaModelCopyWithImpl;
@useResult
$Res call({
 String stageLabel, num? remainingMinutes, num? progressPct, String state
});




}
/// @nodoc
class _$ComplaintSlaModelCopyWithImpl<$Res>
    implements $ComplaintSlaModelCopyWith<$Res> {
  _$ComplaintSlaModelCopyWithImpl(this._self, this._then);

  final ComplaintSlaModel _self;
  final $Res Function(ComplaintSlaModel) _then;

/// Create a copy of ComplaintSlaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stageLabel = null,Object? remainingMinutes = freezed,Object? progressPct = freezed,Object? state = null,}) {
  return _then(_self.copyWith(
stageLabel: null == stageLabel ? _self.stageLabel : stageLabel // ignore: cast_nullable_to_non_nullable
as String,remainingMinutes: freezed == remainingMinutes ? _self.remainingMinutes : remainingMinutes // ignore: cast_nullable_to_non_nullable
as num?,progressPct: freezed == progressPct ? _self.progressPct : progressPct // ignore: cast_nullable_to_non_nullable
as num?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintSlaModel].
extension ComplaintSlaModelPatterns on ComplaintSlaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintSlaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintSlaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintSlaModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintSlaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintSlaModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintSlaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stageLabel,  num? remainingMinutes,  num? progressPct,  String state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintSlaModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stageLabel,  num? remainingMinutes,  num? progressPct,  String state)  $default,) {final _that = this;
switch (_that) {
case _ComplaintSlaModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stageLabel,  num? remainingMinutes,  num? progressPct,  String state)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintSlaModel() when $default != null:
return $default(_that.stageLabel,_that.remainingMinutes,_that.progressPct,_that.state);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintSlaModel implements ComplaintSlaModel {
  const _ComplaintSlaModel({this.stageLabel = '', this.remainingMinutes, this.progressPct, this.state = ''});
  factory _ComplaintSlaModel.fromJson(Map<String, dynamic> json) => _$ComplaintSlaModelFromJson(json);

@override@JsonKey() final  String stageLabel;
@override final  num? remainingMinutes;
@override final  num? progressPct;
@override@JsonKey() final  String state;

/// Create a copy of ComplaintSlaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintSlaModelCopyWith<_ComplaintSlaModel> get copyWith => __$ComplaintSlaModelCopyWithImpl<_ComplaintSlaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintSlaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintSlaModel&&(identical(other.stageLabel, stageLabel) || other.stageLabel == stageLabel)&&(identical(other.remainingMinutes, remainingMinutes) || other.remainingMinutes == remainingMinutes)&&(identical(other.progressPct, progressPct) || other.progressPct == progressPct)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stageLabel,remainingMinutes,progressPct,state);

@override
String toString() {
  return 'ComplaintSlaModel(stageLabel: $stageLabel, remainingMinutes: $remainingMinutes, progressPct: $progressPct, state: $state)';
}


}

/// @nodoc
abstract mixin class _$ComplaintSlaModelCopyWith<$Res> implements $ComplaintSlaModelCopyWith<$Res> {
  factory _$ComplaintSlaModelCopyWith(_ComplaintSlaModel value, $Res Function(_ComplaintSlaModel) _then) = __$ComplaintSlaModelCopyWithImpl;
@override @useResult
$Res call({
 String stageLabel, num? remainingMinutes, num? progressPct, String state
});




}
/// @nodoc
class __$ComplaintSlaModelCopyWithImpl<$Res>
    implements _$ComplaintSlaModelCopyWith<$Res> {
  __$ComplaintSlaModelCopyWithImpl(this._self, this._then);

  final _ComplaintSlaModel _self;
  final $Res Function(_ComplaintSlaModel) _then;

/// Create a copy of ComplaintSlaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stageLabel = null,Object? remainingMinutes = freezed,Object? progressPct = freezed,Object? state = null,}) {
  return _then(_ComplaintSlaModel(
stageLabel: null == stageLabel ? _self.stageLabel : stageLabel // ignore: cast_nullable_to_non_nullable
as String,remainingMinutes: freezed == remainingMinutes ? _self.remainingMinutes : remainingMinutes // ignore: cast_nullable_to_non_nullable
as num?,progressPct: freezed == progressPct ? _self.progressPct : progressPct // ignore: cast_nullable_to_non_nullable
as num?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ComplaintActorModel {

 String get name;
/// Create a copy of ComplaintActorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintActorModelCopyWith<ComplaintActorModel> get copyWith => _$ComplaintActorModelCopyWithImpl<ComplaintActorModel>(this as ComplaintActorModel, _$identity);

  /// Serializes this ComplaintActorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintActorModel&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ComplaintActorModel(name: $name)';
}


}

/// @nodoc
abstract mixin class $ComplaintActorModelCopyWith<$Res>  {
  factory $ComplaintActorModelCopyWith(ComplaintActorModel value, $Res Function(ComplaintActorModel) _then) = _$ComplaintActorModelCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$ComplaintActorModelCopyWithImpl<$Res>
    implements $ComplaintActorModelCopyWith<$Res> {
  _$ComplaintActorModelCopyWithImpl(this._self, this._then);

  final ComplaintActorModel _self;
  final $Res Function(ComplaintActorModel) _then;

/// Create a copy of ComplaintActorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintActorModel].
extension ComplaintActorModelPatterns on ComplaintActorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintActorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintActorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintActorModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintActorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintActorModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintActorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintActorModel() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _ComplaintActorModel():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintActorModel() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintActorModel implements ComplaintActorModel {
  const _ComplaintActorModel({this.name = ''});
  factory _ComplaintActorModel.fromJson(Map<String, dynamic> json) => _$ComplaintActorModelFromJson(json);

@override@JsonKey() final  String name;

/// Create a copy of ComplaintActorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintActorModelCopyWith<_ComplaintActorModel> get copyWith => __$ComplaintActorModelCopyWithImpl<_ComplaintActorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintActorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintActorModel&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ComplaintActorModel(name: $name)';
}


}

/// @nodoc
abstract mixin class _$ComplaintActorModelCopyWith<$Res> implements $ComplaintActorModelCopyWith<$Res> {
  factory _$ComplaintActorModelCopyWith(_ComplaintActorModel value, $Res Function(_ComplaintActorModel) _then) = __$ComplaintActorModelCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$ComplaintActorModelCopyWithImpl<$Res>
    implements _$ComplaintActorModelCopyWith<$Res> {
  __$ComplaintActorModelCopyWithImpl(this._self, this._then);

  final _ComplaintActorModel _self;
  final $Res Function(_ComplaintActorModel) _then;

/// Create a copy of ComplaintActorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_ComplaintActorModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ComplaintTimelineModel {

 String get type; String get description; ComplaintActorModel? get actor; DateTime? get createdAt;
/// Create a copy of ComplaintTimelineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintTimelineModelCopyWith<ComplaintTimelineModel> get copyWith => _$ComplaintTimelineModelCopyWithImpl<ComplaintTimelineModel>(this as ComplaintTimelineModel, _$identity);

  /// Serializes this ComplaintTimelineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintTimelineModel&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,description,actor,createdAt);

@override
String toString() {
  return 'ComplaintTimelineModel(type: $type, description: $description, actor: $actor, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ComplaintTimelineModelCopyWith<$Res>  {
  factory $ComplaintTimelineModelCopyWith(ComplaintTimelineModel value, $Res Function(ComplaintTimelineModel) _then) = _$ComplaintTimelineModelCopyWithImpl;
@useResult
$Res call({
 String type, String description, ComplaintActorModel? actor, DateTime? createdAt
});


$ComplaintActorModelCopyWith<$Res>? get actor;

}
/// @nodoc
class _$ComplaintTimelineModelCopyWithImpl<$Res>
    implements $ComplaintTimelineModelCopyWith<$Res> {
  _$ComplaintTimelineModelCopyWithImpl(this._self, this._then);

  final ComplaintTimelineModel _self;
  final $Res Function(ComplaintTimelineModel) _then;

/// Create a copy of ComplaintTimelineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? description = null,Object? actor = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as ComplaintActorModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ComplaintTimelineModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintActorModelCopyWith<$Res>? get actor {
    if (_self.actor == null) {
    return null;
  }

  return $ComplaintActorModelCopyWith<$Res>(_self.actor!, (value) {
    return _then(_self.copyWith(actor: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComplaintTimelineModel].
extension ComplaintTimelineModelPatterns on ComplaintTimelineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintTimelineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintTimelineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintTimelineModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintTimelineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintTimelineModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintTimelineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String description,  ComplaintActorModel? actor,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintTimelineModel() when $default != null:
return $default(_that.type,_that.description,_that.actor,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String description,  ComplaintActorModel? actor,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ComplaintTimelineModel():
return $default(_that.type,_that.description,_that.actor,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String description,  ComplaintActorModel? actor,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintTimelineModel() when $default != null:
return $default(_that.type,_that.description,_that.actor,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintTimelineModel implements ComplaintTimelineModel {
  const _ComplaintTimelineModel({this.type = '', this.description = '', this.actor, this.createdAt});
  factory _ComplaintTimelineModel.fromJson(Map<String, dynamic> json) => _$ComplaintTimelineModelFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey() final  String description;
@override final  ComplaintActorModel? actor;
@override final  DateTime? createdAt;

/// Create a copy of ComplaintTimelineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintTimelineModelCopyWith<_ComplaintTimelineModel> get copyWith => __$ComplaintTimelineModelCopyWithImpl<_ComplaintTimelineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintTimelineModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintTimelineModel&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,description,actor,createdAt);

@override
String toString() {
  return 'ComplaintTimelineModel(type: $type, description: $description, actor: $actor, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ComplaintTimelineModelCopyWith<$Res> implements $ComplaintTimelineModelCopyWith<$Res> {
  factory _$ComplaintTimelineModelCopyWith(_ComplaintTimelineModel value, $Res Function(_ComplaintTimelineModel) _then) = __$ComplaintTimelineModelCopyWithImpl;
@override @useResult
$Res call({
 String type, String description, ComplaintActorModel? actor, DateTime? createdAt
});


@override $ComplaintActorModelCopyWith<$Res>? get actor;

}
/// @nodoc
class __$ComplaintTimelineModelCopyWithImpl<$Res>
    implements _$ComplaintTimelineModelCopyWith<$Res> {
  __$ComplaintTimelineModelCopyWithImpl(this._self, this._then);

  final _ComplaintTimelineModel _self;
  final $Res Function(_ComplaintTimelineModel) _then;

/// Create a copy of ComplaintTimelineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? description = null,Object? actor = freezed,Object? createdAt = freezed,}) {
  return _then(_ComplaintTimelineModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as ComplaintActorModel?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ComplaintTimelineModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintActorModelCopyWith<$Res>? get actor {
    if (_self.actor == null) {
    return null;
  }

  return $ComplaintActorModelCopyWith<$Res>(_self.actor!, (value) {
    return _then(_self.copyWith(actor: value));
  });
}
}


/// @nodoc
mixin _$ComplaintReportModel {

 int? get id;@JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) String get ticketNumber; String get title; String get description; String get status;@JsonKey(name: 'statusLabel', readValue: _readStatusLabel) String get statusLabel;@JsonKey(name: 'category', readValue: _readCategory) String get category; String get address; num? get latitude; num? get longitude; DateTime? get reportedAt; DateTime? get updatedAt; List<ComplaintAttachmentModel> get attachments; ComplaintSlaModel? get sla; List<ComplaintTimelineModel> get timeline;
/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintReportModelCopyWith<ComplaintReportModel> get copyWith => _$ComplaintReportModelCopyWithImpl<ComplaintReportModel>(this as ComplaintReportModel, _$identity);

  /// Serializes this ComplaintReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.category, category) || other.category == category)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.reportedAt, reportedAt) || other.reportedAt == reportedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.sla, sla) || other.sla == sla)&&const DeepCollectionEquality().equals(other.timeline, timeline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,title,description,status,statusLabel,category,address,latitude,longitude,reportedAt,updatedAt,const DeepCollectionEquality().hash(attachments),sla,const DeepCollectionEquality().hash(timeline));

@override
String toString() {
  return 'ComplaintReportModel(id: $id, ticketNumber: $ticketNumber, title: $title, description: $description, status: $status, statusLabel: $statusLabel, category: $category, address: $address, latitude: $latitude, longitude: $longitude, reportedAt: $reportedAt, updatedAt: $updatedAt, attachments: $attachments, sla: $sla, timeline: $timeline)';
}


}

/// @nodoc
abstract mixin class $ComplaintReportModelCopyWith<$Res>  {
  factory $ComplaintReportModelCopyWith(ComplaintReportModel value, $Res Function(ComplaintReportModel) _then) = _$ComplaintReportModelCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) String ticketNumber, String title, String description, String status,@JsonKey(name: 'statusLabel', readValue: _readStatusLabel) String statusLabel,@JsonKey(name: 'category', readValue: _readCategory) String category, String address, num? latitude, num? longitude, DateTime? reportedAt, DateTime? updatedAt, List<ComplaintAttachmentModel> attachments, ComplaintSlaModel? sla, List<ComplaintTimelineModel> timeline
});


$ComplaintSlaModelCopyWith<$Res>? get sla;

}
/// @nodoc
class _$ComplaintReportModelCopyWithImpl<$Res>
    implements $ComplaintReportModelCopyWith<$Res> {
  _$ComplaintReportModelCopyWithImpl(this._self, this._then);

  final ComplaintReportModel _self;
  final $Res Function(ComplaintReportModel) _then;

/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? ticketNumber = null,Object? title = null,Object? description = null,Object? status = null,Object? statusLabel = null,Object? category = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,Object? reportedAt = freezed,Object? updatedAt = freezed,Object? attachments = null,Object? sla = freezed,Object? timeline = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,reportedAt: freezed == reportedAt ? _self.reportedAt : reportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ComplaintAttachmentModel>,sla: freezed == sla ? _self.sla : sla // ignore: cast_nullable_to_non_nullable
as ComplaintSlaModel?,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<ComplaintTimelineModel>,
  ));
}
/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintSlaModelCopyWith<$Res>? get sla {
    if (_self.sla == null) {
    return null;
  }

  return $ComplaintSlaModelCopyWith<$Res>(_self.sla!, (value) {
    return _then(_self.copyWith(sla: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComplaintReportModel].
extension ComplaintReportModelPatterns on ComplaintReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintReportModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber)  String ticketNumber,  String title,  String description,  String status, @JsonKey(name: 'statusLabel', readValue: _readStatusLabel)  String statusLabel, @JsonKey(name: 'category', readValue: _readCategory)  String category,  String address,  num? latitude,  num? longitude,  DateTime? reportedAt,  DateTime? updatedAt,  List<ComplaintAttachmentModel> attachments,  ComplaintSlaModel? sla,  List<ComplaintTimelineModel> timeline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintReportModel() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.title,_that.description,_that.status,_that.statusLabel,_that.category,_that.address,_that.latitude,_that.longitude,_that.reportedAt,_that.updatedAt,_that.attachments,_that.sla,_that.timeline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber)  String ticketNumber,  String title,  String description,  String status, @JsonKey(name: 'statusLabel', readValue: _readStatusLabel)  String statusLabel, @JsonKey(name: 'category', readValue: _readCategory)  String category,  String address,  num? latitude,  num? longitude,  DateTime? reportedAt,  DateTime? updatedAt,  List<ComplaintAttachmentModel> attachments,  ComplaintSlaModel? sla,  List<ComplaintTimelineModel> timeline)  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportModel():
return $default(_that.id,_that.ticketNumber,_that.title,_that.description,_that.status,_that.statusLabel,_that.category,_that.address,_that.latitude,_that.longitude,_that.reportedAt,_that.updatedAt,_that.attachments,_that.sla,_that.timeline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber)  String ticketNumber,  String title,  String description,  String status, @JsonKey(name: 'statusLabel', readValue: _readStatusLabel)  String statusLabel, @JsonKey(name: 'category', readValue: _readCategory)  String category,  String address,  num? latitude,  num? longitude,  DateTime? reportedAt,  DateTime? updatedAt,  List<ComplaintAttachmentModel> attachments,  ComplaintSlaModel? sla,  List<ComplaintTimelineModel> timeline)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportModel() when $default != null:
return $default(_that.id,_that.ticketNumber,_that.title,_that.description,_that.status,_that.statusLabel,_that.category,_that.address,_that.latitude,_that.longitude,_that.reportedAt,_that.updatedAt,_that.attachments,_that.sla,_that.timeline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintReportModel extends ComplaintReportModel {
  const _ComplaintReportModel({this.id, @JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) this.ticketNumber = '', this.title = '', this.description = '', this.status = '', @JsonKey(name: 'statusLabel', readValue: _readStatusLabel) this.statusLabel = '', @JsonKey(name: 'category', readValue: _readCategory) this.category = '', this.address = '', this.latitude, this.longitude, this.reportedAt, this.updatedAt, final  List<ComplaintAttachmentModel> attachments = const [], this.sla, final  List<ComplaintTimelineModel> timeline = const []}): _attachments = attachments,_timeline = timeline,super._();
  factory _ComplaintReportModel.fromJson(Map<String, dynamic> json) => _$ComplaintReportModelFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) final  String ticketNumber;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'statusLabel', readValue: _readStatusLabel) final  String statusLabel;
@override@JsonKey(name: 'category', readValue: _readCategory) final  String category;
@override@JsonKey() final  String address;
@override final  num? latitude;
@override final  num? longitude;
@override final  DateTime? reportedAt;
@override final  DateTime? updatedAt;
 final  List<ComplaintAttachmentModel> _attachments;
@override@JsonKey() List<ComplaintAttachmentModel> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  ComplaintSlaModel? sla;
 final  List<ComplaintTimelineModel> _timeline;
@override@JsonKey() List<ComplaintTimelineModel> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}


/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintReportModelCopyWith<_ComplaintReportModel> get copyWith => __$ComplaintReportModelCopyWithImpl<_ComplaintReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.category, category) || other.category == category)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.reportedAt, reportedAt) || other.reportedAt == reportedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.sla, sla) || other.sla == sla)&&const DeepCollectionEquality().equals(other._timeline, _timeline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ticketNumber,title,description,status,statusLabel,category,address,latitude,longitude,reportedAt,updatedAt,const DeepCollectionEquality().hash(_attachments),sla,const DeepCollectionEquality().hash(_timeline));

@override
String toString() {
  return 'ComplaintReportModel(id: $id, ticketNumber: $ticketNumber, title: $title, description: $description, status: $status, statusLabel: $statusLabel, category: $category, address: $address, latitude: $latitude, longitude: $longitude, reportedAt: $reportedAt, updatedAt: $updatedAt, attachments: $attachments, sla: $sla, timeline: $timeline)';
}


}

/// @nodoc
abstract mixin class _$ComplaintReportModelCopyWith<$Res> implements $ComplaintReportModelCopyWith<$Res> {
  factory _$ComplaintReportModelCopyWith(_ComplaintReportModel value, $Res Function(_ComplaintReportModel) _then) = __$ComplaintReportModelCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'ticketNumber', readValue: _readTicketNumber) String ticketNumber, String title, String description, String status,@JsonKey(name: 'statusLabel', readValue: _readStatusLabel) String statusLabel,@JsonKey(name: 'category', readValue: _readCategory) String category, String address, num? latitude, num? longitude, DateTime? reportedAt, DateTime? updatedAt, List<ComplaintAttachmentModel> attachments, ComplaintSlaModel? sla, List<ComplaintTimelineModel> timeline
});


@override $ComplaintSlaModelCopyWith<$Res>? get sla;

}
/// @nodoc
class __$ComplaintReportModelCopyWithImpl<$Res>
    implements _$ComplaintReportModelCopyWith<$Res> {
  __$ComplaintReportModelCopyWithImpl(this._self, this._then);

  final _ComplaintReportModel _self;
  final $Res Function(_ComplaintReportModel) _then;

/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? ticketNumber = null,Object? title = null,Object? description = null,Object? status = null,Object? statusLabel = null,Object? category = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,Object? reportedAt = freezed,Object? updatedAt = freezed,Object? attachments = null,Object? sla = freezed,Object? timeline = null,}) {
  return _then(_ComplaintReportModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,ticketNumber: null == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,reportedAt: freezed == reportedAt ? _self.reportedAt : reportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ComplaintAttachmentModel>,sla: freezed == sla ? _self.sla : sla // ignore: cast_nullable_to_non_nullable
as ComplaintSlaModel?,timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<ComplaintTimelineModel>,
  ));
}

/// Create a copy of ComplaintReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintSlaModelCopyWith<$Res>? get sla {
    if (_self.sla == null) {
    return null;
  }

  return $ComplaintSlaModelCopyWith<$Res>(_self.sla!, (value) {
    return _then(_self.copyWith(sla: value));
  });
}
}


/// @nodoc
mixin _$ComplaintLocationModel {

 String get address; String? get village; String? get district; String? get regency; String? get province; num? get latitude; num? get longitude;
/// Create a copy of ComplaintLocationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintLocationModelCopyWith<ComplaintLocationModel> get copyWith => _$ComplaintLocationModelCopyWithImpl<ComplaintLocationModel>(this as ComplaintLocationModel, _$identity);

  /// Serializes this ComplaintLocationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintLocationModel&&(identical(other.address, address) || other.address == address)&&(identical(other.village, village) || other.village == village)&&(identical(other.district, district) || other.district == district)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.province, province) || other.province == province)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,village,district,regency,province,latitude,longitude);

@override
String toString() {
  return 'ComplaintLocationModel(address: $address, village: $village, district: $district, regency: $regency, province: $province, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $ComplaintLocationModelCopyWith<$Res>  {
  factory $ComplaintLocationModelCopyWith(ComplaintLocationModel value, $Res Function(ComplaintLocationModel) _then) = _$ComplaintLocationModelCopyWithImpl;
@useResult
$Res call({
 String address, String? village, String? district, String? regency, String? province, num? latitude, num? longitude
});




}
/// @nodoc
class _$ComplaintLocationModelCopyWithImpl<$Res>
    implements $ComplaintLocationModelCopyWith<$Res> {
  _$ComplaintLocationModelCopyWithImpl(this._self, this._then);

  final ComplaintLocationModel _self;
  final $Res Function(ComplaintLocationModel) _then;

/// Create a copy of ComplaintLocationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? village = freezed,Object? district = freezed,Object? regency = freezed,Object? province = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_self.copyWith(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplaintLocationModel].
extension ComplaintLocationModelPatterns on ComplaintLocationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintLocationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintLocationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintLocationModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintLocationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintLocationModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintLocationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String address,  String? village,  String? district,  String? regency,  String? province,  num? latitude,  num? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintLocationModel() when $default != null:
return $default(_that.address,_that.village,_that.district,_that.regency,_that.province,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String address,  String? village,  String? district,  String? regency,  String? province,  num? latitude,  num? longitude)  $default,) {final _that = this;
switch (_that) {
case _ComplaintLocationModel():
return $default(_that.address,_that.village,_that.district,_that.regency,_that.province,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String address,  String? village,  String? district,  String? regency,  String? province,  num? latitude,  num? longitude)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintLocationModel() when $default != null:
return $default(_that.address,_that.village,_that.district,_that.regency,_that.province,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintLocationModel implements ComplaintLocationModel {
  const _ComplaintLocationModel({this.address = '', this.village, this.district, this.regency, this.province, this.latitude, this.longitude});
  factory _ComplaintLocationModel.fromJson(Map<String, dynamic> json) => _$ComplaintLocationModelFromJson(json);

@override@JsonKey() final  String address;
@override final  String? village;
@override final  String? district;
@override final  String? regency;
@override final  String? province;
@override final  num? latitude;
@override final  num? longitude;

/// Create a copy of ComplaintLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintLocationModelCopyWith<_ComplaintLocationModel> get copyWith => __$ComplaintLocationModelCopyWithImpl<_ComplaintLocationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintLocationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintLocationModel&&(identical(other.address, address) || other.address == address)&&(identical(other.village, village) || other.village == village)&&(identical(other.district, district) || other.district == district)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.province, province) || other.province == province)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,village,district,regency,province,latitude,longitude);

@override
String toString() {
  return 'ComplaintLocationModel(address: $address, village: $village, district: $district, regency: $regency, province: $province, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$ComplaintLocationModelCopyWith<$Res> implements $ComplaintLocationModelCopyWith<$Res> {
  factory _$ComplaintLocationModelCopyWith(_ComplaintLocationModel value, $Res Function(_ComplaintLocationModel) _then) = __$ComplaintLocationModelCopyWithImpl;
@override @useResult
$Res call({
 String address, String? village, String? district, String? regency, String? province, num? latitude, num? longitude
});




}
/// @nodoc
class __$ComplaintLocationModelCopyWithImpl<$Res>
    implements _$ComplaintLocationModelCopyWith<$Res> {
  __$ComplaintLocationModelCopyWithImpl(this._self, this._then);

  final _ComplaintLocationModel _self;
  final $Res Function(_ComplaintLocationModel) _then;

/// Create a copy of ComplaintLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? village = freezed,Object? district = freezed,Object? regency = freezed,Object? province = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_ComplaintLocationModel(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,village: freezed == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$ComplaintReportDetailModel {

 ComplaintReportModel get complaint; ComplaintLocationModel? get location; List<ComplaintAttachmentModel> get attachments; ComplaintSlaModel? get sla; List<ComplaintTimelineModel> get timeline;
/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintReportDetailModelCopyWith<ComplaintReportDetailModel> get copyWith => _$ComplaintReportDetailModelCopyWithImpl<ComplaintReportDetailModel>(this as ComplaintReportDetailModel, _$identity);

  /// Serializes this ComplaintReportDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintReportDetailModel&&(identical(other.complaint, complaint) || other.complaint == complaint)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.sla, sla) || other.sla == sla)&&const DeepCollectionEquality().equals(other.timeline, timeline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,complaint,location,const DeepCollectionEquality().hash(attachments),sla,const DeepCollectionEquality().hash(timeline));

@override
String toString() {
  return 'ComplaintReportDetailModel(complaint: $complaint, location: $location, attachments: $attachments, sla: $sla, timeline: $timeline)';
}


}

/// @nodoc
abstract mixin class $ComplaintReportDetailModelCopyWith<$Res>  {
  factory $ComplaintReportDetailModelCopyWith(ComplaintReportDetailModel value, $Res Function(ComplaintReportDetailModel) _then) = _$ComplaintReportDetailModelCopyWithImpl;
@useResult
$Res call({
 ComplaintReportModel complaint, ComplaintLocationModel? location, List<ComplaintAttachmentModel> attachments, ComplaintSlaModel? sla, List<ComplaintTimelineModel> timeline
});


$ComplaintReportModelCopyWith<$Res> get complaint;$ComplaintLocationModelCopyWith<$Res>? get location;$ComplaintSlaModelCopyWith<$Res>? get sla;

}
/// @nodoc
class _$ComplaintReportDetailModelCopyWithImpl<$Res>
    implements $ComplaintReportDetailModelCopyWith<$Res> {
  _$ComplaintReportDetailModelCopyWithImpl(this._self, this._then);

  final ComplaintReportDetailModel _self;
  final $Res Function(ComplaintReportDetailModel) _then;

/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? complaint = null,Object? location = freezed,Object? attachments = null,Object? sla = freezed,Object? timeline = null,}) {
  return _then(_self.copyWith(
complaint: null == complaint ? _self.complaint : complaint // ignore: cast_nullable_to_non_nullable
as ComplaintReportModel,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as ComplaintLocationModel?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ComplaintAttachmentModel>,sla: freezed == sla ? _self.sla : sla // ignore: cast_nullable_to_non_nullable
as ComplaintSlaModel?,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<ComplaintTimelineModel>,
  ));
}
/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintReportModelCopyWith<$Res> get complaint {
  
  return $ComplaintReportModelCopyWith<$Res>(_self.complaint, (value) {
    return _then(_self.copyWith(complaint: value));
  });
}/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintLocationModelCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $ComplaintLocationModelCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintSlaModelCopyWith<$Res>? get sla {
    if (_self.sla == null) {
    return null;
  }

  return $ComplaintSlaModelCopyWith<$Res>(_self.sla!, (value) {
    return _then(_self.copyWith(sla: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComplaintReportDetailModel].
extension ComplaintReportDetailModelPatterns on ComplaintReportDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintReportDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintReportDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintReportDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintReportDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintReportDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ComplaintReportModel complaint,  ComplaintLocationModel? location,  List<ComplaintAttachmentModel> attachments,  ComplaintSlaModel? sla,  List<ComplaintTimelineModel> timeline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintReportDetailModel() when $default != null:
return $default(_that.complaint,_that.location,_that.attachments,_that.sla,_that.timeline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ComplaintReportModel complaint,  ComplaintLocationModel? location,  List<ComplaintAttachmentModel> attachments,  ComplaintSlaModel? sla,  List<ComplaintTimelineModel> timeline)  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportDetailModel():
return $default(_that.complaint,_that.location,_that.attachments,_that.sla,_that.timeline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ComplaintReportModel complaint,  ComplaintLocationModel? location,  List<ComplaintAttachmentModel> attachments,  ComplaintSlaModel? sla,  List<ComplaintTimelineModel> timeline)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintReportDetailModel() when $default != null:
return $default(_that.complaint,_that.location,_that.attachments,_that.sla,_that.timeline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintReportDetailModel implements ComplaintReportDetailModel {
  const _ComplaintReportDetailModel({this.complaint = const ComplaintReportModel(), this.location, final  List<ComplaintAttachmentModel> attachments = const [], this.sla, final  List<ComplaintTimelineModel> timeline = const []}): _attachments = attachments,_timeline = timeline;
  factory _ComplaintReportDetailModel.fromJson(Map<String, dynamic> json) => _$ComplaintReportDetailModelFromJson(json);

@override@JsonKey() final  ComplaintReportModel complaint;
@override final  ComplaintLocationModel? location;
 final  List<ComplaintAttachmentModel> _attachments;
@override@JsonKey() List<ComplaintAttachmentModel> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  ComplaintSlaModel? sla;
 final  List<ComplaintTimelineModel> _timeline;
@override@JsonKey() List<ComplaintTimelineModel> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}


/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintReportDetailModelCopyWith<_ComplaintReportDetailModel> get copyWith => __$ComplaintReportDetailModelCopyWithImpl<_ComplaintReportDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintReportDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintReportDetailModel&&(identical(other.complaint, complaint) || other.complaint == complaint)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.sla, sla) || other.sla == sla)&&const DeepCollectionEquality().equals(other._timeline, _timeline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,complaint,location,const DeepCollectionEquality().hash(_attachments),sla,const DeepCollectionEquality().hash(_timeline));

@override
String toString() {
  return 'ComplaintReportDetailModel(complaint: $complaint, location: $location, attachments: $attachments, sla: $sla, timeline: $timeline)';
}


}

/// @nodoc
abstract mixin class _$ComplaintReportDetailModelCopyWith<$Res> implements $ComplaintReportDetailModelCopyWith<$Res> {
  factory _$ComplaintReportDetailModelCopyWith(_ComplaintReportDetailModel value, $Res Function(_ComplaintReportDetailModel) _then) = __$ComplaintReportDetailModelCopyWithImpl;
@override @useResult
$Res call({
 ComplaintReportModel complaint, ComplaintLocationModel? location, List<ComplaintAttachmentModel> attachments, ComplaintSlaModel? sla, List<ComplaintTimelineModel> timeline
});


@override $ComplaintReportModelCopyWith<$Res> get complaint;@override $ComplaintLocationModelCopyWith<$Res>? get location;@override $ComplaintSlaModelCopyWith<$Res>? get sla;

}
/// @nodoc
class __$ComplaintReportDetailModelCopyWithImpl<$Res>
    implements _$ComplaintReportDetailModelCopyWith<$Res> {
  __$ComplaintReportDetailModelCopyWithImpl(this._self, this._then);

  final _ComplaintReportDetailModel _self;
  final $Res Function(_ComplaintReportDetailModel) _then;

/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? complaint = null,Object? location = freezed,Object? attachments = null,Object? sla = freezed,Object? timeline = null,}) {
  return _then(_ComplaintReportDetailModel(
complaint: null == complaint ? _self.complaint : complaint // ignore: cast_nullable_to_non_nullable
as ComplaintReportModel,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as ComplaintLocationModel?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ComplaintAttachmentModel>,sla: freezed == sla ? _self.sla : sla // ignore: cast_nullable_to_non_nullable
as ComplaintSlaModel?,timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<ComplaintTimelineModel>,
  ));
}

/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintReportModelCopyWith<$Res> get complaint {
  
  return $ComplaintReportModelCopyWith<$Res>(_self.complaint, (value) {
    return _then(_self.copyWith(complaint: value));
  });
}/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintLocationModelCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $ComplaintLocationModelCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of ComplaintReportDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintSlaModelCopyWith<$Res>? get sla {
    if (_self.sla == null) {
    return null;
  }

  return $ComplaintSlaModelCopyWith<$Res>(_self.sla!, (value) {
    return _then(_self.copyWith(sla: value));
  });
}
}


/// @nodoc
mixin _$ComplaintMetaModel {

@JsonKey(name: 'current_page') int get currentPage;@JsonKey(name: 'last_page') int get lastPage;@JsonKey(name: 'per_page') int get perPage; int get total;
/// Create a copy of ComplaintMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintMetaModelCopyWith<ComplaintMetaModel> get copyWith => _$ComplaintMetaModelCopyWithImpl<ComplaintMetaModel>(this as ComplaintMetaModel, _$identity);

  /// Serializes this ComplaintMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'ComplaintMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class $ComplaintMetaModelCopyWith<$Res>  {
  factory $ComplaintMetaModelCopyWith(ComplaintMetaModel value, $Res Function(ComplaintMetaModel) _then) = _$ComplaintMetaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage, int total
});




}
/// @nodoc
class _$ComplaintMetaModelCopyWithImpl<$Res>
    implements $ComplaintMetaModelCopyWith<$Res> {
  _$ComplaintMetaModelCopyWithImpl(this._self, this._then);

  final ComplaintMetaModel _self;
  final $Res Function(ComplaintMetaModel) _then;

/// Create a copy of ComplaintMetaModel
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


/// Adds pattern-matching-related methods to [ComplaintMetaModel].
extension ComplaintMetaModelPatterns on ComplaintMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintMetaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintMetaModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)  $default,) {final _that = this;
switch (_that) {
case _ComplaintMetaModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_page')  int currentPage, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  int perPage,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintMetaModel() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintMetaModel implements ComplaintMetaModel {
  const _ComplaintMetaModel({@JsonKey(name: 'current_page') this.currentPage = 1, @JsonKey(name: 'last_page') this.lastPage = 1, @JsonKey(name: 'per_page') this.perPage = 15, this.total = 0});
  factory _ComplaintMetaModel.fromJson(Map<String, dynamic> json) => _$ComplaintMetaModelFromJson(json);

@override@JsonKey(name: 'current_page') final  int currentPage;
@override@JsonKey(name: 'last_page') final  int lastPage;
@override@JsonKey(name: 'per_page') final  int perPage;
@override@JsonKey() final  int total;

/// Create a copy of ComplaintMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintMetaModelCopyWith<_ComplaintMetaModel> get copyWith => __$ComplaintMetaModelCopyWithImpl<_ComplaintMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintMetaModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total);

@override
String toString() {
  return 'ComplaintMetaModel(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ComplaintMetaModelCopyWith<$Res> implements $ComplaintMetaModelCopyWith<$Res> {
  factory _$ComplaintMetaModelCopyWith(_ComplaintMetaModel value, $Res Function(_ComplaintMetaModel) _then) = __$ComplaintMetaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') int perPage, int total
});




}
/// @nodoc
class __$ComplaintMetaModelCopyWithImpl<$Res>
    implements _$ComplaintMetaModelCopyWith<$Res> {
  __$ComplaintMetaModelCopyWithImpl(this._self, this._then);

  final _ComplaintMetaModel _self;
  final $Res Function(_ComplaintMetaModel) _then;

/// Create a copy of ComplaintMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,}) {
  return _then(_ComplaintMetaModel(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ComplaintPaginatedModel {

 List<ComplaintReportModel> get data; ComplaintMetaModel? get meta;
/// Create a copy of ComplaintPaginatedModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintPaginatedModelCopyWith<ComplaintPaginatedModel> get copyWith => _$ComplaintPaginatedModelCopyWithImpl<ComplaintPaginatedModel>(this as ComplaintPaginatedModel, _$identity);

  /// Serializes this ComplaintPaginatedModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplaintPaginatedModel&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'ComplaintPaginatedModel(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $ComplaintPaginatedModelCopyWith<$Res>  {
  factory $ComplaintPaginatedModelCopyWith(ComplaintPaginatedModel value, $Res Function(ComplaintPaginatedModel) _then) = _$ComplaintPaginatedModelCopyWithImpl;
@useResult
$Res call({
 List<ComplaintReportModel> data, ComplaintMetaModel? meta
});


$ComplaintMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class _$ComplaintPaginatedModelCopyWithImpl<$Res>
    implements $ComplaintPaginatedModelCopyWith<$Res> {
  _$ComplaintPaginatedModelCopyWithImpl(this._self, this._then);

  final ComplaintPaginatedModel _self;
  final $Res Function(ComplaintPaginatedModel) _then;

/// Create a copy of ComplaintPaginatedModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ComplaintReportModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ComplaintMetaModel?,
  ));
}
/// Create a copy of ComplaintPaginatedModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ComplaintMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComplaintPaginatedModel].
extension ComplaintPaginatedModelPatterns on ComplaintPaginatedModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplaintPaginatedModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplaintPaginatedModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplaintPaginatedModel value)  $default,){
final _that = this;
switch (_that) {
case _ComplaintPaginatedModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplaintPaginatedModel value)?  $default,){
final _that = this;
switch (_that) {
case _ComplaintPaginatedModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ComplaintReportModel> data,  ComplaintMetaModel? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplaintPaginatedModel() when $default != null:
return $default(_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ComplaintReportModel> data,  ComplaintMetaModel? meta)  $default,) {final _that = this;
switch (_that) {
case _ComplaintPaginatedModel():
return $default(_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ComplaintReportModel> data,  ComplaintMetaModel? meta)?  $default,) {final _that = this;
switch (_that) {
case _ComplaintPaginatedModel() when $default != null:
return $default(_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplaintPaginatedModel implements ComplaintPaginatedModel {
  const _ComplaintPaginatedModel({final  List<ComplaintReportModel> data = const [], this.meta}): _data = data;
  factory _ComplaintPaginatedModel.fromJson(Map<String, dynamic> json) => _$ComplaintPaginatedModelFromJson(json);

 final  List<ComplaintReportModel> _data;
@override@JsonKey() List<ComplaintReportModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  ComplaintMetaModel? meta;

/// Create a copy of ComplaintPaginatedModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintPaginatedModelCopyWith<_ComplaintPaginatedModel> get copyWith => __$ComplaintPaginatedModelCopyWithImpl<_ComplaintPaginatedModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintPaginatedModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplaintPaginatedModel&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'ComplaintPaginatedModel(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$ComplaintPaginatedModelCopyWith<$Res> implements $ComplaintPaginatedModelCopyWith<$Res> {
  factory _$ComplaintPaginatedModelCopyWith(_ComplaintPaginatedModel value, $Res Function(_ComplaintPaginatedModel) _then) = __$ComplaintPaginatedModelCopyWithImpl;
@override @useResult
$Res call({
 List<ComplaintReportModel> data, ComplaintMetaModel? meta
});


@override $ComplaintMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class __$ComplaintPaginatedModelCopyWithImpl<$Res>
    implements _$ComplaintPaginatedModelCopyWith<$Res> {
  __$ComplaintPaginatedModelCopyWithImpl(this._self, this._then);

  final _ComplaintPaginatedModel _self;
  final $Res Function(_ComplaintPaginatedModel) _then;

/// Create a copy of ComplaintPaginatedModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = freezed,}) {
  return _then(_ComplaintPaginatedModel(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ComplaintReportModel>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ComplaintMetaModel?,
  ));
}

/// Create a copy of ComplaintPaginatedModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplaintMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ComplaintMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
