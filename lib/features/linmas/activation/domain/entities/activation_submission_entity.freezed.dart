// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_submission_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivationAttachmentEntity {

 int? get id; int? get submissionId; String? get fileName; String? get mimeType; num? get size; String? get filePath; String? get fileUrl;
/// Create a copy of ActivationAttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationAttachmentEntityCopyWith<ActivationAttachmentEntity> get copyWith => _$ActivationAttachmentEntityCopyWithImpl<ActivationAttachmentEntity>(this as ActivationAttachmentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationAttachmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.submissionId, submissionId) || other.submissionId == submissionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.size, size) || other.size == size)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,submissionId,fileName,mimeType,size,filePath,fileUrl);

@override
String toString() {
  return 'ActivationAttachmentEntity(id: $id, submissionId: $submissionId, fileName: $fileName, mimeType: $mimeType, size: $size, filePath: $filePath, fileUrl: $fileUrl)';
}


}

/// @nodoc
abstract mixin class $ActivationAttachmentEntityCopyWith<$Res>  {
  factory $ActivationAttachmentEntityCopyWith(ActivationAttachmentEntity value, $Res Function(ActivationAttachmentEntity) _then) = _$ActivationAttachmentEntityCopyWithImpl;
@useResult
$Res call({
 int? id, int? submissionId, String? fileName, String? mimeType, num? size, String? filePath, String? fileUrl
});




}
/// @nodoc
class _$ActivationAttachmentEntityCopyWithImpl<$Res>
    implements $ActivationAttachmentEntityCopyWith<$Res> {
  _$ActivationAttachmentEntityCopyWithImpl(this._self, this._then);

  final ActivationAttachmentEntity _self;
  final $Res Function(ActivationAttachmentEntity) _then;

/// Create a copy of ActivationAttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? submissionId = freezed,Object? fileName = freezed,Object? mimeType = freezed,Object? size = freezed,Object? filePath = freezed,Object? fileUrl = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,submissionId: freezed == submissionId ? _self.submissionId : submissionId // ignore: cast_nullable_to_non_nullable
as int?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as num?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationAttachmentEntity].
extension ActivationAttachmentEntityPatterns on ActivationAttachmentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationAttachmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationAttachmentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationAttachmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _ActivationAttachmentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationAttachmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationAttachmentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? submissionId,  String? fileName,  String? mimeType,  num? size,  String? filePath,  String? fileUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationAttachmentEntity() when $default != null:
return $default(_that.id,_that.submissionId,_that.fileName,_that.mimeType,_that.size,_that.filePath,_that.fileUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? submissionId,  String? fileName,  String? mimeType,  num? size,  String? filePath,  String? fileUrl)  $default,) {final _that = this;
switch (_that) {
case _ActivationAttachmentEntity():
return $default(_that.id,_that.submissionId,_that.fileName,_that.mimeType,_that.size,_that.filePath,_that.fileUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? submissionId,  String? fileName,  String? mimeType,  num? size,  String? filePath,  String? fileUrl)?  $default,) {final _that = this;
switch (_that) {
case _ActivationAttachmentEntity() when $default != null:
return $default(_that.id,_that.submissionId,_that.fileName,_that.mimeType,_that.size,_that.filePath,_that.fileUrl);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationAttachmentEntity extends ActivationAttachmentEntity {
  const _ActivationAttachmentEntity({this.id, this.submissionId, this.fileName, this.mimeType, this.size, this.filePath, this.fileUrl}): super._();
  

@override final  int? id;
@override final  int? submissionId;
@override final  String? fileName;
@override final  String? mimeType;
@override final  num? size;
@override final  String? filePath;
@override final  String? fileUrl;

/// Create a copy of ActivationAttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationAttachmentEntityCopyWith<_ActivationAttachmentEntity> get copyWith => __$ActivationAttachmentEntityCopyWithImpl<_ActivationAttachmentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationAttachmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.submissionId, submissionId) || other.submissionId == submissionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.size, size) || other.size == size)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,submissionId,fileName,mimeType,size,filePath,fileUrl);

@override
String toString() {
  return 'ActivationAttachmentEntity(id: $id, submissionId: $submissionId, fileName: $fileName, mimeType: $mimeType, size: $size, filePath: $filePath, fileUrl: $fileUrl)';
}


}

/// @nodoc
abstract mixin class _$ActivationAttachmentEntityCopyWith<$Res> implements $ActivationAttachmentEntityCopyWith<$Res> {
  factory _$ActivationAttachmentEntityCopyWith(_ActivationAttachmentEntity value, $Res Function(_ActivationAttachmentEntity) _then) = __$ActivationAttachmentEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? submissionId, String? fileName, String? mimeType, num? size, String? filePath, String? fileUrl
});




}
/// @nodoc
class __$ActivationAttachmentEntityCopyWithImpl<$Res>
    implements _$ActivationAttachmentEntityCopyWith<$Res> {
  __$ActivationAttachmentEntityCopyWithImpl(this._self, this._then);

  final _ActivationAttachmentEntity _self;
  final $Res Function(_ActivationAttachmentEntity) _then;

/// Create a copy of ActivationAttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? submissionId = freezed,Object? fileName = freezed,Object? mimeType = freezed,Object? size = freezed,Object? filePath = freezed,Object? fileUrl = freezed,}) {
  return _then(_ActivationAttachmentEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,submissionId: freezed == submissionId ? _self.submissionId : submissionId // ignore: cast_nullable_to_non_nullable
as int?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as num?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ActivationSubmissionEntity {

 int get id; String? get receiverNik; String? get receiverName; String? get notes; String? get createdAt; List<ActivationAttachmentEntity> get attachments; int? get totalTarget; int? get targetDone;
/// Create a copy of ActivationSubmissionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationSubmissionEntityCopyWith<ActivationSubmissionEntity> get copyWith => _$ActivationSubmissionEntityCopyWithImpl<ActivationSubmissionEntity>(this as ActivationSubmissionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationSubmissionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.receiverNik, receiverNik) || other.receiverNik == receiverNik)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.totalTarget, totalTarget) || other.totalTarget == totalTarget)&&(identical(other.targetDone, targetDone) || other.targetDone == targetDone));
}


@override
int get hashCode => Object.hash(runtimeType,id,receiverNik,receiverName,notes,createdAt,const DeepCollectionEquality().hash(attachments),totalTarget,targetDone);

@override
String toString() {
  return 'ActivationSubmissionEntity(id: $id, receiverNik: $receiverNik, receiverName: $receiverName, notes: $notes, createdAt: $createdAt, attachments: $attachments, totalTarget: $totalTarget, targetDone: $targetDone)';
}


}

/// @nodoc
abstract mixin class $ActivationSubmissionEntityCopyWith<$Res>  {
  factory $ActivationSubmissionEntityCopyWith(ActivationSubmissionEntity value, $Res Function(ActivationSubmissionEntity) _then) = _$ActivationSubmissionEntityCopyWithImpl;
@useResult
$Res call({
 int id, String? receiverNik, String? receiverName, String? notes, String? createdAt, List<ActivationAttachmentEntity> attachments, int? totalTarget, int? targetDone
});




}
/// @nodoc
class _$ActivationSubmissionEntityCopyWithImpl<$Res>
    implements $ActivationSubmissionEntityCopyWith<$Res> {
  _$ActivationSubmissionEntityCopyWithImpl(this._self, this._then);

  final ActivationSubmissionEntity _self;
  final $Res Function(ActivationSubmissionEntity) _then;

/// Create a copy of ActivationSubmissionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? receiverNik = freezed,Object? receiverName = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? attachments = null,Object? totalTarget = freezed,Object? targetDone = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,receiverNik: freezed == receiverNik ? _self.receiverNik : receiverNik // ignore: cast_nullable_to_non_nullable
as String?,receiverName: freezed == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ActivationAttachmentEntity>,totalTarget: freezed == totalTarget ? _self.totalTarget : totalTarget // ignore: cast_nullable_to_non_nullable
as int?,targetDone: freezed == targetDone ? _self.targetDone : targetDone // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationSubmissionEntity].
extension ActivationSubmissionEntityPatterns on ActivationSubmissionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationSubmissionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationSubmissionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationSubmissionEntity value)  $default,){
final _that = this;
switch (_that) {
case _ActivationSubmissionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationSubmissionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationSubmissionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? receiverNik,  String? receiverName,  String? notes,  String? createdAt,  List<ActivationAttachmentEntity> attachments,  int? totalTarget,  int? targetDone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationSubmissionEntity() when $default != null:
return $default(_that.id,_that.receiverNik,_that.receiverName,_that.notes,_that.createdAt,_that.attachments,_that.totalTarget,_that.targetDone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? receiverNik,  String? receiverName,  String? notes,  String? createdAt,  List<ActivationAttachmentEntity> attachments,  int? totalTarget,  int? targetDone)  $default,) {final _that = this;
switch (_that) {
case _ActivationSubmissionEntity():
return $default(_that.id,_that.receiverNik,_that.receiverName,_that.notes,_that.createdAt,_that.attachments,_that.totalTarget,_that.targetDone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? receiverNik,  String? receiverName,  String? notes,  String? createdAt,  List<ActivationAttachmentEntity> attachments,  int? totalTarget,  int? targetDone)?  $default,) {final _that = this;
switch (_that) {
case _ActivationSubmissionEntity() when $default != null:
return $default(_that.id,_that.receiverNik,_that.receiverName,_that.notes,_that.createdAt,_that.attachments,_that.totalTarget,_that.targetDone);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationSubmissionEntity extends ActivationSubmissionEntity {
  const _ActivationSubmissionEntity({required this.id, this.receiverNik, this.receiverName, this.notes, this.createdAt, final  List<ActivationAttachmentEntity> attachments = const [], this.totalTarget, this.targetDone}): _attachments = attachments,super._();
  

@override final  int id;
@override final  String? receiverNik;
@override final  String? receiverName;
@override final  String? notes;
@override final  String? createdAt;
 final  List<ActivationAttachmentEntity> _attachments;
@override@JsonKey() List<ActivationAttachmentEntity> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  int? totalTarget;
@override final  int? targetDone;

/// Create a copy of ActivationSubmissionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationSubmissionEntityCopyWith<_ActivationSubmissionEntity> get copyWith => __$ActivationSubmissionEntityCopyWithImpl<_ActivationSubmissionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationSubmissionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.receiverNik, receiverNik) || other.receiverNik == receiverNik)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.totalTarget, totalTarget) || other.totalTarget == totalTarget)&&(identical(other.targetDone, targetDone) || other.targetDone == targetDone));
}


@override
int get hashCode => Object.hash(runtimeType,id,receiverNik,receiverName,notes,createdAt,const DeepCollectionEquality().hash(_attachments),totalTarget,targetDone);

@override
String toString() {
  return 'ActivationSubmissionEntity(id: $id, receiverNik: $receiverNik, receiverName: $receiverName, notes: $notes, createdAt: $createdAt, attachments: $attachments, totalTarget: $totalTarget, targetDone: $targetDone)';
}


}

/// @nodoc
abstract mixin class _$ActivationSubmissionEntityCopyWith<$Res> implements $ActivationSubmissionEntityCopyWith<$Res> {
  factory _$ActivationSubmissionEntityCopyWith(_ActivationSubmissionEntity value, $Res Function(_ActivationSubmissionEntity) _then) = __$ActivationSubmissionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String? receiverNik, String? receiverName, String? notes, String? createdAt, List<ActivationAttachmentEntity> attachments, int? totalTarget, int? targetDone
});




}
/// @nodoc
class __$ActivationSubmissionEntityCopyWithImpl<$Res>
    implements _$ActivationSubmissionEntityCopyWith<$Res> {
  __$ActivationSubmissionEntityCopyWithImpl(this._self, this._then);

  final _ActivationSubmissionEntity _self;
  final $Res Function(_ActivationSubmissionEntity) _then;

/// Create a copy of ActivationSubmissionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? receiverNik = freezed,Object? receiverName = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? attachments = null,Object? totalTarget = freezed,Object? targetDone = freezed,}) {
  return _then(_ActivationSubmissionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,receiverNik: freezed == receiverNik ? _self.receiverNik : receiverNik // ignore: cast_nullable_to_non_nullable
as String?,receiverName: freezed == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ActivationAttachmentEntity>,totalTarget: freezed == totalTarget ? _self.totalTarget : totalTarget // ignore: cast_nullable_to_non_nullable
as int?,targetDone: freezed == targetDone ? _self.targetDone : targetDone // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
