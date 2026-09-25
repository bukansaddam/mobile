import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import '../models/ronda_laporan_model.dart';

abstract class RondaRemoteDatasource {
  Future<RondaLaporanModel> submitLaporan(RondaLaporanModel model);
}

class RondaRemoteDatasourceImpl extends BaseRemoteDataSource
    implements RondaRemoteDatasource {
  @override
  Future<RondaLaporanModel> submitLaporan(RondaLaporanModel model) async {
    final payload = model.toDailyReportPayload();

    final response = await handleRequest<RondaLaporanModel>(
      () => dio.post(
        ApiConstants.dailyReports,
        data: payload,
      ),
      fromJson: (json) =>
          RondaLaporanModel.fromApiResponse(json, fallback: model),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Gagal mengirim laporan harian');
    }
  }
}
