part of 'redeem_voucher_bloc.dart';

abstract class RedeemVoucherState extends Equatable {
  const RedeemVoucherState();

  @override
  List<Object?> get props => [];
}

class RedeemVoucherInitial extends RedeemVoucherState {
  const RedeemVoucherInitial();
}

class RedeemVoucherSubmitting extends RedeemVoucherState {
  const RedeemVoucherSubmitting();
}

class RedeemVoucherSuccess extends RedeemVoucherState {
  final RedeemVoucherResultEntity result;

  const RedeemVoucherSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class RedeemVoucherFailure extends RedeemVoucherState {
  final String message;
  final int? statusCode;

  const RedeemVoucherFailure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}
