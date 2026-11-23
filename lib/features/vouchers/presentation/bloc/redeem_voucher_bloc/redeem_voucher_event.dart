part of 'redeem_voucher_bloc.dart';

abstract class RedeemVoucherEvent extends Equatable {
  const RedeemVoucherEvent();

  @override
  List<Object?> get props => [];
}

class SubmitRedeemVoucherEvent extends RedeemVoucherEvent {
  final String? notes;
  final String? idempotencyKey;

  const SubmitRedeemVoucherEvent({
    this.notes,
    this.idempotencyKey,
  });

  @override
  List<Object?> get props => [notes, idempotencyKey];
}

class ResetRedeemVoucherEvent extends RedeemVoucherEvent {
  const ResetRedeemVoucherEvent();
}
