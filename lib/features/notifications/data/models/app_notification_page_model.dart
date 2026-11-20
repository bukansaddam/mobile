import 'package:akar/features/notifications/data/models/app_notification_model.dart';
import 'package:akar/features/notifications/data/models/notification_json_utils.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_page_entity.dart';

/// DTO model respons paginasi dari `GET /api/notifications`.
class AppNotificationPageModel extends AppNotificationPageEntity {
  const AppNotificationPageModel({
    super.items,
    super.unreadCount,
    super.escalationUnreadCount,
    super.currentPage,
    super.lastPage,
    super.perPage,
    super.total,
  });

  factory AppNotificationPageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['data'];
    final items = <AppNotificationEntity>[];
    if (rawItems is List) {
      for (final entry in rawItems) {
        final itemMap = notificationAsMap(entry);
        if (itemMap.isNotEmpty) {
          items.add(AppNotificationModel.fromJson(itemMap));
        }
      }
    }

    final meta = notificationAsMap(json['meta'] ?? json['pagination']);

    return AppNotificationPageModel(
      items: items,
      unreadCount: notificationAsInt(
        json['unreadCount'] ?? json['unread_count'],
      ),
      escalationUnreadCount: notificationAsInt(
        json['escalationUnreadCount'] ?? json['escalation_unread_count'],
      ),
      currentPage: notificationAsInt(
        meta['current_page'] ?? meta['currentPage'],
        fallback: 1,
      ),
      lastPage: notificationAsInt(
        meta['last_page'] ?? meta['lastPage'],
        fallback: 1,
      ),
      perPage: notificationAsInt(
        meta['per_page'] ?? meta['perPage'],
        fallback: 20,
      ),
      total: notificationAsInt(meta['total'], fallback: items.length),
    );
  }
}
