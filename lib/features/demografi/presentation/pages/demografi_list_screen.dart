import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/demografi_constants.dart';
import '../provider/demografi_provider.dart';
import '../../domain/entities/tokoh_entity.dart';

class DemografiListScreen extends StatefulWidget {
  const DemografiListScreen({super.key});

  @override
  State<DemografiListScreen> createState() => _DemografiListScreenState();
}

class _DemografiListScreenState extends State<DemografiListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getAfiliasiColor(String afiliasi) {
    switch (afiliasi.toLowerCase()) {
      case 'politik':
        return const Color(0xFFE53935);
      case 'ormas':
        return const Color(0xFFFB8C00);
      case 'agama':
        return const Color(0xFF1E88E5);
      case 'budaya':
        return const Color(0xFF8E24AA);
      case 'pemuda':
        return const Color(0xFF43A047);
      case 'pengusaha':
        return const Color(0xFF00ACC1);
      default:
        return AppColors.primary;
    }
  }

  void _showFilterBottomSheet(
    BuildContext context,
    DemografiProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            final hasActiveFilter = provider.hasActiveFilter;

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
                              'Filter & Urutkan Demografi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (hasActiveFilter)
                              TextButton(
                                onPressed: () {
                                  provider.resetAllFilters();
                                  setBottomSheetState(() {});
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
                            'Kustomisasi daftar tokoh sesuai kebutuhan Anda',
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
                                children: DemografiSortOption.values.map((
                                  sortOpt,
                                ) {
                                  final isSelected =
                                      provider.selectedSortOption == sortOpt;
                                  return _buildFilterChip(
                                    label: sortOpt.label,
                                    icon: sortOpt.icon,
                                    isSelected: isSelected,
                                    onTap: () {
                                      provider.setSortOption(sortOpt);
                                      setBottomSheetState(() {});
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 22),

                              // Section 2: Profesi Tokoh
                              const Text(
                                'Profesi Tokoh',
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
                                    label: 'Semua Profesi',
                                    isSelected:
                                        provider.selectedProfesiFilter == null,
                                    onTap: () {
                                      provider.setProfesiFilter(null);
                                      setBottomSheetState(() {});
                                    },
                                  ),
                                  ...DemografiConstants.profesiOptions.map((
                                    profesi,
                                  ) {
                                    final isSelected =
                                        provider.selectedProfesiFilter ==
                                        profesi;
                                    return _buildFilterChip(
                                      label: profesi,
                                      color: const Color(0xFF0284C7),
                                      isSelected: isSelected,
                                      onTap: () {
                                        provider.setProfesiFilter(profesi);
                                        setBottomSheetState(() {});
                                      },
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 22),

                              // Section 3: Scope Tokoh
                              const Text(
                                'Scope Tokoh',
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
                                    label: 'Semua Scope',
                                    isSelected:
                                        provider.selectedScopeFilter == null,
                                    onTap: () {
                                      provider.setScopeFilter(null);
                                      setBottomSheetState(() {});
                                    },
                                  ),
                                  ...DemografiConstants.scopeOptions.map((
                                    scope,
                                  ) {
                                    final isSelected =
                                        provider.selectedScopeFilter == scope;
                                    return _buildFilterChip(
                                      label: scope,
                                      color: const Color(0xFF0F9F66),
                                      isSelected: isSelected,
                                      onTap: () {
                                        provider.setScopeFilter(scope);
                                        setBottomSheetState(() {});
                                      },
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 22),

                              // Section 4: Afiliasi Tokoh
                              const Text(
                                'Afiliasi Tokoh',
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
                                    label: 'Semua Afiliasi',
                                    isSelected:
                                        provider.selectedAfiliasiFilter == null,
                                    onTap: () {
                                      provider.setAfiliasiFilter(null);
                                      setBottomSheetState(() {});
                                    },
                                  ),
                                  ...DemografiConstants.afiliasiOptions.map((
                                    afiliasi,
                                  ) {
                                    final isSelected =
                                        provider.selectedAfiliasiFilter ==
                                        afiliasi;
                                    final color = _getAfiliasiColor(afiliasi);
                                    return _buildFilterChip(
                                      label: afiliasi,
                                      color: color,
                                      isSelected: isSelected,
                                      onTap: () {
                                        provider.setAfiliasiFilter(afiliasi);
                                        setBottomSheetState(() {});
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
          'Demografi Tokoh',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed('tambah_tokoh');
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Tokoh',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: Consumer<DemografiProvider>(
        builder: (context, provider, child) {
          final list = provider.tokohList;
          final hasActiveFilter = provider.hasActiveFilter;

          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchTokohList();
            },
            child: Column(
              children: [
                // Top Filter & Search Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    children: [
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
                                onChanged: (val) =>
                                    provider.setSearchQuery(val),
                                decoration: InputDecoration(
                                  hintText: 'Cari nama tokoh, profesi, suku...',
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
                                            provider.clearSearch();
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

                          // Filter Trigger Button
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
                              onPressed: () =>
                                  _showFilterBottomSheet(context, provider),
                            ),
                          ),
                        ],
                      ),

                      // Active Filter Chips Row
                      if (hasActiveFilter) ...[
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              // Sort Tag
                              _buildAppliedTag(
                                label: provider.selectedSortOption.label,
                                icon: provider.selectedSortOption.icon,
                                color: const Color(0xFFC62828),
                                onTap: () =>
                                    _showFilterBottomSheet(context, provider),
                              ),

                              // Profesi Tag
                              if (provider.selectedProfesiFilter != null) ...[
                                const SizedBox(width: 8),
                                _buildAppliedTag(
                                  label:
                                      'Profesi: ${provider.selectedProfesiFilter}',
                                  color: const Color(0xFF0284C7),
                                  onRemove: () =>
                                      provider.setProfesiFilter(null),
                                ),
                              ],

                              // Scope Tag
                              if (provider.selectedScopeFilter != null) ...[
                                const SizedBox(width: 8),
                                _buildAppliedTag(
                                  label:
                                      'Scope: ${provider.selectedScopeFilter}',
                                  color: const Color(0xFF0F9F66),
                                  onRemove: () => provider.setScopeFilter(null),
                                ),
                              ],

                              // Afiliasi Tag
                              if (provider.selectedAfiliasiFilter != null) ...[
                                const SizedBox(width: 8),
                                _buildAppliedTag(
                                  label:
                                      'Afiliasi: ${provider.selectedAfiliasiFilter}',
                                  color: _getAfiliasiColor(
                                    provider.selectedAfiliasiFilter!,
                                  ),
                                  onRemove: () =>
                                      provider.setAfiliasiFilter(null),
                                ),
                              ],

                              // Reset Button Tag
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => provider.resetAllFilters(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.error.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        size: 14,
                                        color: AppColors.error,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Reset',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Tokoh',
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
                          '${list.length} Tokoh',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child:
                      provider.state == DemografiState.loading && list.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : list.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return _buildTokohCard(list[index]);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.grey200.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Data Tokoh',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tekan tombol "Tambah Tokoh" di bawah untuk mendaftarkan tokoh tokoh di sekitar Anda.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokohCard(TokohEntity tokoh) {
    final afiliasiColor = _getAfiliasiColor(tokoh.afiliasi);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tokoh.nama,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${tokoh.profesi}${tokoh.suku.isNotEmpty ? ' • Suku ${tokoh.suku}' : ''}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.corporate_fare_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              tokoh.namaOrganisasi.trim().isNotEmpty
                                  ? tokoh.namaOrganisasi
                                  : '-',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: AppColors.grey200),
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  tokoh.noTelp.isNotEmpty ? tokoh.noTelp : '-',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.public_rounded,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        tokoh.wilayah,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: afiliasiColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: afiliasiColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    tokoh.afiliasi,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: afiliasiColor,
                    ),
                  ),
                ),
              ],
            ),
            if (tokoh.createdAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Disubmit: ${DateFormat('dd MMM yyyy, HH:mm').format(tokoh.createdAt!)} WIB',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
