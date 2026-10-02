import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bloc = context.read<BankSampahBloc>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (bloc.page != null && bloc.state is! BankSampahLoading) {
        bloc.add(
          GetBankSampahReportsEvent(
            jenisSampah: bloc.selectedJenisSampahFilter,
            bankId: bloc.selectedBankId,
            bankSampahNama: bloc.selectedBankSampahFilter,
            sortBy: bloc.sortBy,
            sortDirection: bloc.sortDirection,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BankSampahBloc>();
    final state = bloc.state;
    final filteredList = bloc.displayList;
    final hasActiveFilter = bloc.hasActiveFilter;

    return BlocListener<BankSampahBloc, BankSampahState>(
      listener: (context, state) {
        if (state is BankSampahActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is BankSampahActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leadingWidth: 56,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
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
          ),
          title: const Text(
            'Laporan Bank Sampah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasActiveFilter
                        ? AppColors.primary
                        : AppColors.white,
                    border: Border.all(
                      color: hasActiveFilter
                          ? AppColors.primary
                          : AppColors.grey300,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: hasActiveFilter
                          ? Colors.white
                          : AppColors.textPrimary,
                      size: 20,
                    ),
                    tooltip: 'Filter & Urutkan',
                    onPressed: () => _showFilterBottomSheet(context),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
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
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            bloc.add(
              RefreshBankSampahReportsEvent(
                jenisSampah: bloc.selectedJenisSampahFilter,
                bankId: bloc.selectedBankId,
                bankSampahNama: bloc.selectedBankSampahFilter,
                sortBy: bloc.sortBy,
                sortDirection: bloc.sortDirection,
              ),
            );
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (hasActiveFilter)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          if (bloc.sortBy != BankSampahSortBy.date ||
                              bloc.sortDirection !=
                                  BankSampahSortDirection.desc)
                            _buildAppliedTag(
                              label:
                                  '${bloc.sortBy.label}: ${_getDirectionContextLabel(bloc.sortDirection, bloc.sortBy)}',
                              icon:
                                  bloc.sortDirection ==
                                      BankSampahSortDirection.desc
                                  ? Icons.south_rounded
                                  : Icons.north_rounded,
                              color: AppColors.primary,
                              onTap: () => _showFilterBottomSheet(context),
                              onRemove: () => bloc.add(
                                const SetBankSampahFilterEvent.sort(
                                  sortBy: BankSampahSortBy.date,
                                  sortDirection: BankSampahSortDirection.desc,
                                ),
                              ),
                            ),
                          if (bloc.selectedJenisSampahFilter != null) ...[
                            if (bloc.sortBy != BankSampahSortBy.date ||
                                bloc.sortDirection !=
                                    BankSampahSortDirection.desc)
                              const SizedBox(width: 8),
                            _buildAppliedTag(
                              label: 'Jenis: ${bloc.selectedJenisSampahFilter}',
                              icon: bloc.selectedJenisSampahFilter == 'Organik'
                                  ? Icons.eco_rounded
                                  : Icons.recycling_rounded,
                              color: AppColors.primary,
                              onTap: () => _showFilterBottomSheet(context),
                              onRemove: () => bloc.add(
                                const SetBankSampahFilterEvent.jenis(null),
                              ),
                            ),
                          ],
                          if (bloc.selectedBankSampahFilter != null) ...[
                            if (bloc.sortBy != BankSampahSortBy.date ||
                                bloc.sortDirection !=
                                    BankSampahSortDirection.desc ||
                                bloc.selectedJenisSampahFilter != null)
                              const SizedBox(width: 8),
                            _buildAppliedTag(
                              label: 'Lokasi: ${bloc.selectedBankSampahFilter}',
                              icon: Icons.account_balance_rounded,
                              color: AppColors.primary,
                              onTap: () => _showFilterBottomSheet(context),
                              onRemove: () => bloc.add(
                                const SetBankSampahFilterEvent.bank(
                                  bankId: null,
                                  bankSampahNama: null,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    hasActiveFilter ? 8 : 16,
                    16,
                    4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Setoran',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
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
                          '${bloc.total > 0 ? bloc.total : filteredList.length} Laporan',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (state is BankSampahLoading && filteredList.isEmpty)
                SliverToBoxAdapter(child: _buildShimmerLoadingList())
              else if (state is BankSampahFailure && filteredList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              bloc.add(
                                RefreshBankSampahReportsEvent(
                                  jenisSampah: bloc.selectedJenisSampahFilter,
                                  bankId: bloc.selectedBankId,
                                  bankSampahNama: bloc.selectedBankSampahFilter,
                                  sortBy: bloc.sortBy,
                                  sortDirection: bloc.sortDirection,
                                ),
                              );
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (filteredList.isEmpty)
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
                          hasActiveFilter
                              ? 'Tidak ditemukan laporan yang sesuai dengan filter yang dipilih.'
                              : 'Catat penimbangan sampah warga untuk memantau data setoran bank sampah.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        if (hasActiveFilter)
                          OutlinedButton.icon(
                            onPressed: () {
                              bloc.add(const ResetBankSampahFilterEvent());
                            },
                            icon: const Icon(Icons.filter_alt_off_rounded),
                            label: const Text('Reset Filter'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
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
                            label: const Text('Catat Setoran Baru'),
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
                  padding: EdgeInsets.fromLTRB(
                    16,
                    hasActiveFilter ? 8 : 12,
                    16,
                    90,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < filteredList.length) {
                          final item = filteredList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: BankSampahCard(report: item),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      childCount:
                          filteredList.length + (bloc.page != null ? 1 : 0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoadingList() {
    return Shimmer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        child: Column(
          children: List.generate(
            4,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const ShimmerLoading(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(width: 140, height: 16, borderRadius: 4),
                        ShimmerBox(width: 80, height: 22, borderRadius: 12),
                      ],
                    ),
                    SizedBox(height: 12),
                    ShimmerBox(width: 180, height: 13, borderRadius: 4),
                    SizedBox(height: 8),
                    ShimmerBox(width: 120, height: 13, borderRadius: 4),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(width: 90, height: 15, borderRadius: 4),
                        ShimmerBox(width: 110, height: 18, borderRadius: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
        final bloc = context.watch<BankSampahBloc>();
        final hasActiveFilter = bloc.hasActiveFilter;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
            ),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(bottomSheetContext).size.height * 0.85,
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
                              bloc.add(const ResetBankSampahFilterEvent());
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Sesuaikan kriteria pengurutan dan filter data',
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
                            'Kriteria Pengurutan',
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
                            children: BankSampahSortBy.values.map((sortBy) {
                              final isSelected = bloc.sortBy == sortBy;
                              return _buildFilterChip(
                                label: sortBy.label,
                                icon: sortBy.icon,
                                isSelected: isSelected,
                                onTap: () {
                                  bloc.add(
                                    SetBankSampahFilterEvent.sort(
                                      sortBy: sortBy,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Arah Pengurutan',
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
                            children: BankSampahSortDirection.values.map((dir) {
                              final isSelected = bloc.sortDirection == dir;
                              final contextLabel = _getDirectionContextLabel(
                                dir,
                                bloc.sortBy,
                              );
                              return _buildFilterChip(
                                label: contextLabel,
                                icon: dir.icon,
                                isSelected: isSelected,
                                onTap: () {
                                  bloc.add(
                                    SetBankSampahFilterEvent.sort(
                                      sortDirection: dir,
                                    ),
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
                                    bloc.selectedJenisSampahFilter == null,
                                onTap: () {
                                  bloc.add(
                                    const SetBankSampahFilterEvent.jenis(null),
                                  );
                                },
                              ),
                              ...BankSampahConstants.jenisSampahList.map((
                                jenis,
                              ) {
                                final isSelected =
                                    bloc.selectedJenisSampahFilter == jenis;
                                final icon = jenis.toLowerCase() == 'organik'
                                    ? Icons.eco_rounded
                                    : Icons.recycling_rounded;
                                return _buildFilterChip(
                                  label: jenis,
                                  icon: icon,
                                  color: AppColors.primary,
                                  isSelected: isSelected,
                                  onTap: () {
                                    bloc.add(
                                      SetBankSampahFilterEvent.jenis(
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
                                  bloc.selectedBankSampahFilter != null
                                  ? bloc.listLocations
                                        .cast<BankSampahLocationEntity?>()
                                        .firstWhere(
                                          (loc) =>
                                              loc?.nama ==
                                              bloc.selectedBankSampahFilter,
                                          orElse: () => null,
                                        )
                                  : null;

                              final selected = await BankSampahSearchSheet.show(
                                context,
                                initialSelected: currentSelectedLoc,
                                allowAll: true,
                              );

                              if (selected != null && context.mounted) {
                                if (selected.id == 'ALL' ||
                                    selected.nama == 'Semua Lokasi') {
                                  bloc.add(
                                    const SetBankSampahFilterEvent.bank(
                                      bankId: null,
                                      bankSampahNama: null,
                                    ),
                                  );
                                } else {
                                  bloc.add(
                                    SetBankSampahFilterEvent.bank(
                                      bankSampahNama: selected.nama,
                                      bankId: int.tryParse(selected.id),
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
                                  color: bloc.selectedBankSampahFilter != null
                                      ? AppColors.primary
                                      : AppColors.grey300,
                                  width: bloc.selectedBankSampahFilter != null
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
                                          bloc.selectedBankSampahFilter != null
                                          ? AppColors.primary.withValues(
                                              alpha: 0.12,
                                            )
                                          : AppColors.grey100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.account_balance_rounded,
                                      color:
                                          bloc.selectedBankSampahFilter != null
                                          ? AppColors.primary
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
                                          bloc.selectedBankSampahFilter ??
                                              'Semua Lokasi Bank Sampah',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                bloc.selectedBankSampahFilter !=
                                                    null
                                                ? AppColors.textPrimary
                                                : AppColors.textSecondary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          bloc.selectedBankSampahFilter != null
                                              ? 'Ketuk untuk mengubah lokasi bank sampah'
                                              : 'Cari atau pilih lokasi bank sampah',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (bloc.selectedBankSampahFilter !=
                                      null) ...[
                                    GestureDetector(
                                      onTap: () {
                                        bloc.add(
                                          const SetBankSampahFilterEvent.bank(
                                            bankId: null,
                                            bankSampahNama: null,
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
  }

  String _getDirectionContextLabel(
    BankSampahSortDirection dir,
    BankSampahSortBy sortBy,
  ) {
    if (dir == BankSampahSortDirection.desc) {
      switch (sortBy) {
        case BankSampahSortBy.date:
          return 'Terbaru';
        case BankSampahSortBy.weight:
          return 'Terbanyak';
        case BankSampahSortBy.price:
          return 'Tertinggi';
        case BankSampahSortBy.time:
          return 'Paling Akhir';
      }
    } else {
      switch (sortBy) {
        case BankSampahSortBy.date:
          return 'Terlama';
        case BankSampahSortBy.weight:
          return 'Tersedikit';
        case BankSampahSortBy.price:
          return 'Terendah';
        case BankSampahSortBy.time:
          return 'Paling Awal';
      }
    }
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
    final bgTint = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap ?? onRemove,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bgTint.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: bgTint.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.primaryDark),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.close_rounded,
                size: 14,
                color: AppColors.primaryDark,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
