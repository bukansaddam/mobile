import 'package:akar/features/linmas/ronda_malam/data/models/ronda_laporan_model.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';

export 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';

extension RondaLaporanModelMapper on RondaLaporanModel {
  RondaLaporanEntity toDomain() {
    return RondaLaporanEntity(
      id: id,
      sampahMenumpuk: sampahMenumpuk,
      selokanMampet: selokanMampet,
      fasilitasRusak: fasilitasRusak,
      kegiatanMengganggu: kegiatanMengganggu,
      potensiBahaya: potensiBahaya,
      jalanBerlubang: jalanBerlubang,
      lampuMati: lampuMati,
      laporanKeamanan: laporanKeamanan,
      wargaBertengkar: wargaBertengkar,
      tempatKurangAman: tempatKurangAman,
      kerumunanTidakTertib: kerumunanTidakTertib,
      perluBantuanPetugas: perluBantuanPetugas,
      gangguanKamtibmas: gangguanKamtibmas,
      aktivitasMencurigakan: aktivitasMencurigakan,
      kehilanganLingkungan: kehilanganLingkungan,
      wargaButuhBantuan: wargaButuhBantuan,
      kelompokBerselisih: kelompokBerselisih,
      keluhanWarga: keluhanWarga,
      kejadianMenggangguWarga: kejadianMenggangguWarga,
      perluTerusanRTRW: perluTerusanRTRW,
      permasalahanSosial: permasalahanSosial,
      kasusPerzinahan: kasusPerzinahan,
      orangTerlantar: orangTerlantar,
      keterangan: keterangan,
      timestamp: timestamp,
    );
  }
}

extension RondaLaporanEntityMapper on RondaLaporanEntity {
  RondaLaporanModel toModel() {
    return RondaLaporanModel(
      id: id,
      sampahMenumpuk: sampahMenumpuk,
      selokanMampet: selokanMampet,
      fasilitasRusak: fasilitasRusak,
      kegiatanMengganggu: kegiatanMengganggu,
      potensiBahaya: potensiBahaya,
      jalanBerlubang: jalanBerlubang,
      lampuMati: lampuMati,
      laporanKeamanan: laporanKeamanan,
      wargaBertengkar: wargaBertengkar,
      tempatKurangAman: tempatKurangAman,
      kerumunanTidakTertib: kerumunanTidakTertib,
      perluBantuanPetugas: perluBantuanPetugas,
      gangguanKamtibmas: gangguanKamtibmas,
      aktivitasMencurigakan: aktivitasMencurigakan,
      kehilanganLingkungan: kehilanganLingkungan,
      wargaButuhBantuan: wargaButuhBantuan,
      kelompokBerselisih: kelompokBerselisih,
      keluhanWarga: keluhanWarga,
      kejadianMenggangguWarga: kejadianMenggangguWarga,
      perluTerusanRTRW: perluTerusanRTRW,
      permasalahanSosial: permasalahanSosial,
      kasusPerzinahan: kasusPerzinahan,
      orangTerlantar: orangTerlantar,
      keterangan: keterangan,
      timestamp: timestamp,
    );
  }
}
