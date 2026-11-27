import 'dart:math' as math;

import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:akar/features/notifications/domain/usecases/get_notification_count_usecase.dart';
import 'package:akar/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:akar/features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:akar/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  static const int _perPage = 20;

  final GetNotificationsUsecase _getNotifications;
  final GetNotificationCountUsecase _getNotificationCount;
  final MarkNotificationReadUsecase _markNotificationRead;
  final MarkAllNotificationsReadUsecase _markAllNotificationsRead;

  int _sessionGeneration = 0;
  int _fetchGeneration = 0;

  NotificationBloc({
    required this._getNotifications,
    required this._getNotificationCount,
    required this._markNotificationRead,
    required this._markAllNotificationsRead,
  }) : super(const NotificationState()) {
    on<FetchNotificationCountEvent>(_onFetchCount);
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<LoadMoreNotificationsEvent>(_onLoadMore);
    on<MarkNotificationReadEvent>(_onMarkRead);
    on<MarkAllNotificationsReadEvent>(_onMarkAllRead);
    on<ClearNotificationActionErrorEvent>(_onClearActionError);
    on<ResetNotificationsEvent>(_onReset);
  }

  Future<void> _onFetchCount(
    FetchNotificationCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final sessionGen = _sessionGeneration;
    final result = await _getNotificationCount();
    if (sessionGen != _sessionGeneration) return;

    result.fold(
      (failure) => AppLogger.w(
        '[NOTIFICATION_BLOC] Gagal memuat count: ${failure.message}',
      ),
      (count) => emit(
        state.copyWith(
          unreadCount: count.unreadCount,
          escalationUnreadCount: count.escalationUnreadCount,
          totalCount: count.totalCount,
        ),
      ),
    );
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final sessionGen = _sessionGeneration;
    final fetchGen = ++_fetchGeneration;
    final effectiveUnreadOnly = event.unreadOnly ?? state.unreadOnlyFilter;
    final filterChanged = effectiveUnreadOnly != state.unreadOnlyFilter;

    emit(
      state.copyWith(
        unreadOnlyFilter: effectiveUnreadOnly,
        items: filterChanged ? const [] : state.items,
        isLoading: !event.isRefresh || state.items.isEmpty || filterChanged,
        isRefreshing: event.isRefresh,
        clearErrorMessage: true,
        clearActionError: true,
      ),
    );

    final result = await _getNotifications(
      page: 1,
      perPage: _perPage,
      unreadOnly: effectiveUnreadOnly,
    );

    if (sessionGen != _sessionGeneration || fetchGen != _fetchGeneration) {
      return;
    }

    result.fold(
      (failure) {
        if (state.items.isEmpty) {
          emit(
            state.copyWith(
              isLoading: false,
              isRefreshing: false,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              isRefreshing: false,
              actionErrorMessage: failure.message,
            ),
          );
        }
      },
      (page) => emit(
        state.copyWith(
          items: page.items,
          unreadCount: page.unreadCount,
          escalationUnreadCount: page.escalationUnreadCount,
          currentPage: page.currentPage,
          lastPage: page.lastPage,
          totalCount: page.total,
          isLoading: false,
          isRefreshing: false,
          hasLoadedOnce: true,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    final sessionGen = _sessionGeneration;
    final fetchGen = _fetchGeneration;
    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingMore: true, clearActionError: true));

    final result = await _getNotifications(
      page: nextPage,
      perPage: _perPage,
      unreadOnly: state.unreadOnlyFilter,
    );

    if (sessionGen != _sessionGeneration || fetchGen != _fetchGeneration) {
      return;
    }

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          actionErrorMessage: failure.message,
        ),
      ),
      (page) {
        final existingIds = {for (final item in state.items) item.id};
        final merged = [
          ...state.items,
          ...page.items.where((item) => !existingIds.contains(item.id)),
        ];
        emit(
          state.copyWith(
            items: merged,
            unreadCount: page.unreadCount,
            escalationUnreadCount: page.escalationUnreadCount,
            currentPage: page.currentPage,
            lastPage: page.lastPage,
            totalCount: page.total,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> _onMarkRead(
    MarkNotificationReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final index = state.items.indexWhere((item) => item.id == event.id);
    if (index == -1) return;

    final target = state.items[index];
    if (target.isRead) return;

    final sessionGen = _sessionGeneration;
    final previousItems = state.items;
    final previousUnread = state.unreadCount;
    final previousEscalationUnread = state.escalationUnreadCount;

    final updatedItems = List<AppNotificationEntity>.from(state.items);
    updatedItems[index] = target.copyWith(readAt: DateTime.now());

    emit(
      state.copyWith(
        items: updatedItems,
        unreadCount: math.max(0, previousUnread - 1),
        escalationUnreadCount: target.isEscalation
            ? math.max(0, previousEscalationUnread - 1)
            : previousEscalationUnread,
        clearActionError: true,
      ),
    );

    final result = await _markNotificationRead(event.id);
    if (sessionGen != _sessionGeneration) return;

    result.fold((failure) {
      if (failure.statusCode == 404) return;
      emit(
        state.copyWith(
          items: previousItems,
          unreadCount: previousUnread,
          escalationUnreadCount: previousEscalationUnread,
          actionErrorMessage: failure.message,
        ),
      );
    }, (_) {});
  }

  Future<void> _onMarkAllRead(
    MarkAllNotificationsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final hasAnyUnread =
        state.unreadCount > 0 || state.items.any((item) => item.isUnread);
    if (state.isMarkingAllRead || !hasAnyUnread) return;

    final sessionGen = _sessionGeneration;
    emit(state.copyWith(isMarkingAllRead: true, clearActionError: true));

    final result = await _markAllNotificationsRead();
    if (sessionGen != _sessionGeneration) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isMarkingAllRead: false,
          actionErrorMessage: failure.message,
        ),
      ),
      (_) {
        final now = DateTime.now();
        final updatedItems = state.unreadOnlyFilter
            ? const <AppNotificationEntity>[]
            : state.items
                  .map(
                    (item) => item.isRead ? item : item.copyWith(readAt: now),
                  )
                  .toList();
        emit(
          state.copyWith(
            items: updatedItems,
            unreadCount: 0,
            escalationUnreadCount: 0,
            isMarkingAllRead: false,
          ),
        );
      },
    );
  }

  void _onClearActionError(
    ClearNotificationActionErrorEvent event,
    Emitter<NotificationState> emit,
  ) {
    if (state.actionErrorMessage == null) return;
    emit(state.copyWith(clearActionError: true));
  }

  void _onReset(
    ResetNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) {
    _sessionGeneration++;
    _fetchGeneration++;
    emit(const NotificationState());
  }
}
