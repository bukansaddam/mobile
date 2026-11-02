import 'package:akar/features/auth/presentation/widgets/ektp_scan_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildStep() {
  return MaterialApp(
    home: Scaffold(
      body: EktpScanStep(
        entrance: const AlwaysStoppedAnimation(1.0),
        photo: null,
        onClearPhoto: () {},
      ),
    ),
  );
}

void main() {
  testWidgets('langkah foto menampilkan panduan tanpa tombol aksi', (
    tester,
  ) async {
    await tester.pumpWidget(_buildStep());

    expect(find.text('REPUBLIK INDONESIA'), findsOneWidget);
    expect(
      find.text('Foto e-KTP wajib diambil untuk melanjutkan pendaftaran'),
      findsOneWidget,
    );
    expect(find.text('Ambil Gambar'), findsNothing);
    expect(find.text('Kembali'), findsNothing);
  });
}
