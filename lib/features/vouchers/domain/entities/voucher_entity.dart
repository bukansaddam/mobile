import 'package:equatable/equatable.dart';

import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';

/// Entitas voucher milik pengguna hasil penukaran poin.
class VoucherEntity extends Equatable {
  final int id;
  final String code;
  final int pointsSpent;
  final VoucherStatus status;
  final String? notes;
  final DateTime? redeemedAt;
  final DateTime? usedAt;

  const VoucherEntity({
    required this.id,
    required this.code,
    required this.pointsSpent,
    required this.status,
    this.notes,
    this.redeemedAt,
    this.usedAt,
  });

  bool get isActive => status == VoucherStatus.active;
  bool get isUsed => status == VoucherStatus.used;
  bool get isExpired => status == VoucherStatus.expired;

  @override
  List<Object?> get props => [
    id,
    code,
    pointsSpent,
    status,
    notes,
    redeemedAt,
    usedAt,
  ];
}
