// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnnouncementModel _$AnnouncementModelFromJson(Map<String, dynamic> json) =>
    _AnnouncementModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String?,
      category: json['category'] as String?,
      summary: json['summary'] as String?,
      content: json['content'] as String?,
      coverImage: json['cover_image'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      authorName: json['author_name'] as String?,
      status: json['status'] as String?,
      isPinned: _readBool(json, 'is_pinned') as bool? ?? false,
      viewsCount: (json['views_count'] as num?)?.toInt(),
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$AnnouncementModelToJson(_AnnouncementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'category': instance.category,
      'summary': instance.summary,
      'content': instance.content,
      'cover_image': instance.coverImage,
      'images': instance.images,
      'author_name': instance.authorName,
      'status': instance.status,
      'is_pinned': instance.isPinned,
      'views_count': instance.viewsCount,
      'published_at': instance.publishedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_AnnouncementResponseModel _$AnnouncementResponseModelFromJson(
  Map<String, dynamic> json,
) => _AnnouncementResponseModel(
  success: json['success'] as bool? ?? false,
  total: (json['total'] as num?)?.toInt() ?? 0,
  currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
  lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
  perPage: (json['per_page'] as num?)?.toInt() ?? 10,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  message: json['message'] as String?,
);

Map<String, dynamic> _$AnnouncementResponseModelToJson(
  _AnnouncementResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'total': instance.total,
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'data': instance.data,
  'message': instance.message,
};
