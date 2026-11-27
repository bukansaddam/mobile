import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

class ProfilePointsCard extends StatelessWidget {
  final int points;
  final bool isOfficer;
  final bool isEmbedded;
  final VoidCallback? onTap;

  const ProfilePointsCard({
    super.key,
    required this.points,
    this.isOfficer = false,
    this.isEmbedded = false,
    this.onTap,
  });

  static String formatPoints(int value) {
    try {
      return '${NumberFormat.decimalPattern('id_ID').format(value)} Poin';
    } catch (_) {
      return '$value Poin';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final formattedPoints = formatPoints(points);

    final backgroundColor = isEmbedded ? colors.warningLight : colors.surface;
    final borderColor = colors.warningBorder;
    final borderRadius = BorderRadius.circular(isEmbedded ? 16 : 18);

    return Semantics(
      button: onTap != null,
      label: 'Poin: $formattedPoints. Ketuk untuk rincian.',
      child: Material(
        color: backgroundColor,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: EdgeInsets.symmetric(
              horizontal: isEmbedded ? 14 : 16,
              vertical: isEmbedded ? 12 : 14,
            ),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: isEmbedded
                  ? null
                  : [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.isDark
                        ? colors.warningBorder.withValues(alpha: 0.35)
                        : colors.warningLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: colors.earth,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formattedPoints,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: colors.warningDark,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Diperoleh dari laporan yang telah dibuat',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: colors.isDark
                              ? colors.textSecondary
                              : colors.warningDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.earth,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
