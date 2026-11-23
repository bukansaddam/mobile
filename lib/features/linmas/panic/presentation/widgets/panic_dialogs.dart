import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';

class PanicDialogs {
  PanicDialogs._();

  static void showSuccessEmergencyDialog(
    BuildContext context, {
    required int notifiedMembersCount,
    required VoidCallback onDismiss,
  }) {
    final colors = context.appColors;
    final customContent = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active_rounded, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$notifiedMembersCount Anggota Menerima Notifikasi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: colors.primary,
                  ),
                ),
                Text(
                  'Seluruh tim terdekat sedang merespons dan menuju titik posisi Anda.',
                  style: TextStyle(fontSize: 11, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    AppDialogs.showSuccess(
      context,
      title: 'Permintaan Bantuan Terkirim!',
      message: 'Sinyal darurat (SOS) telah berhasil disiarkan secara serentak ke seluruh tim tanggap darurat terdekat.',
      customContent: customContent,
      buttonText: 'Mengerti',
      buttonColor: colors.primary,
      onPressed: onDismiss,
    );
  }

  static void showDeactivateEmergencyDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) async {
    await AppDialogs.showConfirmation(
      context,
      title: 'Matikan Sinyal SOS?',
      message: 'Apakah kondisi darurat Anda sudah selesai dan situasi telah aman?\n\nMenonaktifkan SOS akan memperbarui status Anda menjadi normal (is_emergency: false) di server.',
      confirmText: 'Ya, Matikan SOS',
      cancelText: 'Batal',
      icon: Icons.check_circle_outline_rounded,
      onConfirm: onConfirm,
    );
  }
}
