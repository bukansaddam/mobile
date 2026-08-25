import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_model.freezed.dart';
part 'announcement_model.g.dart';

Object? _readBool(Map json, String key) {
  final val = json[key];
  if (val is bool) return val;
  if (val is int) return val == 1;
  if (val is String) return val.toLowerCase() == 'true' || val == '1';
  return false;
}

@freezed
abstract class AnnouncementModel with _$AnnouncementModel {
  const AnnouncementModel._();

  const factory AnnouncementModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "slug") String? slug,
    @JsonKey(name: "category") String? category,
    @JsonKey(name: "summary") String? summary,
    @JsonKey(name: "content") String? content,
    @JsonKey(name: "cover_image") String? coverImage,
    @JsonKey(name: "images") List<String>? images,
    @JsonKey(name: "author_name") String? authorName,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "is_pinned", readValue: _readBool) @Default(false) bool isPinned,
    @JsonKey(name: "views_count") int? viewsCount,
    @JsonKey(name: "published_at") String? publishedAt,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);
}

@freezed
abstract class AnnouncementResponseModel with _$AnnouncementResponseModel {
  const AnnouncementResponseModel._();

  const factory AnnouncementResponseModel({
    @JsonKey(name: "success") @Default(false) bool success,
    @JsonKey(name: "total") @Default(0) int total,
    @JsonKey(name: "current_page") @Default(1) int currentPage,
    @JsonKey(name: "last_page") @Default(1) int lastPage,
    @JsonKey(name: "per_page") @Default(10) int perPage,
    @JsonKey(name: "data") @Default([]) List<AnnouncementModel> data,
    @JsonKey(name: "message") String? message,
  }) = _AnnouncementResponseModel;

  factory AnnouncementResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementResponseModelFromJson(json);
}
