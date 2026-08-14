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
      sampahMenumpuk: model.sampahMenumpuk,
      selokanMampet: model.selokanMampet,
      fasilitasRusak: model.fasilitasRusak,
      kegiatanMengganggu: model.kegiatanMengganggu,
      potensiBahaya: model.potensiBahaya,
      jalanBerlubang: model.jalanBerlubang,
      lampuMati: model.lampuMati,
      laporanKeamanan: model.laporanKeamanan,
      wargaBertengkar: model.wargaBertengkar,
      tempatKurangAman: model.tempatKurangAman,
      kerumunanTidakTertib: model.kerumunanTidakTertib,
      perluBantuanPetugas: model.perluBantuanPetugas,
      gangguanKamtibmas: model.gangguanKamtibmas,
      aktivitasMencurigakan: model.aktivitasMencurigakan,
      kehilanganLingkungan: model.kehilanganLingkungan,
      wargaButuhBantuan: model.wargaButuhBantuan,
      kelompokBerselisih: model.kelompokBerselisih,
      keluhanWarga: model.keluhanWarga,
      kejadianMenggangguWarga: model.kejadianMenggangguWarga,
      perluTerusanRTRW: model.perluTerusanRTRW,
      permasalahanSosial: model.permasalahanSosial,
      kasusPerzinahan: model.kasusPerzinahan,
      orangTerlantar: model.orangTerlantar,
      keterangan: model.keterangan,
      timestamp: DateTime.now(),
    );
  }
}
