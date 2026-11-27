import 'package:akar/core/services/app_update_service.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/core/widgets/app_update_dialog.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubAppUpdateService extends AppUpdateService {
  final AppUpdateInfo? infoToReturn;
  final List<String> dismissedVersions = [];

  _StubAppUpdateService({required this.infoToReturn}) : super.forTesting();

  @override
  Future<AppUpdateInfo?> checkForUpdate() async => infoToReturn;

  @override
  Future<void> dismissOptionalUpdate(String version) async {
    dismissedVersions.add(version);
  }
}

void main() {
  const optionalInfo = AppUpdateInfo(
    platform: 'android',
    currentVersion: '1.0.0',
    latestVersion: '1.1.0',
    minVersion: '1.0.0',
    isMustUpdate: false,
    downloadUrl: 'https://akaraslinmas.id/download/android',
  );

  const forceInfo = AppUpdateInfo(
    platform: 'android',
    currentVersion: '1.0.0',
    latestVersion: '1.2.0',
    minVersion: '1.1.0',
    isMustUpdate: true,
    downloadUrl: 'https://akaraslinmas.id/download/android',
  );

  Widget buildHost({
    required ThemeData theme,
    required void Function(BuildContext context) onTrigger,
  }) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => onTrigger(context),
              child: const Text('Trigger'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'optional update dialog shows version, dismisses on Nanti, and records cooldown',
    (tester) async {
      String? dismissed;
      Uri? launchedUri;

      await tester.pumpWidget(
        buildHost(
          theme: AppTheme.lightTheme,
          onTrigger: (context) {
            AppUpdateDialog.show(
              context,
              info: optionalInfo,
              onDismissOptional: (v) async => dismissed = v,
              urlLauncher: (uri) async {
                launchedUri = uri;
                return true;
              },
            );
          },
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Pembaruan Aplikasi Tersedia'), findsOneWidget);
      expect(find.text('v1.0.0 -> v1.1.0'), findsOneWidget);
      expect(find.text('Perbarui Sekarang'), findsOneWidget);
      expect(find.text('Nanti'), findsOneWidget);
      expect(launchedUri, isNull);

      await tester.tap(find.text('Nanti'));
      await tester.pumpAndSettle();

      expect(dismissed, '1.1.0');
      expect(find.text('Pembaruan Aplikasi Tersedia'), findsNothing);
    },
  );

  testWidgets(
    'force update dialog hides Nanti, blocks dismiss, and stays open after launching URL',
    (tester) async {
      Uri? launchedUri;

      await tester.pumpWidget(
        buildHost(
          theme: AppTheme.darkTheme,
          onTrigger: (context) {
            AppUpdateDialog.show(
              context,
              info: forceInfo,
              onDismissOptional: (_) async {},
              urlLauncher: (uri) async {
                launchedUri = uri;
                return true;
              },
            );
          },
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Pembaruan Wajib Diperlukan'), findsOneWidget);
      expect(find.text('v1.0.0 -> v1.2.0'), findsOneWidget);
      expect(find.text('Perbarui Sekarang'), findsOneWidget);
      expect(find.text('Nanti'), findsNothing);

      // Tapping outside scrim must NOT dismiss
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Pembaruan Wajib Diperlukan'), findsOneWidget);

      // Tapping Perbarui Sekarang launches URL and keeps force dialog open
      await tester.tap(find.text('Perbarui Sekarang'));
      await tester.pumpAndSettle();
      expect(
        launchedUri,
        Uri.parse('https://akaraslinmas.id/download/android'),
      );
      expect(find.text('Pembaruan Wajib Diperlukan'), findsOneWidget);
    },
  );

  testWidgets(
    'checkAndShow avoids duplicate dialogs and calls dismissOptionalUpdate on Nanti',
    (tester) async {
      final stubService = _StubAppUpdateService(infoToReturn: optionalInfo);

      await tester.pumpWidget(
        buildHost(
          theme: AppTheme.lightTheme,
          onTrigger: (context) {
            AppUpdateDialog.checkAndShow(context, service: stubService);
            AppUpdateDialog.checkAndShow(context, service: stubService);
          },
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Pembaruan Aplikasi Tersedia'), findsOneWidget);

      await tester.tap(find.text('Nanti'));
      await tester.pumpAndSettle();

      expect(stubService.dismissedVersions, ['1.1.0']);
    },
  );
}
