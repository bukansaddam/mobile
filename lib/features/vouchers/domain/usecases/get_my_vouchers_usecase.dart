import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_page_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:akar/features/vouchers/domain/repositories/voucher_repository.dart';

/// Mengambil daftar voucher pengguna aktif beserta ringkasan poin.
class GetMyVouchersUsecase {
  final VoucherRepository _repository;

  const GetMyVouchersUsecase(this._repository);

  Future<Either<Failure, VoucherPageEntity>> call({
    VoucherStatus? status,
    int page = 1,
    int perPage = 20,
  }) {
    return _repository.getMyVouchers(
      status: status,
      page: page,
      perPage: perPage,
    );
  }
}
