import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/masyarakat/complaint/data/dummy_complaints.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/widgets/complaint_list_widget.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyComplaintHistoryPage extends StatefulWidget {
  const MyComplaintHistoryPage({super.key});

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

  List<ComplaintItem> get _filteredMyComplaints {
    return dummyMyComplaints.where((item) {
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
                        'Filter Riwayat Pengaduan',
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
    final filteredList = _filteredMyComplaints;
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
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.trim();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Cari riwayat pengaduan saya...',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
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
                                        color: _selectedStatusFilter!.textColor,
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
                                        color: _selectedStatusFilter!.textColor,
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

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Riwayat Pengaduan Saya',
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
                                'Total: ${filteredList.length}',
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

                    const SizedBox(height: 12),

                    if (filteredList.isEmpty)
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
                              Icons.history_toggle_off_rounded,
                              size: 56,
                              color: Color(0xFFCBD5E1),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isNotEmpty || hasActiveFilter
                                  ? 'Riwayat Tidak Ditemukan'
                                  : 'Belum Ada Riwayat Pengaduan',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _searchQuery.isNotEmpty || hasActiveFilter
                                  ? 'Coba kata kunci lain atau reset filter.'
                                  : 'Sampaikan pengaduan Anda mengenai masalah di lingkungan sekitar.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: const Color(0xFF64748B),
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await CreateComplaintPage.show(
                                  context,
                                );
                                if (result == true && context.mounted) {
                                  context.read<MainCubit>().changeTab(0);
                                }
                              },
                              icon: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: const Text(
                                'Buat Pengaduan Baru',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
