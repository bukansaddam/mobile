import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_bar_circle_button.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';
import 'package:akar/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:akar/features/profile/presentation/widgets/profile_points_info_sheet.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_summary_entity.dart';
import 'package:akar/features/vouchers/presentation/bloc/redeem_voucher_bloc/redeem_voucher_bloc.dart';
import 'package:akar/features/vouchers/presentation/bloc/voucher_list_bloc/voucher_list_bloc.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_card.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_detail_dialog.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_empty_view.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_error_view.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_redeem_dialog.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_summary_card.dart';

/// Halaman utama daftar voucher dan penukaran poin.
class VoucherPage extends StatefulWidget {
  final int initialPoints;
  final bool isOfficer;
  final VoucherListBloc? voucherListBloc;
  final RedeemVoucherBloc? redeemVoucherBloc;

  const VoucherPage({
    super.key,
    this.initialPoints = 0,
    this.isOfficer = false,
    this.voucherListBloc,
    this.redeemVoucherBloc,
  });

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage>
    with SingleTickerProviderStateMixin {
  late final VoucherListBloc _voucherListBloc;
  late final RedeemVoucherBloc _redeemVoucherBloc;
  late final TabController _tabController;
  late final ScrollController _activeScrollController;
  late final ScrollController _historyScrollController;

  @override
  void initState() {
    super.initState();
    _voucherListBloc = widget.voucherListBloc ?? sl<VoucherListBloc>();
    _redeemVoucherBloc = widget.redeemVoucherBloc ?? sl<RedeemVoucherBloc>();

    _tabController = TabController(length: 2, vsync: this);
    _activeScrollController = ScrollController();
    _historyScrollController = ScrollController();

    _activeScrollController.addListener(_onActiveScroll);
    _historyScrollController.addListener(_onHistoryScroll);
    _tabController.addListener(_onTabChanged);

    if (widget.initialPoints > 0) {
      _voucherListBloc.add(SetInitialPointsEvent(widget.initialPoints));
    }

    _voucherListBloc.add(
      const FetchVouchersEvent(status: VoucherStatus.active),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _activeScrollController.removeListener(_onActiveScroll);
    _historyScrollController.removeListener(_onHistoryScroll);

    _tabController.dispose();
    _activeScrollController.dispose();
    _historyScrollController.dispose();

    if (widget.voucherListBloc == null) {
      _voucherListBloc.close();
    }
    if (widget.redeemVoucherBloc == null) {
      _redeemVoucherBloc.close();
    }
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    if (_tabController.index == 1) {
      final currentFilter = _voucherListBloc.state.historyFilter;
      final bucket = _voucherListBloc.state.buckets[currentFilter];
      if (bucket == null || !bucket.hasLoaded) {
        _voucherListBloc.add(FetchVouchersEvent(status: currentFilter));
      }
    }
  }

  void _onActiveScroll() {
    if (!_activeScrollController.hasClients) return;
    final pos = _activeScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _voucherListBloc.add(
        const LoadMoreVouchersEvent(status: VoucherStatus.active),
      );
    }
  }

  void _onHistoryScroll() {
    if (!_historyScrollController.hasClients) return;
    final pos = _historyScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _voucherListBloc.add(
        LoadMoreVouchersEvent(status: _voucherListBloc.state.historyFilter),
      );
    }
  }

  Future<void> _handleRedeemTap(VoucherSummaryEntity summary) async {
    final result = await VoucherRedeemDialog.show(context, summary: summary);

    if (result != null && result.confirmed) {
      _redeemVoucherBloc.add(SubmitRedeemVoucherEvent(notes: result.notes));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return MultiBlocProvider(
      providers: [
        BlocProvider<VoucherListBloc>.value(value: _voucherListBloc),
        BlocProvider<RedeemVoucherBloc>.value(value: _redeemVoucherBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RedeemVoucherBloc, RedeemVoucherState>(
            listener: (context, state) {
              if (state is RedeemVoucherSuccess) {
                _voucherListBloc.add(SyncVoucherAfterRedeemEvent(state.result));

                try {
                  context.read<ProfileBloc>().add(GetProfileEvent());
                } catch (_) {}

                VoucherDetailDialog.show(
                  context,
                  voucher: state.result.voucher,
                  isNewlyRedeemed: true,
                  remainingPoints: state.result.remainingPoints,
                );

                _redeemVoucherBloc.add(const ResetRedeemVoucherEvent());
              } else if (state is RedeemVoucherFailure) {
                AppToast.showError(context, message: state.message);
                if (state.statusCode == 422) {
                  _voucherListBloc.add(
                    const FetchVouchersEvent(
                      status: VoucherStatus.active,
                      isRefresh: true,
                    ),
                  );
                }
                _redeemVoucherBloc.add(const ResetRedeemVoucherEvent());
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: colors.background,
          appBar: AppPageBar(
            title: 'Poin & Voucher',
            actions: [
              BlocBuilder<VoucherListBloc, VoucherListState>(
                builder: (context, state) {
                  return AppBarCircleButton(
                    icon: Icons.info_outline_rounded,
                    tooltip: 'Info Poin',
                    onPressed: () {
                      ProfilePointsInfoSheet.show(
                        context,
                        points: state.displayedPoints,
                        isOfficer: widget.isOfficer,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<VoucherListBloc, VoucherListState>(
            builder: (context, listState) {
              final summary =
                  listState.summary ??
                  VoucherSummaryEntity(
                    currentPoints: listState.displayedPoints,
                    voucherPointCost: 100,
                    canRedeem: listState.displayedPoints >= 100,
                    redeemableCount: listState.displayedPoints ~/ 100,
                  );

              return BlocBuilder<RedeemVoucherBloc, RedeemVoucherState>(
                builder: (context, redeemState) {
                  final isSubmitting = redeemState is RedeemVoucherSubmitting;

                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: VoucherSummaryCard(
                              summary: summary,
                              isSubmitting: isSubmitting,
                              onRedeemTap: () => _handleRedeemTap(summary),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors.surfaceVariant,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                labelColor: colors.onPrimary,
                                unselectedLabelColor: colors.textSecondary,
                                labelStyle: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                tabs: const [
                                  Tab(text: 'Aktif'),
                                  Tab(text: 'Riwayat'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildActiveTab(context, listState, colors),
                        _buildHistoryTab(context, listState, colors),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTab(
    BuildContext context,
    VoucherListState state,
    AppColorScheme colors,
  ) {
    final bucket = state.activeBucket;

    if (bucket.isInitialLoading && bucket.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ReportCardShimmerList(itemCount: 4),
      );
    }

    if (bucket.errorMessage != null && bucket.items.isEmpty) {
      return VoucherErrorView(
        message: bucket.errorMessage!,
        onRetry: () => _voucherListBloc.add(
          const FetchVouchersEvent(
            status: VoucherStatus.active,
            isRefresh: true,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: colors.primary,
      onRefresh: () async {
        _voucherListBloc.add(
          const FetchVouchersEvent(
            status: VoucherStatus.active,
            isRefresh: true,
          ),
        );
      },
      child: bucket.items.isEmpty
          ? const VoucherEmptyView(status: VoucherStatus.active)
          : ListView.builder(
              controller: _activeScrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: bucket.items.length + (bucket.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= bucket.items.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.primary,
                        ),
                      ),
                    ),
                  );
                }

                final voucher = bucket.items[index];
                return VoucherCard(
                  voucher: voucher,
                  onTap: () => _showDetail(voucher),
                );
              },
            ),
    );
  }

  Widget _buildHistoryTab(
    BuildContext context,
    VoucherListState state,
    AppColorScheme colors,
  ) {
    final currentFilter = state.historyFilter;
    final bucket = state.currentHistoryBucket;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              _buildFilterPill(
                label: 'Terpakai',
                isSelected: currentFilter == VoucherStatus.used,
                onTap: () {
                  _voucherListBloc.add(
                    const ChangeHistoryFilterEvent(VoucherStatus.used),
                  );
                },
                colors: colors,
              ),
              const SizedBox(width: 8),
              _buildFilterPill(
                label: 'Kedaluwarsa',
                isSelected: currentFilter == VoucherStatus.expired,
                onTap: () {
                  _voucherListBloc.add(
                    const ChangeHistoryFilterEvent(VoucherStatus.expired),
                  );
                },
                colors: colors,
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildHistoryContent(context, bucket, currentFilter, colors),
        ),
      ],
    );
  }

  Widget _buildHistoryContent(
    BuildContext context,
    VoucherListBucket bucket,
    VoucherStatus currentFilter,
    AppColorScheme colors,
  ) {
    if (bucket.isInitialLoading && bucket.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ReportCardShimmerList(itemCount: 4),
      );
    }

    if (bucket.errorMessage != null && bucket.items.isEmpty) {
      return VoucherErrorView(
        message: bucket.errorMessage!,
        onRetry: () => _voucherListBloc.add(
          FetchVouchersEvent(status: currentFilter, isRefresh: true),
        ),
      );
    }

    return RefreshIndicator(
      color: colors.primary,
      onRefresh: () async {
        _voucherListBloc.add(
          FetchVouchersEvent(status: currentFilter, isRefresh: true),
        );
      },
      child: bucket.items.isEmpty
          ? VoucherEmptyView(status: currentFilter)
          : ListView.builder(
              controller: _historyScrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: bucket.items.length + (bucket.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= bucket.items.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.primary,
                        ),
                      ),
                    ),
                  );
                }

                final voucher = bucket.items[index];
                return VoucherCard(
                  voucher: voucher,
                  onTap: () => _showDetail(voucher),
                );
              },
            ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorScheme colors,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? colors.onPrimary : colors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _showDetail(VoucherEntity voucher) {
    VoucherDetailDialog.show(context, voucher: voucher);
  }
}
