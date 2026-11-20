import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_count_entity.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_page_entity.dart';

/// Kontrak repositori domain untuk fitur notifikasi in-app.
abstract class NotificationRepository {
  Future<Either<Failure, AppNotificationPageEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
  });

  Future<Either<Failure, AppNotificationCountEntity>> getNotificationCount();

  Future<Either<Failure, void>> markAsRead(String id);

  Future<Either<Failure, void>> markAllAsRead();
}
