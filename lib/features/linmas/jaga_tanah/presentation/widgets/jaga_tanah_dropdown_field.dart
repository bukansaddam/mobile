import 'package:akar/core/theme/app_color_scheme.dart';
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
  final bool isLoading;
  final bool isMuted;
  final String? errorText;
  final VoidCallback onTap;

  const JagaTanahDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    this.selectedValue,
    this.prefixIcon,
    this.isRequired = true,
    this.isLoading = false,
    this.isMuted = false,
    this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasValue = selectedValue != null && selectedValue!.trim().isNotEmpty;
    final iconColor = isMuted ? colors.textSecondary : colors.primaryDark;

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
                    ? Icon(prefixIcon, color: iconColor, size: 20)
                    : null,
                suffixIcon: isLoading
                    ? UnconstrainedBox(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.primaryDark,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: iconColor,
                        size: 22,
                      ),
                filled: true,
                fillColor: isMuted ? colors.surfaceElevated : colors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colors.borderStrong),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: errorText != null
                        ? colors.error
                        : colors.borderStrong,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colors.primaryDark, width: 1.5),
                ),
                errorText: errorText,
                errorMaxLines: 2,
                errorStyle: AppTextStyles.bodySmall.copyWith(
                  color: colors.error,
                ),
              ),
              child: Text(
                hasValue ? selectedValue! : hintText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: hasValue ? colors.textPrimary : colors.textSecondary,
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
