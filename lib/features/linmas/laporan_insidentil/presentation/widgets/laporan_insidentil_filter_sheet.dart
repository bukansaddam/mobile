import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LaporanInsidentilFilterSheet extends HookWidget {
  final String? initialStatus;
  final String? initialCategory;
  final void Function(String? status, String? category) onApply;

  const LaporanInsidentilFilterSheet({
    super.key,
    this.initialStatus,
    this.initialCategory,
    required this.onApply,
  });

  static const List<({String code, String label})> _statusOptions = [
    (code: 'new', label: 'Laporan Masuk'),
    (code: 'verification', label: 'Menunggu Verifikasi'),
    (code: 'in_progress', label: 'Sedang Diproses'),
    (code: 'completed', label: 'Selesai'),
    (code: 'rejected', label: 'Ditolak'),
  ];

  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.grey300,
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
                        foregroundColor: AppColors.error,
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
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16, color: AppColors.grey200),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status Laporan',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
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
                            selectedColor: AppColors.primaryLight,
                            backgroundColor: AppColors.grey50,
                            side: BorderSide(
                              color: selectedStatus.value == null
                                  ? AppColors.primaryDark
                                  : AppColors.grey300,
                            ),
                            labelStyle: AppTextStyles.labelMedium.copyWith(
                              color: selectedStatus.value == null
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
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
                              selectedColor: AppColors.primaryLight,
                              backgroundColor: AppColors.grey50,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primaryDark
                                    : AppColors.grey300,
                              ),
                              labelStyle: AppTextStyles.labelMedium.copyWith(
                                color: isSelected
                                    ? AppColors.primaryDark
                                    : AppColors.textPrimary,
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
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<MyComplaintListBloc, MyComplaintListState>(
                        buildWhen: (prev, curr) =>
                            prev.isLoadingCategories !=
                                curr.isLoadingCategories ||
                            prev.categories != curr.categories ||
                            prev.categoryError != curr.categoryError,
                        builder: (context, state) {
                          if (state.isLoadingCategories &&
                              state.categories.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Memuat kategori laporan...',
                                      style: AppTextStyles.bodySmall,
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
                                color: AppColors.errorLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.categoryError!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        context.read<MyComplaintListBloc>().add(
                                          const FetchIncidentCategoriesEvent(
                                            force: true,
                                          ),
                                        ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.error,
                                      minimumSize: const Size(48, 44),
                                    ),
                                    child: const Text('Muat Ulang'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state.categories.isEmpty) {
                            return const Text(
                              'Belum ada kategori tersedia.',
                              style: AppTextStyles.bodySmall,
                            );
                          }

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
                                selectedColor: AppColors.primaryLight,
                                backgroundColor: AppColors.grey50,
                                side: BorderSide(
                                  color: selectedCategory.value == null
                                      ? AppColors.primaryDark
                                      : AppColors.grey300,
                                ),
                                labelStyle: AppTextStyles.labelMedium.copyWith(
                                  color: selectedCategory.value == null
                                      ? AppColors.primaryDark
                                      : AppColors.textPrimary,
                                  fontWeight: selectedCategory.value == null
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                                onSelected: (_) =>
                                    selectedCategory.value = null,
                              ),
                              ...state.categories.map((cat) {
                                final isSelected =
                                    selectedCategory.value == cat.code;
                                return ChoiceChip(
                                  label: Text(cat.label),
                                  selected: isSelected,
                                  showCheckmark: false,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  selectedColor: AppColors.primaryLight,
                                  backgroundColor: AppColors.grey50,
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.primaryDark
                                        : AppColors.grey300,
                                  ),
                                  labelStyle: AppTextStyles.labelMedium
                                      .copyWith(
                                        color: isSelected
                                            ? AppColors.primaryDark
                                            : AppColors.textPrimary,
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
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
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
