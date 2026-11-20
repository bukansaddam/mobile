import 'package:dio/dio.dart';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/notifications/data/models/app_notification_count_model.dart';
import 'package:akar/features/notifications/data/models/app_notification_page_model.dart';
import 'package:akar/features/notifications/data/models/notification_json_utils.dart';
import 'package:akar/utils/app_logger.dart';

/// Kontrak data source jarak jauh untuk API notifikasi in-app.
abstract class NotificationRemoteDatasource {
  Future<AppNotificationPageModel> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
  });

  Future<AppNotificationCountModel> getNotificationCount();

  Future<void> markAsRead(String id);

  Future<void> markAllAsRead();
}

class NotificationRemoteDatasourceImpl extends BaseRemoteDataSource
    implements NotificationRemoteDatasource {
  final Dio? _dioOverride;

  NotificationRemoteDatasourceImpl({Dio? dio}) : _dioOverride = dio;

  @override
  Dio get dio => _dioOverride ?? super.dio;

  @override
  Future<AppNotificationPageModel> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.notifications,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (unreadOnly) 'unread_only': true,
        },
      );
      final body = notificationAsMap(response.data);
      final statusCode = response.statusCode ?? 200;
      if (statusCode < 200 || statusCode >= 300 || body['success'] == false) {
        final msg = ErrorUtils.parseErrorMessage(body);
        throw ServerException(
          msg.isNotEmpty ? msg : 'Gagal memuat daftar notifikasi',
          statusCode: statusCode,
        );
      }
      return AppNotificationPageModel.fromJson(body);
    } on DioException catch (e, s) {
      AppLogger.e(
        '[NOTIFICATION_DS] DioException in getNotifications: ${e.message}',
        e,
        s,
      );
      throw ErrorUtils.toAppException(
        e,
        fallbackMessage: 'Gagal memuat daftar notifikasi',
      );
    } catch (e, s) {
      AppLogger.e('[NOTIFICATION_DS] Error in getNotifications: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<AppNotificationCountModel> getNotificationCount() async {
    try {
      final response = await handleRequest<AppNotificationCountModel>(
        () => dio.get(ApiConstants.notificationsCount),
        fromJson: (json) =>
            AppNotificationCountModel.fromJson(notificationAsMap(json)),
      );
      if (!response.success) {
        throwResponseError(
          response,
          fallbackMessage: 'Gagal memuat jumlah notifikasi',
        );
      }
      return response.data ?? const AppNotificationCountModel();
    } catch (e, s) {
      AppLogger.e('[NOTIFICATION_DS] Error in getNotificationCount: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      final response = await handleRequest<void>(
        () => dio.patch(ApiConstants.notificationRead(id)),
      );
      if (!response.success) {
        throwResponseError(
          response,
          fallbackMessage: 'Gagal menandai notifikasi sebagai dibaca',
        );
      }
    } catch (e, s) {
      AppLogger.e('[NOTIFICATION_DS] Error in markAsRead($id): $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      final response = await handleRequest<void>(
        () => dio.post(ApiConstants.notificationsReadAll),
      );
      if (!response.success) {
        throwResponseError(
          response,
          fallbackMessage: 'Gagal menandai semua notifikasi sebagai dibaca',
        );
      }
    } catch (e, s) {
      AppLogger.e('[NOTIFICATION_DS] Error in markAllAsRead: $e', e, s);
      rethrow;
    }
  }
}
