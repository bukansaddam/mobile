import '../../domain/entities/ronda_laporan_entity.dart';

class RondaLaporanModel extends RondaLaporanEntity {
  const RondaLaporanModel({
    super.id,
    super.sampahMenumpuk,
    super.selokanMampet,
    super.fasilitasRusak,
    super.kegiatanMengganggu,
    super.potensiBahaya,
    super.jalanBerlubang,
    super.lampuMati,
    super.laporanKeamanan,
    super.wargaBertengkar,
    super.tempatKurangAman,
    super.kerumunanTidakTertib,
    super.perluBantuanPetugas,
    super.gangguanKamtibmas,
    super.aktivitasMencurigakan,
    super.kehilanganLingkungan,
    super.wargaButuhBantuan,
    super.kelompokBerselisih,
    super.keluhanWarga,
    super.kejadianMenggangguWarga,
    super.perluTerusanRTRW,
    super.permasalahanSosial,
    super.kasusPerzinahan,
    super.orangTerlantar,
    super.keterangan,
    super.timestamp,
  });

  factory RondaLaporanModel.fromJson(Map<String, dynamic> json) {
    return RondaLaporanModel(
      id: json['id'] as String?,
      sampahMenumpuk: (json['sampahMenumpuk'] as num?)?.toInt() ?? 1,
      selokanMampet: (json['selokanMampet'] as num?)?.toInt() ?? 1,
      fasilitasRusak: (json['fasilitasRusak'] as num?)?.toInt() ?? 1,
      kegiatanMengganggu: (json['kegiatanMengganggu'] as num?)?.toInt() ?? 1,
      potensiBahaya: (json['potensiBahaya'] as num?)?.toInt() ?? 1,
      jalanBerlubang: (json['jalanBerlubang'] as num?)?.toInt() ?? 1,
      lampuMati: (json['lampuMati'] as num?)?.toInt() ?? 1,
      laporanKeamanan: (json['laporanKeamanan'] as num?)?.toInt() ?? 1,
      wargaBertengkar: (json['wargaBertengkar'] as num?)?.toInt() ?? 1,
      tempatKurangAman: (json['tempatKurangAman'] as num?)?.toInt() ?? 1,
      kerumunanTidakTertib:
          (json['kerumunanTidakTertib'] as num?)?.toInt() ?? 1,
      perluBantuanPetugas: (json['perluBantuanPetugas'] as num?)?.toInt() ?? 1,
      gangguanKamtibmas: (json['gangguanKamtibmas'] as num?)?.toInt() ?? 1,
      aktivitasMencurigakan:
          (json['aktivitasMencurigakan'] as num?)?.toInt() ?? 1,
      kehilanganLingkungan:
          (json['kehilanganLingkungan'] as num?)?.toInt() ?? 1,
      wargaButuhBantuan: (json['wargaButuhBantuan'] as num?)?.toInt() ?? 1,
      kelompokBerselisih: (json['kelompokBerselisih'] as num?)?.toInt() ?? 1,
      keluhanWarga: (json['keluhanWarga'] as num?)?.toInt() ?? 1,
      kejadianMenggangguWarga:
          (json['kejadianMenggangguWarga'] as num?)?.toInt() ?? 1,
      perluTerusanRTRW: (json['perluTerusanRTRW'] as num?)?.toInt() ?? 1,
      permasalahanSosial: (json['permasalahanSosial'] as num?)?.toInt() ?? 1,
      kasusPerzinahan: (json['kasusPerzinahan'] as num?)?.toInt() ?? 1,
      orangTerlantar: (json['orangTerlantar'] as num?)?.toInt() ?? 1,
      keterangan: json['keterangan'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sampahMenumpuk': sampahMenumpuk,
      'selokanMampet': selokanMampet,
      'fasilitasRusak': fasilitasRusak,
      'kegiatanMengganggu': kegiatanMengganggu,
      'potensiBahaya': potensiBahaya,
      'jalanBerlubang': jalanBerlubang,
      'lampuMati': lampuMati,
      'laporanKeamanan': laporanKeamanan,
      'wargaBertengkar': wargaBertengkar,
      'tempatKurangAman': tempatKurangAman,
      'kerumunanTidakTertib': kerumunanTidakTertib,
      'perluBantuanPetugas': perluBantuanPetugas,
      'gangguanKamtibmas': gangguanKamtibmas,
      'aktivitasMencurigakan': aktivitasMencurigakan,
      'kehilanganLingkungan': kehilanganLingkungan,
      'wargaButuhBantuan': wargaButuhBantuan,
      'kelompokBerselisih': kelompokBerselisih,
      'keluhanWarga': keluhanWarga,
      'kejadianMenggangguWarga': kejadianMenggangguWarga,
      'perluTerusanRTRW': perluTerusanRTRW,
      'permasalahanSosial': permasalahanSosial,
      'kasusPerzinahan': kasusPerzinahan,
      'orangTerlantar': orangTerlantar,
      'keterangan': keterangan,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory RondaLaporanModel.fromEntity(RondaLaporanEntity entity) {
    return RondaLaporanModel(
      id: entity.id,
      sampahMenumpuk: entity.sampahMenumpuk,
      selokanMampet: entity.selokanMampet,
      fasilitasRusak: entity.fasilitasRusak,
      kegiatanMengganggu: entity.kegiatanMengganggu,
      potensiBahaya: entity.potensiBahaya,
      jalanBerlubang: entity.jalanBerlubang,
      lampuMati: entity.lampuMati,
      laporanKeamanan: entity.laporanKeamanan,
      wargaBertengkar: entity.wargaBertengkar,
      tempatKurangAman: entity.tempatKurangAman,
      kerumunanTidakTertib: entity.kerumunanTidakTertib,
      perluBantuanPetugas: entity.perluBantuanPetugas,
      gangguanKamtibmas: entity.gangguanKamtibmas,
      aktivitasMencurigakan: entity.aktivitasMencurigakan,
      kehilanganLingkungan: entity.kehilanganLingkungan,
      wargaButuhBantuan: entity.wargaButuhBantuan,
      kelompokBerselisih: entity.kelompokBerselisih,
      keluhanWarga: entity.keluhanWarga,
      kejadianMenggangguWarga: entity.kejadianMenggangguWarga,
      perluTerusanRTRW: entity.perluTerusanRTRW,
      permasalahanSosial: entity.permasalahanSosial,
      kasusPerzinahan: entity.kasusPerzinahan,
      orangTerlantar: entity.orangTerlantar,
      keterangan: entity.keterangan,
      timestamp: entity.timestamp,
    );
  }
}
