import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';
import 'package:akar/features/vouchers/domain/repositories/voucher_repository.dart';

/// Menukarkan 100 poin pengguna menjadi 1 kode voucher unik.
class RedeemVoucherUsecase {
  final VoucherRepository _repository;

  const RedeemVoucherUsecase(this._repository);

  Future<Either<Failure, RedeemVoucherResultEntity>> call({
    String? notes,
    required String idempotencyKey,
  }) {
    return _repository.redeemVoucher(
      notes: notes,
      idempotencyKey: idempotencyKey,
    );
  }
}
