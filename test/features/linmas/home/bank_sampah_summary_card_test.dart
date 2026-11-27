import 'package:akar/features/linmas/home/presentation/widgets/bank_sampah_summary_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets(
    'BankSampahSummaryCard memusatkan baris Lihat Detail di antara divider dan tepi bawah kartu',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(480, 640));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: BankSampahSummaryCard(
                userName: 'Agus Sunandar',
                userPhone: '081234567892',
                totalBeratKg: 20,
                totalNilaiRupiah: 40000,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      final cardRect = tester.getRect(find.byType(BankSampahSummaryCard));
      final dividerRect = tester.getRect(find.byType(Divider));
      final detailRowRect = tester.getRect(
        find.descendant(of: find.byType(InkWell), matching: find.byType(Row)),
      );

      final topGap = detailRowRect.top - dividerRect.bottom;
      // Container menggunakan Border.all default 1.0 px di tepi luar kartu.
      final innerBottomGap = (cardRect.bottom - 1.0) - detailRowRect.bottom;

      expect(topGap, 14.0);
      expect(innerBottomGap, topGap);

      await tester.binding.setSurfaceSize(null);
    },
  );
}
