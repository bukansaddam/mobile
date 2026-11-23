import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
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
    final formattedPoints = formatPoints(points);

    final backgroundColor = isEmbedded
        ? AppColors.warningLight
        : AppColors.white;
    const borderColor = AppColors.warningBorder;
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
                  : const [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.warningLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: AppColors.earth,
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF78350F),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Diperoleh dari laporan yang telah dibuat',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warningDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.earth,
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
