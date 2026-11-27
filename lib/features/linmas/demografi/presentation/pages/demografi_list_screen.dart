import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/institusi/presentation/bloc/institusi_bloc/institusi_bloc.dart';
import 'package:akar/features/linmas/demografi/institusi/presentation/widgets/institusi_detail_sheet.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/presentation/bloc/organisasi_bloc/organisasi_bloc.dart';
import 'package:akar/features/linmas/demografi/organisasi/presentation/widgets/organisasi_detail_sheet.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/entities/tokoh_entity.dart';
import 'package:akar/features/linmas/demografi/tokoh/presentation/bloc/tokoh_bloc/tokoh_bloc.dart';
import 'package:akar/features/linmas/demografi/tokoh/presentation/widgets/tokoh_detail_sheet.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';

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
  final ScrollController _institusiScrollController = ScrollController();
  final ScrollController _tokohScrollController = ScrollController();
  Timer? _debounceTimer;
  int _lastTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _lastTabIndex = 0;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _lastTabIndex,
    );
    _tabController.addListener(_handleTabChange);
    _organisasiScrollController.addListener(_onOrganisasiScroll);
    _institusiScrollController.addListener(_onInstitusiScroll);
    _tokohScrollController.addListener(_onTokohScroll);
  }

  void _onTokohScroll() {
    final tokohBloc = context.read<TokohBloc>();
    if (_tokohScrollController.position.pixels >=
        _tokohScrollController.position.maxScrollExtent - 200) {
      if (tokohBloc.page != null && tokohBloc.state is! TokohLoading) {
        tokohBloc.add(
          GetTokohEvent(
            search: tokohBloc.searchQuery.isNotEmpty
                ? tokohBloc.searchQuery
                : null,
            field: tokohBloc.selectedProfesiFilter,
            label: tokohBloc.selectedAfiliasiFilter,
            sort: tokohBloc.selectedSortOption,
          ),
        );
      }
    }
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

  void _onInstitusiScroll() {
    final institusiBloc = context.read<InstitusiBloc>();
    if (_institusiScrollController.position.pixels >=
        _institusiScrollController.position.maxScrollExtent - 200) {
      if (institusiBloc.page != null &&
          institusiBloc.state is! InstitusiLoading) {
        institusiBloc.add(
          GetInstitusiEvent(
            search: institusiBloc.searchQuery.isNotEmpty
                ? institusiBloc.searchQuery
                : null,
            scope: institusiBloc.selectedScopeFilter,
            sort: institusiBloc.selectedSortOption,
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
        context.read<TokohBloc>().searchQuery.isNotEmpty ||
        context.read<InstitusiBloc>().searchQuery.isNotEmpty ||
        context.read<OrganisasiBloc>().searchQuery.isNotEmpty;

    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      setState(() {});
    }

    final tokohBloc = context.read<TokohBloc>();
    final institusiBloc = context.read<InstitusiBloc>();
    final organisasiBloc = context.read<OrganisasiBloc>();
    tokohBloc.add(const SetTokohFilterEvent(search: ''));
    institusiBloc.add(const SetInstitusiFilterEvent(search: ''));
    organisasiBloc.add(const SetOrganisasiFilterEvent(search: ''));

    if (hadSearch && oldIndex == 0) {
      tokohBloc.add(
        RefreshTokohEvent(
          search: '',
          field: tokohBloc.selectedProfesiFilter,
          professions: tokohBloc.selectedProfesiFilter,
          label: tokohBloc.selectedAfiliasiFilter,
          affiliations: tokohBloc.selectedAfiliasiFilter,
          sort: tokohBloc.selectedSortOption,
        ),
      );
    } else if (hadSearch && oldIndex == 1) {
      institusiBloc.add(
        RefreshInstitusiEvent(
          search: '',
          scope: institusiBloc.selectedScopeFilter,
          sort: institusiBloc.selectedSortOption,
        ),
      );
    } else if (hadSearch && oldIndex == 2) {
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
    _institusiScrollController.removeListener(_onInstitusiScroll);
    _institusiScrollController.dispose();
    _tokohScrollController.removeListener(_onTokohScroll);
    _tokohScrollController.dispose();
    super.dispose();
  }

  Color _getAfiliasiColor(String afiliasi, AppColorScheme colors) {
    switch (afiliasi.toLowerCase()) {
      case 'politik':
        return colors.error;
      case 'ormas':
        return colors.orange;
      case 'agama':
        return colors.info;
      case 'budaya':
        return colors.indigo;
      case 'pemuda':
        return colors.success;
      case 'pengusaha':
        return colors.emerald;
      default:
        return colors.primary;
    }
  }

  Color _getBidangColor(String bidang, AppColorScheme colors) => colors.primary;

  Color _getScopeColor(String scope, AppColorScheme colors) => colors.primary;

  void _showFilterBottomSheet(BuildContext context) {
    final outerColors = context.appColors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: outerColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        final colors = bottomSheetContext.appColors;
        return BlocBuilder<TokohBloc, TokohState>(
          builder: (context, tokohState) {
            return BlocBuilder<OrganisasiBloc, OrganisasiState>(
              builder: (context, organisasiState) {
                return BlocBuilder<InstitusiBloc, InstitusiState>(
                  builder: (context, institusiState) {
                    final tokohBloc = context.read<TokohBloc>();
                    final organisasiBloc = context.read<OrganisasiBloc>();
                    final institusiBloc = context.read<InstitusiBloc>();
                    final activeTab = _tabController.index;
                    final hasActiveFilter = activeTab == 2
                        ? organisasiBloc.hasActiveFilter
                        : activeTab == 1
                        ? institusiBloc.hasActiveFilter
                        : tokohBloc.hasActiveFilter;

                    return SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(bottomSheetContext)
                              .viewInsets
                              .bottom,
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
                                    color: colors.borderStrong,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Filter & Urutkan Demografi',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                    if (hasActiveFilter)
                                      TextButton(
                                        onPressed: () {
                                          if (activeTab == 2) {
                                            context.read<OrganisasiBloc>().add(
                                              const ResetOrganisasiFilterEvent(),
                                            );
                                          } else if (activeTab == 1) {
                                            context.read<InstitusiBloc>().add(
                                              const ResetInstitusiFilterEvent(),
                                            );
                                          } else {
                                            context.read<TokohBloc>().add(
                                              const ResetTokohFilterEvent(),
                                            );
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: colors.error,
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    activeTab == 0
                                        ? 'Kustomisasi daftar tokoh sesuai kebutuhan Anda'
                                        : activeTab == 1
                                        ? 'Kustomisasi daftar institusi sesuai kebutuhan Anda'
                                        : 'Kustomisasi daftar organisasi sesuai kebutuhan Anda',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Divider(height: 1, color: colors.divider),

                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Urutkan Berdasarkan',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (activeTab == 2)
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: OrganisasiSortOption.values
                                              .map((sortOpt) {
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
                                              })
                                              .toList(),
                                        )
                                      else if (activeTab == 1)
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: InstitusiSortOption.values.map((
                                            sortOpt,
                                          ) {
                                            final isSelected =
                                                institusiBloc
                                                    .selectedSortOption ==
                                                sortOpt;
                                            return _buildFilterChip(
                                              label: sortOpt.label,
                                              isSelected: isSelected,
                                              onTap: () {
                                                context.read<InstitusiBloc>().add(
                                                  SetInstitusiFilterEvent.sort(
                                                    sortOpt,
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        )
                                      else
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: TokohSortOption.values.map((
                                            sortOpt,
                                          ) {
                                            final isSelected =
                                                tokohBloc.selectedSortOption ==
                                                sortOpt;
                                            return _buildFilterChip(
                                              label: sortOpt.label,
                                              icon: sortOpt.icon,
                                              isSelected: isSelected,
                                              onTap: () {
                                                context.read<TokohBloc>().add(
                                                  SetTokohFilterEvent.sort(
                                                    sortOpt,
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      const SizedBox(height: 22),

                                      if (activeTab == 0) ...[
                                        Text(
                                          'Profesi Tokoh',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textPrimary,
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
                                                  tokohBloc
                                                      .selectedProfesiFilter ==
                                                  null,
                                              onTap: () {
                                                context.read<TokohBloc>().add(
                                                  const SetTokohFilterEvent.professions(
                                                    null,
                                                  ),
                                                );
                                              },
                                            ),
                                            ...DemografiConstants.profesiOptions.map((
                                              profesi,
                                            ) {
                                              final isSelected =
                                                  tokohBloc
                                                      .selectedProfesiFilter ==
                                                  profesi;
                                              return _buildFilterChip(
                                                label: profesi,
                                                isSelected: isSelected,
                                                onTap: () {
                                                  context.read<TokohBloc>().add(
                                                    SetTokohFilterEvent.professions(
                                                      profesi,
                                                    ),
                                                  );
                                                },
                                              );
                                            }),
                                          ],
                                        ),
                                        const SizedBox(height: 22),

                                        Text(
                                          'Afiliasi Tokoh',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textPrimary,
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
                                                  tokohBloc
                                                      .selectedAfiliasiFilter ==
                                                  null,
                                              onTap: () {
                                                context.read<TokohBloc>().add(
                                                  const SetTokohFilterEvent.affiliations(
                                                    null,
                                                  ),
                                                );
                                              },
                                            ),
                                            ...DemografiConstants.afiliasiOptions.map((
                                              afiliasi,
                                            ) {
                                              final isSelected =
                                                  tokohBloc
                                                      .selectedAfiliasiFilter ==
                                                  afiliasi;
                                              return _buildFilterChip(
                                                label: afiliasi,
                                                isSelected: isSelected,
                                                onTap: () {
                                                  context.read<TokohBloc>().add(
                                                    SetTokohFilterEvent.affiliations(
                                                      afiliasi,
                                                    ),
                                                  );
                                                },
                                              );
                                            }),
                                          ],
                                        ),
                                      ],

                                      if (activeTab == 1) ...[
                                        Text(
                                          'Kategori Institusi',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textPrimary,
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
                                                  institusiBloc
                                                      .selectedKategoriFilter ==
                                                  null,
                                              onTap: () {
                                                context.read<InstitusiBloc>().add(
                                                  const SetInstitusiFilterEvent.kategori(
                                                    null,
                                                  ),
                                                );
                                              },
                                            ),
                                            ...institusiBloc.categoryOptions.map((
                                              kat,
                                            ) {
                                              final isSelected =
                                                  institusiBloc
                                                      .selectedKategoriFilter ==
                                                  kat;
                                              return _buildFilterChip(
                                                label: kat,
                                                isSelected: isSelected,
                                                onTap: () {
                                                  context.read<InstitusiBloc>().add(
                                                    SetInstitusiFilterEvent.kategori(
                                                      kat,
                                                    ),
                                                  );
                                                },
                                              );
                                            }),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Scope Institusi',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textPrimary,
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
                                                  institusiBloc
                                                      .selectedScopeFilter ==
                                                  null,
                                              onTap: () {
                                                context.read<InstitusiBloc>().add(
                                                  const SetInstitusiFilterEvent.scope(
                                                    null,
                                                  ),
                                                );
                                              },
                                            ),
                                            ...DemografiConstants
                                                .institusiScopeOptions
                                                .map((scope) {
                                                  final isSelected =
                                                      institusiBloc
                                                          .selectedScopeFilter ==
                                                      scope;
                                                  return _buildFilterChip(
                                                    label: scope,
                                                    isSelected: isSelected,
                                                    onTap: () {
                                                      context
                                                          .read<InstitusiBloc>()
                                                          .add(
                                                            SetInstitusiFilterEvent.scope(
                                                              scope,
                                                            ),
                                                          );
                                                    },
                                                  );
                                                }),
                                          ],
                                        ),
                                      ],

                                      if (activeTab == 2) ...[
                                        Text(
                                          'Bidang Organisasi',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textPrimary,
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
                                                  return _buildFilterChip(
                                                    label: bidang,
                                                    isSelected: isSelected,
                                                    onTap: () {
                                                      context
                                                          .read<
                                                            OrganisasiBloc
                                                          >()
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

                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(bottomSheetContext),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.primary,
                                      foregroundColor: colors.onPrimary,
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
                                        color: colors.onPrimary,
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
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    final activeColor = colors.primary;
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
    final fgColor = color ?? colors.primaryDark;
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
              Icon(icon, size: 14, color: fgColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: fgColor,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.close_rounded, size: 14, color: fgColor),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppPageBar(
        title: 'Demografi',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            indicatorColor: colors.primaryDark,
            indicatorWeight: 3,
            labelColor: colors.primaryDark,
            unselectedLabelColor: colors.textSecondary,
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
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          final activeTab = _tabController.index;
          final String fabTitle;
          final IconData fabIcon;
          if (activeTab == 0) {
            fabTitle = 'Tambah Tokoh';
            fabIcon = Icons.person_add_rounded;
          } else if (activeTab == 1) {
            fabTitle = 'Tambah Institusi';
            fabIcon = Icons.domain_add_rounded;
          } else {
            fabTitle = 'Tambah Organisasi';
            fabIcon = Icons.group_add_rounded;
          }

          return FloatingActionButton.extended(
            onPressed: () {
              if (activeTab == 0) {
                context.pushNamed('tambahTokoh');
              } else if (activeTab == 1) {
                context.pushNamed('tambahInstitusi');
              } else {
                context.pushNamed('tambahOrganisasi');
              }
            },
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            elevation: 4,
            icon: Icon(fabIcon),
            label: Text(
              fabTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          );
        },
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            _buildSearchAndFilterHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTokohTab(),
                  _buildInstitusiTab(),
                  _buildOrganisasiTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    final activeTab = _tabController.index;
                    final searchHint = activeTab == 0
                        ? 'Cari nama tokoh...'
                        : activeTab == 1
                        ? 'Cari nama institusi...'
                        : 'Cari nama organisasi...';
                    return _buildSearchTextField(searchHint);
                  },
                ),
              ),
              const SizedBox(width: 10),
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  final activeTab = _tabController.index;
                  if (activeTab == 2) {
                    return BlocBuilder<OrganisasiBloc, OrganisasiState>(
                      builder: (context, _) {
                        return _buildFilterButton(
                          context.read<OrganisasiBloc>().hasActiveFilter,
                        );
                      },
                    );
                  } else if (activeTab == 1) {
                    return BlocBuilder<InstitusiBloc, InstitusiState>(
                      builder: (context, _) {
                        return _buildFilterButton(
                          context.read<InstitusiBloc>().hasActiveFilter,
                        );
                      },
                    );
                  } else {
                    return BlocBuilder<TokohBloc, TokohState>(
                      builder: (context, _) {
                        return _buildFilterButton(
                          context.read<TokohBloc>().hasActiveFilter,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              final activeTab = _tabController.index;
              if (activeTab == 2) {
                return BlocBuilder<OrganisasiBloc, OrganisasiState>(
                  builder: (context, _) => _buildOrganisasiFilterChips(),
                );
              } else if (activeTab == 1) {
                return BlocBuilder<InstitusiBloc, InstitusiState>(
                  builder: (context, _) => _buildInstitusiFilterChips(),
                );
              } else {
                return BlocBuilder<TokohBloc, TokohState>(
                  builder: (context, _) => _buildTokohFilterChips(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTextField(String searchHint) {
    final colors = context.appColors;
    return Container(
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
        textInputAction: TextInputAction.search,
        style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: (val) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 500), () {
            if (!mounted) return;
            final activeTab = _tabController.index;
            if (activeTab == 2) {
              final orgBloc = context.read<OrganisasiBloc>();
              orgBloc.add(SetOrganisasiFilterEvent.search(val.trim()));
            } else if (activeTab == 1) {
              final instBloc = context.read<InstitusiBloc>();
              instBloc.add(SetInstitusiFilterEvent.search(val.trim()));
            } else {
              final tokBloc = context.read<TokohBloc>();
              tokBloc.add(SetTokohFilterEvent.search(val.trim()));
            }
          });
        },
        onSubmitted: (val) {
          _debounceTimer?.cancel();
          final activeTab = _tabController.index;
          if (activeTab == 2) {
            final orgBloc = context.read<OrganisasiBloc>();
            orgBloc.add(SetOrganisasiFilterEvent.search(val.trim()));
          } else if (activeTab == 1) {
            final instBloc = context.read<InstitusiBloc>();
            instBloc.add(SetInstitusiFilterEvent.search(val.trim()));
          } else {
            final tokBloc = context.read<TokohBloc>();
            tokBloc.add(SetTokohFilterEvent.search(val.trim()));
          }
        },
        decoration: InputDecoration(
          hintText: searchHint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: colors.textHint),
          prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, _) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(Icons.clear_rounded, color: colors.textHint),
                onPressed: () {
                  _debounceTimer?.cancel();
                  _searchController.clear();
                  final activeTab = _tabController.index;
                  if (activeTab == 2) {
                    final orgBloc = context.read<OrganisasiBloc>();
                    orgBloc.add(const SetOrganisasiFilterEvent.search(''));
                  } else if (activeTab == 1) {
                    final instBloc = context.read<InstitusiBloc>();
                    instBloc.add(const SetInstitusiFilterEvent.search(''));
                  } else {
                    final tokBloc = context.read<TokohBloc>();
                    tokBloc.add(const SetTokohFilterEvent.search(''));
                  }
                },
              );
            },
          ),
          filled: true,
          fillColor: colors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colors.borderStrong),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(bool hasActiveFilter) {
    final colors = context.appColors;
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: hasActiveFilter ? colors.primary : colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasActiveFilter ? colors.primary : colors.borderStrong,
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
          color: hasActiveFilter ? colors.onPrimary : colors.textPrimary,
          size: 22,
        ),
        tooltip: 'Filter & Urutkan',
        onPressed: () => _showFilterBottomSheet(context),
      ),
    );
  }

  Widget _buildTokohFilterChips() {
    final tokohBloc = context.read<TokohBloc>();
    if (!tokohBloc.hasActiveFilter) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildAppliedTag(
                label: tokohBloc.selectedSortOption.label,
                icon: tokohBloc.selectedSortOption.icon,
                onTap: () => _showFilterBottomSheet(context),
              ),
              if (tokohBloc.selectedProfesiFilter != null) ...[
                const SizedBox(width: 8),
                _buildAppliedTag(
                  label: 'Profesi: ${tokohBloc.selectedProfesiFilter}',
                  onRemove: () => context.read<TokohBloc>().add(
                    const SetTokohFilterEvent.professions(null),
                  ),
                ),
              ],
              if (tokohBloc.selectedAfiliasiFilter != null) ...[
                const SizedBox(width: 8),
                _buildAppliedTag(
                  label: 'Afiliasi: ${tokohBloc.selectedAfiliasiFilter}',
                  onRemove: () => context.read<TokohBloc>().add(
                    const SetTokohFilterEvent.affiliations(null),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              _buildResetFilterChip(
                onTap: () => context.read<TokohBloc>().add(
                  const ResetTokohFilterEvent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstitusiFilterChips() {
    final institusiBloc = context.read<InstitusiBloc>();
    if (!institusiBloc.hasActiveFilter) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildAppliedTag(
                label: institusiBloc.selectedSortOption.label,
                icon: Icons.sort_rounded,
                onTap: () => _showFilterBottomSheet(context),
              ),
              if (institusiBloc.selectedKategoriFilter != null) ...[
                const SizedBox(width: 8),
                _buildAppliedTag(
                  label: 'Kategori: ${institusiBloc.selectedKategoriFilter}',
                  icon: Icons.local_offer_outlined,
                  onRemove: () => context.read<InstitusiBloc>().add(
                    const SetInstitusiFilterEvent.kategori(null),
                  ),
                ),
              ],
              if (institusiBloc.selectedScopeFilter != null) ...[
                const SizedBox(width: 8),
                _buildAppliedTag(
                  label: 'Scope: ${institusiBloc.selectedScopeFilter}',
                  onRemove: () => context.read<InstitusiBloc>().add(
                    const SetInstitusiFilterEvent.scope(null),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              _buildResetFilterChip(
                onTap: () => context.read<InstitusiBloc>().add(
                  const ResetInstitusiFilterEvent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganisasiFilterChips() {
    final organisasiBloc = context.read<OrganisasiBloc>();
    if (!organisasiBloc.hasActiveFilter) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildAppliedTag(
                label: organisasiBloc.selectedSortOption.label,
                icon: organisasiBloc.selectedSortOption.icon,
                onTap: () => _showFilterBottomSheet(context),
              ),
              if (organisasiBloc.selectedBidangFilter != null) ...[
                const SizedBox(width: 8),
                _buildAppliedTag(
                  label: 'Bidang: ${organisasiBloc.selectedBidangFilter}',
                  onRemove: () => context.read<OrganisasiBloc>().add(
                    const SetOrganisasiFilterEvent.field(null),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              _buildResetFilterChip(
                onTap: () => context.read<OrganisasiBloc>().add(
                  const ResetOrganisasiFilterEvent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResetFilterChip({required VoidCallback onTap}) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, size: 14, color: colors.error),
            const SizedBox(width: 4),
            Text(
              'Reset',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokohTab() {
    return BlocBuilder<TokohBloc, TokohState>(
      builder: (context, state) {
        final colors = context.appColors;
        final tokohBloc = context.read<TokohBloc>();
        final list = tokohBloc.displayList;

        return RefreshIndicator(
          color: colors.primary,
          onRefresh: () async {
            tokohBloc.add(
              RefreshTokohEvent(
                field: tokohBloc.selectedProfesiFilter,
                professions: tokohBloc.selectedProfesiFilter,
                label: tokohBloc.selectedAfiliasiFilter,
                affiliations: tokohBloc.selectedAfiliasiFilter,
                sort: tokohBloc.selectedSortOption,
                search: tokohBloc.searchQuery.trim().isNotEmpty
                    ? tokohBloc.searchQuery.trim()
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
                    Expanded(
                      child: Text(
                        'Daftar Tokoh',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        '${tokohBloc.total > 0 ? tokohBloc.total : list.length} Tokoh',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.primaryDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state is TokohLoading && list.isEmpty
                    ? DemografiShimmerList.tokoh()
                    : state is TokohFailure && list.isEmpty
                    ? _buildErrorState(
                        context,
                        state.message,
                        onRetry: () {
                          tokohBloc.add(
                            RefreshTokohEvent(
                              field: tokohBloc.selectedProfesiFilter,
                              professions: tokohBloc.selectedProfesiFilter,
                              label: tokohBloc.selectedAfiliasiFilter,
                              affiliations: tokohBloc.selectedAfiliasiFilter,
                              sort: tokohBloc.selectedSortOption,
                              search: tokohBloc.searchQuery.trim().isNotEmpty
                                  ? tokohBloc.searchQuery.trim()
                                  : null,
                            ),
                          );
                        },
                      )
                    : list.isEmpty
                    ? _buildEmptyState(
                        title: 'Belum Ada Data Tokoh',
                        message: 'Tekan tombol "Tambah Tokoh" di bawah untuk mendaftarkan tokoh di sekitar Anda.',
                        icon: Icons.person_search_rounded,
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _tokohScrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount:
                            list.length + (tokohBloc.page != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == list.length && tokohBloc.page != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return _buildTokohCard(list[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstitusiTab() {
    return BlocBuilder<InstitusiBloc, InstitusiState>(
      builder: (context, state) {
        final colors = context.appColors;
        final institusiBloc = context.read<InstitusiBloc>();
        final list = institusiBloc.displayList;

        return RefreshIndicator(
          color: colors.primary,
          onRefresh: () async {
            institusiBloc.add(
              RefreshInstitusiEvent(
                scope: institusiBloc.selectedScopeFilter,
                kategori: institusiBloc.selectedKategoriFilter,
                sort: institusiBloc.selectedSortOption,
                search: institusiBloc.searchQuery.trim().isNotEmpty
                    ? institusiBloc.searchQuery.trim()
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
                    Expanded(
                      child: Text(
                        'Daftar Institusi',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        '${institusiBloc.total > 0 ? institusiBloc.total : list.length} Institusi',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.primaryDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state is InstitusiLoading && list.isEmpty
                    ? DemografiShimmerList.institusi()
                    : state is InstitusiFailure && list.isEmpty
                    ? _buildErrorState(
                        context,
                        state.message,
                        onRetry: () {
                          institusiBloc.add(
                            RefreshInstitusiEvent(
                              scope: institusiBloc.selectedScopeFilter,
                              sort: institusiBloc.selectedSortOption,
                              search:
                                  institusiBloc.searchQuery.trim().isNotEmpty
                                  ? institusiBloc.searchQuery.trim()
                                  : null,
                            ),
                          );
                        },
                      )
                    : list.isEmpty
                    ? _buildEmptyState(
                        title: 'Belum Ada Data Institusi',
                        message: 'Tekan tombol "Tambah Institusi" di bawah untuk mendaftarkan institusi baru.',
                        icon: Icons.domain_outlined,
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _institusiScrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount:
                            list.length + (institusiBloc.page != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == list.length &&
                              institusiBloc.page != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return _buildInstitusiCard(list[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrganisasiTab() {
    return BlocBuilder<OrganisasiBloc, OrganisasiState>(
      builder: (context, state) {
        final colors = context.appColors;
        final organisasiBloc = context.read<OrganisasiBloc>();
        final list = organisasiBloc.displayList;

        return RefreshIndicator(
          color: colors.primary,
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
                    Expanded(
                      child: Text(
                        'Daftar Organisasi',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        '${organisasiBloc.total > 0 ? organisasiBloc.total : list.length} Organisasi',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.primaryDark,
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
                    ? DemografiShimmerList.organisasi()
                    : state is OrganisasiFailure && list.isEmpty
                    ? _buildErrorState(
                        context,
                        state.message,
                        onRetry: () {
                          organisasiBloc.add(
                            RefreshOrganisasiEvent(
                              field: organisasiBloc.selectedBidangFilter,
                              sort: organisasiBloc.selectedSortOption,
                              search:
                                  organisasiBloc.searchQuery.trim().isNotEmpty
                                  ? organisasiBloc.searchQuery.trim()
                                  : null,
                            ),
                          );
                        },
                      )
                    : list.isEmpty
                    ? _buildEmptyState(
                        title: 'Belum Ada Data Organisasi',
                        message: 'Tekan tombol "Tambah Organisasi" di bawah untuk mendaftarkan organisasi baru.',
                        icon: Icons.groups_outlined,
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _organisasiScrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount:
                            list.length + (organisasiBloc.page != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == list.length &&
                              organisasiBloc.page != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.primary,
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
      },
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String message,
    required IconData icon,
  }) {
    final colors = context.appColors;
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
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
    final colors = context.appColors;
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: colors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Data',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (onRetry != null) {
                  onRetry();
                } else {
                  if (_tabController.index == 0) {
                    context.read<TokohBloc>().add(const GetTokohEvent());
                  } else if (_tabController.index == 1) {
                    context.read<InstitusiBloc>().add(
                      const GetInstitusiEvent(),
                    );
                  } else {
                    context.read<OrganisasiBloc>().add(
                      const GetOrganisasiEvent(),
                    );
                  }
                }
              },
              icon: Icon(Icons.refresh_rounded, color: colors.onPrimary),
              label: Text(
                'Coba Lagi',
                style: TextStyle(color: colors.onPrimary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
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
    final colors = context.appColors;
    final afiliasiColor = _getAfiliasiColor(tokoh.afiliasi, colors);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.03),
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
                  backgroundColor: colors.primary.withValues(alpha: 0.12),
                  child: Text(
                    tokoh.nama.isNotEmpty ? tokoh.nama[0].toUpperCase() : 'T',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: colors.primary,
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
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tokoh.profesi,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
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
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.textHint,
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
    final colors = context.appColors;
    final scopeColor = _getScopeColor(institusi.scope, colors);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.03),
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
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer_outlined,
                                  size: 11,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    institusi.displayKategori,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primary,
                                    ),
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
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  (institusi.alamat != null &&
                                          institusi.alamat!.trim().isNotEmpty)
                                      ? institusi.alamat!
                                      : (institusi.formattedWilayah.isNotEmpty
                                            ? institusi.formattedWilayah
                                            : 'Alamat belum diisi'),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: colors.textSecondary,
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
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.textHint,
                      size: 20,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: colors.divider),
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
                            'Scope: ${institusi.displayScope}',
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
                          color: colors.textHint,
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
    final colors = context.appColors;
    final bidangColor = _getBidangColor(organisasi.bidang, colors);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.03),
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
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.people_alt_outlined,
                                size: 14,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  organisasi.jumlahAnggota == 0
                                      ? 'Belum ada anggota'
                                      : '${organisasi.jumlahAnggota} Anggota',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.place_rounded,
                                size: 14,
                                color: colors.textSecondary,
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
                                    color: colors.textSecondary,
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
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.textHint,
                      size: 20,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: colors.divider),
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
                          color: colors.textHint,
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
