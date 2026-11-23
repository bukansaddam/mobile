import 'package:akar/core/theme/app_color_scheme.dart';
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
    if (lower.contains('desa')) {
      return Icons.terrain_rounded;
    }
    return Icons.landscape_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
                  color: colors.borderStrong,
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
                        color: colors.textPrimary,
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
                    icon: Icon(Icons.close_rounded, color: colors.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Divider(height: 1, color: colors.divider),
            Flexible(
              child: categories.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Belum ada kategori tersedia.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textSecondary,
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
                                  ? colors.primaryLight
                                  : colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              iconFor(item),
                              size: 20,
                              color: isSelected
                                  ? colors.primaryDark
                                  : colors.earth,
                            ),
                          ),
                          title: Text(
                            item.label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? colors.primaryDark
                                  : colors.textPrimary,
                            ),
                          ),
                          subtitle: item.hasSubCategories
                              ? Text(
                                  '${item.children.length} sub-kategori',
                                  style: AppTextStyles.caption.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                )
                              : null,
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: colors.primaryDark,
                                )
                              : (item.hasSubCategories
                                    ? Icon(
                                        Icons.chevron_right_rounded,
                                        color: colors.textSecondary,
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
