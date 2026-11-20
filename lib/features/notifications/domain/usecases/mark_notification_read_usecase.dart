import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/notifications/domain/repositories/notification_repository.dart';

/// Menandai satu notifikasi sebagai sudah dibaca berdasarkan ID.
class MarkNotificationReadUsecase {
  final NotificationRepository _repository;

  const MarkNotificationReadUsecase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.markAsRead(id);
  }
}
