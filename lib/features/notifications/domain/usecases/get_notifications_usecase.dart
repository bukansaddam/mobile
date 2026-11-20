import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_page_entity.dart';
import 'package:akar/features/notifications/domain/repositories/notification_repository.dart';

/// Mengambil daftar notifikasi in-app terpaginasi dari backend.
class GetNotificationsUsecase {
  final NotificationRepository _repository;

  const GetNotificationsUsecase(this._repository);

  Future<Either<Failure, AppNotificationPageEntity>> call({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
  }) {
    return _repository.getNotifications(
      page: page,
      perPage: perPage,
      unreadOnly: unreadOnly,
    );
  }
}
