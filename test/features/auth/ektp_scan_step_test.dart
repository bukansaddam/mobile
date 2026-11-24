import 'dart:io';

import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/auth/presentation/widgets/ektp_scan_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildStep({
  File? photo,
  bool isScanning = false,
  bool disableAnimations = false,
  ThemeData? theme,
}) {
  return MaterialApp(
    theme: theme ?? AppTheme.lightTheme,
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(320, 640),
        disableAnimations: disableAnimations,
      ),
      child: Scaffold(
        body: EktpScanStep(
          entrance: const AlwaysStoppedAnimation(1.0),
          photo: photo,
          onClearPhoto: () {},
          isScanning: isScanning,
        ),
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

  testWidgets(
    'isScanning menampilkan overlay status, menyembunyikan hapus foto, dan aman di layar sempit dark/light',
    (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.binding.setSurfaceSize(const Size(320, 640));
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;

      final fakeFile = File('nonexistent_preview.jpg');

      await tester.pumpWidget(
        _buildStep(
          photo: fakeFile,
          isScanning: true,
          disableAnimations: true,
          theme: AppTheme.darkTheme,
        ),
      );
      await tester.pump();

      expect(find.text('Memindai data e-KTP...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byTooltip('Hapus foto'), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        _buildStep(
          photo: fakeFile,
          isScanning: false,
          disableAnimations: true,
          theme: AppTheme.lightTheme,
        ),
      );
      await tester.pump();

      expect(find.text('Memindai data e-KTP...'), findsNothing);
      expect(find.byTooltip('Hapus foto'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
