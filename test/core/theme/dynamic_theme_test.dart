import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/core/theme/bloc/theme_bloc.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/theme_mode_selector_tile.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/notification/presentation/widgets/emergency_disaster_dialog.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_empty_view.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_error_view.dart';
import 'package:akar/features/profile/presentation/widgets/profile_points_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestAudioAlarmService extends Fake implements AudioAlarmService {
  @override
  bool get isPlaying => false;
}

void main() {
  double contrastRatio(Color a, Color b) {
    final l1 = a.computeLuminance();
    final l2 = b.computeLuminance();
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  group('AppColorScheme Contrast & Tokens', () {
    test(
      'meets WCAG AA 4.5:1 across all Light Mode text and semantic pairs',
      () {
        const c = AppColorScheme.light;
        final pairs = <(String, Color, Color)>[
          ('textPrimary on background', c.textPrimary, c.background),
          ('textPrimary on surface', c.textPrimary, c.surface),
          ('textSecondary on surface', c.textSecondary, c.surface),
          ('textMuted on surface', c.textMuted, c.surface),
          ('primaryDark on surface', c.primaryDark, c.surface),
          ('primaryDark on primaryLight', c.primaryDark, c.primaryLight),
          ('success on surface', c.success, c.surface),
          ('warningDark on warningLight', c.warningDark, c.warningLight),
          ('error on surface', c.error, c.surface),
          ('errorDark on errorLight', c.errorDark, c.errorLight),
          ('onErrorSolid on errorSolid', c.onErrorSolid, c.errorSolid),
          ('info on surface', c.info, c.surface),
        ];

        for (final (name, fg, bg) in pairs) {
          expect(
            contrastRatio(fg, bg),
            greaterThanOrEqualTo(4.5),
            reason: '$name below 4.5:1',
          );
        }

        // Bold/large button label on Light primary (#0D8E34) meets >= 3.0:1 AA large text.
        expect(
          contrastRatio(c.onPrimary, c.primary),
          greaterThanOrEqualTo(3.0),
        );
      },
    );

    test(
      'meets WCAG AA 4.5:1 across all Dark Mode text and semantic pairs',
      () {
        const c = AppColorScheme.dark;
        final pairs = <(String, Color, Color)>[
          ('textPrimary on background', c.textPrimary, c.background),
          ('textPrimary on surface', c.textPrimary, c.surface),
          ('textSecondary on surface', c.textSecondary, c.surface),
          ('textMuted on surface', c.textMuted, c.surface),
          ('textMuted on background', c.textMuted, c.background),
          ('primary on background', c.primary, c.background),
          ('primary on surface', c.primary, c.surface),
          ('onPrimary on primary', c.onPrimary, c.primary),
          ('primaryDark on primaryLight', c.primaryDark, c.primaryLight),
          ('success on surface', c.success, c.surface),
          ('success on successLight', c.success, c.successLight),
          ('warning on surface', c.warning, c.surface),
          ('warningDark on warningLight', c.warningDark, c.warningLight),
          ('error on surface', c.error, c.surface),
          ('errorDark on errorLight', c.errorDark, c.errorLight),
          ('onErrorSolid on errorSolid', c.onErrorSolid, c.errorSolid),
          ('info on surface', c.info, c.surface),
          ('info on infoLight', c.info, c.infoLight),
          ('indigo on surface', c.indigo, c.surface),
          ('orange on surface', c.orange, c.surface),
          ('emerald on surface', c.emerald, c.surface),
          ('earth on surface', c.earth, c.surface),
        ];

        for (final (name, fg, bg) in pairs) {
          expect(
            contrastRatio(fg, bg),
            greaterThanOrEqualTo(4.5),
            reason: '$name below 4.5:1',
          );
        }
      },
    );

    test('supports copyWith and lerp smoothly between light and dark', () {
      const light = AppColorScheme.light;
      const dark = AppColorScheme.dark;

      expect(light.lerp(dark, 0.0).background, light.background);
      expect(light.lerp(dark, 1.0).background, dark.background);

      final mid = light.lerp(dark, 0.5);
      expect(
        mid.background,
        Color.lerp(light.background, dark.background, 0.5),
      );

      final copied = light.copyWith(primary: const Color(0xFF123456));
      expect(copied.primary, const Color(0xFF123456));
      expect(copied.surface, light.surface);
    });
  });

  group('AppTheme Light & Dark Registration', () {
    test(
      'registers AppColorScheme, button/FAB themes, and status bar style',
      () {
        final light = AppTheme.lightTheme;
        final dark = AppTheme.darkTheme;

        expect(light.extension<AppColorScheme>(), AppColorScheme.light);
        expect(dark.extension<AppColorScheme>(), AppColorScheme.dark);

        expect(
          dark.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          AppColorScheme.dark.primary,
        );
        expect(
          dark.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
          AppColorScheme.dark.onPrimary,
        );
        expect(
          dark.filledButtonTheme.style?.backgroundColor?.resolve({}),
          AppColorScheme.dark.primary,
        );
        expect(
          dark.floatingActionButtonTheme.backgroundColor,
          AppColorScheme.dark.primary,
        );
        expect(
          dark.floatingActionButtonTheme.foregroundColor,
          AppColorScheme.dark.onPrimary,
        );

        expect(
          light.appBarTheme.systemOverlayStyle?.statusBarIconBrightness,
          Brightness.dark,
        );
        expect(
          dark.appBarTheme.systemOverlayStyle?.statusBarIconBrightness,
          Brightness.light,
        );
      },
    );

    testWidgets(
      'context.appColors resolves with and without AppColorScheme extension',
      (tester) async {
        late AppColorScheme capturedWithExt;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Builder(
              builder: (context) {
                capturedWithExt = context.appColors;
                return const SizedBox();
              },
            ),
          ),
        );
        expect(capturedWithExt, AppColorScheme.dark);

        late AppColorScheme capturedFallback;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (context) {
                capturedFallback = context.appColors;
                return const SizedBox();
              },
            ),
          ),
        );
        expect(capturedFallback, AppColorScheme.dark);
      },
    );
  });

  group('ThemeBloc Persistence', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'defaults to ThemeMode.system and persists changes synchronously',
      () async {
        SharedPreferences.setMockInitialValues({});
        var prefs = await SharedPreferences.getInstance();
        final bloc = ThemeBloc(sharedPreferences: prefs);

        expect(bloc.state.themeMode, ThemeMode.system);

        bloc.add(const ChangeThemeModeEvent(ThemeMode.dark));
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state.themeMode, ThemeMode.dark);
        expect(prefs.getString(ThemeBloc.themeModeKey), 'dark');

        // New instance restores persisted value immediately in initial state.
        prefs = await SharedPreferences.getInstance();
        final restoredBloc = ThemeBloc(sharedPreferences: prefs);
        expect(restoredBloc.state.themeMode, ThemeMode.dark);

        restoredBloc.add(const ChangeThemeModeEvent(ThemeMode.light));
        await Future<void>.delayed(Duration.zero);
        expect(restoredBloc.state.themeMode, ThemeMode.light);
        expect(prefs.getString(ThemeBloc.themeModeKey), 'light');

        restoredBloc.add(const ChangeThemeModeEvent(ThemeMode.system));
        await Future<void>.delayed(Duration.zero);
        expect(restoredBloc.state.themeMode, ThemeMode.system);
        expect(prefs.getString(ThemeBloc.themeModeKey), 'system');

        await bloc.close();
        await restoredBloc.close();
      },
    );
  });

  group('ThemeModeSelectorTile & Dark Core Widgets', () {
    testWidgets(
      'displays current ThemeMode label, opens sheet, and dispatches ChangeThemeModeEvent',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final themeBloc = ThemeBloc(sharedPreferences: prefs);
        addTearDown(themeBloc.close);

        await tester.pumpWidget(
          BlocProvider<ThemeBloc>.value(
            value: themeBloc,
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return MaterialApp(
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: state.themeMode,
                  home: const Scaffold(
                    body: Padding(
                      padding: EdgeInsets.all(16),
                      child: ThemeModeSelectorTile(),
                    ),
                  ),
                );
              },
            ),
          ),
        );

        expect(find.text('Tema Tampilan'), findsOneWidget);
        expect(find.text('Ikuti Sistem'), findsOneWidget);

        await tester.tap(find.byType(ThemeModeSelectorTile));
        await tester.pumpAndSettle();

        expect(find.text('Pilih Tema Tampilan'), findsOneWidget);
        expect(find.text('Gelap'), findsOneWidget);
        expect(find.text('Terang'), findsOneWidget);

        await tester.tap(find.text('Gelap'));
        await tester.pumpAndSettle();

        expect(themeBloc.state.themeMode, ThemeMode.dark);
        expect(find.text('Gelap'), findsOneWidget);
      },
    );

    testWidgets(
      'AppDialogs floating surface uses AppColorScheme.dark surface in Dark Mode',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      AppDialogs.showSuccess<void>(
                        context,
                        title: 'Tersimpan',
                        message: 'Tema gelap aktif.',
                      );
                    },
                    child: const Text('Buka'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Buka'));
        await tester.pumpAndSettle();

        final surface = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('Tersimpan'),
                matching: find.byWidgetPredicate((widget) {
                  if (widget is! Container) return false;
                  final decoration = widget.decoration;
                  return decoration is BoxDecoration &&
                      decoration.borderRadius == BorderRadius.circular(32);
                }),
              )
              .first,
        );
        final dec = surface.decoration! as BoxDecoration;
        expect(dec.color, AppColorScheme.dark.surface);
        expect(
          tester.widget<Text>(find.text('Tersimpan')).style?.color,
          AppColorScheme.dark.textPrimary,
        );
      },
    );

    testWidgets(
      'NotificationEmptyView, NotificationErrorView, and ProfilePointsCard '
      'resolve AppColorScheme.dark tokens in Dark Mode',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: Column(
                children: [
                  const Expanded(
                    child: NotificationEmptyView(unreadOnlyFilter: false),
                  ),
                  Expanded(
                    child: NotificationErrorView(
                      message: 'Koneksi terputus',
                      onRetry: () {},
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: ProfilePointsCard(points: 1250),
                  ),
                ],
              ),
            ),
          ),
        );

        final emptyTitle = tester.widget<Text>(
          find.text('Belum ada notifikasi'),
        );
        expect(emptyTitle.style?.color, AppColorScheme.dark.textPrimary);

        final errorTitle = tester.widget<Text>(
          find.text('Gagal memuat notifikasi'),
        );
        expect(errorTitle.style?.color, AppColorScheme.dark.textPrimary);

        final pointsMaterial = tester.widget<Material>(
          find
              .descendant(
                of: find.byType(ProfilePointsCard),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(pointsMaterial.color, AppColorScheme.dark.surface);
      },
    );

    test('ComplaintStatus.resolveTextColor and resolveBgColor use AppColorScheme tokens in Dark Mode', () {
      const dark = AppColorScheme.dark;
      expect(ComplaintStatus.received.resolveTextColor(dark), dark.info);
      expect(ComplaintStatus.received.resolveBgColor(dark), dark.infoLight);
      expect(ComplaintStatus.pending.resolveTextColor(dark), dark.warning);
      expect(ComplaintStatus.pending.resolveBgColor(dark), dark.warningLight);
      expect(ComplaintStatus.verified.resolveTextColor(dark), dark.info);
      expect(ComplaintStatus.rejected.resolveTextColor(dark), dark.error);
      expect(ComplaintStatus.inProgress.resolveTextColor(dark), dark.orange);
      expect(ComplaintStatus.completed.resolveTextColor(dark), dark.success);
      expect(
        ComplaintStatus.cancelled.resolveBgColor(dark),
        dark.surfaceElevated,
      );
    });

    testWidgets(
      'EmergencyDisasterDialog uses AppColorScheme.dark surface, errorSolid header, and high-contrast Saya Aman button',
      (tester) async {
        if (sl.isRegistered<AudioAlarmService>()) {
          await sl.unregister<AudioAlarmService>();
        }
        sl.registerSingleton<AudioAlarmService>(_TestAudioAlarmService());
        addTearDown(() async {
          if (sl.isRegistered<AudioAlarmService>()) {
            await sl.unregister<AudioAlarmService>();
          }
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: EmergencyDisasterDialog(
                event: DisasterAlertEvent(
                  id: 'ALT-DARK',
                  title: 'Peringatan Gempa',
                  type: 'Gempa Bumi',
                  description: 'Uji tema gelap',
                  location: 'Posko Utama',
                  severity: DisasterSeverity.critical,
                  timestamp: DateTime(2026, 11, 23, 15, 0),
                ),
              ),
            ),
          ),
        );

        final card = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('PERINGATAN DARURAT'),
                matching: find.byWidgetPredicate((widget) {
                  if (widget is! Container) return false;
                  final dec = widget.decoration;
                  return dec is BoxDecoration &&
                      dec.borderRadius == BorderRadius.circular(32);
                }),
              )
              .first,
        );
        final cardDec = card.decoration! as BoxDecoration;
        expect(cardDec.color, AppColorScheme.dark.surface);

        final headerText = tester.widget<Text>(find.text('PERINGATAN DARURAT'));
        expect(headerText.style?.color, AppColorScheme.dark.onErrorSolid);

        final safeLabel = tester.widget<Text>(find.text('Saya Aman'));
        expect(safeLabel.style?.color, AppColorScheme.dark.secondary);
      },
    );
  });
}
