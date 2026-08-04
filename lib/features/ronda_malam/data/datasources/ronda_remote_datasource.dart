import '../models/ronda_laporan_model.dart';

abstract class RondaRemoteDatasource {
  Future<RondaLaporanModel> submitLaporan(RondaLaporanModel model);
}

class RondaRemoteDatasourceImpl implements RondaRemoteDatasource {
  @override
  Future<RondaLaporanModel> submitLaporan(RondaLaporanModel model) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final generatedId =
        'RND-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    return RondaLaporanModel(
      id: generatedId,
      gangguanKamtibmas: model.gangguanKamtibmas,
      aktivitasMencurigakan: model.aktivitasMencurigakan,
      kehilanganLingkungan: model.kehilanganLingkungan,
      sampahMenumpuk: model.sampahMenumpuk,
      jalanBerlubang: model.jalanBerlubang,
      lampuMati: model.lampuMati,
      permasalahanSosial: model.permasalahanSosial,
      kasusPerzinahan: model.kasusPerzinahan,
      orangTerlantar: model.orangTerlantar,
      keterangan: model.keterangan,
      timestamp: DateTime.now(),
    );
  }
}
