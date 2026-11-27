import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/report_point_policy.dart';
import 'package:material_ui/material_ui.dart';

/// Badge ringkas penanda poin yang diperoleh pada kartu daftar laporan.
class ReportPointBadge extends StatelessWidget {
  final ReportPointInfo info;
  final double? maxWidth;

  const ReportPointBadge({super.key, required this.info, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final badge = Semantics(
      label: 'Memperoleh ${info.badgeLabel}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: colors.warningLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.warningBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: 13,
              color: colors.earth,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                info.badgeLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  color: colors.warningDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (maxWidth != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: badge,
      );
    }
    return badge;
  }
}
