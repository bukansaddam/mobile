import 'dart:async';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_colors.dart';
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Pengaduan',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
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
                          child: const Text(
                            'Reset Filter',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFE11D48),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Status Pengaduan',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChipItem(
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
                          label: status.label,
                          isSelected: isSelected,
                          activeBgColor: status.bgColor,
                          activeTextColor: status.textColor,
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
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 18),

                  const Text(
                    'Kategori Pengaduan',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChipItem(
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
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
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    Color? activeBgColor,
    Color? activeTextColor,
  }) {
    final bgColor = isSelected
        ? (activeBgColor ?? const Color(0xFFDCFCE7))
        : const Color(0xFFF8FAFC);
    final textColor = isSelected
        ? (activeTextColor ?? AppColors.primary)
        : const Color(0xFF64748B);
    final borderColor = isSelected
        ? (activeTextColor ?? AppColors.primary)
        : const Color(0xFFE2E8F0);

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
            backgroundColor: const Color(0xFFF8FAFC),
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
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
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
                                          color: const Color(0xFF94A3B8),
                                          fontSize: 13.5,
                                        ),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF64748B),
                                      size: 22,
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.cancel_rounded,
                                              color: Color(0xFF94A3B8),
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
                                      ? const Color(0xFFDCFCE7)
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: hasActiveFilter
                                        ? AppColors.primary
                                        : const Color(0xFFE2E8F0),
                                    width: 1.5,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      color: hasActiveFilter
                                          ? AppColors.primary
                                          : const Color(0xFF64748B),
                                      size: 22,
                                    ),
                                    if (hasActiveFilter)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '$activeFilterCount',
                                            style: const TextStyle(
                                              color: Colors.white,
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
                                  const Text(
                                    'Filter: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
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
                                        color: _selectedStatusFilter!.bgColor,
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
                                                  .textColor,
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
                                                  .textColor,
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
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFBBF7D0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _selectedCategoryFilter!.icon,
                                            size: 12,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Kategori: ${_selectedCategoryFilter!.label}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
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
                                            child: const Icon(
                                              Icons.close_rounded,
                                              size: 14,
                                              color: AppColors.primary,
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
                        const Text(
                          'Daftar Pengaduan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
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
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFBBF7D0),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Total: ${state.total}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
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
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE11D48),
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
                      color: AppColors.primary,
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
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.cloud_off_rounded,
                                        size: 48,
                                        color: Color(0xFFCBD5E1),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        state.errorMessage ??
                                            'Gagal memuat daftar pengaduan.',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: const Color(0xFF64748B),
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _fetch,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Coba Lagi',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
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
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.search_off_rounded,
                                        size: 56,
                                        color: Color(0xFFCBD5E1),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Pengaduan Tidak Ditemukan',
                                        style: AppTextStyles.titleMedium
                                            .copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF0F172A),
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Coba kata kunci pencarian lain atau ubah filter status.',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: const Color(0xFF64748B),
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
