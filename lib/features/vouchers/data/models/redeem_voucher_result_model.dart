import 'package:akar/features/vouchers/data/models/voucher_json_utils.dart';
import 'package:akar/features/vouchers/data/models/voucher_model.dart';
import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';

/// Model DTO untuk response transaksi penukaran poin.
class RedeemVoucherResultModel extends RedeemVoucherResultEntity {
  const RedeemVoucherResultModel({
    required super.voucher,
    required super.pointsSpent,
    required super.remainingPoints,
    required super.message,
  });

  factory RedeemVoucherResultModel.fromJson(Map<String, dynamic> body) {
    final message = voucherAsString(
      body['message'],
      fallback: 'Voucher berhasil ditukar.',
    );
    final dataMap = voucherAsMap(body['data']);
    final voucherMap = voucherAsMap(dataMap['voucher']);
    final voucher = VoucherModel.fromJson(voucherMap);
    final pointsSpent = voucherAsInt(
      dataMap['points_spent'],
      fallback: voucher.pointsSpent,
    );
    final remainingPoints = voucherAsInt(dataMap['remaining_points']);

    return RedeemVoucherResultModel(
      voucher: voucher,
      pointsSpent: pointsSpent,
      remainingPoints: remainingPoints,
      message: message,
    );
  }
}
