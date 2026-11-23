import 'package:equatable/equatable.dart';

import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';

/// Hasil transaksi penukaran poin menjadi voucher.
class RedeemVoucherResultEntity extends Equatable {
  final VoucherEntity voucher;
  final int pointsSpent;
  final int remainingPoints;
  final String message;

  const RedeemVoucherResultEntity({
    required this.voucher,
    required this.pointsSpent,
    required this.remainingPoints,
    required this.message,
  });

  @override
  List<Object?> get props => [voucher, pointsSpent, remainingPoints, message];
}
