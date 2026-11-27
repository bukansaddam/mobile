import 'dart:async';

import 'package:akar/core/widgets/app_bar_notification_button.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:akar/features/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:akar/features/notifications/presentation/pages/notification_page.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_detail_sheet.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_lifecycle_listener.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingNotificationBloc extends Fake implements NotificationBloc {
  _RecordingNotificationBloc([this._state = const NotificationState()]);

  NotificationState _state;
  final _controller = StreamController<NotificationState>.broadcast(sync: true);
  final List<NotificationEvent> events = [];

  @override
  NotificationState get state => _state;

  @override
  Stream<NotificationState> get stream => _controller.stream;

  @override
  bool get isClosed => _controller.isClosed;

  void emitState(NotificationState next) {
    _state = next;
    _controller.add(next);
  }

  @override
  void add(NotificationEvent event) {
    events.add(event);
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

class _MutableAuthBloc extends Fake implements AuthBloc {
  _MutableAuthBloc(this._state);

  AuthState _state;
  final _controller = StreamController<AuthState>.broadcast();

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => _controller.stream;

  void emitState(AuthState next) {
    _state = next;
    _controller.add(next);
  }

  @override
  void add(AuthEvent event) {}

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

AppNotificationEntity _buildItem({
  required String id,
  String kind = 'jaga_tanah_escalation_l1',
  NotificationSeverity severity = NotificationSeverity.warning,
  String title = 'Laporan Tanah Memerlukan Verifikasi',
  String body = 'Segera tinjau laporan di lapangan.',
  String? ticketNumber = 'JGT-261120001',
  String? escalationLevel = 'L1',
  DateTime? readAt,
}) {
  return AppNotificationEntity(
    id: id,
    type: kind,
    kind: kind,
    severity: severity,
    title: title,
    body: body,
    ticketNumber: ticketNumber,
    escalationLevel: escalationLevel,
    readAt: readAt,
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  );
}

void main() {
  group('NotificationPage & AppBarNotificationButton Widget Tests', () {
    testWidgets('shows loading shimmer then error view with retry button', (
      tester,
    ) async {
      final bloc = _RecordingNotificationBloc(
        const NotificationState(isLoading: true),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(
        BlocProvider<NotificationBloc>.value(
          value: bloc,
          child: const MaterialApp(home: NotificationPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(ReportCardShimmerList), findsOneWidget);
      expect(bloc.events.whereType<FetchNotificationsEvent>(), isNotEmpty);

      bloc.emitState(
        const NotificationState(
          isLoading: false,
          errorMessage: 'Koneksi timeout',
        ),
      );
      await tester.pump();

      expect(find.text('Gagal memuat notifikasi'), findsOneWidget);
      expect(find.text('Koneksi timeout'), findsOneWidget);

      await tester.tap(find.text('Coba Lagi'));
      await tester.pump();
      expect(
        bloc.events.whereType<FetchNotificationsEvent>().length,
        greaterThanOrEqualTo(2),
      );
    });

    testWidgets(
      'renders notifications without filter chips or mark-all icon and opens detail sheet on 320x640 @ 2x text scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 640));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final items = [
          _buildItem(id: 'n1'),
          _buildItem(
            id: 'n2',
            kind: 'announcement',
            severity: NotificationSeverity.normal,
            title: 'Pemeliharaan Sistem',
            body: 'Jadwal pemeliharaan malam ini pukul 23:00 WIB.',
            ticketNumber: null,
            escalationLevel: null,
            readAt: DateTime(2026, 11, 20),
          ),
        ];

        final bloc = _RecordingNotificationBloc(
          NotificationState(
            items: items,
            unreadCount: 1,
            escalationUnreadCount: 1,
            hasLoadedOnce: true,
          ),
        );
        addTearDown(bloc.close);

        await tester.pumpWidget(
          BlocProvider<NotificationBloc>.value(
            value: bloc,
            child: const MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
                child: NotificationPage(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Semua'), findsNothing);
        expect(find.textContaining('Belum Dibaca'), findsNothing);
        expect(find.text('L1'), findsNothing);
        expect(find.byIcon(Icons.done_all_rounded), findsNothing);
        expect(
          find.text('Laporan Tanah Memerlukan Verifikasi'),
          findsOneWidget,
        );
        expect(find.text('#JGT-261120001'), findsOneWidget);

        await tester.tap(find.text('Laporan Tanah Memerlukan Verifikasi'));
        await tester.pumpAndSettle();

        expect(
          bloc.events.whereType<MarkNotificationReadEvent>().any(
            (e) => e.id == 'n1',
          ),
          isTrue,
        );
        expect(find.byType(NotificationDetailSheet), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'shows unread empty state and renders cleanly on 800x1024 layout',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1024));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final bloc = _RecordingNotificationBloc(
          const NotificationState(unreadOnlyFilter: true, hasLoadedOnce: true),
        );
        addTearDown(bloc.close);

        await tester.pumpWidget(
          BlocProvider<NotificationBloc>.value(
            value: bloc,
            child: const MaterialApp(home: NotificationPage()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Tidak ada notifikasi belum dibaca'), findsOneWidget);
        expect(find.text('Muat Ulang'), findsNothing);
        await tester.tap(find.text('Tampilkan Semua Notifikasi'));
        await tester.pump();

        expect(
          bloc.events.whereType<FetchNotificationsEvent>().any(
            (e) => e.unreadOnly == false,
          ),
          isTrue,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('AppBarNotificationButton caps badge at 99+ and hides when 0', (
      tester,
    ) async {
      final bloc = _RecordingNotificationBloc(
        const NotificationState(unreadCount: 0),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(
        BlocProvider<NotificationBloc>.value(
          value: bloc,
          child: const MaterialApp(
            home: Scaffold(body: AppBarNotificationButton()),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('99+'), findsNothing);

      bloc.emitState(const NotificationState(unreadCount: 125));
      await tester.pump();

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets(
      'NotificationLifecycleListener syncs count on auth and foreground FCM, and resets on logout',
      (tester) async {
        final authBloc = _MutableAuthBloc(const AuthUnauthenticated());
        final notificationBloc = _RecordingNotificationBloc();
        final fcmController = StreamController<RemoteMessage>.broadcast();
        addTearDown(() async {
          await authBloc.close();
          await notificationBloc.close();
          await fcmController.close();
        });

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(value: authBloc),
              BlocProvider<NotificationBloc>.value(value: notificationBloc),
            ],
            child: MaterialApp(
              home: NotificationLifecycleListener(
                foregroundMessages: fcmController.stream,
                child: const SizedBox.shrink(),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(notificationBloc.events, isEmpty);

        authBloc.emitState(
          const AuthAuthenticated(
            token: 'token',
            user: UserEntity(id: 1, name: 'Budi', role: 'linmas'),
          ),
        );
        await tester.pump();
        expect(
          notificationBloc.events
              .whereType<FetchNotificationCountEvent>()
              .length,
          1,
        );

        fcmController.add(const RemoteMessage());
        await tester.pump();
        expect(
          notificationBloc.events
              .whereType<FetchNotificationCountEvent>()
              .length,
          2,
        );

        authBloc.emitState(const AuthUnauthenticated());
        await tester.pump();
        expect(
          notificationBloc.events.whereType<ResetNotificationsEvent>().length,
          1,
        );
      },
    );
  });
}
