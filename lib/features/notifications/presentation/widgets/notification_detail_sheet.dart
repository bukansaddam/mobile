import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_visual_config.dart';
import 'package:material_ui/material_ui.dart';

/// Bottom sheet detail notifikasi ketika item tidak memicu navigasi halaman khusus
/// atau sebagai ringkasan cepat pesan notifikasi.
class NotificationDetailSheet extends StatelessWidget {
  final AppNotificationEntity item;
  final VoidCallback? onOpenLaporanInsidentil;

  const NotificationDetailSheet({
    super.key,
    required this.item,
    this.onOpenLaporanInsidentil,
  });

  static Future<void> show(
    BuildContext context,
    AppNotificationEntity item, {
    VoidCallback? onOpenLaporanInsidentil,
  }) {
    final colors = context.appColors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => NotificationDetailSheet(
        item: item,
        onOpenLaporanInsidentil: onOpenLaporanInsidentil,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final visual = NotificationVisualConfig.fromEntity(item, colors);
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: visual.chipBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(visual.icon, color: visual.iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: visual.chipBgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              visual.categoryLabel,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: visual.chipTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          if (item.status != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceElevated,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.status!,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NotificationVisualConfig.formatDateTime(item.createdAt),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.body.isNotEmpty
                  ? item.body
                  : 'Tidak ada rincian tambahan pada notifikasi ini.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            if (item.ticketNumber != null ||
                item.dueDate != null ||
                item.totalTarget != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    if (item.ticketNumber != null)
                      Text(
                        'Tiket: #${item.ticketNumber}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (item.totalTarget != null)
                      Text(
                        'Target: ${item.totalTarget}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (item.dueDate != null)
                      Text(
                        'Batas Waktu: ${NotificationVisualConfig.formatDateOnly(item.dueDate!)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (onOpenLaporanInsidentil != null) ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onOpenLaporanInsidentil!();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Buka Daftar Laporan Insidentil'),
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.textPrimary,
                  side: BorderSide(color: colors.borderStrong),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
