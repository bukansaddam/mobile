// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_submission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivationAttachmentModel {

@JsonKey(name: "id") int? get id;@JsonKey(name: "submission_id") int? get submissionId;@JsonKey(name: "file_name") String? get fileName;@JsonKey(name: "saved_at") String? get savedAt;@JsonKey(name: "mime_type") String? get mimeType;@JsonKey(name: "size") num? get size;@JsonKey(name: "file_path") String? get filePath;@JsonKey(name: "file_url") String? get fileUrl;@JsonKey(name: "metadata") dynamic get metadata;
/// Create a copy of ActivationAttachmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationAttachmentModelCopyWith<ActivationAttachmentModel> get copyWith => _$ActivationAttachmentModelCopyWithImpl<ActivationAttachmentModel>(this as ActivationAttachmentModel, _$identity);

  /// Serializes this ActivationAttachmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationAttachmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.submissionId, submissionId) || other.submissionId == submissionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.size, size) || other.size == size)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,submissionId,fileName,savedAt,mimeType,size,filePath,fileUrl,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'ActivationAttachmentModel(id: $id, submissionId: $submissionId, fileName: $fileName, savedAt: $savedAt, mimeType: $mimeType, size: $size, filePath: $filePath, fileUrl: $fileUrl, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $ActivationAttachmentModelCopyWith<$Res>  {
  factory $ActivationAttachmentModelCopyWith(ActivationAttachmentModel value, $Res Function(ActivationAttachmentModel) _then) = _$ActivationAttachmentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "submission_id") int? submissionId,@JsonKey(name: "file_name") String? fileName,@JsonKey(name: "saved_at") String? savedAt,@JsonKey(name: "mime_type") String? mimeType,@JsonKey(name: "size") num? size,@JsonKey(name: "file_path") String? filePath,@JsonKey(name: "file_url") String? fileUrl,@JsonKey(name: "metadata") dynamic metadata
});




}
/// @nodoc
class _$ActivationAttachmentModelCopyWithImpl<$Res>
    implements $ActivationAttachmentModelCopyWith<$Res> {
  _$ActivationAttachmentModelCopyWithImpl(this._self, this._then);

  final ActivationAttachmentModel _self;
  final $Res Function(ActivationAttachmentModel) _then;

/// Create a copy of ActivationAttachmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? submissionId = freezed,Object? fileName = freezed,Object? savedAt = freezed,Object? mimeType = freezed,Object? size = freezed,Object? filePath = freezed,Object? fileUrl = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,submissionId: freezed == submissionId ? _self.submissionId : submissionId // ignore: cast_nullable_to_non_nullable
as int?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as num?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationAttachmentModel].
extension ActivationAttachmentModelPatterns on ActivationAttachmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationAttachmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationAttachmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationAttachmentModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationAttachmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationAttachmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationAttachmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "submission_id")  int? submissionId, @JsonKey(name: "file_name")  String? fileName, @JsonKey(name: "saved_at")  String? savedAt, @JsonKey(name: "mime_type")  String? mimeType, @JsonKey(name: "size")  num? size, @JsonKey(name: "file_path")  String? filePath, @JsonKey(name: "file_url")  String? fileUrl, @JsonKey(name: "metadata")  dynamic metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationAttachmentModel() when $default != null:
return $default(_that.id,_that.submissionId,_that.fileName,_that.savedAt,_that.mimeType,_that.size,_that.filePath,_that.fileUrl,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "submission_id")  int? submissionId, @JsonKey(name: "file_name")  String? fileName, @JsonKey(name: "saved_at")  String? savedAt, @JsonKey(name: "mime_type")  String? mimeType, @JsonKey(name: "size")  num? size, @JsonKey(name: "file_path")  String? filePath, @JsonKey(name: "file_url")  String? fileUrl, @JsonKey(name: "metadata")  dynamic metadata)  $default,) {final _that = this;
switch (_that) {
case _ActivationAttachmentModel():
return $default(_that.id,_that.submissionId,_that.fileName,_that.savedAt,_that.mimeType,_that.size,_that.filePath,_that.fileUrl,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "submission_id")  int? submissionId, @JsonKey(name: "file_name")  String? fileName, @JsonKey(name: "saved_at")  String? savedAt, @JsonKey(name: "mime_type")  String? mimeType, @JsonKey(name: "size")  num? size, @JsonKey(name: "file_path")  String? filePath, @JsonKey(name: "file_url")  String? fileUrl, @JsonKey(name: "metadata")  dynamic metadata)?  $default,) {final _that = this;
switch (_that) {
case _ActivationAttachmentModel() when $default != null:
return $default(_that.id,_that.submissionId,_that.fileName,_that.savedAt,_that.mimeType,_that.size,_that.filePath,_that.fileUrl,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationAttachmentModel extends ActivationAttachmentModel {
  const _ActivationAttachmentModel({@JsonKey(name: "id") this.id, @JsonKey(name: "submission_id") this.submissionId, @JsonKey(name: "file_name") this.fileName, @JsonKey(name: "saved_at") this.savedAt, @JsonKey(name: "mime_type") this.mimeType, @JsonKey(name: "size") this.size, @JsonKey(name: "file_path") this.filePath, @JsonKey(name: "file_url") this.fileUrl, @JsonKey(name: "metadata") this.metadata}): super._();
  factory _ActivationAttachmentModel.fromJson(Map<String, dynamic> json) => _$ActivationAttachmentModelFromJson(json);

@override@JsonKey(name: "id") final  int? id;
@override@JsonKey(name: "submission_id") final  int? submissionId;
@override@JsonKey(name: "file_name") final  String? fileName;
@override@JsonKey(name: "saved_at") final  String? savedAt;
@override@JsonKey(name: "mime_type") final  String? mimeType;
@override@JsonKey(name: "size") final  num? size;
@override@JsonKey(name: "file_path") final  String? filePath;
@override@JsonKey(name: "file_url") final  String? fileUrl;
@override@JsonKey(name: "metadata") final  dynamic metadata;

/// Create a copy of ActivationAttachmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationAttachmentModelCopyWith<_ActivationAttachmentModel> get copyWith => __$ActivationAttachmentModelCopyWithImpl<_ActivationAttachmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationAttachmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationAttachmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.submissionId, submissionId) || other.submissionId == submissionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.size, size) || other.size == size)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,submissionId,fileName,savedAt,mimeType,size,filePath,fileUrl,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'ActivationAttachmentModel(id: $id, submissionId: $submissionId, fileName: $fileName, savedAt: $savedAt, mimeType: $mimeType, size: $size, filePath: $filePath, fileUrl: $fileUrl, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ActivationAttachmentModelCopyWith<$Res> implements $ActivationAttachmentModelCopyWith<$Res> {
  factory _$ActivationAttachmentModelCopyWith(_ActivationAttachmentModel value, $Res Function(_ActivationAttachmentModel) _then) = __$ActivationAttachmentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "submission_id") int? submissionId,@JsonKey(name: "file_name") String? fileName,@JsonKey(name: "saved_at") String? savedAt,@JsonKey(name: "mime_type") String? mimeType,@JsonKey(name: "size") num? size,@JsonKey(name: "file_path") String? filePath,@JsonKey(name: "file_url") String? fileUrl,@JsonKey(name: "metadata") dynamic metadata
});




}
/// @nodoc
class __$ActivationAttachmentModelCopyWithImpl<$Res>
    implements _$ActivationAttachmentModelCopyWith<$Res> {
  __$ActivationAttachmentModelCopyWithImpl(this._self, this._then);

  final _ActivationAttachmentModel _self;
  final $Res Function(_ActivationAttachmentModel) _then;

/// Create a copy of ActivationAttachmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? submissionId = freezed,Object? fileName = freezed,Object? savedAt = freezed,Object? mimeType = freezed,Object? size = freezed,Object? filePath = freezed,Object? fileUrl = freezed,Object? metadata = freezed,}) {
  return _then(_ActivationAttachmentModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,submissionId: freezed == submissionId ? _self.submissionId : submissionId // ignore: cast_nullable_to_non_nullable
as int?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as num?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileUrl: freezed == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}


/// @nodoc
mixin _$ActivationSubmissionDataModel {

@JsonKey(name: "id") int get id;@JsonKey(name: "receiver_nik") String? get receiverNik;@JsonKey(name: "receiver_name") String? get receiverName;@JsonKey(name: "notes") String? get notes;@JsonKey(name: "creator") dynamic get creator;@JsonKey(name: "created_at") String? get createdAt;@JsonKey(name: "attachments") List<ActivationAttachmentModel> get attachments;
/// Create a copy of ActivationSubmissionDataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationSubmissionDataModelCopyWith<ActivationSubmissionDataModel> get copyWith => _$ActivationSubmissionDataModelCopyWithImpl<ActivationSubmissionDataModel>(this as ActivationSubmissionDataModel, _$identity);

  /// Serializes this ActivationSubmissionDataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationSubmissionDataModel&&(identical(other.id, id) || other.id == id)&&(identical(other.receiverNik, receiverNik) || other.receiverNik == receiverNik)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.creator, creator)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,receiverNik,receiverName,notes,const DeepCollectionEquality().hash(creator),createdAt,const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'ActivationSubmissionDataModel(id: $id, receiverNik: $receiverNik, receiverName: $receiverName, notes: $notes, creator: $creator, createdAt: $createdAt, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class $ActivationSubmissionDataModelCopyWith<$Res>  {
  factory $ActivationSubmissionDataModelCopyWith(ActivationSubmissionDataModel value, $Res Function(ActivationSubmissionDataModel) _then) = _$ActivationSubmissionDataModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "receiver_nik") String? receiverNik,@JsonKey(name: "receiver_name") String? receiverName,@JsonKey(name: "notes") String? notes,@JsonKey(name: "creator") dynamic creator,@JsonKey(name: "created_at") String? createdAt,@JsonKey(name: "attachments") List<ActivationAttachmentModel> attachments
});




}
/// @nodoc
class _$ActivationSubmissionDataModelCopyWithImpl<$Res>
    implements $ActivationSubmissionDataModelCopyWith<$Res> {
  _$ActivationSubmissionDataModelCopyWithImpl(this._self, this._then);

  final ActivationSubmissionDataModel _self;
  final $Res Function(ActivationSubmissionDataModel) _then;

/// Create a copy of ActivationSubmissionDataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? receiverNik = freezed,Object? receiverName = freezed,Object? notes = freezed,Object? creator = freezed,Object? createdAt = freezed,Object? attachments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,receiverNik: freezed == receiverNik ? _self.receiverNik : receiverNik // ignore: cast_nullable_to_non_nullable
as String?,receiverName: freezed == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ActivationAttachmentModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationSubmissionDataModel].
extension ActivationSubmissionDataModelPatterns on ActivationSubmissionDataModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationSubmissionDataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationSubmissionDataModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationSubmissionDataModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationSubmissionDataModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationSubmissionDataModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationSubmissionDataModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "receiver_nik")  String? receiverNik, @JsonKey(name: "receiver_name")  String? receiverName, @JsonKey(name: "notes")  String? notes, @JsonKey(name: "creator")  dynamic creator, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "attachments")  List<ActivationAttachmentModel> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationSubmissionDataModel() when $default != null:
return $default(_that.id,_that.receiverNik,_that.receiverName,_that.notes,_that.creator,_that.createdAt,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "receiver_nik")  String? receiverNik, @JsonKey(name: "receiver_name")  String? receiverName, @JsonKey(name: "notes")  String? notes, @JsonKey(name: "creator")  dynamic creator, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "attachments")  List<ActivationAttachmentModel> attachments)  $default,) {final _that = this;
switch (_that) {
case _ActivationSubmissionDataModel():
return $default(_that.id,_that.receiverNik,_that.receiverName,_that.notes,_that.creator,_that.createdAt,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "receiver_nik")  String? receiverNik, @JsonKey(name: "receiver_name")  String? receiverName, @JsonKey(name: "notes")  String? notes, @JsonKey(name: "creator")  dynamic creator, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "attachments")  List<ActivationAttachmentModel> attachments)?  $default,) {final _that = this;
switch (_that) {
case _ActivationSubmissionDataModel() when $default != null:
return $default(_that.id,_that.receiverNik,_that.receiverName,_that.notes,_that.creator,_that.createdAt,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationSubmissionDataModel extends ActivationSubmissionDataModel {
  const _ActivationSubmissionDataModel({@JsonKey(name: "id") required this.id, @JsonKey(name: "receiver_nik") this.receiverNik, @JsonKey(name: "receiver_name") this.receiverName, @JsonKey(name: "notes") this.notes, @JsonKey(name: "creator") this.creator, @JsonKey(name: "created_at") this.createdAt, @JsonKey(name: "attachments") final  List<ActivationAttachmentModel> attachments = const []}): _attachments = attachments,super._();
  factory _ActivationSubmissionDataModel.fromJson(Map<String, dynamic> json) => _$ActivationSubmissionDataModelFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "receiver_nik") final  String? receiverNik;
@override@JsonKey(name: "receiver_name") final  String? receiverName;
@override@JsonKey(name: "notes") final  String? notes;
@override@JsonKey(name: "creator") final  dynamic creator;
@override@JsonKey(name: "created_at") final  String? createdAt;
 final  List<ActivationAttachmentModel> _attachments;
@override@JsonKey(name: "attachments") List<ActivationAttachmentModel> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of ActivationSubmissionDataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationSubmissionDataModelCopyWith<_ActivationSubmissionDataModel> get copyWith => __$ActivationSubmissionDataModelCopyWithImpl<_ActivationSubmissionDataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationSubmissionDataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationSubmissionDataModel&&(identical(other.id, id) || other.id == id)&&(identical(other.receiverNik, receiverNik) || other.receiverNik == receiverNik)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.creator, creator)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,receiverNik,receiverName,notes,const DeepCollectionEquality().hash(creator),createdAt,const DeepCollectionEquality().hash(_attachments));

@override
String toString() {
  return 'ActivationSubmissionDataModel(id: $id, receiverNik: $receiverNik, receiverName: $receiverName, notes: $notes, creator: $creator, createdAt: $createdAt, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$ActivationSubmissionDataModelCopyWith<$Res> implements $ActivationSubmissionDataModelCopyWith<$Res> {
  factory _$ActivationSubmissionDataModelCopyWith(_ActivationSubmissionDataModel value, $Res Function(_ActivationSubmissionDataModel) _then) = __$ActivationSubmissionDataModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "receiver_nik") String? receiverNik,@JsonKey(name: "receiver_name") String? receiverName,@JsonKey(name: "notes") String? notes,@JsonKey(name: "creator") dynamic creator,@JsonKey(name: "created_at") String? createdAt,@JsonKey(name: "attachments") List<ActivationAttachmentModel> attachments
});




}
/// @nodoc
class __$ActivationSubmissionDataModelCopyWithImpl<$Res>
    implements _$ActivationSubmissionDataModelCopyWith<$Res> {
  __$ActivationSubmissionDataModelCopyWithImpl(this._self, this._then);

  final _ActivationSubmissionDataModel _self;
  final $Res Function(_ActivationSubmissionDataModel) _then;

/// Create a copy of ActivationSubmissionDataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? receiverNik = freezed,Object? receiverName = freezed,Object? notes = freezed,Object? creator = freezed,Object? createdAt = freezed,Object? attachments = null,}) {
  return _then(_ActivationSubmissionDataModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,receiverNik: freezed == receiverNik ? _self.receiverNik : receiverNik // ignore: cast_nullable_to_non_nullable
as String?,receiverName: freezed == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ActivationAttachmentModel>,
  ));
}


}


/// @nodoc
mixin _$ActivationSubmissionMetaModel {

@JsonKey(name: "total_target") int? get totalTarget;@JsonKey(name: "target_done") int? get targetDone;
/// Create a copy of ActivationSubmissionMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationSubmissionMetaModelCopyWith<ActivationSubmissionMetaModel> get copyWith => _$ActivationSubmissionMetaModelCopyWithImpl<ActivationSubmissionMetaModel>(this as ActivationSubmissionMetaModel, _$identity);

  /// Serializes this ActivationSubmissionMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationSubmissionMetaModel&&(identical(other.totalTarget, totalTarget) || other.totalTarget == totalTarget)&&(identical(other.targetDone, targetDone) || other.targetDone == targetDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalTarget,targetDone);

@override
String toString() {
  return 'ActivationSubmissionMetaModel(totalTarget: $totalTarget, targetDone: $targetDone)';
}


}

/// @nodoc
abstract mixin class $ActivationSubmissionMetaModelCopyWith<$Res>  {
  factory $ActivationSubmissionMetaModelCopyWith(ActivationSubmissionMetaModel value, $Res Function(ActivationSubmissionMetaModel) _then) = _$ActivationSubmissionMetaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "total_target") int? totalTarget,@JsonKey(name: "target_done") int? targetDone
});




}
/// @nodoc
class _$ActivationSubmissionMetaModelCopyWithImpl<$Res>
    implements $ActivationSubmissionMetaModelCopyWith<$Res> {
  _$ActivationSubmissionMetaModelCopyWithImpl(this._self, this._then);

  final ActivationSubmissionMetaModel _self;
  final $Res Function(ActivationSubmissionMetaModel) _then;

/// Create a copy of ActivationSubmissionMetaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalTarget = freezed,Object? targetDone = freezed,}) {
  return _then(_self.copyWith(
totalTarget: freezed == totalTarget ? _self.totalTarget : totalTarget // ignore: cast_nullable_to_non_nullable
as int?,targetDone: freezed == targetDone ? _self.targetDone : targetDone // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationSubmissionMetaModel].
extension ActivationSubmissionMetaModelPatterns on ActivationSubmissionMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationSubmissionMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationSubmissionMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationSubmissionMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationSubmissionMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationSubmissionMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationSubmissionMetaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "total_target")  int? totalTarget, @JsonKey(name: "target_done")  int? targetDone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationSubmissionMetaModel() when $default != null:
return $default(_that.totalTarget,_that.targetDone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "total_target")  int? totalTarget, @JsonKey(name: "target_done")  int? targetDone)  $default,) {final _that = this;
switch (_that) {
case _ActivationSubmissionMetaModel():
return $default(_that.totalTarget,_that.targetDone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "total_target")  int? totalTarget, @JsonKey(name: "target_done")  int? targetDone)?  $default,) {final _that = this;
switch (_that) {
case _ActivationSubmissionMetaModel() when $default != null:
return $default(_that.totalTarget,_that.targetDone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationSubmissionMetaModel extends ActivationSubmissionMetaModel {
  const _ActivationSubmissionMetaModel({@JsonKey(name: "total_target") this.totalTarget, @JsonKey(name: "target_done") this.targetDone}): super._();
  factory _ActivationSubmissionMetaModel.fromJson(Map<String, dynamic> json) => _$ActivationSubmissionMetaModelFromJson(json);

@override@JsonKey(name: "total_target") final  int? totalTarget;
@override@JsonKey(name: "target_done") final  int? targetDone;

/// Create a copy of ActivationSubmissionMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationSubmissionMetaModelCopyWith<_ActivationSubmissionMetaModel> get copyWith => __$ActivationSubmissionMetaModelCopyWithImpl<_ActivationSubmissionMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationSubmissionMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationSubmissionMetaModel&&(identical(other.totalTarget, totalTarget) || other.totalTarget == totalTarget)&&(identical(other.targetDone, targetDone) || other.targetDone == targetDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalTarget,targetDone);

@override
String toString() {
  return 'ActivationSubmissionMetaModel(totalTarget: $totalTarget, targetDone: $targetDone)';
}


}

/// @nodoc
abstract mixin class _$ActivationSubmissionMetaModelCopyWith<$Res> implements $ActivationSubmissionMetaModelCopyWith<$Res> {
  factory _$ActivationSubmissionMetaModelCopyWith(_ActivationSubmissionMetaModel value, $Res Function(_ActivationSubmissionMetaModel) _then) = __$ActivationSubmissionMetaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "total_target") int? totalTarget,@JsonKey(name: "target_done") int? targetDone
});




}
/// @nodoc
class __$ActivationSubmissionMetaModelCopyWithImpl<$Res>
    implements _$ActivationSubmissionMetaModelCopyWith<$Res> {
  __$ActivationSubmissionMetaModelCopyWithImpl(this._self, this._then);

  final _ActivationSubmissionMetaModel _self;
  final $Res Function(_ActivationSubmissionMetaModel) _then;

/// Create a copy of ActivationSubmissionMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalTarget = freezed,Object? targetDone = freezed,}) {
  return _then(_ActivationSubmissionMetaModel(
totalTarget: freezed == totalTarget ? _self.totalTarget : totalTarget // ignore: cast_nullable_to_non_nullable
as int?,targetDone: freezed == targetDone ? _self.targetDone : targetDone // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ActivationSubmissionResponseModel {

@JsonKey(name: "success") bool get success;@JsonKey(name: "data") ActivationSubmissionDataModel? get data;@JsonKey(name: "meta") ActivationSubmissionMetaModel? get meta;@JsonKey(name: "message") String? get message;
/// Create a copy of ActivationSubmissionResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationSubmissionResponseModelCopyWith<ActivationSubmissionResponseModel> get copyWith => _$ActivationSubmissionResponseModelCopyWithImpl<ActivationSubmissionResponseModel>(this as ActivationSubmissionResponseModel, _$identity);

  /// Serializes this ActivationSubmissionResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationSubmissionResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,meta,message);

@override
String toString() {
  return 'ActivationSubmissionResponseModel(success: $success, data: $data, meta: $meta, message: $message)';
}


}

/// @nodoc
abstract mixin class $ActivationSubmissionResponseModelCopyWith<$Res>  {
  factory $ActivationSubmissionResponseModelCopyWith(ActivationSubmissionResponseModel value, $Res Function(ActivationSubmissionResponseModel) _then) = _$ActivationSubmissionResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "data") ActivationSubmissionDataModel? data,@JsonKey(name: "meta") ActivationSubmissionMetaModel? meta,@JsonKey(name: "message") String? message
});


$ActivationSubmissionDataModelCopyWith<$Res>? get data;$ActivationSubmissionMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class _$ActivationSubmissionResponseModelCopyWithImpl<$Res>
    implements $ActivationSubmissionResponseModelCopyWith<$Res> {
  _$ActivationSubmissionResponseModelCopyWithImpl(this._self, this._then);

  final ActivationSubmissionResponseModel _self;
  final $Res Function(ActivationSubmissionResponseModel) _then;

/// Create a copy of ActivationSubmissionResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? meta = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ActivationSubmissionDataModel?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ActivationSubmissionMetaModel?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ActivationSubmissionResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationSubmissionDataModelCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $ActivationSubmissionDataModelCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of ActivationSubmissionResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationSubmissionMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ActivationSubmissionMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivationSubmissionResponseModel].
extension ActivationSubmissionResponseModelPatterns on ActivationSubmissionResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationSubmissionResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationSubmissionResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationSubmissionResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationSubmissionResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationSubmissionResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationSubmissionResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  ActivationSubmissionDataModel? data, @JsonKey(name: "meta")  ActivationSubmissionMetaModel? meta, @JsonKey(name: "message")  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationSubmissionResponseModel() when $default != null:
return $default(_that.success,_that.data,_that.meta,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  ActivationSubmissionDataModel? data, @JsonKey(name: "meta")  ActivationSubmissionMetaModel? meta, @JsonKey(name: "message")  String? message)  $default,) {final _that = this;
switch (_that) {
case _ActivationSubmissionResponseModel():
return $default(_that.success,_that.data,_that.meta,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "data")  ActivationSubmissionDataModel? data, @JsonKey(name: "meta")  ActivationSubmissionMetaModel? meta, @JsonKey(name: "message")  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ActivationSubmissionResponseModel() when $default != null:
return $default(_that.success,_that.data,_that.meta,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationSubmissionResponseModel extends ActivationSubmissionResponseModel {
  const _ActivationSubmissionResponseModel({@JsonKey(name: "success") this.success = false, @JsonKey(name: "data") this.data, @JsonKey(name: "meta") this.meta, @JsonKey(name: "message") this.message}): super._();
  factory _ActivationSubmissionResponseModel.fromJson(Map<String, dynamic> json) => _$ActivationSubmissionResponseModelFromJson(json);

@override@JsonKey(name: "success") final  bool success;
@override@JsonKey(name: "data") final  ActivationSubmissionDataModel? data;
@override@JsonKey(name: "meta") final  ActivationSubmissionMetaModel? meta;
@override@JsonKey(name: "message") final  String? message;

/// Create a copy of ActivationSubmissionResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationSubmissionResponseModelCopyWith<_ActivationSubmissionResponseModel> get copyWith => __$ActivationSubmissionResponseModelCopyWithImpl<_ActivationSubmissionResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationSubmissionResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationSubmissionResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,meta,message);

@override
String toString() {
  return 'ActivationSubmissionResponseModel(success: $success, data: $data, meta: $meta, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActivationSubmissionResponseModelCopyWith<$Res> implements $ActivationSubmissionResponseModelCopyWith<$Res> {
  factory _$ActivationSubmissionResponseModelCopyWith(_ActivationSubmissionResponseModel value, $Res Function(_ActivationSubmissionResponseModel) _then) = __$ActivationSubmissionResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "data") ActivationSubmissionDataModel? data,@JsonKey(name: "meta") ActivationSubmissionMetaModel? meta,@JsonKey(name: "message") String? message
});


@override $ActivationSubmissionDataModelCopyWith<$Res>? get data;@override $ActivationSubmissionMetaModelCopyWith<$Res>? get meta;

}
/// @nodoc
class __$ActivationSubmissionResponseModelCopyWithImpl<$Res>
    implements _$ActivationSubmissionResponseModelCopyWith<$Res> {
  __$ActivationSubmissionResponseModelCopyWithImpl(this._self, this._then);

  final _ActivationSubmissionResponseModel _self;
  final $Res Function(_ActivationSubmissionResponseModel) _then;

/// Create a copy of ActivationSubmissionResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? meta = freezed,Object? message = freezed,}) {
  return _then(_ActivationSubmissionResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ActivationSubmissionDataModel?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ActivationSubmissionMetaModel?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ActivationSubmissionResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationSubmissionDataModelCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $ActivationSubmissionDataModelCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of ActivationSubmissionResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationSubmissionMetaModelCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ActivationSubmissionMetaModelCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
