import 'package:equatable/equatable.dart';

import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_summary_entity.dart';

/// Halaman daftar voucher terpaginasi beserta ringkasan poin.
class VoucherPageEntity extends Equatable {
  final List<VoucherEntity> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final VoucherSummaryEntity summary;

  const VoucherPageEntity({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.summary,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [
    items,
    currentPage,
    lastPage,
    perPage,
    total,
    summary,
  ];
}
