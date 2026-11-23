import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';
import 'package:akar/features/vouchers/domain/usecases/redeem_voucher_usecase.dart';

part 'redeem_voucher_event.dart';
part 'redeem_voucher_state.dart';

class RedeemVoucherBloc extends Bloc<RedeemVoucherEvent, RedeemVoucherState> {
  final RedeemVoucherUsecase redeemVoucher;

  RedeemVoucherBloc({required this.redeemVoucher})
    : super(const RedeemVoucherInitial()) {
    on<SubmitRedeemVoucherEvent>(_onSubmitRedeemVoucher);
    on<ResetRedeemVoucherEvent>(_onResetRedeemVoucher);
  }

  static String generateIdempotencyKey() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // RFC 4122 version 4
    values[8] = (values[8] & 0x3f) | 0x80; // RFC 4122 variant 1

    final buffer = StringBuffer();
    for (int i = 0; i < 16; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10) {
        buffer.write('-');
      }
      buffer.write(values[i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  Future<void> _onSubmitRedeemVoucher(
    SubmitRedeemVoucherEvent event,
    Emitter<RedeemVoucherState> emit,
  ) async {
    if (state is RedeemVoucherSubmitting) return;

    emit(const RedeemVoucherSubmitting());

    final key =
        (event.idempotencyKey != null &&
            event.idempotencyKey!.trim().isNotEmpty)
        ? event.idempotencyKey!.trim()
        : generateIdempotencyKey();

    final result = await redeemVoucher(notes: event.notes, idempotencyKey: key);

    result.fold(
      (failure) {
        emit(
          RedeemVoucherFailure(
            message: failure.message,
            statusCode: failure.statusCode,
          ),
        );
      },
      (success) {
        emit(RedeemVoucherSuccess(success));
      },
    );
  }

  void _onResetRedeemVoucher(
    ResetRedeemVoucherEvent event,
    Emitter<RedeemVoucherState> emit,
  ) {
    emit(const RedeemVoucherInitial());
  }
}
