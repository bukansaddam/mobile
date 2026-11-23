import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/widgets/app_bar_circle_button.dart';
import 'package:akar/core/widgets/app_logo_badge.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppBarCircleButton Widget Tests', () {
    testWidgets('renders default back button with chevron_left and 48x48 tap area', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppBarCircleButton.back(onPressed: () => tapped = true),
          ),
        ),
      );

      final iconFinder = find.byIcon(Icons.chevron_left_rounded);
      expect(iconFinder, findsOneWidget);

      final sizeBoxFinder = find.byType(SizedBox).first;
      final renderBox = tester.renderObject<RenderBox>(sizeBoxFinder);
      expect(renderBox.size.width, 48.0);
      expect(renderBox.size.height, 48.0);

      await tester.tap(iconFinder);
      expect(tapped, isTrue);
    });

    testWidgets('handles active state with primary background and white icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppBarCircleButton(
              icon: Icons.tune_rounded,
              isActive: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.tune_rounded));
      expect(icon.color, AppColors.white);
    });

    testWidgets('handles disabled state when onPressed is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppBarCircleButton(
              icon: Icons.chevron_left_rounded,
              onPressed: null,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.chevron_left_rounded));
      expect(icon.color, AppColors.textDisabled);
    });
  });

  group('AppPageBar Widget Tests', () {
    testWidgets('renders centered title and back button by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppPageBar(title: 'Detail Pengaduan'),
            body: SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text('Detail Pengaduan'), findsOneWidget);
      expect(find.byType(AppBarCircleButton), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });

    testWidgets('renders no back button when showBackButton is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppPageBar(
              title: 'Survey Profil Baseline Linmas',
              showBackButton: false,
            ),
            body: SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text('Survey Profil Baseline Linmas'), findsOneWidget);
      expect(find.byType(AppBarCircleButton), findsNothing);
    });

    testWidgets('calculates preferredSize correctly with bottom widget', (
      tester,
    ) async {
      const pageBar = AppPageBar(
        title: 'Demografi',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: SizedBox(height: 48),
        ),
      );

      expect(pageBar.preferredSize.height, kToolbarHeight + 48);
    });

    testWidgets('renders without overflow at 320x640 with 200% text scale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: Scaffold(
              appBar: AppPageBar(title: 'Detail Laporan Jaga Tanah'),
              body: SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Detail Laporan Jaga Tanah'), findsOneWidget);
    });
  });

  group('CustomAppBar.linmas Widget Tests', () {
    testWidgets('renders linmas brand logo and custom subtitle', (tester) async {
      bool logoTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar.linmas(
              onLogoTap: () => logoTapped = true,
              showNotificationButton: false,
            ),
            body: const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text(AppConstants.appBarTitle), findsOneWidget);
      expect(find.text('Laporan Linmas'), findsOneWidget);
      expect(find.byType(AppLogoBadge), findsOneWidget);

      await tester.tap(find.byType(GestureDetector).first);
      expect(logoTapped, isTrue);
    });
  });
}
