import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_category_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_list_bloc/jaga_tanah_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class JagaTanahFilterSheet extends HookWidget {
  final String? initialStatus;
  final String? initialCategory;
  final void Function(String? status, String? category) onApply;

  const JagaTanahFilterSheet({
    super.key,
    this.initialStatus,
    this.initialCategory,
    required this.onApply,
  });

  static const List<({String code, String label})> _statusOptions = [
    (code: 'submitted', label: 'Diajukan'),
    (code: 'verification_assigned', label: 'Verifikasi Ditugaskan'),
    (code: 'verified', label: 'Terverifikasi'),
    (code: 'mediation', label: 'Mediasi'),
    (code: 'fifty_fifty', label: 'Mediasi 50:50'),
    (code: 'bpn_forwarded', label: 'Diteruskan ke BPN'),
    (code: 'completed', label: 'Selesai'),
    (code: 'rejected', label: 'Ditolak'),
  ];

  static List<({String code, String label})> _flattenCategories(
    List<JagaTanahCategoryEntity> parents,
  ) {
    final options = <({String code, String label})>[];
    for (final parent in parents) {
      options.add((code: parent.code, label: parent.label));
      for (final child in parent.children) {
        options.add((
          code: child.code,
          label: '${parent.label} - ${child.label}',
        ));
      }
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final selectedStatus = useState<String?>(initialStatus);
    final selectedCategory = useState<String?>(initialCategory);
    final hasSelection =
        selectedStatus.value != null || selectedCategory.value != null;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Filter Laporan',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  if (hasSelection)
                    TextButton(
                      onPressed: () {
                        selectedStatus.value = null;
                        selectedCategory.value = null;
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colors.error,
                        minimumSize: const Size(48, 44),
                      ),
                      child: const Text('Reset Filter'),
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
              Divider(height: 16, color: colors.divider),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status Laporan',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Semua Status'),
                            selected: selectedStatus.value == null,
                            showCheckmark: false,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            selectedColor: colors.primaryLight,
                            backgroundColor: colors.surfaceVariant,
                            side: BorderSide(
                              color: selectedStatus.value == null
                                  ? colors.primaryDark
                                  : colors.borderStrong,
                            ),
                            labelStyle: AppTextStyles.labelMedium.copyWith(
                              color: selectedStatus.value == null
                                  ? colors.primaryDark
                                  : colors.textPrimary,
                              fontWeight: selectedStatus.value == null
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            onSelected: (_) => selectedStatus.value = null,
                          ),
                          ..._statusOptions.map((option) {
                            final isSelected =
                                selectedStatus.value == option.code;
                            return ChoiceChip(
                              label: Text(option.label),
                              selected: isSelected,
                              showCheckmark: false,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              selectedColor: colors.primaryLight,
                              backgroundColor: colors.surfaceVariant,
                              side: BorderSide(
                                color: isSelected
                                    ? colors.primaryDark
                                    : colors.borderStrong,
                              ),
                              labelStyle: AppTextStyles.labelMedium.copyWith(
                                color: isSelected
                                    ? colors.primaryDark
                                    : colors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                              onSelected: (_) {
                                selectedStatus.value = isSelected
                                    ? null
                                    : option.code;
                              },
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Kategori Laporan',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<JagaTanahListBloc, JagaTanahListState>(
                        buildWhen: (prev, curr) =>
                            prev.isLoadingCategories !=
                                curr.isLoadingCategories ||
                            prev.categories != curr.categories ||
                            prev.categoryError != curr.categoryError,
                        builder: (context, state) {
                          if (state.isLoadingCategories &&
                              state.categories.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Memuat kategori Jaga Tanah...',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state.categoryError != null &&
                              state.categories.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.errorLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.categoryError!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: colors.error,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        context.read<JagaTanahListBloc>().add(
                                          const FetchJagaTanahCategoriesEvent(
                                            force: true,
                                          ),
                                        ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: colors.error,
                                      minimumSize: const Size(48, 44),
                                    ),
                                    child: const Text('Muat Ulang'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state.categories.isEmpty) {
                            return Text(
                              'Belum ada kategori tersedia.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            );
                          }

                          final categoryOptions = _flattenCategories(
                            state.categories,
                          );

                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ChoiceChip(
                                label: const Text('Semua Kategori'),
                                selected: selectedCategory.value == null,
                                showCheckmark: false,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                selectedColor: colors.primaryLight,
                                backgroundColor: colors.surfaceVariant,
                                side: BorderSide(
                                  color: selectedCategory.value == null
                                      ? colors.primaryDark
                                      : colors.borderStrong,
                                ),
                                labelStyle: AppTextStyles.labelMedium.copyWith(
                                  color: selectedCategory.value == null
                                      ? colors.primaryDark
                                      : colors.textPrimary,
                                  fontWeight: selectedCategory.value == null
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                                onSelected: (_) =>
                                    selectedCategory.value = null,
                              ),
                              ...categoryOptions.map((cat) {
                                final isSelected =
                                    selectedCategory.value == cat.code;
                                return ChoiceChip(
                                  label: Text(cat.label),
                                  selected: isSelected,
                                  showCheckmark: false,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  selectedColor: colors.primaryLight,
                                  backgroundColor: colors.surfaceVariant,
                                  side: BorderSide(
                                    color: isSelected
                                        ? colors.primaryDark
                                        : colors.borderStrong,
                                  ),
                                  labelStyle: AppTextStyles.labelMedium
                                      .copyWith(
                                        color: isSelected
                                            ? colors.primaryDark
                                            : colors.textPrimary,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                  onSelected: (_) {
                                    selectedCategory.value = isSelected
                                        ? null
                                        : cat.code;
                                  },
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  onApply(selectedStatus.value, selectedCategory.value);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppTextStyles.button,
                ),
                child: const Text('Terapkan Filter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
