import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:flutter/material.dart';

class JagaTanahCategorySheet extends StatelessWidget {
  final String title;
  final List<JagaTanahCategoryEntity> categories;
  final int? selectedId;
  final ValueChanged<JagaTanahCategoryEntity> onSelected;

  const JagaTanahCategorySheet({
    super.key,
    required this.title,
    required this.categories,
    this.selectedId,
    required this.onSelected,
  });

  static IconData iconFor(JagaTanahCategoryEntity category) {
    final lower = category.label.toLowerCase();
    if (lower.contains('pemda') ||
        lower.contains('provinsi') ||
        lower.contains('kabupaten') ||
        lower.contains('kecamatan')) {
      return Icons.account_balance_rounded;
    }
    return Icons.terrain_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
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
              child: categories.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Belum ada kategori tersedia.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        final isSelected = selectedId == item.id;

                        return ListTile(
                          minVerticalPadding: 12,
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : AppColors.grey100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              iconFor(item),
                              size: 20,
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.earth,
                            ),
                          ),
                          title: Text(
                            item.label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: item.hasSubCategories
                              ? Text(
                                  '${item.children.length} sub-kategori',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : null,
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primaryDark,
                                )
                              : (item.hasSubCategories
                                    ? const Icon(
                                        Icons.chevron_right_rounded,
                                        color: AppColors.textSecondary,
                                      )
                                    : null),
                          onTap: () {
                            onSelected(item);
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
