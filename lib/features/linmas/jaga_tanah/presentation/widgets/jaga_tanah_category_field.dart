import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_field_label.dart';
import 'package:flutter/material.dart';

class JagaTanahCategoryField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? selectedLabel;
  final IconData prefixIcon;
  final bool isLoading;
  final String? errorText;
  final String? fetchErrorText;
  final VoidCallback onTap;
  final VoidCallback? onRetry;

  const JagaTanahCategoryField({
    super.key,
    required this.label,
    required this.hintText,
    this.selectedLabel,
    this.prefixIcon = Icons.category_outlined,
    this.isLoading = false,
    this.errorText,
    this.fetchErrorText,
    required this.onTap,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = selectedLabel != null && selectedLabel!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JagaTanahFieldLabel(label: label),
        const SizedBox(height: 8),
        InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: InputDecorator(
            isEmpty: !hasValue,
            decoration: InputDecoration(
              prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: 20),
              suffixIcon: isLoading
                  ? const UnconstrainedBox(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
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
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.error,
              ),
            ),
            child: Text(
              hasValue ? selectedLabel! : hintText,
              style: AppTextStyles.bodyMedium.copyWith(
                color: hasValue
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ),
        if (fetchErrorText != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    fetchErrorText!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
                if (onRetry != null)
                  TextButton(
                    onPressed: onRetry,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      minimumSize: const Size(48, 44),
                    ),
                    child: const Text('Muat Ulang'),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
