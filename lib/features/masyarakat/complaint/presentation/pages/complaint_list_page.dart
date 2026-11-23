import 'dart:async';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/complaint_list_bloc/complaint_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/widgets/complaint_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintListPage extends StatefulWidget {
  const ComplaintListPage({super.key});

  @override
  State<ComplaintListPage> createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends State<ComplaintListPage> {
  final TextEditingController _searchController = TextEditingController();
  late final ComplaintListBloc _bloc = sl<ComplaintListBloc>()
    ..add(const FetchComplaintsEvent());
  ComplaintStatus? _selectedStatusFilter;
  ComplaintCategory? _selectedCategoryFilter;
  String _searchQuery = '';
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _fetch({bool isRefresh = false}) {
    _bloc.add(
      FetchComplaintsEvent(
        isRefresh: isRefresh,
        status: _selectedStatusFilter == null
            ? null
            : complaintStatusCode(_selectedStatusFilter!),
        category: _selectedCategoryFilter?.label,
        query: _searchQuery.isEmpty ? null : _searchQuery,
      ),
    );
  }

  void _onSearchChanged(String value) {
    final query = value.trim();
    setState(() {
      _searchQuery = query;
    });
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), _fetch);
  }

  void _showDetailBottomSheet(BuildContext context, ComplaintItem item) {
    ComplaintDetailPage.show(context, item);
  }

  void _showFilterBottomSheet(BuildContext context) {
    ComplaintStatus? tempStatus = _selectedStatusFilter;
    ComplaintCategory? tempCategory = _selectedCategoryFilter;

    final colors = context.appColors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final sheetColors = sheetContext.appColors;
        return StatefulBuilder(
          builder: (context, setModalState) {
            final hasFilter = tempStatus != null || tempCategory != null;

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: sheetColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Pengaduan',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: sheetColors.textPrimary,
                        ),
                      ),
                      if (hasFilter)
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempStatus = null;
                              tempCategory = null;
                            });
                          },
                          child: Text(
                            'Reset Filter',
                            style: TextStyle(
                              fontSize: 13,
                              color: sheetColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Text(
                    'Status Pengaduan',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: sheetColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChipItem(
                        colors: sheetColors,
                        label: 'Semua Status',
                        isSelected: tempStatus == null,
                        onTap: () {
                          setModalState(() {
                            tempStatus = null;
                          });
                        },
                      ),
                      ...ComplaintStatus.values.map((status) {
                        final isSelected = tempStatus == status;
                        return _buildChipItem(
                          colors: sheetColors,
                          label: status.label,
                          isSelected: isSelected,
                          activeBgColor: status.resolveBgColor(sheetColors),
                          activeTextColor: status.resolveTextColor(sheetColors),
                          onTap: () {
                            setModalState(() {
                              tempStatus = isSelected ? null : status;
                            });
                          },
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 18),
                  Divider(height: 1, color: sheetColors.divider),
                  const SizedBox(height: 18),

                  Text(
                    'Kategori Pengaduan',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: sheetColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChipItem(
                        colors: sheetColors,
                        label: 'Semua Kategori',
                        isSelected: tempCategory == null,
                        onTap: () {
                          setModalState(() {
                            tempCategory = null;
                          });
                        },
                      ),
                      ...ComplaintCategory.values.map((cat) {
                        final isSelected = tempCategory == cat;
                        return _buildChipItem(
                          colors: sheetColors,
                          label: cat.label,
                          icon: cat.icon,
                          isSelected: isSelected,
                          onTap: () {
                            setModalState(() {
                              tempCategory = isSelected ? null : cat;
                            });
                          },
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStatusFilter = tempStatus;
                          _selectedCategoryFilter = tempCategory;
                        });
                        _fetch();
                        Navigator.pop(sheetContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sheetColors.primary,
                        foregroundColor: sheetColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Terapkan Filter',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChipItem({
    required AppColorScheme colors,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    Color? activeBgColor,
    Color? activeTextColor,
  }) {
    final bgColor = isSelected
        ? (activeBgColor ?? colors.primaryLight)
        : colors.surfaceVariant;
    final textColor = isSelected
        ? (activeTextColor ?? colors.primary)
        : colors.textMuted;
    final borderColor = isSelected
        ? (activeTextColor ?? colors.primary)
        : colors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<ComplaintListBloc, ComplaintListState>(
        builder: (context, state) {
          final items = state.items.map(ComplaintItem.fromReport).toList();
          final hasActiveFilter =
              _selectedStatusFilter != null || _selectedCategoryFilter != null;
          final activeFilterCount =
              (_selectedStatusFilter != null ? 1 : 0) +
              (_selectedCategoryFilter != null ? 1 : 0);

          return Scaffold(
            backgroundColor: colors.background,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: colors.border,
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onTapOutside: (event) => FocusManager
                                      .instance
                                      .primaryFocus
                                      ?.unfocus(),
                                  onChanged: _onSearchChanged,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Cari pengaduan, lokasi, atau ID...',
                                    hintStyle: AppTextStyles.bodyMedium
                                        .copyWith(
                                          color: colors.textHint,
                                          fontSize: 13.5,
                                        ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: colors.textMuted,
                                      size: 22,
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.cancel_rounded,
                                              color: colors.textHint,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              _onSearchChanged('');
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => _showFilterBottomSheet(context),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: hasActiveFilter
                                      ? colors.primaryLight
                                      : colors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: hasActiveFilter
                                        ? colors.primary
                                        : colors.border,
                                    width: 1.5,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      color: hasActiveFilter
                                          ? colors.primary
                                          : colors.textMuted,
                                      size: 22,
                                    ),
                                    if (hasActiveFilter)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: colors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '$activeFilterCount',
                                            style: TextStyle(
                                              color: colors.onPrimary,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (hasActiveFilter) ...[
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Filter: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (_selectedStatusFilter != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _selectedStatusFilter!
                                            .resolveBgColor(colors),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Status: ${_selectedStatusFilter!.label}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: _selectedStatusFilter!
                                                  .resolveTextColor(colors),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedStatusFilter = null;
                                              });
                                              _fetch();
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 14,
                                              color: _selectedStatusFilter!
                                                  .resolveTextColor(colors),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  if (_selectedCategoryFilter != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.primaryLight,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: colors.primaryBorder,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _selectedCategoryFilter!.icon,
                                            size: 12,
                                            color: colors.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Kategori: ${_selectedCategoryFilter!.label}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: colors.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedCategoryFilter = null;
                                              });
                                              _fetch();
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 14,
                                              color: colors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Daftar Pengaduan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colors.primaryBorder,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Total: ${state.total}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                            if (hasActiveFilter || _searchQuery.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _selectedStatusFilter = null;
                                    _selectedCategoryFilter = null;
                                  });
                                  _fetch();
                                },
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colors.error,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: RefreshIndicator(
                      color: colors.primary,
                      onRefresh: () async {
                        _fetch(isRefresh: true);
                        try {
                          await _bloc.stream.firstWhere(
                            (state) =>
                                state.status != ComplaintListStatus.loading,
                          );
                        } on StateError {
                          // Bloc ditutup saat refresh masih berjalan.
                        }
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 200) {
                            context.read<ComplaintListBloc>().add(
                              const LoadMoreComplaintsEvent(),
                            );
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (items.isEmpty &&
                                  state.status == ComplaintListStatus.loading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (items.isEmpty &&
                                  state.status == ComplaintListStatus.failure)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 32,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.cloud_off_rounded,
                                        size: 48,
                                        color: colors.borderStrong,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        state.errorMessage ??
                                            'Gagal memuat daftar pengaduan.',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: colors.textMuted,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _fetch,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colors.primary,
                                          foregroundColor: colors.onPrimary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Coba Lagi',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colors.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (items.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 40,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 56,
                                        color: colors.borderStrong,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Pengaduan Tidak Ditemukan',
                                        style: AppTextStyles.titleMedium
                                            .copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: colors.textPrimary,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Coba kata kunci pencarian lain atau ubah filter status.',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: colors.textMuted,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ComplaintListWidget(
                                  items: items,
                                  onItemTap: (item) =>
                                      _showDetailBottomSheet(context, item),
                                ),

                              if (state.isLoadingMore)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
