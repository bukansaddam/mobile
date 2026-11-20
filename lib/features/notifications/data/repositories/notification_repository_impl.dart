import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_count_entity.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_page_entity.dart';
import 'package:akar/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource _remoteDatasource;

  const NotificationRepositoryImpl({
    required NotificationRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, AppNotificationPageEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final result = await _remoteDatasource.getNotifications(
        page: page,
        perPage: perPage,
        unreadOnly: unreadOnly,
      );
      return Right(result);
    } catch (e) {
      return Left(
        ErrorUtils.toFailure(
          e,
          fallbackMessage: 'Gagal memuat daftar notifikasi',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AppNotificationCountEntity>>
  getNotificationCount() async {
    try {
      final result = await _remoteDatasource.getNotificationCount();
      return Right(result);
    } catch (e) {
      return Left(
        ErrorUtils.toFailure(
          e,
          fallbackMessage: 'Gagal memuat jumlah notifikasi',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _remoteDatasource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(
        ErrorUtils.toFailure(
          e,
          fallbackMessage: 'Gagal menandai notifikasi sebagai dibaca',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remoteDatasource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(
        ErrorUtils.toFailure(
          e,
          fallbackMessage: 'Gagal menandai semua notifikasi sebagai dibaca',
        ),
      );
    }
  }
}
