import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_summary_entity.dart';
import 'package:akar/features/vouchers/domain/usecases/get_my_vouchers_usecase.dart';

part 'voucher_list_event.dart';
part 'voucher_list_state.dart';

class VoucherListBloc extends Bloc<VoucherListEvent, VoucherListState> {
  final GetMyVouchersUsecase getMyVouchers;

  VoucherListBloc({required this.getMyVouchers})
    : super(const VoucherListState()) {
    on<SetInitialPointsEvent>(_onSetInitialPoints);
    on<FetchVouchersEvent>(_onFetchVouchers);
    on<LoadMoreVouchersEvent>(_onLoadMoreVouchers);
    on<ChangeHistoryFilterEvent>(_onChangeHistoryFilter);
    on<SyncVoucherAfterRedeemEvent>(_onSyncVoucherAfterRedeem);
  }

  void _onSetInitialPoints(
    SetInitialPointsEvent event,
    Emitter<VoucherListState> emit,
  ) {
    emit(state.copyWith(initialPointsFallback: event.points));
  }

  Future<void> _onFetchVouchers(
    FetchVouchersEvent event,
    Emitter<VoucherListState> emit,
  ) async {
    final status = event.status;
    final currentBucket = state.buckets[status] ?? const VoucherListBucket();

    if (!event.isRefresh && currentBucket.isInitialLoading) {
      return;
    }

    final updatedBuckets = Map<VoucherStatus, VoucherListBucket>.from(
      state.buckets,
    );
    updatedBuckets[status] = currentBucket.copyWith(
      isInitialLoading: true,
      clearError: true,
    );
    emit(state.copyWith(buckets: updatedBuckets));

    final result = await getMyVouchers(status: status, page: 1, perPage: 20);

    result.fold(
      (failure) {
        final failureBuckets = Map<VoucherStatus, VoucherListBucket>.from(
          state.buckets,
        );
        failureBuckets[status] = currentBucket.copyWith(
          isInitialLoading: false,
          errorMessage: failure.message,
        );
        emit(state.copyWith(buckets: failureBuckets));
      },
      (page) {
        final successBuckets = Map<VoucherStatus, VoucherListBucket>.from(
          state.buckets,
        );
        successBuckets[status] = VoucherListBucket(
          items: page.items,
          currentPage: page.currentPage,
          lastPage: page.lastPage,
          total: page.total,
          hasLoaded: true,
          isInitialLoading: false,
          isLoadingMore: false,
          errorMessage: null,
        );

        emit(state.copyWith(summary: page.summary, buckets: successBuckets));
      },
    );
  }

  Future<void> _onLoadMoreVouchers(
    LoadMoreVouchersEvent event,
    Emitter<VoucherListState> emit,
  ) async {
    final status = event.status;
    final currentBucket = state.buckets[status] ?? const VoucherListBucket();

    if (currentBucket.isInitialLoading ||
        currentBucket.isLoadingMore ||
        !currentBucket.hasMore) {
      return;
    }

    final updatedBuckets = Map<VoucherStatus, VoucherListBucket>.from(
      state.buckets,
    );
    updatedBuckets[status] = currentBucket.copyWith(
      isLoadingMore: true,
      clearError: true,
    );
    emit(state.copyWith(buckets: updatedBuckets));

    final nextPage = currentBucket.currentPage + 1;
    final result = await getMyVouchers(
      status: status,
      page: nextPage,
      perPage: 20,
    );

    result.fold(
      (failure) {
        final failureBuckets = Map<VoucherStatus, VoucherListBucket>.from(
          state.buckets,
        );
        failureBuckets[status] = currentBucket.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        );
        emit(state.copyWith(buckets: failureBuckets));
      },
      (page) {
        final existingIds = currentBucket.items.map((e) => e.id).toSet();
        final newItems = page.items.where((e) => !existingIds.contains(e.id));
        final mergedItems = [...currentBucket.items, ...newItems];

        final successBuckets = Map<VoucherStatus, VoucherListBucket>.from(
          state.buckets,
        );
        successBuckets[status] = currentBucket.copyWith(
          items: mergedItems,
          currentPage: page.currentPage,
          lastPage: page.lastPage,
          total: page.total,
          isLoadingMore: false,
          hasLoaded: true,
          clearError: true,
        );

        emit(state.copyWith(summary: page.summary, buckets: successBuckets));
      },
    );
  }

  void _onChangeHistoryFilter(
    ChangeHistoryFilterEvent event,
    Emitter<VoucherListState> emit,
  ) {
    if (state.historyFilter == event.status) return;
    emit(state.copyWith(historyFilter: event.status));

    final targetBucket = state.buckets[event.status];
    if (targetBucket == null || !targetBucket.hasLoaded) {
      add(FetchVouchersEvent(status: event.status));
    }
  }

  void _onSyncVoucherAfterRedeem(
    SyncVoucherAfterRedeemEvent event,
    Emitter<VoucherListState> emit,
  ) {
    final currentSummary =
        state.summary ??
        VoucherSummaryEntity(
          currentPoints: event.result.remainingPoints,
          voucherPointCost: 100,
          canRedeem: event.result.remainingPoints >= 100,
          redeemableCount: event.result.remainingPoints ~/ 100,
        );
    final updatedSummary = currentSummary.withRemainingPoints(
      event.result.remainingPoints,
    );

    final activeBucket = state.activeBucket;
    final filteredItems = activeBucket.items
        .where((e) => e.id != event.result.voucher.id)
        .toList();
    final updatedItems = [event.result.voucher, ...filteredItems];

    final updatedBuckets = Map<VoucherStatus, VoucherListBucket>.from(
      state.buckets,
    );
    updatedBuckets[VoucherStatus.active] = activeBucket.copyWith(
      items: updatedItems,
      total: activeBucket.total + 1,
      hasLoaded: true,
    );

    emit(state.copyWith(summary: updatedSummary, buckets: updatedBuckets));
  }
}
