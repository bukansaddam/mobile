import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/widgets/laporan_insidentil_card.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/widgets/laporan_insidentil_status_view.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:flutter/material.dart';

class LaporanInsidentilBody extends StatelessWidget {
  final MyComplaintListState state;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onResetSearch;
  final VoidCallback onResetFilter;
  final VoidCallback onCreateReport;
  final ValueChanged<ComplaintItem> onItemTap;

  const LaporanInsidentilBody({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onRefresh,
    required this.onRetry,
    required this.onResetSearch,
    required this.onResetFilter,
    required this.onCreateReport,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (state.status == MyComplaintListStatus.loading && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 14),
              Text(
                'Memuat laporan insidentil...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.status == MyComplaintListStatus.failure && state.items.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: onRefresh,
        child: LaporanInsidentilStatusView(
          icon: Icons.cloud_off_rounded,
          iconColor: AppColors.error,
          iconBackgroundColor: AppColors.errorLight,
          title: 'Gagal Memuat Laporan',
          message:
              state.errorMessage ??
              'Terjadi kendala saat mengambil daftar laporan insidentil.',
          actionLabel: 'Coba Lagi',
          actionIcon: Icons.refresh_rounded,
          onAction: onRetry,
        ),
      );
    }

    final visibleReports = state.filteredItems;
    if (visibleReports.isEmpty) {
      final isSearching = state.searchQuery.isNotEmpty;
      final hasFilter = state.hasActiveFilter;
      final hasConstraints = isSearching || hasFilter;
      final String emptyMessage = isSearching && hasFilter
          ? 'Tidak ada laporan yang cocok dengan "${state.searchQuery}" dan filter yang dipilih.'
          : isSearching
          ? 'Tidak ada laporan yang cocok dengan "${state.searchQuery}".'
          : hasFilter
          ? 'Tidak ada laporan yang sesuai dengan filter yang dipilih.'
          : 'Laporan kejadian lapangan yang Anda buat akan tampil di sini.';
      final String actionLabel = isSearching && hasFilter
          ? 'Reset Pencarian & Filter'
          : isSearching
          ? 'Reset Pencarian'
          : hasFilter
          ? 'Reset Filter'
          : 'Buat Laporan';

      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: onRefresh,
        child: LaporanInsidentilStatusView(
          icon: hasConstraints
              ? Icons.search_off_rounded
              : Icons.report_problem_outlined,
          iconColor: AppColors.primaryDark,
          iconBackgroundColor: AppColors.primaryLight,
          title: hasConstraints
              ? 'Laporan Tidak Ditemukan'
              : 'Belum Ada Laporan Insidentil',
          message: emptyMessage,
          actionLabel: actionLabel,
          actionIcon: hasConstraints ? Icons.close_rounded : Icons.add_rounded,
          onAction: () {
            if (isSearching) onResetSearch();
            if (hasFilter) onResetFilter();
            if (!hasConstraints) onCreateReport();
          },
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        itemCount: visibleReports.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index >= visibleReports.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
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

          final item = ComplaintItem.fromReport(visibleReports[index]);
          return LaporanInsidentilCard(
            item: item,
            onTap: () => onItemTap(item),
          );
        },
      ),
    );
  }
}
