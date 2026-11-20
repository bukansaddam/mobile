import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_field_label.dart';
import 'package:flutter/material.dart';

/// Field pemilih opsi tunggal berbentuk dropdown bottom sheet pada form Jaga Tanahku.
class JagaTanahDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? selectedValue;
  final IconData? prefixIcon;
  final bool isRequired;
  final String? errorText;
  final VoidCallback onTap;

  const JagaTanahDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    this.selectedValue,
    this.prefixIcon,
    this.isRequired = true,
    this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = selectedValue != null && selectedValue!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JagaTanahFieldLabel(label: label, isRequired: isRequired),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: InputDecorator(
              isEmpty: !hasValue,
              decoration: InputDecoration(
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: AppColors.primaryDark, size: 20)
                    : null,
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primaryDark,
                  size: 22,
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: errorText != null
                        ? AppColors.error
                        : AppColors.grey300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.primaryDark,
                    width: 1.5,
                  ),
                ),
                errorText: errorText,
                errorStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                ),
              ),
              child: Text(
                hasValue ? selectedValue! : hintText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: hasValue
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
