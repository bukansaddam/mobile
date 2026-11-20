part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotificationCountEvent extends NotificationEvent {
  const FetchNotificationCountEvent();
}

class FetchNotificationsEvent extends NotificationEvent {
  final bool isRefresh;
  final bool? unreadOnly;

  const FetchNotificationsEvent({this.isRefresh = false, this.unreadOnly});

  @override
  List<Object?> get props => [isRefresh, unreadOnly];
}

class LoadMoreNotificationsEvent extends NotificationEvent {
  const LoadMoreNotificationsEvent();
}

class MarkNotificationReadEvent extends NotificationEvent {
  final String id;

  const MarkNotificationReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllNotificationsReadEvent extends NotificationEvent {
  const MarkAllNotificationsReadEvent();
}

class ClearNotificationActionErrorEvent extends NotificationEvent {
  const ClearNotificationActionErrorEvent();
}

class ResetNotificationsEvent extends NotificationEvent {
  const ResetNotificationsEvent();
}
