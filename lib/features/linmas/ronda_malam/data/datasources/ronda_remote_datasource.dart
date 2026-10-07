import 'package:dio/dio.dart';
import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/features/linmas/ronda_malam/data/models/ronda_laporan_model.dart';
import 'package:akar/utils/app_logger.dart';

abstract class RondaRemoteDatasource {
  Future<RondaLaporanModel> submitLaporan(RondaLaporanModel model);
}

class RondaRemoteDatasourceImpl extends BaseRemoteDataSource
    implements RondaRemoteDatasource {
  @override
  Future<RondaLaporanModel> submitLaporan(RondaLaporanModel model) async {
    try {
      final payload = model.toDailyReportPayload();

      final response = await handleRequest<RondaLaporanModel>(
        () => dio.post(ApiConstants.dailyReports, data: payload),
        fromJson: (json) =>
            RondaLaporanModel.fromApiResponse(json, fallback: model),
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Gagal mengirim laporan harian');
      }
    } on DioException catch (e) {
      AppLogger.e(
        '[RONDA_DS] DioException in submitLaporan: ${e.message}',
        e,
        e.stackTrace,
      );
      throw Exception(ErrorUtils.parseErrorMessage(e));
    } catch (e, s) {
      AppLogger.e('[RONDA_DS] Unexpected error: $e', e, s);
      throw Exception(ErrorUtils.parseErrorMessage(e));
    }
  }
}
