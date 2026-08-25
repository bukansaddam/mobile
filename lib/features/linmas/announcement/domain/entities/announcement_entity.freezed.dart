// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcement_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnnouncementEntity {

 int get id; String get title; String? get slug; String? get category; String? get summary; String? get content; String? get coverImage; List<String> get images; String? get authorName; String? get status; bool get isPinned; int get viewsCount; DateTime? get publishedAt; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of AnnouncementEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementEntityCopyWith<AnnouncementEntity> get copyWith => _$AnnouncementEntityCopyWithImpl<AnnouncementEntity>(this as AnnouncementEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.category, category) || other.category == category)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.viewsCount, viewsCount) || other.viewsCount == viewsCount)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,slug,category,summary,content,coverImage,const DeepCollectionEquality().hash(images),authorName,status,isPinned,viewsCount,publishedAt,createdAt,updatedAt);

@override
String toString() {
  return 'AnnouncementEntity(id: $id, title: $title, slug: $slug, category: $category, summary: $summary, content: $content, coverImage: $coverImage, images: $images, authorName: $authorName, status: $status, isPinned: $isPinned, viewsCount: $viewsCount, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AnnouncementEntityCopyWith<$Res>  {
  factory $AnnouncementEntityCopyWith(AnnouncementEntity value, $Res Function(AnnouncementEntity) _then) = _$AnnouncementEntityCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? slug, String? category, String? summary, String? content, String? coverImage, List<String> images, String? authorName, String? status, bool isPinned, int viewsCount, DateTime? publishedAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$AnnouncementEntityCopyWithImpl<$Res>
    implements $AnnouncementEntityCopyWith<$Res> {
  _$AnnouncementEntityCopyWithImpl(this._self, this._then);

  final AnnouncementEntity _self;
  final $Res Function(AnnouncementEntity) _then;

/// Create a copy of AnnouncementEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? category = freezed,Object? summary = freezed,Object? content = freezed,Object? coverImage = freezed,Object? images = null,Object? authorName = freezed,Object? status = freezed,Object? isPinned = null,Object? viewsCount = null,Object? publishedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,viewsCount: null == viewsCount ? _self.viewsCount : viewsCount // ignore: cast_nullable_to_non_nullable
as int,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementEntity].
extension AnnouncementEntityPatterns on AnnouncementEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementEntity value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? slug,  String? category,  String? summary,  String? content,  String? coverImage,  List<String> images,  String? authorName,  String? status,  bool isPinned,  int viewsCount,  DateTime? publishedAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementEntity() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.category,_that.summary,_that.content,_that.coverImage,_that.images,_that.authorName,_that.status,_that.isPinned,_that.viewsCount,_that.publishedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? slug,  String? category,  String? summary,  String? content,  String? coverImage,  List<String> images,  String? authorName,  String? status,  bool isPinned,  int viewsCount,  DateTime? publishedAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementEntity():
return $default(_that.id,_that.title,_that.slug,_that.category,_that.summary,_that.content,_that.coverImage,_that.images,_that.authorName,_that.status,_that.isPinned,_that.viewsCount,_that.publishedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? slug,  String? category,  String? summary,  String? content,  String? coverImage,  List<String> images,  String? authorName,  String? status,  bool isPinned,  int viewsCount,  DateTime? publishedAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementEntity() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.category,_that.summary,_that.content,_that.coverImage,_that.images,_that.authorName,_that.status,_that.isPinned,_that.viewsCount,_that.publishedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AnnouncementEntity extends AnnouncementEntity {
  const _AnnouncementEntity({required this.id, required this.title, this.slug, this.category, this.summary, this.content, this.coverImage, final  List<String> images = const [], this.authorName, this.status, this.isPinned = false, this.viewsCount = 0, this.publishedAt, this.createdAt, this.updatedAt}): _images = images,super._();
  

@override final  int id;
@override final  String title;
@override final  String? slug;
@override final  String? category;
@override final  String? summary;
@override final  String? content;
@override final  String? coverImage;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  String? authorName;
@override final  String? status;
@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  int viewsCount;
@override final  DateTime? publishedAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of AnnouncementEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementEntityCopyWith<_AnnouncementEntity> get copyWith => __$AnnouncementEntityCopyWithImpl<_AnnouncementEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.category, category) || other.category == category)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.viewsCount, viewsCount) || other.viewsCount == viewsCount)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,slug,category,summary,content,coverImage,const DeepCollectionEquality().hash(_images),authorName,status,isPinned,viewsCount,publishedAt,createdAt,updatedAt);

@override
String toString() {
  return 'AnnouncementEntity(id: $id, title: $title, slug: $slug, category: $category, summary: $summary, content: $content, coverImage: $coverImage, images: $images, authorName: $authorName, status: $status, isPinned: $isPinned, viewsCount: $viewsCount, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementEntityCopyWith<$Res> implements $AnnouncementEntityCopyWith<$Res> {
  factory _$AnnouncementEntityCopyWith(_AnnouncementEntity value, $Res Function(_AnnouncementEntity) _then) = __$AnnouncementEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? slug, String? category, String? summary, String? content, String? coverImage, List<String> images, String? authorName, String? status, bool isPinned, int viewsCount, DateTime? publishedAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$AnnouncementEntityCopyWithImpl<$Res>
    implements _$AnnouncementEntityCopyWith<$Res> {
  __$AnnouncementEntityCopyWithImpl(this._self, this._then);

  final _AnnouncementEntity _self;
  final $Res Function(_AnnouncementEntity) _then;

/// Create a copy of AnnouncementEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? category = freezed,Object? summary = freezed,Object? content = freezed,Object? coverImage = freezed,Object? images = null,Object? authorName = freezed,Object? status = freezed,Object? isPinned = null,Object? viewsCount = null,Object? publishedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AnnouncementEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,viewsCount: null == viewsCount ? _self.viewsCount : viewsCount // ignore: cast_nullable_to_non_nullable
as int,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$AnnouncementPaginatedEntity {

 bool get success; int get total; int get currentPage; int get lastPage; int get perPage; List<AnnouncementEntity> get data; String? get message;
/// Create a copy of AnnouncementPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementPaginatedEntityCopyWith<AnnouncementPaginatedEntity> get copyWith => _$AnnouncementPaginatedEntityCopyWithImpl<AnnouncementPaginatedEntity>(this as AnnouncementPaginatedEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementPaginatedEntity&&(identical(other.success, success) || other.success == success)&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,success,total,currentPage,lastPage,perPage,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'AnnouncementPaginatedEntity(success: $success, total: $total, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $AnnouncementPaginatedEntityCopyWith<$Res>  {
  factory $AnnouncementPaginatedEntityCopyWith(AnnouncementPaginatedEntity value, $Res Function(AnnouncementPaginatedEntity) _then) = _$AnnouncementPaginatedEntityCopyWithImpl;
@useResult
$Res call({
 bool success, int total, int currentPage, int lastPage, int perPage, List<AnnouncementEntity> data, String? message
});




}
/// @nodoc
class _$AnnouncementPaginatedEntityCopyWithImpl<$Res>
    implements $AnnouncementPaginatedEntityCopyWith<$Res> {
  _$AnnouncementPaginatedEntityCopyWithImpl(this._self, this._then);

  final AnnouncementPaginatedEntity _self;
  final $Res Function(AnnouncementPaginatedEntity) _then;

/// Create a copy of AnnouncementPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? total = null,Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? data = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<AnnouncementEntity>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementPaginatedEntity].
extension AnnouncementPaginatedEntityPatterns on AnnouncementPaginatedEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementPaginatedEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementPaginatedEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementPaginatedEntity value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementPaginatedEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementPaginatedEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementPaginatedEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int total,  int currentPage,  int lastPage,  int perPage,  List<AnnouncementEntity> data,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementPaginatedEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int total,  int currentPage,  int lastPage,  int perPage,  List<AnnouncementEntity> data,  String? message)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementPaginatedEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int total,  int currentPage,  int lastPage,  int perPage,  List<AnnouncementEntity> data,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementPaginatedEntity() when $default != null:
return $default(_that.success,_that.total,_that.currentPage,_that.lastPage,_that.perPage,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _AnnouncementPaginatedEntity implements AnnouncementPaginatedEntity {
  const _AnnouncementPaginatedEntity({this.success = false, this.total = 0, this.currentPage = 1, this.lastPage = 1, this.perPage = 10, final  List<AnnouncementEntity> data = const [], this.message}): _data = data;
  

@override@JsonKey() final  bool success;
@override@JsonKey() final  int total;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int lastPage;
@override@JsonKey() final  int perPage;
 final  List<AnnouncementEntity> _data;
@override@JsonKey() List<AnnouncementEntity> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  String? message;

/// Create a copy of AnnouncementPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementPaginatedEntityCopyWith<_AnnouncementPaginatedEntity> get copyWith => __$AnnouncementPaginatedEntityCopyWithImpl<_AnnouncementPaginatedEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementPaginatedEntity&&(identical(other.success, success) || other.success == success)&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,success,total,currentPage,lastPage,perPage,const DeepCollectionEquality().hash(_data),message);

@override
String toString() {
  return 'AnnouncementPaginatedEntity(success: $success, total: $total, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementPaginatedEntityCopyWith<$Res> implements $AnnouncementPaginatedEntityCopyWith<$Res> {
  factory _$AnnouncementPaginatedEntityCopyWith(_AnnouncementPaginatedEntity value, $Res Function(_AnnouncementPaginatedEntity) _then) = __$AnnouncementPaginatedEntityCopyWithImpl;
@override @useResult
$Res call({
 bool success, int total, int currentPage, int lastPage, int perPage, List<AnnouncementEntity> data, String? message
});




}
/// @nodoc
class __$AnnouncementPaginatedEntityCopyWithImpl<$Res>
    implements _$AnnouncementPaginatedEntityCopyWith<$Res> {
  __$AnnouncementPaginatedEntityCopyWithImpl(this._self, this._then);

  final _AnnouncementPaginatedEntity _self;
  final $Res Function(_AnnouncementPaginatedEntity) _then;

/// Create a copy of AnnouncementPaginatedEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? total = null,Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? data = null,Object? message = freezed,}) {
  return _then(_AnnouncementPaginatedEntity(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<AnnouncementEntity>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
