import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';
import 'package:akar/features/linmas/demografi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/presentation/bloc/demografi_bloc/demografi_bloc.dart';
import 'package:akar/features/linmas/demografi/presentation/widgets/tokoh_detail_sheet.dart';

class DemografiListScreen extends StatefulWidget {
  const DemografiListScreen({super.key});

  @override
  State<DemografiListScreen> createState() => _DemografiListScreenState();
}

class _DemografiListScreenState extends State<DemografiListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<DemografiBloc>().add(
          SetDemografiActiveTabEvent(_tabController.index),
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Color _getBidangColor(String bidang) {
    switch (bidang.toLowerCase()) {
      case 'usaha':
        return const Color(0xFF00ACC1);
      case 'keagamaan':
        return const Color(0xFF1E88E5);
      case 'politik':
        return const Color(0xFFE53935);
      case 'kebudayaan':
        return const Color(0xFF8E24AA);
      case 'kepemudaan':
        return const Color(0xFF43A047);
      case 'lingkungan':
        return const Color(0xFF0F9F66);
      default:
        return AppColors.primary;
    }
  }

  Color _getScopeColor(String scope) {
    switch (scope.toLowerCase()) {
      case 'kelurahan':
        return const Color(0xFF0F9F66);
      case 'kecamatan':
        return const Color(0xFF0284C7);
      case 'kabupaten/kota':
        return const Color(0xFFD97706);
      case 'provinsi':
        return const Color(0xFF9333EA);
      case 'nasional':
        return const Color(0xFFDC2626);
      default:
        return AppColors.primary;
    }
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
        return BlocBuilder<DemografiBloc, DemografiState>(
          builder: (context, state) {
            final hasActiveFilter = state.hasActiveFilter;
            final activeTab = state.activeTabIndex;

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
                                  context.read<DemografiBloc>().add(
                                    ResetDemografiFiltersEvent(),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            activeTab == 0
                                ? 'Kustomisasi daftar tokoh sesuai kebutuhan Anda'
                                : activeTab == 1
                                ? 'Kustomisasi daftar institusi sesuai kebutuhan Anda'
                                : 'Kustomisasi daftar organisasi sesuai kebutuhan Anda',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.grey200),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
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
                                children: DemografiSortOption.values.map((
                                  sortOpt,
                                ) {
                                  final isSelected =
                                      state.selectedSortOption == sortOpt;
                                  return _buildFilterChip(
                                    label: sortOpt.label,
                                    icon: sortOpt.icon,
                                    isSelected: isSelected,
                                    onTap: () {
                                      context.read<DemografiBloc>().add(
                                        SetDemografiSortOptionEvent(sortOpt),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 22),

                              // Tab 0 specific filters (Tokoh)
                              if (activeTab == 0) ...[
                                // Profesi Tokoh
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
                                          state.selectedProfesiFilter == null,
                                      onTap: () {
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiProfesiFilterEvent(
                                            null,
                                          ),
                                        );
                                      },
                                    ),
                                    ...DemografiConstants.profesiOptions.map((
                                      profesi,
                                    ) {
                                      final isSelected =
                                          state.selectedProfesiFilter ==
                                          profesi;
                                      return _buildFilterChip(
                                        label: profesi,
                                        color: const Color(0xFF0284C7),
                                        isSelected: isSelected,
                                        onTap: () {
                                          context.read<DemografiBloc>().add(
                                            SetDemografiProfesiFilterEvent(
                                              profesi,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 22),

                                // Scope Tokoh
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
                                          state.selectedScopeFilter == null,
                                      onTap: () {
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiScopeFilterEvent(
                                            null,
                                          ),
                                        );
                                      },
                                    ),
                                    ...DemografiConstants.scopeOptions.map((
                                      scope,
                                    ) {
                                      final isSelected =
                                          state.selectedScopeFilter == scope;
                                      return _buildFilterChip(
                                        label: scope,
                                        color: const Color(0xFF0F9F66),
                                        isSelected: isSelected,
                                        onTap: () {
                                          context.read<DemografiBloc>().add(
                                            SetDemografiScopeFilterEvent(scope),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 22),

                                // Afiliasi Tokoh
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
                                          state.selectedAfiliasiFilter == null,
                                      onTap: () {
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiAfiliasiFilterEvent(
                                            null,
                                          ),
                                        );
                                      },
                                    ),
                                    ...DemografiConstants.afiliasiOptions.map((
                                      afiliasi,
                                    ) {
                                      final isSelected =
                                          state.selectedAfiliasiFilter ==
                                          afiliasi;
                                      final color = _getAfiliasiColor(afiliasi);
                                      return _buildFilterChip(
                                        label: afiliasi,
                                        color: color,
                                        isSelected: isSelected,
                                        onTap: () {
                                          context.read<DemografiBloc>().add(
                                            SetDemografiAfiliasiFilterEvent(
                                              afiliasi,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ],

                              // Tab 1 specific filters (Institusi)
                              if (activeTab == 1) ...[
                                const Text(
                                  'Kategori Institusi',
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
                                          state
                                              .selectedInstitusiKategoriFilter ==
                                          null,
                                      onTap: () {
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiInstitusiKategoriFilterEvent(
                                            null,
                                          ),
                                        );
                                      },
                                    ),
                                    ...DemografiConstants.institusiKategoriOptions.map((
                                      kat,
                                    ) {
                                      final isSelected =
                                          state
                                              .selectedInstitusiKategoriFilter ==
                                          kat;
                                      return _buildFilterChip(
                                        label: kat,
                                        icon: Icons.local_offer_outlined,
                                        color: const Color(0xFF0284C7),
                                        isSelected: isSelected,
                                        onTap: () {
                                          context.read<DemografiBloc>().add(
                                            SetDemografiInstitusiKategoriFilterEvent(
                                              kat,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Scope Institusi',
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
                                          state.selectedInstitusiScopeFilter ==
                                          null,
                                      onTap: () {
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiInstitusiScopeFilterEvent(
                                            null,
                                          ),
                                        );
                                      },
                                    ),
                                    ...DemografiConstants.institusiScopeOptions.map((
                                      scope,
                                    ) {
                                      final isSelected =
                                          state.selectedInstitusiScopeFilter ==
                                          scope;
                                      final color = _getScopeColor(scope);
                                      return _buildFilterChip(
                                        label: scope,
                                        color: color,
                                        isSelected: isSelected,
                                        onTap: () {
                                          context.read<DemografiBloc>().add(
                                            SetDemografiInstitusiScopeFilterEvent(
                                              scope,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ],

                              // Tab 2 specific filters (Organisasi)
                              if (activeTab == 2) ...[
                                const Text(
                                  'Bidang Organisasi',
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
                                      label: 'Semua Bidang',
                                      isSelected:
                                          state
                                              .selectedOrganisasiBidangFilter ==
                                          null,
                                      onTap: () {
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiOrganisasiBidangFilterEvent(
                                            null,
                                          ),
                                        );
                                      },
                                    ),
                                    ...DemografiConstants.organisasiBidangOptions.map((
                                      bidang,
                                    ) {
                                      final isSelected =
                                          state
                                              .selectedOrganisasiBidangFilter ==
                                          bidang;
                                      final color = _getBidangColor(bidang);
                                      return _buildFilterChip(
                                        label: bidang,
                                        color: color,
                                        isSelected: isSelected,
                                        onTap: () {
                                          context.read<DemografiBloc>().add(
                                            SetDemografiOrganisasiBidangFilterEvent(
                                              bidang,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ],
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
    return BlocBuilder<DemografiBloc, DemografiState>(
      builder: (context, state) {
        final activeTab = state.activeTabIndex;

        String fabTitle;
        IconData fabIcon;
        Color fabColor;
        String searchHint;

        if (activeTab == 0) {
          fabTitle = 'Tambah Tokoh';
          fabIcon = Icons.person_add_rounded;
          fabColor = AppColors.primary;
          searchHint = 'Cari nama tokoh...';
        } else if (activeTab == 1) {
          fabTitle = 'Tambah Institusi';
          fabIcon = Icons.domain_add_rounded;
          fabColor = AppColors.primary;
          searchHint = 'Cari nama institusi...';
        } else {
          fabTitle = 'Tambah Organisasi';
          fabIcon = Icons.group_add_rounded;
          fabColor = AppColors.primary;
          searchHint = 'Cari nama organisasi...';
        }

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
              'Demografi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_alt_rounded, size: 18),
                            SizedBox(width: 6),
                            Text('Tokoh'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_rounded, size: 18),
                            SizedBox(width: 6),
                            Text('Institusi'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.groups_rounded, size: 18),
                            SizedBox(width: 6),
                            Text('Organisasi'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (activeTab == 0) {
                context.pushNamed('tambahTokoh');
              } else if (activeTab == 1) {
                context.pushNamed('tambahInstitusi');
              } else {
                context.pushNamed('tambahOrganisasi');
              }
            },
            backgroundColor: fabColor,
            foregroundColor: AppColors.white,
            elevation: 4,
            icon: Icon(fabIcon),
            label: Text(
              fabTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              children: [
                // Top Search & Filter Bar
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
                                onChanged: (val) => context
                                    .read<DemografiBloc>()
                                    .add(SetDemografiSearchQueryEvent(val)),
                                decoration: InputDecoration(
                                  hintText: searchHint,
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
                                            context.read<DemografiBloc>().add(
                                              ClearDemografiSearchEvent(),
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

                          // Filter Trigger Button
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
                              onPressed: () => _showFilterBottomSheet(context),
                            ),
                          ),
                        ],
                      ),

                      // Active Filter Chips Row
                      if (state.hasActiveFilter) ...[
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              // Sort Tag
                              _buildAppliedTag(
                                label: state.selectedSortOption.label,
                                icon: state.selectedSortOption.icon,
                                color: const Color(0xFFC62828),
                                onTap: () => _showFilterBottomSheet(context),
                              ),

                              // Tokoh Filters
                              if (activeTab == 0) ...[
                                if (state.selectedProfesiFilter != null) ...[
                                  const SizedBox(width: 8),
                                  _buildAppliedTag(
                                    label:
                                        'Profesi: ${state.selectedProfesiFilter}',
                                    color: const Color(0xFF0284C7),
                                    onRemove: () =>
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiProfesiFilterEvent(
                                            null,
                                          ),
                                        ),
                                  ),
                                ],
                                if (state.selectedScopeFilter != null) ...[
                                  const SizedBox(width: 8),
                                  _buildAppliedTag(
                                    label:
                                        'Scope: ${state.selectedScopeFilter}',
                                    color: const Color(0xFF0F9F66),
                                    onRemove: () =>
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiScopeFilterEvent(
                                            null,
                                          ),
                                        ),
                                  ),
                                ],
                                if (state.selectedAfiliasiFilter != null) ...[
                                  const SizedBox(width: 8),
                                  _buildAppliedTag(
                                    label:
                                        'Afiliasi: ${state.selectedAfiliasiFilter}',
                                    color: _getAfiliasiColor(
                                      state.selectedAfiliasiFilter!,
                                    ),
                                    onRemove: () =>
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiAfiliasiFilterEvent(
                                            null,
                                          ),
                                        ),
                                  ),
                                ],
                              ],

                              // Institusi Filters
                              if (activeTab == 1) ...[
                                if (state.selectedInstitusiKategoriFilter !=
                                    null) ...[
                                  const SizedBox(width: 8),
                                  _buildAppliedTag(
                                    label:
                                        'Kategori: ${state.selectedInstitusiKategoriFilter}',
                                    icon: Icons.local_offer_outlined,
                                    color: const Color(0xFF0284C7),
                                    onRemove: () =>
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiInstitusiKategoriFilterEvent(
                                            null,
                                          ),
                                        ),
                                  ),
                                ],
                                if (state.selectedInstitusiScopeFilter !=
                                    null) ...[
                                  const SizedBox(width: 8),
                                  _buildAppliedTag(
                                    label:
                                        'Scope: ${state.selectedInstitusiScopeFilter}',
                                    color: _getScopeColor(
                                      state.selectedInstitusiScopeFilter!,
                                    ),
                                    onRemove: () =>
                                        context.read<DemografiBloc>().add(
                                          const SetDemografiInstitusiScopeFilterEvent(
                                            null,
                                          ),
                                        ),
                                  ),
                                ],
                              ],

                              // Organisasi Filters
                              if (activeTab == 2 &&
                                  state.selectedOrganisasiBidangFilter !=
                                      null) ...[
                                const SizedBox(width: 8),
                                _buildAppliedTag(
                                  label:
                                      'Bidang: ${state.selectedOrganisasiBidangFilter}',
                                  color: _getBidangColor(
                                    state.selectedOrganisasiBidangFilter!,
                                  ),
                                  onRemove: () => context.read<DemografiBloc>().add(
                                    const SetDemografiOrganisasiBidangFilterEvent(
                                      null,
                                    ),
                                  ),
                                ),
                              ],

                              // Reset Button Tag
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => context.read<DemografiBloc>().add(
                                  ResetDemografiFiltersEvent(),
                                ),
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

                // TabBarView Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTokohTab(context, state),
                      _buildInstitusiTab(context, state),
                      _buildOrganisasiTab(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTokohTab(BuildContext context, DemografiState state) {
    final list = state.tokohList;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DemografiBloc>().add(FetchDemografiDataEvent());
      },
      child: Column(
        children: [
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
            child: state.status == DemografiStatus.loading && list.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : list.isEmpty
                ? _buildEmptyState(
                    title: 'Belum Ada Data Tokoh',
                    message:
                        'Tekan tombol "Tambah Tokoh" di bawah untuk mendaftarkan tokoh di sekitar Anda.',
                    icon: Icons.person_search_rounded,
                  )
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
  }

  Widget _buildInstitusiTab(BuildContext context, DemografiState state) {
    final list = state.institusiList;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DemografiBloc>().add(FetchDemografiDataEvent());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Institusi',
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
                    '${list.length} Institusi',
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
            child: state.status == DemografiStatus.loading && list.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : list.isEmpty
                ? _buildEmptyState(
                    title: 'Belum Ada Data Institusi',
                    message:
                        'Tekan tombol "Tambah Institusi" di bawah untuk mendaftarkan institusi baru.',
                    icon: Icons.account_balance_outlined,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _buildInstitusiCard(list[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganisasiTab(BuildContext context, DemografiState state) {
    final list = state.organisasiList;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DemografiBloc>().add(FetchDemografiDataEvent());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Organisasi',
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
                    '${list.length} Organisasi',
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
            child: state.status == DemografiStatus.loading && list.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : list.isEmpty
                ? _buildEmptyState(
                    title: 'Belum Ada Data Organisasi',
                    message:
                        'Tekan tombol "Tambah Organisasi" di bawah untuk mendaftarkan organisasi baru.',
                    icon: Icons.groups_outlined,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _buildOrganisasiCard(list[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String message,
    required IconData icon,
  }) {
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
              child: Icon(icon, size: 64, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => TokohDetailSheet.show(context, tokoh),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    tokoh.nama.isNotEmpty ? tokoh.nama[0].toUpperCase() : 'T',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tokoh.profesi,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
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
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grey400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstitusiCard(InstitusiEntity institusi) {
    final scopeColor = _getScopeColor(institusi.scope);

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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(
                              0xFF0284C7,
                            ).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_offer_outlined,
                              size: 11,
                              color: Color(0xFF0284C7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              institusi.kategori,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        institusi.nama,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              (institusi.alamat != null &&
                                      institusi.alamat!.trim().isNotEmpty)
                                  ? institusi.alamat!
                                  : 'Alamat belum diisi',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scopeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: scopeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, size: 12, color: scopeColor),
                      const SizedBox(width: 4),
                      Text(
                        'Scope: ${institusi.scope}',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: scopeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (institusi.createdAt != null)
                  Text(
                    'Disubmit: ${DateFormat('dd MMM yyyy').format(institusi.createdAt!)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganisasiCard(OrganisasiEntity organisasi) {
    final bidangColor = _getBidangColor(organisasi.bidang);

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
                        organisasi.nama,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.place_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              (organisasi.alamatSekretariat != null &&
                                      organisasi.alamatSekretariat!
                                          .trim()
                                          .isNotEmpty)
                                  ? organisasi.alamatSekretariat!
                                  : 'Sekretariat belum diisi',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.people_alt_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${organisasi.jumlahAnggota} Anggota',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bidangColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: bidangColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    organisasi.bidang,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: bidangColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (organisasi.createdAt != null)
                  Text(
                    'Disubmit: ${DateFormat('dd MMM yyyy').format(organisasi.createdAt!)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
