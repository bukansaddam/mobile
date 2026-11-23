import 'package:dio/dio.dart';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/vouchers/data/models/redeem_voucher_result_model.dart';
import 'package:akar/features/vouchers/data/models/voucher_json_utils.dart';
import 'package:akar/features/vouchers/data/models/voucher_page_model.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:akar/utils/app_logger.dart';

/// Kontrak remote datasource untuk endpoint voucher dan redeem.
abstract class VoucherRemoteDatasource {
  Future<VoucherPageModel> getMyVouchers({
    VoucherStatus? status,
    int page = 1,
    int perPage = 20,
  });

  Future<RedeemVoucherResultModel> redeemVoucher({
    String? notes,
    required String idempotencyKey,
  });
}

class VoucherRemoteDatasourceImpl extends BaseRemoteDataSource
    implements VoucherRemoteDatasource {
  final Dio? _dioOverride;

  VoucherRemoteDatasourceImpl({Dio? dio}) : _dioOverride = dio;

  @override
  Dio get dio => _dioOverride ?? super.dio;

  @override
  Future<VoucherPageModel> getMyVouchers({
    VoucherStatus? status,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (status != null) 'status': status.apiValue,
      };

      final response = await dio.get(
        ApiConstants.vouchersMe,
        queryParameters: queryParams,
      );

      final body = voucherAsMap(response.data);
      final statusCode = response.statusCode ?? 200;

      if (statusCode < 200 || statusCode >= 300 || body['success'] == false) {
        final msg = ErrorUtils.parseErrorMessage(body);
        throw ServerException(
          msg.isNotEmpty ? msg : 'Gagal memuat daftar voucher',
          statusCode: statusCode,
        );
      }

      return VoucherPageModel.fromJson(body);
    } on DioException catch (e, s) {
      AppLogger.e(
        '[VOUCHER_DS] DioException in getMyVouchers: ${e.message}',
        e,
        s,
      );
      throw ErrorUtils.toAppException(
        e,
        fallbackMessage: 'Gagal memuat daftar voucher',
      );
    } catch (e, s) {
      AppLogger.e('[VOUCHER_DS] Error in getMyVouchers: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<RedeemVoucherResultModel> redeemVoucher({
    String? notes,
    required String idempotencyKey,
  }) async {
    try {
      final trimmedNotes = notes?.trim();
      final payload = <String, dynamic>{
        if (trimmedNotes != null && trimmedNotes.isNotEmpty)
          'notes': trimmedNotes,
      };

      final options = Options(
        headers: <String, dynamic>{
          if (idempotencyKey.trim().isNotEmpty)
            'X-Idempotency-Key': idempotencyKey.trim(),
        },
      );

      final response = await dio.post(
        ApiConstants.vouchersRedeem,
        data: payload,
        options: options,
      );

      final body = voucherAsMap(response.data);
      final statusCode = response.statusCode ?? 200;

      if (statusCode < 200 || statusCode >= 300 || body['success'] == false) {
        final msg = ErrorUtils.parseErrorMessage(body);
        throw ServerException(
          msg.isNotEmpty ? msg : 'Gagal menukarkan voucher',
          statusCode: statusCode,
        );
      }

      return RedeemVoucherResultModel.fromJson(body);
    } on DioException catch (e, s) {
      AppLogger.e(
        '[VOUCHER_DS] DioException in redeemVoucher: ${e.message}',
        e,
        s,
      );
      throw ErrorUtils.toAppException(
        e,
        fallbackMessage: 'Gagal menukarkan voucher',
      );
    } catch (e, s) {
      AppLogger.e('[VOUCHER_DS] Error in redeemVoucher: $e', e, s);
      rethrow;
    }
  }
}
