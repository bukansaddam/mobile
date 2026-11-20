import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Bottom sheet daftar pilihan tunggal untuk dropdown form Jaga Tanahku.
class JagaTanahOptionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const JagaTanahOptionSheet({
    super.key,
    required this.title,
    required this.options,
    this.selectedValue,
    required this.onSelected,
  });

  static void show(
    BuildContext context, {
    required String title,
    required List<String> options,
    String? selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => JagaTanahOptionSheet(
        title: title,
        options: options,
        selectedValue: selectedValue,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Tutup',
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Divider(height: 1, color: AppColors.grey200),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == selectedValue;

                  return ListTile(
                    minVerticalPadding: 12,
                    title: Text(
                      option,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryDark,
                          )
                        : null,
                    tileColor: isSelected
                        ? AppColors.primaryLight.withValues(alpha: 0.45)
                        : null,
                    onTap: () {
                      onSelected(option);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
