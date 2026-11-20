import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Baris informasi label + nilai pada layar detail laporan Jaga Tanah.
class JagaTanahDetailField extends StatelessWidget {
  final String label;
  final String? value;
  final double bottomSpacing;

  const JagaTanahDetailField({
    super.key,
    required this.label,
    required this.value,
    this.bottomSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = value?.trim() ?? '';
    final displayValue = trimmed.isNotEmpty ? trimmed : '-';

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            displayValue,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
