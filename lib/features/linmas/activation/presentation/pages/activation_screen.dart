import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/widgets/activation_card.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return BlocBuilder<ActivationBloc, ActivationState>(
          builder: (context, state) {
            final hasActiveFilters = state.hasActiveFilter;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(bottomSheetContext).size.height * 0.85,
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
                      const SizedBox(height: 16),

                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filter & Urutkan Kegiatan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (hasActiveFilters)
                              TextButton(
                                onPressed: () {
                                  context.read<ActivationBloc>().add(
                                    ResetActivationFiltersEvent(),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Reset Filter',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kustomisasi daftar kegiatan sesuai kebutuhan Anda',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.grey200),

                      // Scrollable Filter Sections
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section 1: Urutkan Berdasarkan
                              const Text(
                                'Urutkan Berdasarkan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ActivationSortOption.values.map((
                                  sortOpt,
                                ) {
                                  final isSelected =
                                      state.selectedSortOption == sortOpt;
                                  return _buildFilterChip(
                                    label: sortOpt.label,
                                    icon: sortOpt.icon,
                                    isSelected: isSelected,
                                    onTap: () {
                                      context.read<ActivationBloc>().add(
                                        SetActivationSortOptionEvent(sortOpt),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 22),

                              // Section 2: Kategori Kegiatan
                              const Text(
                                'Kategori Kegiatan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildFilterChip(
                                    label: 'Semua Kategori',
                                    isSelected:
                                        state.selectedCategoryFilter == null,
                                    onTap: () {
                                      context.read<ActivationBloc>().add(
                                        const SetActivationCategoryFilterEvent(
                                          null,
                                        ),
                                      );
                                    },
                                  ),
                                  ...ActivationCategory.values.map((cat) {
                                    final isSelected =
                                        state.selectedCategoryFilter == cat;
                                    return _buildFilterChip(
                                      label: cat.label,
                                      icon: cat.icon,
                                      color: cat.color,
                                      isSelected: isSelected,
                                      onTap: () {
                                        context.read<ActivationBloc>().add(
                                          SetActivationCategoryFilterEvent(cat),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 22),

                              // Section 3: Status Kegiatan
                              const Text(
                                'Status Kegiatan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildFilterChip(
                                    label: 'Semua Status',
                                    isSelected:
                                        state.selectedStatusFilter == null,
                                    onTap: () {
                                      context.read<ActivationBloc>().add(
                                        const SetActivationStatusFilterEvent(
                                          null,
                                        ),
                                      );
                                    },
                                  ),
                                  ...ActivationStatus.values.map((status) {
                                    final isSelected =
                                        state.selectedStatusFilter == status;
                                    return _buildFilterChip(
                                      label: status.label,
                                      color: status.color,
                                      isSelected: isSelected,
                                      onTap: () {
                                        context.read<ActivationBloc>().add(
                                          SetActivationStatusFilterEvent(
                                            status,
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Apply Button
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(bottomSheetContext),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Terapkan Filter',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    Color? color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final activeColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.grey300,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? activeColor : AppColors.grey600,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppliedTag({
    required String label,
    IconData? icon,
    Color? color,
    VoidCallback? onRemove,
    VoidCallback? onTap,
  }) {
    final tagColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap ?? onRemove,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: tagColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: tagColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: tagColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: tagColor,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.close_rounded, size: 14, color: tagColor),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivationBloc, ActivationState>(
      builder: (context, state) {
        final filteredList = state.filteredActivities;
        final hasActiveFilter = state.hasActiveFilter;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.15],
              ),
            ),
            child: Column(
              children: [
                // Fixed Top Section (Search Bar & Applied Filters Below Search)
                Container(
                  padding: const EdgeInsets.fromLTRB(18.0, 14.0, 18.0, 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Search Bar & Filter Trigger Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                onTapOutside: (event) => FocusManager
                                    .instance
                                    .primaryFocus
                                    ?.unfocus(),
                                onChanged: (val) {
                                  context.read<ActivationBloc>().add(
                                    SetActivationSearchQueryEvent(val),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      'Cari kegiatan, lokasi, atau kategori...',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.grey500,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: AppColors.primary,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear_rounded,
                                            color: AppColors.grey500,
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                            context.read<ActivationBloc>().add(
                                              ClearActivationSearchEvent(),
                                            );
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: AppColors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey200,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Filter Button to trigger Bottom Sheet
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color: hasActiveFilter
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: hasActiveFilter
                                    ? AppColors.primary
                                    : AppColors.grey300,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.tune_rounded,
                                color: hasActiveFilter
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                size: 22,
                              ),
                              tooltip: 'Filter & Urutkan',
                              onPressed: () => _showFilterBottomSheet(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Row 2: Applied Filters Chips Row (Directly below search input)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            // Applied Sort Tag
                            _buildAppliedTag(
                              label: state.selectedSortOption.label,
                              icon: state.selectedSortOption.icon,
                              color: const Color(0xFFC62828),
                              onTap: () => _showFilterBottomSheet(context),
                            ),

                            // Applied Category Tag
                            if (state.selectedCategoryFilter != null) ...[
                              const SizedBox(width: 8),
                              _buildAppliedTag(
                                label: state.selectedCategoryFilter!.label,
                                icon: state.selectedCategoryFilter!.icon,
                                color: state.selectedCategoryFilter!.color,
                                onRemove: () {
                                  context.read<ActivationBloc>().add(
                                    const SetActivationCategoryFilterEvent(
                                      null,
                                    ),
                                  );
                                },
                              ),
                            ],

                            // Applied Status Tag
                            if (state.selectedStatusFilter != null) ...[
                              const SizedBox(width: 8),
                              _buildAppliedTag(
                                label: state.selectedStatusFilter!.label,
                                color: state.selectedStatusFilter!.color,
                                onRemove: () {
                                  context.read<ActivationBloc>().add(
                                    const SetActivationStatusFilterEvent(null),
                                  );
                                },
                              ),
                            ],

                            // Reset All Tag
                            if (hasActiveFilter) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  context.read<ActivationBloc>().add(
                                    ResetActivationFiltersEvent(),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.grey200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        size: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Reset',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Row 3: Section Header (Title & Total Count)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daftar Kegiatan',
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${filteredList.length} Kegiatan',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable List / Empty State
                Expanded(
                  child: filteredList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off_rounded,
                                  size: 64,
                                  color: AppColors.grey400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Kegiatan Tidak Ditemukan',
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Coba kata kunci lain atau ubah filter pada tombol filter.',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            18.0,
                            4.0,
                            18.0,
                            24.0,
                          ),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final activity = filteredList[index];
                            return ActivationCard(
                              activity: activity,
                              onTap: () => context.pushNamed(
                                'activationDetail',
                                extra: activity.id,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
