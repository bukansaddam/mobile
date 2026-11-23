import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_page_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';

/// Kontrak repositori domain untuk fitur voucher dan poin.
abstract class VoucherRepository {
  Future<Either<Failure, VoucherPageEntity>> getMyVouchers({
    VoucherStatus? status,
    int page = 1,
    int perPage = 20,
  });

  Future<Either<Failure, RedeemVoucherResultEntity>> redeemVoucher({
    String? notes,
    required String idempotencyKey,
  });
}
