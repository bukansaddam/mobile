import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Kartu seksi langkah form Jaga Tanahku yang selaras dengan kartu step Laporan Harian.
class JagaTanahSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Color badgeColor;
  final Widget child;

  const JagaTanahSectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.accentColor = AppColors.primaryDark,
    this.badgeColor = AppColors.primaryLight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
