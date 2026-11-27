import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeFirebaseMessaging extends Fake implements FirebaseMessaging {}

class _FakeLocalNotificationsPlugin extends Fake
    implements FlutterLocalNotificationsPlugin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'handleRouting with kind=offline_queue opens PendingQueueBottomSheet',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final service = FirebaseNotificationService(
        prefs: prefs,
        fcm: _FakeFirebaseMessaging(),
        localNotifications: _FakeLocalNotificationsPlugin(),
      );

      final router = GoRouter(
        navigatorKey: AppRouter.rootNavigatorKey,
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
      );
      await tester.pumpAndSettle();

      service.handleRouting({'kind': 'offline_queue'});
      await tester.pumpAndSettle();

      expect(find.text('Antrean Laporan Offline'), findsOneWidget);

      router.dispose();
    },
  );
}
