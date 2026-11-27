import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/masyarakat/complaint/presentation/widgets/complaint_list_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ComplaintListWidget empty state interaktif tanpa overflow pada layar sempit dan skala teks 200%',
    (tester) async {
      var createTapped = false;

      for (final mediaData in [
        const MediaQueryData(size: Size(320, 640)),
        const MediaQueryData(
          size: Size(320, 640),
          textScaler: TextScaler.linear(2.0),
        ),
      ]) {
        await tester.binding.setSurfaceSize(const Size(320, 640));
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: MediaQuery(
              data: mediaData,
              child: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ComplaintListWidget(
                    items: const [],
                    onCreateTap: () => createTapped = true,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Belum Ada Pengaduan Saya'), findsOneWidget);
        expect(find.text('Buat Pengaduan'), findsOneWidget);
        final createButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(
          createButton.style?.backgroundColor?.resolve(<WidgetState>{}),
          AppColors.primary,
        );
        expect(find.byIcon(Icons.add_rounded), findsNothing);
        expect(find.text('Lihat Aduan Warga'), findsNothing);
      }

      await tester.ensureVisible(find.text('Buat Pengaduan'));
      await tester.tap(find.text('Buat Pengaduan'));
      await tester.pump();
      expect(createTapped, isTrue);

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'ComplaintListWidget menampilkan aksi Coba Lagi saat gagal muat',
    (tester) async {
      var refreshTapped = false;

      await tester.binding.setSurfaceSize(const Size(360, 640));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ComplaintListWidget(
                items: const [],
                isError: true,
                errorMessage: 'Koneksi terputus',
                onRefreshTap: () => refreshTapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Gagal Memuat Pengaduan'), findsOneWidget);
      expect(find.text('Koneksi terputus'), findsOneWidget);

      await tester.tap(find.text('Coba Lagi'));
      await tester.pump();
      expect(refreshTapped, isTrue);

      await tester.binding.setSurfaceSize(null);
    },
  );
}
