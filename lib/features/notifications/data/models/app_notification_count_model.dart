import 'package:akar/features/notifications/data/models/notification_json_utils.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_count_entity.dart';

/// DTO model ringkasan penghitung notifikasi dari `/api/notifications/count`.
class AppNotificationCountModel extends AppNotificationCountEntity {
  const AppNotificationCountModel({
    super.unreadCount,
    super.escalationUnreadCount,
    super.totalCount,
  });

  factory AppNotificationCountModel.fromJson(Map<String, dynamic> json) {
    final dataMap = notificationAsMap(json['data']);
    final source = dataMap.isNotEmpty ? dataMap : json;

    return AppNotificationCountModel(
      unreadCount: notificationAsInt(
        source['unreadCount'] ?? source['unread_count'],
      ),
      escalationUnreadCount: notificationAsInt(
        source['escalationUnreadCount'] ?? source['escalation_unread_count'],
      ),
      totalCount: notificationAsInt(
        source['totalCount'] ?? source['total_count'],
      ),
    );
  }
}
