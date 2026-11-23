import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_status_view.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/widgets/laporan_insidentil_status_view.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_empty_view.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  double contrastRatio(Color a, Color b) {
    final l1 = a.computeLuminance();
    final l2 = b.computeLuminance();
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  group('AppColors Semantic Companion Tokens', () {
    test(
      'defines semantic companion error & warning tokens with AA contrast',
      () {
        expect(AppColors.errorDark, const Color(0xFF991B1B));
        expect(AppColors.errorBorder, const Color(0xFFFCA5A5));
        expect(AppColors.warningDark, const Color(0xFF92400E));
        expect(AppColors.warningBorder, const Color(0xFFFDE68A));

        expect(
          contrastRatio(AppColors.warningDark, AppColors.warningLight),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrastRatio(AppColors.errorDark, AppColors.errorLight),
          greaterThanOrEqualTo(4.5),
        );
      },
    );
  });

  group('AppTheme Unified Button & FAB Theme', () {
    test('aligns ElevatedButton, FilledButton, OutlinedButton, TextButton, and FAB to AppColors.primary', () {
      final theme = AppTheme.lightTheme;

      expect(
        theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        theme.filledButtonTheme.style?.backgroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.filledButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.textButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.floatingActionButtonTheme.backgroundColor,
        AppColors.primary,
      );
      expect(theme.floatingActionButtonTheme.foregroundColor, AppColors.white);
    });
  });

  group('Task 2 Primary CTA & Status Views Alignment', () {
    testWidgets(
      'NotificationEmptyView, NotificationErrorView, JagaTanahStatusView, and LaporanInsidentilStatusView use AppColors.primary',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationEmptyView(
                unreadOnlyFilter: true,
                onShowAll: () {},
              ),
            ),
          ),
        );
        final emptyBtn = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(emptyBtn.style?.backgroundColor?.resolve({}), AppColors.primary);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationErrorView(message: 'Gagal', onRetry: () {}),
            ),
          ),
        );
        final errorBtn = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(errorBtn.style?.backgroundColor?.resolve({}), AppColors.primary);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: JagaTanahStatusView(
                icon: Icons.landscape_rounded,
                iconColor: AppColors.primary,
                iconBackgroundColor: AppColors.primaryLight,
                title: 'Kosong',
                message: 'Belum ada data',
                actionLabel: 'Buat Laporan',
                onAction: () {},
              ),
            ),
          ),
        );
        final jgBtn = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(jgBtn.style?.backgroundColor?.resolve({}), AppColors.primary);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LaporanInsidentilStatusView(
                icon: Icons.report_problem_rounded,
                iconColor: AppColors.primary,
                iconBackgroundColor: AppColors.primaryLight,
                title: 'Kosong',
                message: 'Belum ada data',
                actionLabel: 'Coba Lagi',
                onAction: () {},
              ),
            ),
          ),
        );
        final liBtn = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(liBtn.style?.backgroundColor?.resolve({}), AppColors.primary);
      },
    );
  });
}
