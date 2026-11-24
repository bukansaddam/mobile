import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_completed_view.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_illustration.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_notice_strip.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_seamless_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _CorruptPermissionAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    if (key.startsWith('assets/permissions/')) {
      return Future<ByteData>.value(ByteData(0));
    }
    return rootBundle.load(key);
  }
}

void main() {
  group('PermissionSeamlessBackground', () {
    testWidgets(
      'renders vertical LinearGradient matching SplashScreen and WelcomeScreen in Light and Dark themes',
      (tester) async {
        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          await tester.pumpWidget(
            MaterialApp(
              key: ValueKey(theme.brightness),
              theme: theme,
              home: const Scaffold(
                body: SizedBox.expand(child: PermissionSeamlessBackground()),
              ),
            ),
          );
          await tester.pump();

          final backgroundFinder = find.byType(PermissionSeamlessBackground);
          final context = tester.element(backgroundFinder);
          final colors = context.appColors;

          final decoratedBox = tester.widget<DecoratedBox>(
            find.descendant(
              of: backgroundFinder,
              matching: find.byType(DecoratedBox),
            ),
          );
          final decoration = decoratedBox.decoration as BoxDecoration;
          final gradient = decoration.gradient as LinearGradient;
          expect(gradient.begin, equals(Alignment.topCenter));
          expect(gradient.end, equals(Alignment.bottomCenter));
          expect(
            gradient.colors,
            equals([
              colors.primaryLight,
              colors.surfaceVariant,
              colors.isDark ? colors.background : colors.surface,
            ]),
          );
          expect(gradient.stops, equals([0.0, 0.45, 1.0]));
        }
      },
    );
  });

  group('PermissionIllustration', () {
    test('assetPathFor maps all 5 AppPermissionType values exhaustively', () {
      expect(
        PermissionIllustration.assetPathFor(
          AppPermissionType.locationWhenInUse,
        ),
        equals('assets/permissions/permission_location.png'),
      );
      expect(
        PermissionIllustration.assetPathFor(AppPermissionType.locationAlways),
        equals('assets/permissions/permission_location_always.png'),
      );
      expect(
        PermissionIllustration.assetPathFor(AppPermissionType.camera),
        equals('assets/permissions/permission_camera.png'),
      );
      expect(
        PermissionIllustration.assetPathFor(AppPermissionType.microphone),
        equals('assets/permissions/permission_microphone.png'),
      );
      expect(
        PermissionIllustration.assetPathFor(AppPermissionType.notification),
        equals('assets/permissions/permission_notification.png'),
      );
    });

    testWidgets(
      'renders cleanly for every AppPermissionType with bounded cacheHeight in Light and Dark themes',
      (tester) async {
        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          for (final type in AppPermissionType.values) {
            await tester.pumpWidget(
              MaterialApp(
                key: ValueKey('${theme.brightness}_$type'),
                theme: theme,
                home: Scaffold(
                  body: Center(
                    child: PermissionIllustration(type: type, height: 180),
                  ),
                ),
              ),
            );
            await tester.pump();

            expect(tester.takeException(), isNull);
            final imageWidget = tester.widget<Image>(find.byType(Image));
            final provider = imageWidget.image;
            expect(provider, isA<ResizeImage>());
            final resizeImage = provider as ResizeImage;
            expect(resizeImage.height, isNotNull);
            expect(resizeImage.height!, greaterThan(0));
            expect(resizeImage.height!, lessThanOrEqualTo(1024));
          }
        }
      },
    );

    testWidgets(
      'falls back cleanly to themed Material icon without crashing when asset is missing',
      (tester) async {
        await tester.pumpWidget(
          DefaultAssetBundle(
            bundle: _CorruptPermissionAssetBundle(),
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: const Scaffold(
                body: Center(
                  child: PermissionIllustration(
                    type: AppPermissionType.locationAlways,
                    height: 180,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
      },
    );
  });

  group('PermissionNoticeStrip', () {
    testWidgets(
      'info variant renders flat strip with colors.infoLight in Light and Dark Mode',
      (tester) async {
        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          await tester.pumpWidget(
            MaterialApp(
              key: ValueKey(theme.brightness),
              theme: theme,
              home: const Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(16),
                  child: PermissionNoticeStrip.info(message: 'Catatan 24/7'),
                ),
              ),
            ),
          );
          await tester.pump();

          final context = tester.element(find.byType(PermissionNoticeStrip));
          final colors = context.appColors;

          expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
          expect(find.text('Catatan 24/7'), findsOneWidget);

          final container = tester.widget<Container>(
            find.descendant(
              of: find.byType(PermissionNoticeStrip),
              matching: find.byType(Container),
            ),
          );
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.boxShadow, isNull);
          expect(decoration.color, equals(colors.infoLight));
        }
      },
    );

    testWidgets(
      'warning variant renders icon and message without overflow at 320px width and 2.0x text scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        addTearDown(() => tester.binding.setSurfaceSize(null));
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: PermissionNoticeStrip.warning(
                  icon: Icons.warning_amber_rounded,
                  message:
                      'Izin belum diberikan. Izinkan akses ini agar fitur aplikasi dapat berfungsi dengan baik.',
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
        expect(find.textContaining('Izin belum diberikan'), findsOneWidget);

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(PermissionNoticeStrip),
            matching: find.byType(Container),
          ),
        );
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.boxShadow, isNull);
      },
    );
  });

  group('PermissionCompletedView', () {
    testWidgets(
      'renders check icon and completion copy without any bordered or shadowed card',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: Center(child: PermissionCompletedView())),
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
        expect(find.text('Semua Izin Lengkap'), findsOneWidget);
        expect(find.text('Membuka halaman utama aplikasi...'), findsOneWidget);

        final decoratedBoxes = tester.widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(PermissionCompletedView),
            matching: find.byType(DecoratedBox),
          ),
        );
        for (final box in decoratedBoxes) {
          final decoration = box.decoration;
          if (decoration is BoxDecoration) {
            expect(decoration.border, isNull);
            expect(decoration.boxShadow, isNull);
          }
        }
      },
    );
  });
}
