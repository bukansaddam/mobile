import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/profile/presentation/widgets/profile_points_card.dart';
import 'package:akar/features/profile/presentation/widgets/profile_points_info_sheet.dart';

void main() {
  group('ProfilePointsCard & ProfilePointsInfoSheet Tests', () {
    testWidgets('renders 0 Poin and taps to open info sheet for citizen', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ProfilePointsCard(
                points: 0,
                isOfficer: false,
                onTap: () => ProfilePointsInfoSheet.show(
                  context,
                  points: 0,
                  isOfficer: false,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('0 Poin'), findsOneWidget);
      expect(
        find.text('Diperoleh dari laporan yang telah dibuat'),
        findsOneWidget,
      );

      await tester.tap(find.byType(ProfilePointsCard));
      await tester.pumpAndSettle();

      expect(find.text('Poin Laporan'), findsOneWidget);
      expect(find.text('Total Poin Saat Ini'), findsOneWidget);
      expect(
        find.textContaining('laporan pengaduan yang telah Anda buat'),
        findsOneWidget,
      );
      expect(find.text('Tersedia'), findsOneWidget);
    });

    testWidgets('formats thousands points and shows officer description', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ProfilePointsCard(
                points: 1250,
                isOfficer: true,
                onTap: () => ProfilePointsInfoSheet.show(
                  context,
                  points: 1250,
                  isOfficer: true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('1.250 Poin'), findsOneWidget);

      await tester.tap(find.byType(ProfilePointsCard));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('laporan tugas yang telah Anda buat'),
        findsOneWidget,
      );
      expect(find.text('Laporan Jaga Tanah'), findsOneWidget);
      expect(find.text('+10 Poin'), findsOneWidget);
      expect(find.text('Laporan Insidentil'), findsOneWidget);
      expect(find.text('+1 Poin'), findsOneWidget);
      expect(
        find.textContaining('setelah laporan diverifikasi'),
        findsWidgets,
      );
    });

    testWidgets('hides officer point breakdown on citizen sheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfilePointsInfoSheet(points: 50, isOfficer: false),
          ),
        ),
      );

      expect(find.text('Laporan Jaga Tanah'), findsNothing);
      expect(find.text('+10 Poin'), findsNothing);
      expect(find.text('Laporan Insidentil'), findsNothing);
      expect(find.text('+1 Poin'), findsNothing);
    });

    testWidgets(
      'renders officer breakdown cleanly on 320x640 at 2.5x text scale in Light and Dark Mode',
      (tester) async {
        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: const MediaQuery(
                data: MediaQueryData(
                  size: Size(320, 640),
                  textScaler: TextScaler.linear(2.5),
                ),
                child: Scaffold(
                  body: SizedBox(
                    width: 320,
                    child: ProfilePointsInfoSheet(
                      points: 1250,
                      isOfficer: true,
                    ),
                  ),
                ),
              ),
            ),
          );

          expect(find.text('Laporan Jaga Tanah'), findsOneWidget);
          expect(find.text('+10 Poin'), findsOneWidget);
          expect(find.text('Laporan Insidentil'), findsOneWidget);
          expect(find.text('+1 Poin'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      },
    );
  });
}
