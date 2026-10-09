import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';
import 'package:flutter/material.dart';

class RondaSuccessDialog {
  RondaSuccessDialog._();

  static Future<void> show(
    BuildContext context, {
    required RondaLaporanEntity? result,
    required VoidCallback onDismiss,
  }) {
    return AppDialogs.showSuccess(
      context,
      title: 'Laporan Harian Berhasil Terkirim!',
      message:
          'Laporan harian Anda telah tersimpan. Terima kasih atas partisipasi siaga lingkungan.',
      buttonText: 'KEMBALI KE HALAMAN UTAMA',
      onPressed: onDismiss,
    );
  }
}
