import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/core/utils/report_point_policy.dart';
import 'package:akar/core/widgets/report_point_badge.dart';
import 'package:akar/core/widgets/report_point_banner_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child, {required ThemeData theme, double textScale = 1.0}) {
    return MaterialApp(
      theme: theme,
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(320, 640),
          textScaler: TextScaler.linear(textScale),
        ),
        child: Scaffold(
          body: SizedBox(width: 320, child: child),
        ),
      ),
    );
  }

  group('ReportPointBadge', () {
    testWidgets('renders +10 Poin in Light and Dark Mode without overflow', (
      tester,
    ) async {
      final info = ReportPointPolicy.resolve(
        category: ReportPointCategory.jagaTanah,
        statusCode: 'verified',
      );

      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        await tester.pumpWidget(
          wrap(
            ReportPointBadge(info: info, maxWidth: 110),
            theme: theme,
            textScale: 2.0,
          ),
        );
        expect(find.text('+10 Poin'), findsOneWidget);
        expect(find.byIcon(Icons.workspace_premium_rounded), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('ReportPointBannerStrip', () {
    testWidgets('renders earned, pending, and notEligible states cleanly', (
      tester,
    ) async {
      final states = [
        (
          info: ReportPointPolicy.resolve(
            category: ReportPointCategory.jagaTanah,
            statusCode: 'verified',
          ),
          expectedChip: '+10 Poin',
          expectedTitle: 'Poin diperoleh',
        ),
        (
          info: ReportPointPolicy.resolve(
            category: ReportPointCategory.laporanInsidentil,
            statusCode: 'verification',
          ),
          expectedChip: 'Potensi +1 Poin',
          expectedTitle: 'Menunggu verifikasi',
        ),
        (
          info: ReportPointPolicy.resolve(
            category: ReportPointCategory.jagaTanah,
            statusCode: 'rejected',
          ),
          expectedChip: '0 Poin',
          expectedTitle: 'Tidak memperoleh poin',
        ),
      ];

      for (final entry in states) {
        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          await tester.pumpWidget(
            wrap(
              Container(
                padding: const EdgeInsets.all(16),
                child: ReportPointBannerStrip(info: entry.info),
              ),
              theme: theme,
              textScale: 2.0,
            ),
          );

          expect(find.text(entry.expectedChip), findsOneWidget);
          expect(find.text(entry.expectedTitle), findsOneWidget);
          expect(entry.info.detailDescription.contains('—'), isFalse);
          expect(tester.takeException(), isNull);
        }
      }
    });
  });
}
