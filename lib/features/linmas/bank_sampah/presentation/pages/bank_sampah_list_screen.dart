import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/bank_sampah/core/constants/bank_sampah_constants.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/widgets/bank_sampah_card.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/widgets/bank_sampah_search_sheet.dart';

class BankSampahListScreen extends StatefulWidget {
  const BankSampahListScreen({super.key});

  @override
  State<BankSampahListScreen> createState() => _BankSampahListScreenState();
}

class _BankSampahListScreenState extends State<BankSampahListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.grey300),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textPrimary,
                size: 22,
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Text(
          'Laporan Bank Sampah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(AppRouter.tambahBankSampah);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Laporan Baru',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: BlocBuilder<BankSampahBloc, BankSampahState>(
        builder: (context, state) {
          if (state.isLoading && state.reports.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final filteredList = state.filteredReports;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              context.read<BankSampahBloc>().add(RefreshBankSampahDataEvent());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.grey300),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(
                                        alpha: 0.03,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) {
                                    context.read<BankSampahBloc>().add(
                                      SetBankSampahSearchQueryEvent(val),
                                    );
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        'Cari bank sampah, jenis, catatan...',
                                    hintStyle: AppTextStyles.bodyMedium
                                        .copyWith(color: AppColors.textHint),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      color: AppColors.grey500,
                                    ),
                                    suffixIcon: state.searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              context.read<BankSampahBloc>().add(
                                                ResetBankSampahFiltersEvent(),
                                              );
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: state.hasActiveFilter
                                    ? AppColors.primary
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: state.hasActiveFilter
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
                                  color: state.hasActiveFilter
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  size: 22,
                                ),
                                tooltip: 'Filter & Urutkan',
                                onPressed: () =>
                                    _showFilterBottomSheet(context),
                              ),
                            ),
                          ],
                        ),

                        if (state.hasActiveFilter) ...[
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                if (state.selectedSortOption !=
                                    BankSampahSortOption.terbaru)
                                  _buildAppliedTag(
                                    label: state.selectedSortOption.label,
                                    icon: state.selectedSortOption.icon,
                                    color: const Color(0xFFC62828),
                                    onTap: () =>
                                        _showFilterBottomSheet(context),
                                    onRemove: () =>
                                        context.read<BankSampahBloc>().add(
                                          const SetBankSampahSortOptionEvent(
                                            BankSampahSortOption.terbaru,
                                          ),
                                        ),
                                  ),

                                if (state.selectedJenisSampahFilter !=
                                    null) ...[
                                  if (state.selectedSortOption !=
                                      BankSampahSortOption.terbaru)
                                    const SizedBox(width: 8),
                                  _buildAppliedTag(
                                    label:
                                        'Jenis: ${state.selectedJenisSampahFilter}',
                                    icon:
                                        state.selectedJenisSampahFilter ==
                                            'Organik'
                                        ? Icons.eco_rounded
                                        : Icons.recycling_rounded,
                                    color:
                                        state.selectedJenisSampahFilter ==
                                            'Organik'
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFF0284C7),
                                    onTap: () =>
                                        _showFilterBottomSheet(context),
                                    onRemove: () =>
                                        context.read<BankSampahBloc>().add(
                                          const SetBankSampahJenisFilterEvent(
                                            null,
                                          ),
                                        ),
                                  ),
                                ],

                                if (state.selectedBankSampahFilter != null) ...[
                                  const SizedBox(width: 8),
                                  _buildAppliedTag(
                                    label:
                                        'Lokasi: ${state.selectedBankSampahFilter}',
                                    icon: Icons.account_balance_rounded,
                                    color: const Color(0xFFD97706),
                                    onTap: () =>
                                        _showFilterBottomSheet(context),
                                    onRemove: () =>
                                        context.read<BankSampahBloc>().add(
                                          const SetBankSampahLocationFilterEvent(
                                            null,
                                          ),
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                if (filteredList.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.restore_from_trash_rounded,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum Ada Laporan Bank Sampah',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.searchQuery.isNotEmpty ||
                                    state.hasActiveFilter
                                ? 'Tidak ditemukan laporan yang sesuai dengan kata kunci atau filter yang dipilih.'
                                : 'Mulai catat penimbangan sampah di Bank Sampah dengan menekan tombol Laporan Baru di bawah.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (state.searchQuery.isNotEmpty ||
                              state.hasActiveFilter)
                            OutlinedButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                context.read<BankSampahBloc>().add(
                                  ResetBankSampahFiltersEvent(),
                                );
                              },
                              icon: const Icon(Icons.filter_alt_off_rounded),
                              label: const Text('Reset Filter Pencarian'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: () {
                                context.pushNamed(AppRouter.tambahBankSampah);
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Tambah Laporan Pertama'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = filteredList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: BankSampahCard(report: item),
                        );
                      }, childCount: filteredList.length),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
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
        return BlocBuilder<BankSampahBloc, BankSampahState>(
          builder: (context, state) {
            final hasActiveFilter = state.hasActiveFilter;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
                ),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(bottomSheetContext).size.height * 0.85,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filter & Urutkan Bank Sampah',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (hasActiveFilter)
                              TextButton(
                                onPressed: () {
                                  context.read<BankSampahBloc>().add(
                                    ResetBankSampahFiltersEvent(),
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
                        child: Text(
                          'Kustomisasi daftar laporan bank sampah sesuai kebutuhan Anda',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.grey200),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                children: BankSampahSortOption.values.map((
                                  sortOpt,
                                ) {
                                  final isSelected =
                                      state.selectedSortOption == sortOpt;
                                  return _buildFilterChip(
                                    label: sortOpt.label,
                                    icon: sortOpt.icon,
                                    isSelected: isSelected,
                                    onTap: () {
                                      context.read<BankSampahBloc>().add(
                                        SetBankSampahSortOptionEvent(sortOpt),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 22),

                              const Text(
                                'Kategori Jenis Sampah',
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
                                    label: 'Semua Jenis',
                                    isSelected:
                                        state.selectedJenisSampahFilter == null,
                                    onTap: () {
                                      context.read<BankSampahBloc>().add(
                                        const SetBankSampahJenisFilterEvent(
                                          null,
                                        ),
                                      );
                                    },
                                  ),
                                  ...BankSampahConstants.jenisSampahList.map((
                                    jenis,
                                  ) {
                                    final isSelected =
                                        state.selectedJenisSampahFilter ==
                                        jenis;
                                    final color =
                                        jenis.toLowerCase() == 'organik'
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFF0284C7);
                                    final icon =
                                        jenis.toLowerCase() == 'organik'
                                        ? Icons.eco_rounded
                                        : Icons.recycling_rounded;
                                    return _buildFilterChip(
                                      label: jenis,
                                      icon: icon,
                                      color: color,
                                      isSelected: isSelected,
                                      onTap: () {
                                        context.read<BankSampahBloc>().add(
                                          SetBankSampahJenisFilterEvent(
                                            isSelected ? null : jenis,
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 22),

                              const Text(
                                'Lokasi Bank Sampah',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () async {
                                  final currentSelectedLoc =
                                      state.selectedBankSampahFilter != null
                                      ? state.locations
                                            .cast<BankSampahLocationEntity?>()
                                            .firstWhere(
                                              (loc) =>
                                                  loc?.nama ==
                                                  state
                                                      .selectedBankSampahFilter,
                                              orElse: () => null,
                                            )
                                      : null;

                                  final selected =
                                      await BankSampahSearchSheet.show(
                                        context,
                                        initialSelected: currentSelectedLoc,
                                        allowAll: true,
                                      );

                                  if (selected != null && context.mounted) {
                                    if (selected.id == 'ALL' ||
                                        selected.nama == 'Semua Lokasi') {
                                      context.read<BankSampahBloc>().add(
                                        const SetBankSampahLocationFilterEvent(
                                          null,
                                        ),
                                      );
                                    } else {
                                      context.read<BankSampahBloc>().add(
                                        SetBankSampahLocationFilterEvent(
                                          selected.nama,
                                        ),
                                      );
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color:
                                          state.selectedBankSampahFilter != null
                                          ? const Color(0xFFD97706)
                                          : AppColors.grey300,
                                      width:
                                          state.selectedBankSampahFilter != null
                                          ? 1.5
                                          : 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              state.selectedBankSampahFilter !=
                                                  null
                                              ? const Color(
                                                  0xFFD97706,
                                                ).withValues(alpha: 0.12)
                                              : AppColors.grey100,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.account_balance_rounded,
                                          color:
                                              state.selectedBankSampahFilter !=
                                                  null
                                              ? const Color(0xFFD97706)
                                              : AppColors.grey500,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.selectedBankSampahFilter ??
                                                  'Semua Lokasi Bank Sampah',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        state.selectedBankSampahFilter !=
                                                            null
                                                        ? AppColors.textPrimary
                                                        : AppColors
                                                              .textSecondary,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              state.selectedBankSampahFilter !=
                                                      null
                                                  ? 'Ketuk untuk mengubah lokasi bank sampah'
                                                  : 'Cari atau pilih lokasi bank sampah',
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 11,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (state.selectedBankSampahFilter !=
                                          null) ...[
                                        GestureDetector(
                                          onTap: () {
                                            context.read<BankSampahBloc>().add(
                                              const SetBankSampahLocationFilterEvent(
                                                null,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: AppColors.grey200,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close_rounded,
                                              color: AppColors.grey700,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                      const Icon(
                                        Icons.search_rounded,
                                        color: AppColors.grey500,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

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
}
