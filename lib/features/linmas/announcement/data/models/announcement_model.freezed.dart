// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnnouncementModel {

@JsonKey(name: "id") int get id;@JsonKey(name: "title") String get title;@JsonKey(name: "slug") String? get slug;@JsonKey(name: "category") String? get category;@JsonKey(name: "summary") String? get summary;@JsonKey(name: "content") String? get content;@JsonKey(name: "cover_image") String? get coverImage;@JsonKey(name: "images") List<String>? get images;@JsonKey(name: "author_name") String? get authorName;@JsonKey(name: "status") String? get status;@JsonKey(name: "is_pinned", readValue: _readBool) bool get isPinned;@JsonKey(name: "views_count") int? get viewsCount;@JsonKey(name: "published_at") String? get publishedAt;@JsonKey(name: "created_at") String? get createdAt;@JsonKey(name: "updated_at") String? get updatedAt;
/// Create a copy of AnnouncementModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementModelCopyWith<AnnouncementModel> get copyWith => _$AnnouncementModelCopyWithImpl<AnnouncementModel>(this as AnnouncementModel, _$identity);

  /// Serializes this AnnouncementModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.category, category) || other.category == category)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.viewsCount, viewsCount) || other.viewsCount == viewsCount)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,slug,category,summary,content,coverImage,const DeepCollectionEquality().hash(images),authorName,status,isPinned,viewsCount,publishedAt,createdAt,updatedAt);

@override
String toString() {
  return 'AnnouncementModel(id: $id, title: $title, slug: $slug, category: $category, summary: $summary, content: $content, coverImage: $coverImage, images: $images, authorName: $authorName, status: $status, isPinned: $isPinned, viewsCount: $viewsCount, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AnnouncementModelCopyWith<$Res>  {
  factory $AnnouncementModelCopyWith(AnnouncementModel value, $Res Function(AnnouncementModel) _then) = _$AnnouncementModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "title") String title,@JsonKey(name: "slug") String? slug,@JsonKey(name: "category") String? category,@JsonKey(name: "summary") String? summary,@JsonKey(name: "content") String? content,@JsonKey(name: "cover_image") String? coverImage,@JsonKey(name: "images") List<String>? images,@JsonKey(name: "author_name") String? authorName,@JsonKey(name: "status") String? status,@JsonKey(name: "is_pinned", readValue: _readBool) bool isPinned,@JsonKey(name: "views_count") int? viewsCount,@JsonKey(name: "published_at") String? publishedAt,@JsonKey(name: "created_at") String? createdAt,@JsonKey(name: "updated_at") String? updatedAt
});




}
/// @nodoc
class _$AnnouncementModelCopyWithImpl<$Res>
    implements $AnnouncementModelCopyWith<$Res> {
  _$AnnouncementModelCopyWithImpl(this._self, this._then);

  final AnnouncementModel _self;
  final $Res Function(AnnouncementModel) _then;

/// Create a copy of AnnouncementModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? category = freezed,Object? summary = freezed,Object? content = freezed,Object? coverImage = freezed,Object? images = freezed,Object? authorName = freezed,Object? status = freezed,Object? isPinned = null,Object? viewsCount = freezed,Object? publishedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,viewsCount: freezed == viewsCount ? _self.viewsCount : viewsCount // ignore: cast_nullable_to_non_nullable
as int?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementModel].
extension AnnouncementModelPatterns on AnnouncementModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementModel value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "slug")  String? slug, @JsonKey(name: "category")  String? category, @JsonKey(name: "summary")  String? summary, @JsonKey(name: "content")  String? content, @JsonKey(name: "cover_image")  String? coverImage, @JsonKey(name: "images")  List<String>? images, @JsonKey(name: "author_name")  String? authorName, @JsonKey(name: "status")  String? status, @JsonKey(name: "is_pinned", readValue: _readBool)  bool isPinned, @JsonKey(name: "views_count")  int? viewsCount, @JsonKey(name: "published_at")  String? publishedAt, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "updated_at")  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "slug")  String? slug, @JsonKey(name: "category")  String? category, @JsonKey(name: "summary")  String? summary, @JsonKey(name: "content")  String? content, @JsonKey(name: "cover_image")  String? coverImage, @JsonKey(name: "images")  List<String>? images, @JsonKey(name: "author_name")  String? authorName, @JsonKey(name: "status")  String? status, @JsonKey(name: "is_pinned", readValue: _readBool)  bool isPinned, @JsonKey(name: "views_count")  int? viewsCount, @JsonKey(name: "published_at")  String? publishedAt, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "updated_at")  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "slug")  String? slug, @JsonKey(name: "category")  String? category, @JsonKey(name: "summary")  String? summary, @JsonKey(name: "content")  String? content, @JsonKey(name: "cover_image")  String? coverImage, @JsonKey(name: "images")  List<String>? images, @JsonKey(name: "author_name")  String? authorName, @JsonKey(name: "status")  String? status, @JsonKey(name: "is_pinned", readValue: _readBool)  bool isPinned, @JsonKey(name: "views_count")  int? viewsCount, @JsonKey(name: "published_at")  String? publishedAt, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "updated_at")  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementModel() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.category,_that.summary,_that.content,_that.coverImage,_that.images,_that.authorName,_that.status,_that.isPinned,_that.viewsCount,_that.publishedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnnouncementModel extends AnnouncementModel {
  const _AnnouncementModel({@JsonKey(name: "id") required this.id, @JsonKey(name: "title") required this.title, @JsonKey(name: "slug") this.slug, @JsonKey(name: "category") this.category, @JsonKey(name: "summary") this.summary, @JsonKey(name: "content") this.content, @JsonKey(name: "cover_image") this.coverImage, @JsonKey(name: "images") final  List<String>? images, @JsonKey(name: "author_name") this.authorName, @JsonKey(name: "status") this.status, @JsonKey(name: "is_pinned", readValue: _readBool) this.isPinned = false, @JsonKey(name: "views_count") this.viewsCount, @JsonKey(name: "published_at") this.publishedAt, @JsonKey(name: "created_at") this.createdAt, @JsonKey(name: "updated_at") this.updatedAt}): _images = images,super._();
  factory _AnnouncementModel.fromJson(Map<String, dynamic> json) => _$AnnouncementModelFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "title") final  String title;
@override@JsonKey(name: "slug") final  String? slug;
@override@JsonKey(name: "category") final  String? category;
@override@JsonKey(name: "summary") final  String? summary;
@override@JsonKey(name: "content") final  String? content;
@override@JsonKey(name: "cover_image") final  String? coverImage;
 final  List<String>? _images;
@override@JsonKey(name: "images") List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "author_name") final  String? authorName;
@override@JsonKey(name: "status") final  String? status;
@override@JsonKey(name: "is_pinned", readValue: _readBool) final  bool isPinned;
@override@JsonKey(name: "views_count") final  int? viewsCount;
@override@JsonKey(name: "published_at") final  String? publishedAt;
@override@JsonKey(name: "created_at") final  String? createdAt;
@override@JsonKey(name: "updated_at") final  String? updatedAt;

/// Create a copy of AnnouncementModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementModelCopyWith<_AnnouncementModel> get copyWith => __$AnnouncementModelCopyWithImpl<_AnnouncementModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.category, category) || other.category == category)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.viewsCount, viewsCount) || other.viewsCount == viewsCount)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,slug,category,summary,content,coverImage,const DeepCollectionEquality().hash(_images),authorName,status,isPinned,viewsCount,publishedAt,createdAt,updatedAt);

@override
String toString() {
  return 'AnnouncementModel(id: $id, title: $title, slug: $slug, category: $category, summary: $summary, content: $content, coverImage: $coverImage, images: $images, authorName: $authorName, status: $status, isPinned: $isPinned, viewsCount: $viewsCount, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementModelCopyWith<$Res> implements $AnnouncementModelCopyWith<$Res> {
  factory _$AnnouncementModelCopyWith(_AnnouncementModel value, $Res Function(_AnnouncementModel) _then) = __$AnnouncementModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "title") String title,@JsonKey(name: "slug") String? slug,@JsonKey(name: "category") String? category,@JsonKey(name: "summary") String? summary,@JsonKey(name: "content") String? content,@JsonKey(name: "cover_image") String? coverImage,@JsonKey(name: "images") List<String>? images,@JsonKey(name: "author_name") String? authorName,@JsonKey(name: "status") String? status,@JsonKey(name: "is_pinned", readValue: _readBool) bool isPinned,@JsonKey(name: "views_count") int? viewsCount,@JsonKey(name: "published_at") String? publishedAt,@JsonKey(name: "created_at") String? createdAt,@JsonKey(name: "updated_at") String? updatedAt
});




}
/// @nodoc
class __$AnnouncementModelCopyWithImpl<$Res>
    implements _$AnnouncementModelCopyWith<$Res> {
  __$AnnouncementModelCopyWithImpl(this._self, this._then);

  final _AnnouncementModel _self;
  final $Res Function(_AnnouncementModel) _then;

/// Create a copy of AnnouncementModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? category = freezed,Object? summary = freezed,Object? content = freezed,Object? coverImage = freezed,Object? images = freezed,Object? authorName = freezed,Object? status = freezed,Object? isPinned = null,Object? viewsCount = freezed,Object? publishedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AnnouncementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,viewsCount: freezed == viewsCount ? _self.viewsCount : viewsCount // ignore: cast_nullable_to_non_nullable
as int?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AnnouncementResponseModel {

@JsonKey(name: "success") bool get success;@JsonKey(name: "total") int get total;@JsonKey(name: "current_page") int get currentPage;@JsonKey(name: "last_page") int get lastPage;@JsonKey(name: "per_page") int get perPage;@JsonKey(name: "data") List<AnnouncementModel> get data;@JsonKey(name: "message") String? get message;
/// Create a copy of AnnouncementResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementResponseModelCopyWith<AnnouncementResponseModel> get copyWith => _$AnnouncementResponseModelCopyWithImpl<AnnouncementResponseModel>(this as AnnouncementResponseModel, _$identity);

  /// Serializes this AnnouncementResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,total,currentPage,lastPage,perPage,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'AnnouncementResponseModel(success: $success, total: $total, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $AnnouncementResponseModelCopyWith<$Res>  {
  factory $AnnouncementResponseModelCopyWith(AnnouncementResponseModel value, $Res Function(AnnouncementResponseModel) _then) = _$AnnouncementResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "total") int total,@JsonKey(name: "current_page") int currentPage,@JsonKey(name: "last_page") int lastPage,@JsonKey(name: "per_page") int perPage,@JsonKey(name: "data") List<AnnouncementModel> data,@JsonKey(name: "message") String? message
});




}
/// @nodoc
class _$AnnouncementResponseModelCopyWithImpl<$Res>
    implements $AnnouncementResponseModelCopyWith<$Res> {
  _$AnnouncementResponseModelCopyWithImpl(this._self, this._then);

  final AnnouncementResponseModel _self;
  final $Res Function(AnnouncementResponseModel) _then;

/// Create a copy of AnnouncementResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? total = null,Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? data = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<AnnouncementModel>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementResponseModel].
extension AnnouncementResponseModelPatterns on AnnouncementResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "total")  int total, @JsonKey(name: "current_page")  int currentPage, @JsonKey(name: "last_page")  int lastPage, @JsonKey(name: "per_page")  int perPage, @JsonKey(name: "data")  List<AnnouncementModel> data, @JsonKey(name: "message")  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementResponseModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "total")  int total, @JsonKey(name: "current_page")  int currentPage, @JsonKey(name: "last_page")  int lastPage, @JsonKey(name: "per_page")  int perPage, @JsonKey(name: "data")  List<AnnouncementModel> data, @JsonKey(name: "message")  String? message)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementResponseModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "total")  int total, @JsonKey(name: "current_page")  int currentPage, @JsonKey(name: "last_page")  int lastPage, @JsonKey(name: "per_page")  int perPage, @JsonKey(name: "data")  List<AnnouncementModel> data, @JsonKey(name: "message")  String? message)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementResponseModel() when $default != null:
return $default(_that.success,_that.total,_that.currentPage,_that.lastPage,_that.perPage,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnnouncementResponseModel extends AnnouncementResponseModel {
  const _AnnouncementResponseModel({@JsonKey(name: "success") this.success = false, @JsonKey(name: "total") this.total = 0, @JsonKey(name: "current_page") this.currentPage = 1, @JsonKey(name: "last_page") this.lastPage = 1, @JsonKey(name: "per_page") this.perPage = 10, @JsonKey(name: "data") final  List<AnnouncementModel> data = const [], @JsonKey(name: "message") this.message}): _data = data,super._();
  factory _AnnouncementResponseModel.fromJson(Map<String, dynamic> json) => _$AnnouncementResponseModelFromJson(json);

@override@JsonKey(name: "success") final  bool success;
@override@JsonKey(name: "total") final  int total;
@override@JsonKey(name: "current_page") final  int currentPage;
@override@JsonKey(name: "last_page") final  int lastPage;
@override@JsonKey(name: "per_page") final  int perPage;
 final  List<AnnouncementModel> _data;
@override@JsonKey(name: "data") List<AnnouncementModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: "message") final  String? message;

/// Create a copy of AnnouncementResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementResponseModelCopyWith<_AnnouncementResponseModel> get copyWith => __$AnnouncementResponseModelCopyWithImpl<_AnnouncementResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.total, total) || other.total == total)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,total,currentPage,lastPage,perPage,const DeepCollectionEquality().hash(_data),message);

@override
String toString() {
  return 'AnnouncementResponseModel(success: $success, total: $total, currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementResponseModelCopyWith<$Res> implements $AnnouncementResponseModelCopyWith<$Res> {
  factory _$AnnouncementResponseModelCopyWith(_AnnouncementResponseModel value, $Res Function(_AnnouncementResponseModel) _then) = __$AnnouncementResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "total") int total,@JsonKey(name: "current_page") int currentPage,@JsonKey(name: "last_page") int lastPage,@JsonKey(name: "per_page") int perPage,@JsonKey(name: "data") List<AnnouncementModel> data,@JsonKey(name: "message") String? message
});




}
/// @nodoc
class __$AnnouncementResponseModelCopyWithImpl<$Res>
    implements _$AnnouncementResponseModelCopyWith<$Res> {
  __$AnnouncementResponseModelCopyWithImpl(this._self, this._then);

  final _AnnouncementResponseModel _self;
  final $Res Function(_AnnouncementResponseModel) _then;

/// Create a copy of AnnouncementResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? total = null,Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? data = null,Object? message = freezed,}) {
  return _then(_AnnouncementResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<AnnouncementModel>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
