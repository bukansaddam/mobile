import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/notifications/domain/repositories/notification_repository.dart';

/// Menandai seluruh notifikasi pengguna sebagai sudah dibaca.
class MarkAllNotificationsReadUsecase {
  final NotificationRepository _repository;

  const MarkAllNotificationsReadUsecase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.markAllAsRead();
  }
}
