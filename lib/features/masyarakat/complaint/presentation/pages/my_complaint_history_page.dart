import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/widgets/complaint_list_widget.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyComplaintHistoryPage extends StatefulWidget {
  final bool showAppBar;

  const MyComplaintHistoryPage({super.key, this.showAppBar = false});

  @override
  State<MyComplaintHistoryPage> createState() => _MyComplaintHistoryPageState();
}

class _MyComplaintHistoryPageState extends State<MyComplaintHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  ComplaintStatus? _selectedStatusFilter;
  ComplaintCategory? _selectedCategoryFilter;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ComplaintItem> _applyFilters(List<ComplaintItem> source) {
    return source.where((item) {
      if (_selectedStatusFilter != null &&
          item.status != _selectedStatusFilter) {
        return false;
      }

      if (_selectedCategoryFilter != null &&
          item.category.toLowerCase() !=
              _selectedCategoryFilter!.label.toLowerCase()) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchCategory = item.category.toLowerCase().contains(query);
        final matchLocation = item.location.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        final matchId = item.id.toLowerCase().contains(query);

        return matchTitle ||
            matchCategory ||
            matchLocation ||
            matchDesc ||
            matchId;
      }

      return true;
    }).toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  void _openDetail(BuildContext context, ComplaintItem item) {
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
                        'Filter Riwayat Pengaduan',
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
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
    return BlocBuilder<MyComplaintListBloc, MyComplaintListState>(
      builder: (context, state) {
        final allItems = state.items.map(ComplaintItem.fromReport).toList();
        final filteredList = _applyFilters(allItems);
        final hasActiveFilter =
            _selectedStatusFilter != null || _selectedCategoryFilter != null;
        final activeFilterCount =
            (_selectedStatusFilter != null ? 1 : 0) +
            (_selectedCategoryFilter != null ? 1 : 0);

        return Scaffold(
          backgroundColor: colors.background,
          appBar: widget.showAppBar
              ? const AppPageBar(title: 'Riwayat Pengaduan')
              : null,
          body: SafeArea(
            top: !widget.showAppBar,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Column(
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
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Cari riwayat pengaduan saya...',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
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
                                            setState(() {
                                              _searchQuery = '';
                                            });
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
                        'Riwayat Pengaduan Saya',
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
                              'Total: ${filteredList.length}',
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
                    onRefresh: () async => context
                        .read<MyComplaintListBloc>()
                        .add(const FetchMyComplaintsEvent(isRefresh: true)),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 200) {
                          context.read<MyComplaintListBloc>().add(
                            const LoadMoreMyComplaintsEvent(),
                          );
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 14.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (filteredList.isEmpty &&
                                state.status == MyComplaintListStatus.loading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (filteredList.isEmpty &&
                                state.status == MyComplaintListStatus.failure)
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
                                          'Gagal memuat riwayat pengaduan.',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: colors.textMuted,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => context
                                          .read<MyComplaintListBloc>()
                                          .add(const FetchMyComplaintsEvent()),
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
                            else if (filteredList.isEmpty)
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
                                      Icons.history_toggle_off_rounded,
                                      size: 56,
                                      color: colors.borderStrong,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _searchQuery.isNotEmpty || hasActiveFilter
                                          ? 'Riwayat Tidak Ditemukan'
                                          : 'Belum Ada Riwayat Pengaduan',
                                      style: AppTextStyles.titleMedium.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _searchQuery.isNotEmpty || hasActiveFilter
                                          ? 'Coba kata kunci lain atau reset filter.'
                                          : 'Sampaikan pengaduan Anda mengenai masalah di lingkungan sekitar.',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: colors.textMuted,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        final result =
                                            await CreateComplaintPage.show(
                                              context,
                                            );
                                        if (result == true && context.mounted) {
                                          context.read<MainCubit>().changeTab(
                                            0,
                                          );
                                          context
                                              .read<MyComplaintListBloc>()
                                              .add(
                                                const FetchMyComplaintsEvent(
                                                  isRefresh: true,
                                                ),
                                              );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add_rounded,
                                        color: colors.onPrimary,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Buat Pengaduan Baru',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colors.onPrimary,
                                        ),
                                      ),
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
                                    ),
                                  ],
                                ),
                              )
                            else
                              ComplaintListWidget(
                                items: filteredList,
                                onItemTap: (item) => _openDetail(context, item),
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

                            const SizedBox(height: 24),
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
    );
  }
}
