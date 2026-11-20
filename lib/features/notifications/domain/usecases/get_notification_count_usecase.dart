import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_count_entity.dart';
import 'package:akar/features/notifications/domain/repositories/notification_repository.dart';

/// Mengambil ringkasan jumlah notifikasi belum dibaca untuk badge AppBar.
class GetNotificationCountUsecase {
  final NotificationRepository _repository;

  const GetNotificationCountUsecase(this._repository);

  Future<Either<Failure, AppNotificationCountEntity>> call() {
    return _repository.getNotificationCount();
  }
}
