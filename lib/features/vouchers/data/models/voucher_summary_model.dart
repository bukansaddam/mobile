import 'package:akar/features/vouchers/data/models/voucher_json_utils.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_summary_entity.dart';

/// Model DTO untuk ringkasan poin dan limit redeem.
class VoucherSummaryModel extends VoucherSummaryEntity {
  const VoucherSummaryModel({
    required super.currentPoints,
    super.voucherPointCost = 100,
    required super.canRedeem,
    required super.redeemableCount,
  });

  factory VoucherSummaryModel.fromJson(Map<String, dynamic> json) {
    final cost = voucherAsInt(json['voucher_point_cost'], fallback: 100);
    final current = voucherAsInt(json['current_points']);
    final fallbackCanRedeem = current >= cost;
    final fallbackCount = cost > 0 ? current ~/ cost : 0;

    return VoucherSummaryModel(
      currentPoints: current,
      voucherPointCost: cost,
      canRedeem: voucherAsBool(json['can_redeem'], fallback: fallbackCanRedeem),
      redeemableCount: voucherAsInt(
        json['redeemable_count'],
        fallback: fallbackCount,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_points': currentPoints,
      'voucher_point_cost': voucherPointCost,
      'can_redeem': canRedeem,
      'redeemable_count': redeemableCount,
    };
  }
}
