import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HomeSummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String count;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  const HomeSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 22.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.white, size: 32),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 18,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: AppColors.white.withValues(alpha: 0.88),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                Text(
                  count,
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 38,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
