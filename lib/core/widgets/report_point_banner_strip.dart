import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/report_point_policy.dart';
import 'package:material_ui/material_ui.dart';

/// Strip keterangan poin yang menyatu di bagian bawah banner status halaman detail laporan.
class ReportPointBannerStrip extends StatelessWidget {
  final ReportPointInfo info;
  final Color? dividerColor;

  const ReportPointBannerStrip({
    super.key,
    required this.info,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = _resolveStyle(info.state, colors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Divider(
          height: 1,
          thickness: 1,
          color: dividerColor ?? colors.primary.withValues(alpha: 0.16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: style.chipBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: style.chipBorder, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(style.icon, size: 14, color: style.iconColor),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      info.detailChipLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: style.chipText,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              info.detailTitle,
              style: AppTextStyles.labelMedium.copyWith(
                color: style.titleColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          info.detailDescription,
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.textSecondary,
            fontSize: 12,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  static ({
    Color chipBg,
    Color chipBorder,
    Color chipText,
    Color iconColor,
    Color titleColor,
    IconData icon,
  })
  _resolveStyle(ReportPointState state, AppColorScheme colors) {
    return switch (state) {
      ReportPointState.earned => (
        chipBg: colors.warningLight,
        chipBorder: colors.warningBorder,
        chipText: colors.warningDark,
        iconColor: colors.earth,
        titleColor: colors.warningDark,
        icon: Icons.workspace_premium_rounded,
      ),
      ReportPointState.pending => (
        chipBg: colors.surface,
        chipBorder: colors.borderStrong,
        chipText: colors.textPrimary,
        iconColor: colors.earth,
        titleColor: colors.primaryDark,
        icon: Icons.hourglass_top_rounded,
      ),
      ReportPointState.notEligible => (
        chipBg: colors.errorLight,
        chipBorder: colors.errorBorder,
        chipText: colors.errorDark,
        iconColor: colors.error,
        titleColor: colors.errorDark,
        icon: Icons.block_rounded,
      ),
    };
  }
}
