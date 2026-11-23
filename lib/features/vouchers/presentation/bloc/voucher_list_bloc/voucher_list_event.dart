part of 'voucher_list_bloc.dart';

abstract class VoucherListEvent extends Equatable {
  const VoucherListEvent();

  @override
  List<Object?> get props => [];
}

class SetInitialPointsEvent extends VoucherListEvent {
  final int points;

  const SetInitialPointsEvent(this.points);

  @override
  List<Object?> get props => [points];
}

class FetchVouchersEvent extends VoucherListEvent {
  final VoucherStatus status;
  final bool isRefresh;

  const FetchVouchersEvent({
    required this.status,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [status, isRefresh];
}

class LoadMoreVouchersEvent extends VoucherListEvent {
  final VoucherStatus status;

  const LoadMoreVouchersEvent({required this.status});

  @override
  List<Object?> get props => [status];
}

class ChangeHistoryFilterEvent extends VoucherListEvent {
  final VoucherStatus status;

  const ChangeHistoryFilterEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class SyncVoucherAfterRedeemEvent extends VoucherListEvent {
  final RedeemVoucherResultEntity result;

  const SyncVoucherAfterRedeemEvent(this.result);

  @override
  List<Object?> get props => [result];
}
