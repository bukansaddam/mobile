import 'package:equatable/equatable.dart';

/// Ringkasan jumlah notifikasi belum dibaca untuk badge AppBar.
class AppNotificationCountEntity extends Equatable {
  final int unreadCount;
  final int escalationUnreadCount;
  final int totalCount;

  const AppNotificationCountEntity({
    this.unreadCount = 0,
    this.escalationUnreadCount = 0,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [unreadCount, escalationUnreadCount, totalCount];
}
