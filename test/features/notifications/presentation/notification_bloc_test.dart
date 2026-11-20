import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_count_entity.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_page_entity.dart';
import 'package:akar/features/notifications/domain/repositories/notification_repository.dart';
import 'package:akar/features/notifications/domain/usecases/get_notification_count_usecase.dart';
import 'package:akar/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:akar/features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:akar/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:akar/features/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeNotificationRepository implements NotificationRepository {
  Future<Either<Failure, AppNotificationPageEntity>> Function({
    int page,
    int perPage,
    bool unreadOnly,
  })?
  onGetNotifications;

  Future<Either<Failure, AppNotificationCountEntity>> Function()?
  onGetNotificationCount;

  Future<Either<Failure, void>> Function(String id)? onMarkAsRead;

  Future<Either<Failure, void>> Function()? onMarkAllAsRead;

  @override
  Future<Either<Failure, AppNotificationPageEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
  }) {
    return onGetNotifications!(
      page: page,
      perPage: perPage,
      unreadOnly: unreadOnly,
    );
  }

  @override
  Future<Either<Failure, AppNotificationCountEntity>> getNotificationCount() {
    return onGetNotificationCount!();
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) {
    return onMarkAsRead!(id);
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() {
    return onMarkAllAsRead!();
  }
}

AppNotificationEntity _sampleNotification(
  String id, {
  String kind = 'jaga_tanah_escalation_l1',
  NotificationSeverity severity = NotificationSeverity.warning,
  DateTime? readAt,
}) {
  return AppNotificationEntity(
    id: id,
    type: kind,
    kind: kind,
    severity: severity,
    title: 'Notifikasi $id',
    body: 'Detail untuk $id',
    escalationLevel: kind.contains('escalation') ? 'L1' : null,
    readAt: readAt,
    createdAt: DateTime(2026, 11, 20, 9),
  );
}

void main() {
  late _FakeNotificationRepository repository;
  late NotificationBloc bloc;

  setUp(() {
    repository = _FakeNotificationRepository();
    bloc = NotificationBloc(
      getNotifications: GetNotificationsUsecase(repository),
      getNotificationCount: GetNotificationCountUsecase(repository),
      markNotificationRead: MarkNotificationReadUsecase(repository),
      markAllNotificationsRead: MarkAllNotificationsReadUsecase(repository),
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  group('NotificationBloc', () {
    test(
      'FetchNotificationCountEvent updates counts while preserving items',
      () async {
        repository.onGetNotifications =
            ({int page = 1, int perPage = 20, bool unreadOnly = false}) async =>
                Right(
                  AppNotificationPageEntity(
                    items: [_sampleNotification('n1')],
                    unreadCount: 1,
                    escalationUnreadCount: 1,
                    currentPage: 1,
                    lastPage: 1,
                    total: 1,
                  ),
                );
        repository.onGetNotificationCount = () async => const Right(
          AppNotificationCountEntity(
            unreadCount: 5,
            escalationUnreadCount: 2,
            totalCount: 11,
          ),
        );

        bloc.add(const FetchNotificationsEvent());
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>((s) => s.items.length == 1),
          ),
        );

        bloc.add(const FetchNotificationCountEvent());
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>(
              (s) =>
                  s.unreadCount == 5 &&
                  s.escalationUnreadCount == 2 &&
                  s.totalCount == 11 &&
                  s.items.length == 1,
            ),
          ),
        );
      },
    );

    test(
      'LoadMoreNotificationsEvent appends deduplicated page 2 items',
      () async {
        repository.onGetNotifications =
            ({int page = 1, int perPage = 20, bool unreadOnly = false}) async {
              if (page == 1) {
                return Right(
                  AppNotificationPageEntity(
                    items: [
                      _sampleNotification('n1'),
                      _sampleNotification('n2'),
                    ],
                    unreadCount: 2,
                    currentPage: 1,
                    lastPage: 2,
                    total: 3,
                  ),
                );
              }
              return Right(
                AppNotificationPageEntity(
                  items: [_sampleNotification('n2'), _sampleNotification('n3')],
                  unreadCount: 2,
                  currentPage: 2,
                  lastPage: 2,
                  total: 3,
                ),
              );
            };

        bloc.add(const FetchNotificationsEvent());
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>((s) => s.items.length == 2),
          ),
        );

        bloc.add(const LoadMoreNotificationsEvent());
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>(
              (s) =>
                  !s.isLoadingMore &&
                  s.currentPage == 2 &&
                  !s.hasMore &&
                  listEquals(s.items.map((e) => e.id).toList(), const [
                    'n1',
                    'n2',
                    'n3',
                  ]),
            ),
          ),
        );
      },
    );

    test(
      'MarkNotificationReadEvent updates optimistically and rolls back on failure',
      () async {
        repository.onGetNotifications =
            ({int page = 1, int perPage = 20, bool unreadOnly = false}) async =>
                Right(
                  AppNotificationPageEntity(
                    items: [_sampleNotification('n1')],
                    unreadCount: 2,
                    escalationUnreadCount: 1,
                  ),
                );

        final markCompleter = Completer<Either<Failure, void>>();
        repository.onMarkAsRead = (_) => markCompleter.future;

        bloc.add(const FetchNotificationsEvent());
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>((s) => s.items.length == 1),
          ),
        );

        bloc.add(const MarkNotificationReadEvent('n1'));
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>(
              (s) =>
                  s.items.single.isRead &&
                  s.unreadCount == 1 &&
                  s.escalationUnreadCount == 0,
            ),
          ),
        );

        markCompleter.complete(
          const Left(ServerFailure('Server sibuk', statusCode: 500)),
        );
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>(
              (s) =>
                  s.items.single.isUnread &&
                  s.unreadCount == 2 &&
                  s.escalationUnreadCount == 1 &&
                  s.actionErrorMessage == 'Server sibuk',
            ),
          ),
        );
      },
    );

    test(
      'MarkAllNotificationsReadEvent marks all items read and clears unreadOnly list',
      () async {
        repository.onGetNotifications =
            ({int page = 1, int perPage = 20, bool unreadOnly = false}) async =>
                Right(
                  AppNotificationPageEntity(
                    items: [
                      _sampleNotification('n1'),
                      _sampleNotification('n2'),
                    ],
                    unreadCount: 2,
                    escalationUnreadCount: 1,
                  ),
                );
        repository.onMarkAllAsRead = () async => const Right(null);

        bloc.add(const FetchNotificationsEvent(unreadOnly: true));
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>(
              (s) => s.unreadOnlyFilter && s.items.length == 2,
            ),
          ),
        );

        bloc.add(const MarkAllNotificationsReadEvent());
        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NotificationState>(
              (s) =>
                  !s.isMarkingAllRead &&
                  s.unreadCount == 0 &&
                  s.escalationUnreadCount == 0 &&
                  s.items.isEmpty,
            ),
          ),
        );
      },
    );

    test(
      'ResetNotificationsEvent drops in-flight response and resets state',
      () async {
        final completer =
            Completer<Either<Failure, AppNotificationPageEntity>>();
        repository.onGetNotifications =
            ({int page = 1, int perPage = 20, bool unreadOnly = false}) =>
                completer.future;

        bloc.add(const FetchNotificationsEvent());
        await expectLater(
          bloc.stream,
          emitsThrough(predicate<NotificationState>((s) => s.isLoading)),
        );

        bloc.add(const ResetNotificationsEvent());
        await expectLater(bloc.stream, emitsThrough(const NotificationState()));

        completer.complete(
          Right(
            AppNotificationPageEntity(
              items: [_sampleNotification('stale')],
              unreadCount: 9,
            ),
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(bloc.state, const NotificationState());
      },
    );
  });
}
