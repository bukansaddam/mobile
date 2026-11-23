import 'package:akar/features/vouchers/data/models/voucher_json_utils.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';

/// Model DTO untuk entitas voucher dari respon API.
class VoucherModel extends VoucherEntity {
  const VoucherModel({
    required super.id,
    required super.code,
    required super.pointsSpent,
    required super.status,
    super.notes,
    super.redeemedAt,
    super.usedAt,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: voucherAsInt(json['id']),
      code: voucherAsString(json['code']),
      pointsSpent: voucherAsInt(json['points_spent'], fallback: 100),
      status: VoucherStatus.fromApi(voucherAsString(json['status'])),
      notes: voucherAsNullableString(json['notes']),
      redeemedAt: voucherAsDateTime(json['redeemed_at']),
      usedAt: voucherAsDateTime(json['used_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'points_spent': pointsSpent,
      'status': status.apiValue,
      'notes': notes,
      'redeemed_at': redeemedAt?.toIso8601String(),
      'used_at': usedAt?.toIso8601String(),
    };
  }
}
