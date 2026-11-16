import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';

class JagaTanahCard extends StatelessWidget {
  final ComplaintItem item;
  final VoidCallback onTap;

  const JagaTanahCard({super.key, required this.item, required this.onTap});

  static IconData _categoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('pemda') ||
        lower.contains('provinsi') ||
        lower.contains('kabupaten') ||
        lower.contains('kecamatan')) {
      return Icons.account_balance_rounded;
    }
    if (lower.contains('desa')) {
      return Icons.terrain_rounded;
    }
    return Icons.landscape_rounded;
  }

  static ({Color bg, Color fg}) _statusPalette(ComplaintStatus status) {
    return switch (status) {
      ComplaintStatus.completed => (
        bg: AppColors.primaryLight,
        fg: AppColors.primaryDark,
      ),
      ComplaintStatus.rejected => (
        bg: AppColors.errorLight,
        fg: AppColors.error,
      ),
      ComplaintStatus.pending || ComplaintStatus.inProgress => (
        bg: AppColors.warningLight,
        fg: AppColors.accent,
      ),
      ComplaintStatus.received || ComplaintStatus.verified => (
        bg: AppColors.infoLight,
        fg: AppColors.secondary,
      ),
      ComplaintStatus.cancelled => (
        bg: AppColors.grey100,
        fg: AppColors.secondary,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = _statusPalette(item.status);
    final statusText = item.statusLabel.isNotEmpty
        ? item.statusLabel
        : item.status.label;
    final titleText = item.title.trim().isNotEmpty
        ? item.title.trim()
        : 'Laporan tanpa judul';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(6),
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
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _categoryIcon(item.category),
                        color: AppColors.earth,
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
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.timeAgo,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              color: AppColors.textSecondary,
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
