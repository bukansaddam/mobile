import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_field_label.dart';
import 'package:flutter/material.dart';

/// Input teks standar dengan label wajib/opsional pada form Jaga Tanahku.
class JagaTanahTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final bool isRequired;
  final int maxLines;
  final int maxLength;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;

  const JagaTanahTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.isRequired = true,
    this.maxLines = 1,
    this.maxLength = 255,
    this.textInputAction = TextInputAction.next,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JagaTanahFieldLabel(label: label, isRequired: isRequired),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            counterText: '',
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.primaryDark, size: 20)
                : null,
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
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primaryDark,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
          validator:
              validator ??
              (value) {
                if (!isRequired) return null;
                if (value == null || value.trim().isEmpty) {
                  return '$label wajib diisi';
                }
                return null;
              },
        ),
      ],
    );
  }
}
