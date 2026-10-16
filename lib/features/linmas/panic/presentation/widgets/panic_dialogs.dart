import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';

class PanicDialogs {
  PanicDialogs._();

  static void showSuccessEmergencyDialog(
    BuildContext context, {
    required int notifiedMembersCount,
    required VoidCallback onDismiss,
  }) {
    final customContent = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$notifiedMembersCount Anggota Menerima Notifikasi',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  'Seluruh tim terdekat sedang merespons dan menuju titik posisi Anda.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
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
      message:
          'Sinyal darurat (SOS) telah berhasil disiarkan secara serentak ke seluruh tim tanggap darurat terdekat.',
      customContent: customContent,
      buttonText: 'Mengerti',
      buttonColor: AppColors.primary,
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
      message:
          'Apakah kondisi darurat Anda sudah selesai dan situasi telah aman?\n\nMenonaktifkan SOS akan memperbarui status Anda menjadi normal (is_emergency: false) di server.',
      confirmText: 'Ya, Matikan SOS',
      cancelText: 'Batal',
      icon: Icons.check_circle_outline_rounded,
      onConfirm: onConfirm,
    );
  }
}
