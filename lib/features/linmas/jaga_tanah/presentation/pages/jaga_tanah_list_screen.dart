import 'dart:async';

import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_list_bloc/jaga_tanah_list_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_body.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_filter_button.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_filter_sheet.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_search_bar.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class JagaTanahListScreen extends HookWidget {
  final bool showFilter;

  const JagaTanahListScreen({super.key, this.showFilter = true});

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<JagaTanahListBloc>();
    final nextState = bloc.stream
        .firstWhere(
          (state) =>
              state.status == JagaTanahListStatus.loaded ||
              state.status == JagaTanahListStatus.failure,
        )
        .timeout(const Duration(seconds: 15));
    bloc.add(const FetchJagaTanahReportsEvent(isRefresh: true));
    try {
      await nextState;
    } catch (_) {}
  }

  Future<void> _openCreateReport(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final created = await AppRouter.toTambahJagaTanah(context);
    if (created == true && context.mounted) {
      context.read<JagaTanahListBloc>().add(
        const FetchJagaTanahReportsEvent(isRefresh: true),
      );
    }
  }

  void _openDetail(BuildContext context, ComplaintItem item) {
    FocusManager.instance.primaryFocus?.unfocus();
    AppRouter.toJagaTanahDetail(context, item);
  }

  void _openFilterSheet(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final bloc = context.read<JagaTanahListBloc>();
    if (bloc.state.categories.isEmpty && !bloc.state.isLoadingCategories) {
      bloc.add(const FetchJagaTanahCategoriesEvent());
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
        child: JagaTanahFilterSheet(
          initialStatus: bloc.state.statusFilter,
          initialCategory: bloc.state.categoryFilter,
          onApply: (status, category) {
            bloc.add(
              ApplyJagaTanahFilterEvent(status: status, category: category),
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
      context.read<JagaTanahListBloc>().add(SearchJagaTanahReportsEvent(query));
      return;
    }
    debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
      if (!context.mounted) return;
      context.read<JagaTanahListBloc>().add(SearchJagaTanahReportsEvent(query));
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
        context.read<JagaTanahListBloc>().add(
          const LoadMoreJagaTanahReportsEvent(),
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
      appBar: const AppPageBar(title: 'Jaga Tanah'),
      floatingActionButton: BlocBuilder<JagaTanahListBloc, JagaTanahListState>(
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
      body: BlocListener<JagaTanahListBloc, JagaTanahListState>(
        listenWhen: (previous, current) =>
            current.status == JagaTanahListStatus.failure &&
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
                      child: JagaTanahSearchBar(
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
                      BlocBuilder<JagaTanahListBloc, JagaTanahListState>(
                        buildWhen: (prev, curr) =>
                            prev.activeFilterCount != curr.activeFilterCount,
                        builder: (context, state) {
                          return JagaTanahFilterButton(
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
                child: BlocBuilder<JagaTanahListBloc, JagaTanahListState>(
                  builder: (context, state) {
                    return JagaTanahBody(
                      state: state,
                      scrollController: scrollController,
                      onRefresh: () => _onRefresh(context),
                      onRetry: () => context.read<JagaTanahListBloc>().add(
                        const FetchJagaTanahReportsEvent(),
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
                      onResetFilter: () => context
                          .read<JagaTanahListBloc>()
                          .add(const ApplyJagaTanahFilterEvent()),
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
