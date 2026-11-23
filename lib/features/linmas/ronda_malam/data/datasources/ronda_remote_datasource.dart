import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/features/linmas/ronda_malam/data/models/ronda_laporan_model.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

abstract class RondaRemoteDatasource {
  Future<RondaLaporanModel> submitLaporan(
    RondaLaporanModel model, {
    String? idempotencyKey,
  });
}

class RondaRemoteDatasourceImpl extends BaseRemoteDataSource
    implements RondaRemoteDatasource {
  @override
  Future<RondaLaporanModel> submitLaporan(
    RondaLaporanModel model, {
    String? idempotencyKey,
  }) async {
    try {
      final payload = model.toDailyReportPayload();

      final response = await handleRequest<RondaLaporanModel>(
        () => dio.post(
          ApiConstants.dailyReports,
          data: payload,
          options: idempotencyKey != null && idempotencyKey.isNotEmpty
              ? Options(headers: {'X-Idempotency-Key': idempotencyKey})
              : null,
        ),
        fromJson: (json) =>
            RondaLaporanModel.fromApiResponse(json, fallback: model),
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throwResponseError(
          response,
          fallbackMessage: 'Gagal mengirim laporan harian',
        );
      }
    } catch (e, s) {
      AppLogger.e('[RONDA_DS] Error in submitLaporan: $e', e, s);
      rethrow;
    }
  }
}
