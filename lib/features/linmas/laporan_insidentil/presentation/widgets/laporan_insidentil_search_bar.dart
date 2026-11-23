import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LaporanInsidentilSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const LaporanInsidentilSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: 'Cari judul laporan...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.textSecondary,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              onPressed: onClear,
              tooltip: 'Hapus pencarian',
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(
                Icons.close_rounded,
                color: colors.textSecondary,
                size: 20,
              ),
            );
          },
        ),
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}
