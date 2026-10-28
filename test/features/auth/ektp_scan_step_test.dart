import 'package:akar/features/auth/presentation/widgets/ektp_scan_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildStep({ValueChanged<String>? onContinue}) {
  return MaterialApp(
    home: Scaffold(
      body: EktpScanStep(
        entrance: const AlwaysStoppedAnimation(1.0),
        photo: null,
        onPhotoPicked: (_) {},
        onClearPhoto: () {},
        onContinue: onContinue ?? (_) {},
      ),
    ),
  );
}

void main() {
  testWidgets('foto e-KTP wajib sebelum lanjut ke formulir', (tester) async {
    await tester.pumpWidget(_buildStep());

    expect(find.text('Ambil Foto Sekarang'), findsOneWidget);
    expect(find.text('Unggah dari Galeri Foto'), findsOneWidget);
    expect(
      find.text('Foto e-KTP wajib diambil untuk melanjutkan pendaftaran'),
      findsOneWidget,
    );
    expect(find.text('Lanjut ke Data Kependudukan'), findsNothing);
    expect(find.text('Isi formulir secara manual tanpa e-KTP'), findsNothing);
  });
}
