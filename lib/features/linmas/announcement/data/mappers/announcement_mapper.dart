import 'package:akar/features/linmas/announcement/data/models/announcement_model.dart';
import 'package:akar/features/linmas/announcement/domain/entities/announcement_entity.dart';

export 'package:akar/features/linmas/announcement/domain/entities/announcement_entity.dart';

extension AnnouncementModelMapper on AnnouncementModel {
  AnnouncementEntity toDomain() {
    return AnnouncementEntity(
      id: id,
      title: title,
      slug: slug,
      category: category,
      summary: summary,
      content: content,
      coverImage: coverImage,
      images: images ?? [],
      authorName: authorName,
      status: status,
      isPinned: isPinned,
      viewsCount: viewsCount ?? 0,
      publishedAt: publishedAt != null ? DateTime.tryParse(publishedAt!) : null,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}

extension AnnouncementEntityMapper on AnnouncementEntity {
  AnnouncementModel toModel() {
    return AnnouncementModel(
      id: id,
      title: title,
      slug: slug,
      category: category,
      summary: summary,
      content: content,
      coverImage: coverImage,
      images: images,
      authorName: authorName,
      status: status,
      isPinned: isPinned,
      viewsCount: viewsCount,
      publishedAt: publishedAt?.toIso8601String(),
      createdAt: createdAt?.toIso8601String(),
      updatedAt: updatedAt?.toIso8601String(),
    );
  }
}

extension AnnouncementResponseModelMapper on AnnouncementResponseModel {
  AnnouncementPaginatedEntity toDomain() {
    return AnnouncementPaginatedEntity(
      success: success,
      total: total,
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      data: data.map((model) => model.toDomain()).toList(),
      message: message,
    );
  }
}

extension AnnouncementPaginatedEntityMapper on AnnouncementPaginatedEntity {
  AnnouncementResponseModel toModel() {
    return AnnouncementResponseModel(
      success: success,
      total: total,
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      data: data.map((entity) => entity.toModel()).toList(),
      message: message,
    );
  }
}
