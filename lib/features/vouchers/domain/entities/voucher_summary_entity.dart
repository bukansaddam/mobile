import 'package:equatable/equatable.dart';

/// Ringkasan saldo poin dan batas penukaran voucher pengguna.
class VoucherSummaryEntity extends Equatable {
  final int currentPoints;
  final int voucherPointCost;
  final bool canRedeem;
  final int redeemableCount;

  const VoucherSummaryEntity({
    required this.currentPoints,
    this.voucherPointCost = 100,
    required this.canRedeem,
    required this.redeemableCount,
  });

  /// Jumlah poin yang masih dibutuhkan untuk mencapai minimal 1 voucher.
  int get pointsNeeded {
    if (currentPoints >= voucherPointCost) return 0;
    return voucherPointCost - currentPoints;
  }

  /// Sinkronisasi instan saldo poin setelah transaksi redeem berhasil.
  VoucherSummaryEntity withRemainingPoints(int remainingPoints) {
    final int cost = voucherPointCost > 0 ? voucherPointCost : 100;
    final bool canStillRedeem = remainingPoints >= cost;
    final int count = cost > 0 ? remainingPoints ~/ cost : 0;

    return VoucherSummaryEntity(
      currentPoints: remainingPoints,
      voucherPointCost: cost,
      canRedeem: canStillRedeem,
      redeemableCount: count,
    );
  }

  @override
  List<Object?> get props => [
    currentPoints,
    voucherPointCost,
    canRedeem,
    redeemableCount,
  ];
}
