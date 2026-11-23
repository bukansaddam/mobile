import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_visual_config.dart';
import 'package:flutter/material.dart';

/// Kartu tunggal item notifikasi yang menampilkan kategori, urgensi, judul,
/// ringkasan isi, metadata relevan, dan status baca.
class NotificationCard extends StatelessWidget {
  final AppNotificationEntity item;
  final VoidCallback onTap;

  const NotificationCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final visual = NotificationVisualConfig.fromEntity(item, colors);
    final isUnread = item.isUnread;
    final timeText = NotificationVisualConfig.formatRelativeTime(
      item.createdAt,
    );

    final Color cardBg;
    final Color cardBorder;
    if (isUnread) {
      final isCritical =
          item.severity == NotificationSeverity.critical ||
          item.isEmergencyReport;
      cardBg = (isCritical ? colors.errorLight : colors.primaryLight)
          .withValues(alpha: colors.isDark ? 0.85 : 0.45);
      cardBorder = (isCritical ? colors.error : colors.primary).withValues(
        alpha: colors.isDark ? 0.45 : 0.28,
      );
    } else {
      cardBg = colors.surface;
      cardBorder = colors.border;
    }

    final metadataChips = _buildMetadataLabels(item);

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cardBorder, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: visual.chipBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(visual.icon, color: visual.iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
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
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                timeText,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                              if (isUnread)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color:
                                        item.severity ==
                                            NotificationSeverity.critical
                                        ? colors.error
                                        : colors.primaryDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: isUnread
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: colors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    if (item.body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (metadataChips.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: metadataChips
                            .map(
                              (label) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  label,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _buildMetadataLabels(AppNotificationEntity notification) {
    final labels = <String>[];
    if (notification.ticketNumber != null) {
      labels.add('#${notification.ticketNumber}');
    }
    if (notification.totalTarget != null) {
      labels.add('Target: ${notification.totalTarget}');
    }
    if (notification.dueDate != null) {
      labels.add(
        'Batas: ${NotificationVisualConfig.formatDateOnly(notification.dueDate!)}',
      );
    }
    return labels;
  }
}
