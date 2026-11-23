import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/vouchers/data/datasources/voucher_remote_datasource.dart';
import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_page_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:akar/features/vouchers/domain/repositories/voucher_repository.dart';

/// Implementasi repositori voucher menggunakan remote data source.
class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDatasource remoteDatasource;

  const VoucherRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, VoucherPageEntity>> getMyVouchers({
    VoucherStatus? status,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final result = await remoteDatasource.getMyVouchers(
        status: status,
        page: page,
        perPage: perPage,
      );
      return Right(result);
    } catch (e) {
      return Left(
        ErrorUtils.toFailure(e, fallbackMessage: 'Gagal memuat daftar voucher'),
      );
    }
  }

  @override
  Future<Either<Failure, RedeemVoucherResultEntity>> redeemVoucher({
    String? notes,
    required String idempotencyKey,
  }) async {
    try {
      final result = await remoteDatasource.redeemVoucher(
        notes: notes,
        idempotencyKey: idempotencyKey,
      );
      return Right(result);
    } catch (e) {
      return Left(
        ErrorUtils.toFailure(e, fallbackMessage: 'Gagal menukarkan voucher'),
      );
    }
  }
}
