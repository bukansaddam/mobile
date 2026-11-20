import 'package:equatable/equatable.dart';

import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';

/// Respons paginasi daftar notifikasi in-app beserta penghitung unread.
class AppNotificationPageEntity extends Equatable {
  final List<AppNotificationEntity> items;
  final int unreadCount;
  final int escalationUnreadCount;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const AppNotificationPageEntity({
    this.items = const [],
    this.unreadCount = 0,
    this.escalationUnreadCount = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 20,
    this.total = 0,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [
    items,
    unreadCount,
    escalationUnreadCount,
    currentPage,
    lastPage,
    perPage,
    total,
  ];
}
