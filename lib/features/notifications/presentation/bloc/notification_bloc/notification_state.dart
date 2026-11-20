part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final List<AppNotificationEntity> items;
  final int unreadCount;
  final int escalationUnreadCount;
  final int totalCount;
  final int currentPage;
  final int lastPage;
  final bool unreadOnlyFilter;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isMarkingAllRead;
  final bool hasLoadedOnce;
  final String? errorMessage;
  final String? actionErrorMessage;

  const NotificationState({
    this.items = const [],
    this.unreadCount = 0,
    this.escalationUnreadCount = 0,
    this.totalCount = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.unreadOnlyFilter = false,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isMarkingAllRead = false,
    this.hasLoadedOnce = false,
    this.errorMessage,
    this.actionErrorMessage,
  });

  bool get hasMore => currentPage < lastPage;

  NotificationState copyWith({
    List<AppNotificationEntity>? items,
    int? unreadCount,
    int? escalationUnreadCount,
    int? totalCount,
    int? currentPage,
    int? lastPage,
    bool? unreadOnlyFilter,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isMarkingAllRead,
    bool? hasLoadedOnce,
    String? errorMessage,
    String? actionErrorMessage,
    bool clearErrorMessage = false,
    bool clearActionError = false,
  }) {
    return NotificationState(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      escalationUnreadCount:
          escalationUnreadCount ?? this.escalationUnreadCount,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      unreadOnlyFilter: unreadOnlyFilter ?? this.unreadOnlyFilter,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      actionErrorMessage: clearActionError
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    items,
    unreadCount,
    escalationUnreadCount,
    totalCount,
    currentPage,
    lastPage,
    unreadOnlyFilter,
    isLoading,
    isRefreshing,
    isLoadingMore,
    isMarkingAllRead,
    hasLoadedOnce,
    errorMessage,
    actionErrorMessage,
  ];
}
