import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Konfigurasi visual dan pemformatan label untuk setiap `kind`/`severity` notifikasi.
class NotificationVisualConfig {
  final IconData icon;
  final Color iconColor;
  final Color chipBgColor;
  final Color chipTextColor;
  final String categoryLabel;

  const NotificationVisualConfig({
    required this.icon,
    required this.iconColor,
    required this.chipBgColor,
    required this.chipTextColor,
    required this.categoryLabel,
  });

  factory NotificationVisualConfig.fromEntity(
    AppNotificationEntity item,
    AppColorScheme colors,
  ) {
    if (item.severity == NotificationSeverity.critical ||
        item.isEmergencyReport) {
      return NotificationVisualConfig(
        icon: Icons.warning_amber_rounded,
        iconColor: colors.error,
        chipBgColor: colors.errorLight,
        chipTextColor: colors.error,
        categoryLabel: 'Darurat',
      );
    }

    if (item.kind == 'jaga_tanah_rejected') {
      return NotificationVisualConfig(
        icon: Icons.gavel_rounded,
        iconColor: colors.error,
        chipBgColor: colors.errorLight,
        chipTextColor: colors.error,
        categoryLabel: 'Jaga Tanah',
      );
    }

    if (item.kind.contains('escalation') ||
        item.severity == NotificationSeverity.warning) {
      return NotificationVisualConfig(
        icon: Icons.priority_high_rounded,
        iconColor: colors.earth,
        chipBgColor: colors.warningLight,
        chipTextColor: colors.warningDark,
        categoryLabel: 'Eskalasi',
      );
    }

    if (item.isJagaTanah) {
      return NotificationVisualConfig(
        icon: Icons.landscape_rounded,
        iconColor: colors.primaryDark,
        chipBgColor: colors.primaryLight,
        chipTextColor: colors.primaryDark,
        categoryLabel: 'Jaga Tanah',
      );
    }

    if (item.isActivation) {
      return NotificationVisualConfig(
        icon: Icons.campaign_rounded,
        iconColor: colors.info,
        chipBgColor: colors.infoLight,
        chipTextColor: colors.secondary,
        categoryLabel: 'Aktivasi',
      );
    }

    if (item.isRegularReport) {
      return NotificationVisualConfig(
        icon: Icons.assignment_turned_in_rounded,
        iconColor: colors.info,
        chipBgColor: colors.infoLight,
        chipTextColor: colors.secondary,
        categoryLabel: 'Pengaduan',
      );
    }

    return NotificationVisualConfig(
      icon: Icons.notifications_active_rounded,
      iconColor: colors.secondary,
      chipBgColor: colors.surfaceElevated,
      chipTextColor: colors.textPrimary,
      categoryLabel: 'Informasi',
    );
  }

  /// Format waktu relatif singkat berbahasa Indonesia untuk kartu notifikasi.
  static String formatRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final local = dateTime.toLocal();
    final diff = DateTime.now().difference(local);
    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hr lalu';
    return formatDateOnly(local);
  }

  static String formatDateOnly(DateTime dateTime) {
    try {
      return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime.toLocal());
    } catch (_) {
      return DateFormat('dd MMM yyyy').format(dateTime.toLocal());
    }
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final local = dateTime.toLocal();
    try {
      return '${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(local)} WIB';
    } catch (_) {
      return '${DateFormat('dd MMM yyyy, HH:mm').format(local)} WIB';
    }
  }
}
