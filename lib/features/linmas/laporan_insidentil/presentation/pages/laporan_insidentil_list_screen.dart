import 'dart:async';

import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/widgets/laporan_insidentil_body.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/widgets/laporan_insidentil_filter_button.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/widgets/laporan_insidentil_filter_sheet.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/widgets/laporan_insidentil_search_bar.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LaporanInsidentilListScreen extends HookWidget {
  final bool showFilter;

  const LaporanInsidentilListScreen({super.key, this.showFilter = true});

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<MyComplaintListBloc>();
    final nextState = bloc.stream
        .firstWhere(
          (state) =>
              state.status == MyComplaintListStatus.loaded ||
              state.status == MyComplaintListStatus.failure,
        )
        .timeout(const Duration(seconds: 15));
    bloc.add(const FetchMyComplaintsEvent(isRefresh: true, isInsidentil: true));
    try {
      await nextState;
    } catch (_) {}
  }

  Future<void> _openCreateReport(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final created = await AppRouter.toTambahLaporanInsidentil(context);
    if (created == true && context.mounted) {
      context.read<MyComplaintListBloc>().add(
        const FetchMyComplaintsEvent(isRefresh: true, isInsidentil: true),
      );
    }
  }

  void _openDetail(BuildContext context, ComplaintItem item) {
    FocusManager.instance.primaryFocus?.unfocus();
    ComplaintDetailPage.show(context, item);
  }

  void _openFilterSheet(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final bloc = context.read<MyComplaintListBloc>();
    if (bloc.state.categories.isEmpty && !bloc.state.isLoadingCategories) {
      bloc.add(const FetchIncidentCategoriesEvent());
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: LaporanInsidentilFilterSheet(
          initialStatus: bloc.state.statusFilter,
          initialCategory: bloc.state.categoryFilter,
          onApply: (status, category) {
            bloc.add(
              ApplyMyComplaintFilterEvent(status: status, category: category),
            );
          },
        ),
      ),
    );
  }

  void _dispatchSearch({
    required BuildContext context,
    required String query,
    required ObjectRef<Timer?> debounceTimer,
    bool immediate = false,
  }) {
    debounceTimer.value?.cancel();
    if (immediate) {
      context.read<MyComplaintListBloc>().add(SearchMyComplaintsEvent(query));
      return;
    }
    debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
      if (!context.mounted) return;
      context.read<MyComplaintListBloc>().add(SearchMyComplaintsEvent(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    final debounceTimer = useRef<Timer?>(null);

    useEffect(() {
      void onScroll() {
        if (!scrollController.hasClients) return;
        if (scrollController.position.pixels <
            scrollController.position.maxScrollExtent - 200) {
          return;
        }
        context.read<MyComplaintListBloc>().add(
          const LoadMoreMyComplaintsEvent(),
        );
      }

      scrollController.addListener(onScroll);
      return () {
        debounceTimer.value?.cancel();
        scrollController.removeListener(onScroll);
      };
    }, [scrollController]);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppPageBar(title: 'Laporan Insidentil'),
      floatingActionButton:
          BlocBuilder<MyComplaintListBloc, MyComplaintListState>(
            buildWhen: (prev, curr) => prev.items.isEmpty != curr.items.isEmpty,
            builder: (context, state) {
              if (state.items.isEmpty) {
                return const SizedBox.shrink();
              }
              return FloatingActionButton.extended(
                onPressed: () => _openCreateReport(context),
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.white,
                elevation: 3,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  'Buat Laporan',
                  style: AppTextStyles.button.copyWith(color: AppColors.white),
                ),
              );
            },
          ),
      body: BlocListener<MyComplaintListBloc, MyComplaintListState>(
        listenWhen: (previous, current) =>
            current.status == MyComplaintListStatus.failure &&
            current.items.isNotEmpty &&
            previous.status != current.status,
        listener: (context, state) {
          AppToast.showError(
            context,
            message: state.errorMessage ?? 'Gagal memperbarui daftar laporan.',
          );
        },
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: LaporanInsidentilSearchBar(
                        controller: searchController,
                        onChanged: (value) => _dispatchSearch(
                          context: context,
                          query: value,
                          debounceTimer: debounceTimer,
                        ),
                        onSubmitted: (value) => _dispatchSearch(
                          context: context,
                          query: value,
                          debounceTimer: debounceTimer,
                          immediate: true,
                        ),
                        onClear: () {
                          searchController.clear();
                          _dispatchSearch(
                            context: context,
                            query: '',
                            debounceTimer: debounceTimer,
                            immediate: true,
                          );
                        },
                      ),
                    ),
                    if (showFilter) ...[
                      const SizedBox(width: 10),
                      BlocBuilder<MyComplaintListBloc, MyComplaintListState>(
                        buildWhen: (prev, curr) =>
                            prev.activeFilterCount != curr.activeFilterCount,
                        builder: (context, state) {
                          return LaporanInsidentilFilterButton(
                            activeCount: state.activeFilterCount,
                            onTap: () => _openFilterSheet(context),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<MyComplaintListBloc, MyComplaintListState>(
                  builder: (context, state) {
                    return LaporanInsidentilBody(
                      state: state,
                      scrollController: scrollController,
                      onRefresh: () => _onRefresh(context),
                      onRetry: () => context.read<MyComplaintListBloc>().add(
                        const FetchMyComplaintsEvent(isInsidentil: true),
                      ),
                      onResetSearch: () {
                        searchController.clear();
                        _dispatchSearch(
                          context: context,
                          query: '',
                          debounceTimer: debounceTimer,
                          immediate: true,
                        );
                      },
                      onResetFilter: () =>
                          context.read<MyComplaintListBloc>().add(
                            const ApplyMyComplaintFilterEvent(
                              status: null,
                              category: null,
                            ),
                          ),
                      onCreateReport: () => _openCreateReport(context),
                      onItemTap: (item) => _openDetail(context, item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
