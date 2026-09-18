import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';
import 'package:akar/features/linmas/demografi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/presentation/bloc/demografi_bloc/demografi_bloc.dart';
import 'package:akar/features/linmas/demografi/organisasi/presentation/bloc/organisasi_bloc/organisasi_bloc.dart';
import 'package:akar/features/linmas/demografi/presentation/widgets/institusi_detail_sheet.dart';
import 'package:akar/features/linmas/demografi/organisasi/presentation/widgets/organisasi_detail_sheet.dart';
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
  final ScrollController _organisasiScrollController = ScrollController();
  Timer? _debounceTimer;
  int _lastTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _lastTabIndex = context.read<DemografiBloc>().state.activeTabIndex;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _lastTabIndex,
    );
    _tabController.addListener(_handleTabChange);
    _organisasiScrollController.addListener(_onOrganisasiScroll);
  }

  void _onOrganisasiScroll() {
    final organisasiBloc = context.read<OrganisasiBloc>();
    if (_organisasiScrollController.position.pixels >=
        _organisasiScrollController.position.maxScrollExtent - 200) {
      if (organisasiBloc.page != null &&
          organisasiBloc.state is! OrganisasiLoading) {
        organisasiBloc.add(
          GetOrganisasiEvent(
            search: organisasiBloc.searchQuery.isNotEmpty
                ? organisasiBloc.searchQuery
                : null,
            field: organisasiBloc.selectedBidangFilter,
            sort: organisasiBloc.selectedSortOption,
          ),
        );
      }
    }
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _onTabChanged(_tabController.index);
    } else if (_tabController.index != _lastTabIndex) {
      _onTabChanged(_tabController.index);
    }
  }

  void _onTabChanged(int newIndex) {
    if (newIndex == _lastTabIndex) return;

    final oldIndex = _lastTabIndex;
    _lastTabIndex = newIndex;

    FocusManager.instance.primaryFocus?.unfocus();
    _debounceTimer?.cancel();

    final hadSearch =
        _searchController.text.isNotEmpty ||
        context.read<DemografiBloc>().state.searchQuery.isNotEmpty ||
        context.read<OrganisasiBloc>().searchQuery.isNotEmpty;

    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      setState(() {});
    }

    final demografiBloc = context.read<DemografiBloc>();
    final organisasiBloc = context.read<OrganisasiBloc>();
    demografiBloc.add(ClearDemografiSearchEvent());
    demografiBloc.add(SetDemografiActiveTabEvent(newIndex));
    organisasiBloc.add(const SetOrganisasiFilterEvent(search: ''));

    if (hadSearch && oldIndex == 2) {
      organisasiBloc.add(
        RefreshOrganisasiEvent(
          search: '',
          field: organisasiBloc.selectedBidangFilter,
          sort: organisasiBloc.selectedSortOption,
        ),
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    _organisasiScrollController.removeListener(_onOrganisasiScroll);
    _organisasiScrollController.dispose();
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

  Color _getBidangColor(String bidang) => AppColors.primary;

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
            return BlocBuilder<OrganisasiBloc, OrganisasiState>(
              builder: (context, organisasiState) {
                final organisasiBloc = context.read<OrganisasiBloc>();
                final activeTab = state.activeTabIndex;
                final hasActiveFilter = activeTab == 2
                    ? organisasiBloc.hasActiveFilter
                    : state.hasActiveFilter;

                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(
                        bottomSheetContext,
                      ).viewInsets.bottom,
                    ),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight:
                            MediaQuery.of(bottomSheetContext).size.height *
                            0.85,
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
                                      if (activeTab == 2) {
                                        context.read<OrganisasiBloc>().add(
                                          const ResetOrganisasiFilterEvent(),
                                        );
                                      } else {
                                        context.read<DemografiBloc>().add(
                                          ResetDemografiFiltersEvent(),
                                        );
                                      }
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
                                  if (activeTab == 2)
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: OrganisasiSortOption.values.map(
                                        (sortOpt) {
                                          final isSelected =
                                              organisasiBloc
                                                  .selectedSortOption ==
                                              sortOpt;
                                          return _buildFilterChip(
                                            label: sortOpt.label,
                                            icon: sortOpt.icon,
                                            isSelected: isSelected,
                                            onTap: () {
                                              context
                                                  .read<OrganisasiBloc>()
                                                  .add(
                                                    SetOrganisasiFilterEvent(
                                                      sort: sortOpt,
                                                    ),
                                                  );
                                            },
                                          );
                                        },
                                      ).toList(),
                                    )
                                  else
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
                                              SetDemografiSortOptionEvent(
                                                sortOpt,
                                              ),
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
                                              state.selectedProfesiFilter ==
                                              null,
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
                                              state.selectedScopeFilter ==
                                              scope;
                                          return _buildFilterChip(
                                            label: scope,
                                            color: const Color(0xFF0F9F66),
                                            isSelected: isSelected,
                                            onTap: () {
                                              context.read<DemografiBloc>().add(
                                                SetDemografiScopeFilterEvent(
                                                  scope,
                                                ),
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
                                              state.selectedAfiliasiFilter ==
                                              null,
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
                                          final color = _getAfiliasiColor(
                                            afiliasi,
                                          );
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
                                              state
                                                  .selectedInstitusiScopeFilter ==
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
                                              state
                                                  .selectedInstitusiScopeFilter ==
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
                                              organisasiBloc
                                                  .selectedBidangFilter ==
                                              null,
                                          onTap: () {
                                            context.read<OrganisasiBloc>().add(
                                              const SetOrganisasiFilterEvent(
                                                field: null,
                                              ),
                                            );
                                          },
                                        ),
                                        ...DemografiConstants
                                            .organisasiBidangOptions
                                            .map((bidang) {
                                              final isSelected =
                                                  organisasiBloc
                                                      .selectedBidangFilter ==
                                                  bidang;
                                              final color = _getBidangColor(
                                                bidang,
                                              );
                                              return _buildFilterChip(
                                                label: bidang,
                                                color: color,
                                                isSelected: isSelected,
                                                onTap: () {
                                                  context
                                                      .read<OrganisasiBloc>()
                                                      .add(
                                                        SetOrganisasiFilterEvent(
                                                          field: bidang,
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
                                onPressed: () =>
                                    Navigator.pop(bottomSheetContext),
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
    final organisasiBloc = context.watch<OrganisasiBloc>();
    final organisasiState = organisasiBloc.state;
    return BlocBuilder<DemografiBloc, DemografiState>(
      builder: (context, state) {
        final activeTab = state.activeTabIndex;
        final isOrgTab = activeTab == 2;
        final hasActiveFilter = isOrgTab
            ? organisasiBloc.hasActiveFilter
            : state.hasActiveFilter;

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                textInputAction: TextInputAction.search,
                                onTapOutside: (event) => FocusManager
                                    .instance
                                    .primaryFocus
                                    ?.unfocus(),
                                onChanged: (val) {
                                  setState(() {});
                                  _debounceTimer?.cancel();
                                  _debounceTimer = Timer(
                                    const Duration(milliseconds: 500),
                                    () {
                                      if (!mounted) return;
                                      final demografiBloc = context
                                          .read<DemografiBloc>();
                                      if (demografiBloc.state.activeTabIndex ==
                                          2) {
                                        final orgBloc = context
                                            .read<OrganisasiBloc>();
                                        orgBloc.add(
                                          SetOrganisasiFilterEvent.search(
                                            val.trim(),
                                          ),
                                        );
                                      } else {
                                        demografiBloc.add(
                                          SetDemografiSearchQueryEvent(val),
                                        );
                                      }
                                    },
                                  );
                                },
                                onSubmitted: (val) {
                                  _debounceTimer?.cancel();
                                  final demografiBloc = context
                                      .read<DemografiBloc>();
                                  if (demografiBloc.state.activeTabIndex == 2) {
                                    final orgBloc = context
                                        .read<OrganisasiBloc>();
                                    orgBloc.add(
                                      SetOrganisasiFilterEvent.search(
                                        val.trim(),
                                      ),
                                    );
                                  } else {
                                    demografiBloc.add(
                                      SetDemografiSearchQueryEvent(val),
                                    );
                                  }
                                },
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
                                            _debounceTimer?.cancel();
                                            _searchController.clear();
                                            setState(() {});
                                            final demografiBloc = context
                                                .read<DemografiBloc>();
                                            if (demografiBloc
                                                    .state
                                                    .activeTabIndex ==
                                                2) {
                                              final orgBloc = context
                                                  .read<OrganisasiBloc>();
                                              orgBloc.add(
                                                const SetOrganisasiFilterEvent.search(
                                                  '',
                                                ),
                                              );
                                            } else {
                                              demografiBloc.add(
                                                ClearDemografiSearchEvent(),
                                              );
                                            }
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
                              onPressed: () => _showFilterBottomSheet(context),
                            ),
                          ),
                        ],
                      ),

                      // Active Filter Chips Row
                      if (hasActiveFilter) ...[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                // Sort Tag
                                _buildAppliedTag(
                                  label: isOrgTab
                                      ? organisasiBloc.selectedSortOption.label
                                      : state.selectedSortOption.label,
                                  icon: isOrgTab
                                      ? organisasiBloc.selectedSortOption.icon
                                      : state.selectedSortOption.icon,
                                  color: AppColors.primary,
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
                                if (isOrgTab &&
                                    organisasiBloc.selectedBidangFilter !=
                                        null) ...[
                                  const SizedBox(width: 8),
                                  _buildAppliedTag(
                                    label:
                                        'Bidang: ${organisasiBloc.selectedBidangFilter}',
                                    color: _getBidangColor(
                                      organisasiBloc.selectedBidangFilter!,
                                    ),
                                    onRemove: () =>
                                        context.read<OrganisasiBloc>().add(
                                          const SetOrganisasiFilterEvent.field(
                                            null,
                                          ),
                                        ),
                                  ),
                                ],

                                // Reset Button Tag
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    if (isOrgTab) {
                                      context.read<OrganisasiBloc>().add(
                                        const ResetOrganisasiFilterEvent(),
                                      );
                                    } else {
                                      context.read<DemografiBloc>().add(
                                        ResetDemografiFiltersEvent(),
                                      );
                                    }
                                  },
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
                      _buildOrganisasiTab(context, organisasiState),
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
    final list = state.filteredTokohList;

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
            child: state is DemografiLoadingState && list.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state is DemografiFailureState && list.isEmpty
                ? _buildErrorState(context, state.message)
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
    final list = state.filteredInstitusiList;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DemografiBloc>().add(const FetchDemografiDataEvent());
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
            child: state is DemografiLoadingState && list.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state is DemografiFailureState && list.isEmpty
                ? _buildErrorState(context, state.message)
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

  Widget _buildOrganisasiTab(BuildContext context, OrganisasiState state) {
    final organisasiBloc = context.watch<OrganisasiBloc>();
    final list = organisasiBloc.displayList;

    return RefreshIndicator(
      onRefresh: () async {
        organisasiBloc.add(
          RefreshOrganisasiEvent(
            field: organisasiBloc.selectedBidangFilter,
            sort: organisasiBloc.selectedSortOption,
            search: organisasiBloc.searchQuery.trim().isNotEmpty
                ? organisasiBloc.searchQuery.trim()
                : null,
          ),
        );
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
                    '${organisasiBloc.total > 0 ? organisasiBloc.total : list.length} Organisasi',
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
            child: state is OrganisasiLoading && list.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state is OrganisasiFailure && list.isEmpty
                ? _buildErrorState(
                    context,
                    state.message,
                    onRetry: () {
                      organisasiBloc.add(
                        RefreshOrganisasiEvent(
                          field: organisasiBloc.selectedBidangFilter,
                          sort: organisasiBloc.selectedSortOption,
                          search: organisasiBloc.searchQuery.trim().isNotEmpty
                              ? organisasiBloc.searchQuery.trim()
                              : null,
                        ),
                      );
                    },
                  )
                : list.isEmpty
                ? _buildEmptyState(
                    title: 'Belum Ada Data Organisasi',
                    message:
                        'Tekan tombol "Tambah Organisasi" di bawah untuk mendaftarkan organisasi baru.',
                    icon: Icons.groups_outlined,
                  )
                : ListView.builder(
                    controller: _organisasiScrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount:
                        list.length + (organisasiBloc.page != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == list.length && organisasiBloc.page != null) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
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

  Widget _buildErrorState(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
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
                color: AppColors.errorLight.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Data',
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (onRetry != null) {
                  onRetry();
                } else {
                  context.read<DemografiBloc>().add(
                    const FetchDemografiDataEvent(),
                  );
                }
              },
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => InstitusiDetailSheet.show(context, institusi: institusi),
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
                              color: const Color(
                                0xFF0284C7,
                              ).withValues(alpha: 0.1),
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
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.grey400,
                      size: 20,
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
                          Icon(
                            Icons.verified_rounded,
                            size: 12,
                            color: scopeColor,
                          ),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () =>
              OrganisasiDetailSheet.show(context, organisasi: organisasi),
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
                                Icons.people_alt_outlined,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  organisasi.jumlahAnggota == 0
                                      ? 'Belum ada anggota'
                                      : '${organisasi.jumlahAnggota} Anggota',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
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
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.grey400,
                      size: 20,
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
        ),
      ),
    );
  }
}
