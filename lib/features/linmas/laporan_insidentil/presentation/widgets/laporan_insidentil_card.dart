import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';

class LaporanInsidentilCard extends StatelessWidget {
  final ComplaintItem item;
  final VoidCallback onTap;

  const LaporanInsidentilCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  static ({Color bg, Color fg}) _statusPalette(
    ComplaintStatus status,
    AppColorScheme colors,
  ) {
    return switch (status) {
      ComplaintStatus.completed => (
        bg: colors.primaryLight,
        fg: colors.primaryDark,
      ),
      ComplaintStatus.rejected => (bg: colors.errorLight, fg: colors.error),
      ComplaintStatus.pending || ComplaintStatus.inProgress => (
        bg: colors.warningLight,
        fg: colors.accent,
      ),
      ComplaintStatus.received ||
      ComplaintStatus.verified => (bg: colors.infoLight, fg: colors.secondary),
      ComplaintStatus.cancelled => (
        bg: colors.surfaceElevated,
        fg: colors.secondary,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final palette = _statusPalette(item.status, colors);
    final statusText = item.statusLabel.isNotEmpty
        ? item.statusLabel
        : item.status.label;
    final titleText = item.title.trim().isNotEmpty
        ? item.title.trim()
        : 'Laporan tanpa judul';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withAlpha(6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxBadgeWidth = ((constraints.maxWidth - 62) * 0.48)
                    .clamp(0.0, double.infinity);

                return Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: colors.textSecondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleText,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.timeAgo,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxBadgeWidth),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: palette.bg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: palette.fg,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
