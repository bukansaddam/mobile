import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/linmas/activation/data/models/pending_activation_report_model.dart';
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
  final ScrollController _scrollController = ScrollController();
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        if (mounted) {
          context.read<ActivationBloc>().add(const SyncPendingReportsEvent());
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ActivationBloc>().add(const SyncPendingReportsEvent());
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ActivationBloc>().add(LoadMoreActivationActivitiesEvent());
    }
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context) {
    final colors = context.appColors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return BlocBuilder<ActivationBloc, ActivationState>(
          builder: (context, state) {
            final sheetColors = context.appColors;
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
                            color: sheetColors.borderStrong,
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
                            Text(
                              'Filter & Urutkan Kegiatan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: sheetColors.textPrimary,
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
                                  foregroundColor: sheetColors.error,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kustomisasi daftar kegiatan sesuai kebutuhan Anda',
                            style: TextStyle(
                              fontSize: 12,
                              color: sheetColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Divider(height: 1, color: sheetColors.divider),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Urutkan Berdasarkan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: sheetColors.textPrimary,
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
                              Text(
                                'Kategori Kegiatan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: sheetColors.textPrimary,
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
                                      color: cat.resolveColor(sheetColors),
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
                              Text(
                                'Status Kegiatan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: sheetColors.textPrimary,
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
                                      color: status.resolveColor(sheetColors),
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
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(bottomSheetContext),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: sheetColors.primary,
                              foregroundColor: sheetColors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Terapkan Filter',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: sheetColors.onPrimary,
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
    final colors = context.appColors;
    final activeColor = color ?? colors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : colors.borderStrong,
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
                color: isSelected ? activeColor : colors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : colors.textPrimary,
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
    final colors = context.appColors;
    final tagColor = color ?? colors.primary;
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

  Widget _buildPendingBanner(ActivationState state) {
    final colors = context.appColors;
    final isSyncing = state.isSyncingPending;
    final count = state.pendingReports.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: colors.warningLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            isSyncing ? Icons.cloud_upload_rounded : Icons.cloud_off_rounded,
            color: colors.warning,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: _showPendingReports,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSyncing
                        ? 'Mengirim laporan...'
                        : '$count laporan belum terkirim',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSyncing
                        ? 'Jangan tutup aplikasi sampai selesai.'
                        : 'Tersimpan di perangkat. Ketuk untuk melihat.',
                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: isSyncing
                ? null
                : () => context.read<ActivationBloc>().add(
                    const SyncPendingReportsEvent(),
                  ),
            child: Text(
              isSyncing ? 'Mengirim' : 'Kirim',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showPendingReports() {
    final colors = context.appColors;
    final screenContext = context;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return BlocBuilder<ActivationBloc, ActivationState>(
          builder: (context, state) {
            final sheetColors = context.appColors;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Laporan Menunggu Dikirim',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: sheetColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Laporan tersimpan di perangkat dan dikirim otomatis '
                      'saat ada koneksi.',
                      style: TextStyle(
                        fontSize: 12,
                        color: sheetColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: state.pendingReports.length,
                        separatorBuilder: (_, _) =>
                            Divider(height: 1, color: sheetColors.divider),
                        itemBuilder: (context, index) {
                          final report = state.pendingReports[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.assignment_late_rounded,
                              color: sheetColors.warning,
                            ),
                            title: Text(
                              report.activityTitle,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: sheetColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              '${DateFormat('HH:mm').format(report.createdAt)}'
                              ' • '
                              '${report.lastError == null ? 'Menunggu koneksi' : 'Gagal: ${report.lastError}'}',
                              style: TextStyle(
                                fontSize: 11,
                                color: sheetColors.textSecondary,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(sheetContext);
                              screenContext.pushNamed(
                                'activation_detail',
                                extra: {'activityId': report.participantId},
                              );
                            },
                            trailing: IconButton(
                              tooltip: 'Hapus',
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: sheetColors.error,
                              ),
                              onPressed: () =>
                                  _confirmDeletePending(context, report),
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
      },
    );
  }

  Future<void> _confirmDeletePending(
    BuildContext context,
    PendingActivationReportModel report,
  ) async {
    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Hapus laporan?',
      message:
          'Laporan "${report.activityTitle}" akan dihapus dari perangkat '
          'dan tidak akan pernah terkirim.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
      icon: Icons.delete_outline_rounded,
    );

    if (confirmed && context.mounted) {
      context.read<ActivationBloc>().add(DeletePendingReportEvent(report.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivationBloc, ActivationState>(
      builder: (context, state) {
        final colors = context.appColors;
        final filteredList = state.filteredActivities;
        final hasActiveFilter = state.hasActiveFilter;

        return Scaffold(
          backgroundColor: colors.background,
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(18.0, 14.0, 18.0, 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.shadow.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textPrimary,
                              ),
                              onChanged: (val) {
                                context.read<ActivationBloc>().add(
                                  SetActivationSearchQueryEvent(val),
                                );
                              },
                              decoration: InputDecoration(
                                hintText:
                                    'Cari kegiatan, lokasi, atau kategori...',
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: colors.textMuted,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: colors.primary,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear_rounded,
                                          color: colors.textMuted,
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
                                fillColor: colors.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: colors.borderStrong,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: colors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: colors.primary,
                                    width: 2,
                                  ),
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
                            color: hasActiveFilter
                                ? colors.primary
                                : colors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: hasActiveFilter
                                  ? colors.primary
                                  : colors.borderStrong,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.shadow.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.tune_rounded,
                              color: hasActiveFilter
                                  ? colors.onPrimary
                                  : colors.textPrimary,
                              size: 22,
                            ),
                            tooltip: 'Filter & Urutkan',
                            onPressed: () => _showFilterBottomSheet(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildAppliedTag(
                            label: state.selectedSortOption.label,
                            icon: state.selectedSortOption.icon,
                            color: colors.errorDark,
                            onTap: () => _showFilterBottomSheet(context),
                          ),
                          if (state.selectedCategoryFilter != null) ...[
                            const SizedBox(width: 8),
                            _buildAppliedTag(
                              label: state.selectedCategoryFilter!.label,
                              icon: state.selectedCategoryFilter!.icon,
                              color: state.selectedCategoryFilter!.resolveColor(
                                colors,
                              ),
                              onRemove: () {
                                context.read<ActivationBloc>().add(
                                  const SetActivationCategoryFilterEvent(null),
                                );
                              },
                            ),
                          ],
                          if (state.selectedStatusFilter != null) ...[
                            const SizedBox(width: 8),
                            _buildAppliedTag(
                              label: state.selectedStatusFilter!.label,
                              color: state.selectedStatusFilter!.resolveColor(
                                colors,
                              ),
                              onRemove: () {
                                context.read<ActivationBloc>().add(
                                  const SetActivationStatusFilterEvent(null),
                                );
                              },
                            ),
                          ],
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
                                  color: colors.border,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.refresh_rounded,
                                      size: 13,
                                      color: colors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Reset',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textSecondary,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daftar Kegiatan',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: colors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${filteredList.length} Kegiatan',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: colors.primaryDark,
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
              if (state.pendingReports.isNotEmpty) _buildPendingBanner(state),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () async {
                          context.read<ActivationBloc>().add(
                            const LoadActivationActivitiesEvent(),
                          );
                        },
                        child: filteredList.isEmpty
                            ? SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: 400,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 64,
                                        color: colors.textHint,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Kegiatan Tidak Ditemukan',
                                        style: AppTextStyles.headlineSmall
                                            .copyWith(
                                              fontSize: 16,
                                              color: colors.textPrimary,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Coba kata kunci lain atau ubah filter pada tombol filter.',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: colors.textSecondary,
                                              fontSize: 13,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  18.0,
                                  4.0,
                                  18.0,
                                  24.0,
                                ),
                                itemCount:
                                    filteredList.length +
                                    (state.isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == filteredList.length) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

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
              ),
            ],
          ),
        );
      },
    );
  }
}
