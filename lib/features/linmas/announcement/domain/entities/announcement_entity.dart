import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_entity.freezed.dart';

@freezed
abstract class AnnouncementEntity with _$AnnouncementEntity {
  const AnnouncementEntity._();

  const factory AnnouncementEntity({
    required int id,
    required String title,
    String? slug,
    String? category,
    String? summary,
    String? content,
    String? coverImage,
    @Default([]) List<String> images,
    String? authorName,
    String? status,
    @Default(false) bool isPinned,
    @Default(0) int viewsCount,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AnnouncementEntity;

  String get subtitle => summary ?? '';

  String get author => authorName ?? 'Admin';

  String get date {
    final dtUtc = publishedAt ?? createdAt;
    if (dtUtc == null) return '';
    final dt = dtUtc.toLocal();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(dt.year, dt.month, dt.day);
    final diffDays = today.difference(itemDate).inDays;

    if (diffDays <= 0) {
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else if (diffDays == 1) {
      return 'Kemarin';
    } else {
      return '${diffDays}d ago';
    }
  }

  List<String> get allImages {
    final list = <String>[];
    if (coverImage != null && coverImage!.isNotEmpty) {
      list.add(coverImage!);
    }
    for (final img in images) {
      if (img.isNotEmpty && !list.contains(img)) {
        list.add(img);
      }
    }
    return list;
  }

  bool get hasImage => allImages.isNotEmpty;

  bool get isPenting => isPinned;
}

typedef AnnouncementItem = AnnouncementEntity;

@freezed
abstract class AnnouncementPaginatedEntity with _$AnnouncementPaginatedEntity {
  const factory AnnouncementPaginatedEntity({
    @Default(false) bool success,
    @Default(0) int total,
    @Default(1) int currentPage,
    @Default(1) int lastPage,
    @Default(10) int perPage,
    @Default([]) List<AnnouncementEntity> data,
    String? message,
  }) = _AnnouncementPaginatedEntity;
}
