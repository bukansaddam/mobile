import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    });
  });
}
