import '../../domain/entities/ronda_laporan_entity.dart';

class RondaLaporanModel extends RondaLaporanEntity {
  const RondaLaporanModel({
    super.id,
    super.patrolTime,
    super.waktuKejadian,
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
    super.adaSampahMenumpuk,
    super.waktuSampahMenumpuk,
    super.lokasiSampahMenumpuk,
    super.jenisSampahDominan,
    super.pengangkutanSesuaiJadwal,
    super.alasanPengangkutan,
    super.adaPembakaranSampah,
    super.waktuPembakaran,
    super.lokasiPembakaran,
    super.pembakaranDiberiTindakan,
    super.adaPencurian,
    super.waktuPencurian,
    super.lokasiPencurian,
    super.pelakuPencurianDiketahui,
    super.pencurianDilaporkanAparat,
    super.adaTawuran,
    super.waktuTawuran,
    super.lokasiTawuran,
    super.pelakuTawuranDiketahui,
    super.tawuranDilaporkanAparat,
    super.adaNarkoba,
    super.narkobaDilaporkanAparat,
    super.adaSelokanTersumbat,
    super.waktuSelokanTersumbat,
    super.lokasiSelokanTersumbat,
    super.resikoSelokanTersumbat,
    super.adaJalanRusak,
    super.lokasiJalanRusakGps,
    super.latitudeJalanRusak,
    super.longitudeJalanRusak,
    super.resikoJalanRusak,
    super.adaLampuMati,
    super.lokasiLampuMatiGps,
    super.latitudeLampuMati,
    super.longitudeLampuMati,
    super.resikoLampuMati,
    super.keterangan,
    super.timestamp,
  });

  factory RondaLaporanModel.fromJson(Map<String, dynamic> json) {
    return RondaLaporanModel(
      id: json['id'] as String?,
      patrolTime: json['patrolTime'] as String? ?? json['patrol_time'] as String?,
      waktuKejadian:
          json['waktuKejadian'] as String? ?? json['waktu_kejadian'] as String?,
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
      adaSampahMenumpuk: json['adaSampahMenumpuk'] as bool? ?? false,
      waktuSampahMenumpuk: json['waktuSampahMenumpuk'] as String?,
      lokasiSampahMenumpuk: json['lokasiSampahMenumpuk'] as String?,
      jenisSampahDominan: json['jenisSampahDominan'] as String?,
      pengangkutanSesuaiJadwal:
          json['pengangkutanSesuaiJadwal'] as bool? ?? true,
      alasanPengangkutan: json['alasanPengangkutan'] as String?,
      adaPembakaranSampah: json['adaPembakaranSampah'] as bool? ?? false,
      waktuPembakaran: json['waktuPembakaran'] as String?,
      lokasiPembakaran: json['lokasiPembakaran'] as String?,
      pembakaranDiberiTindakan: json['pembakaranDiberiTindakan'] as String?,
      adaPencurian: json['adaPencurian'] as bool? ?? false,
      waktuPencurian: json['waktuPencurian'] as String?,
      lokasiPencurian: json['lokasiPencurian'] as String?,
      pelakuPencurianDiketahui: json['pelakuPencurianDiketahui'] as String?,
      pencurianDilaporkanAparat: json['pencurianDilaporkanAparat'] as String?,
      adaTawuran: json['adaTawuran'] as bool? ?? false,
      waktuTawuran: json['waktuTawuran'] as String?,
      lokasiTawuran: json['lokasiTawuran'] as String?,
      pelakuTawuranDiketahui: json['pelakuTawuranDiketahui'] as String?,
      tawuranDilaporkanAparat: json['tawuranDilaporkanAparat'] as String?,
      adaNarkoba: json['adaNarkoba'] as bool? ?? false,
      narkobaDilaporkanAparat: json['narkobaDilaporkanAparat'] as String?,
      adaSelokanTersumbat: json['adaSelokanTersumbat'] as bool? ?? false,
      waktuSelokanTersumbat: json['waktuSelokanTersumbat'] as String?,
      lokasiSelokanTersumbat: json['lokasiSelokanTersumbat'] as String?,
      resikoSelokanTersumbat: json['resikoSelokanTersumbat'] as String?,
      adaJalanRusak: json['adaJalanRusak'] as bool? ?? false,
      lokasiJalanRusakGps: json['lokasiJalanRusakGps'] as String?,
      latitudeJalanRusak: (json['latitudeJalanRusak'] as num?)?.toDouble() ??
          (json['latitude_jalan_rusak'] as num?)?.toDouble() ??
          (json['latitude'] as num?)?.toDouble(),
      longitudeJalanRusak: (json['longitudeJalanRusak'] as num?)?.toDouble() ??
          (json['longitude_jalan_rusak'] as num?)?.toDouble() ??
          (json['longitude'] as num?)?.toDouble(),
      resikoJalanRusak: json['resikoJalanRusak'] as String?,
      adaLampuMati: json['adaLampuMati'] as bool? ?? false,
      lokasiLampuMatiGps: json['lokasiLampuMatiGps'] as String?,
      latitudeLampuMati: (json['latitudeLampuMati'] as num?)?.toDouble() ??
          (json['latitude_lampu_mati'] as num?)?.toDouble(),
      longitudeLampuMati: (json['longitudeLampuMati'] as num?)?.toDouble() ??
          (json['longitude_lampu_mati'] as num?)?.toDouble(),
      resikoLampuMati: json['resikoLampuMati'] as String?,
      keterangan: json['keterangan'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patrolTime': patrolTime,
      'waktuKejadian': waktuKejadian,
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
      'adaSampahMenumpuk': adaSampahMenumpuk,
      'waktuSampahMenumpuk': waktuSampahMenumpuk,
      'lokasiSampahMenumpuk': lokasiSampahMenumpuk,
      'jenisSampahDominan': jenisSampahDominan,
      'pengangkutanSesuaiJadwal': pengangkutanSesuaiJadwal,
      'alasanPengangkutan': alasanPengangkutan,
      'adaPembakaranSampah': adaPembakaranSampah,
      'waktuPembakaran': waktuPembakaran,
      'lokasiPembakaran': lokasiPembakaran,
      'pembakaranDiberiTindakan': pembakaranDiberiTindakan,
      'adaPencurian': adaPencurian,
      'waktuPencurian': waktuPencurian,
      'lokasiPencurian': lokasiPencurian,
      'pelakuPencurianDiketahui': pelakuPencurianDiketahui,
      'pencurianDilaporkanAparat': pencurianDilaporkanAparat,
      'adaTawuran': adaTawuran,
      'waktuTawuran': waktuTawuran,
      'lokasiTawuran': lokasiTawuran,
      'pelakuTawuranDiketahui': pelakuTawuranDiketahui,
      'tawuranDilaporkanAparat': tawuranDilaporkanAparat,
      'adaNarkoba': adaNarkoba,
      'narkobaDilaporkanAparat': narkobaDilaporkanAparat,
      'adaSelokanTersumbat': adaSelokanTersumbat,
      'waktuSelokanTersumbat': waktuSelokanTersumbat,
      'lokasiSelokanTersumbat': lokasiSelokanTersumbat,
      'resikoSelokanTersumbat': resikoSelokanTersumbat,
      'adaJalanRusak': adaJalanRusak,
      'lokasiJalanRusakGps': lokasiJalanRusakGps,
      'latitudeJalanRusak': latitudeJalanRusak,
      'longitudeJalanRusak': longitudeJalanRusak,
      'resikoJalanRusak': resikoJalanRusak,
      'adaLampuMati': adaLampuMati,
      'lokasiLampuMatiGps': lokasiLampuMatiGps,
      'latitudeLampuMati': latitudeLampuMati,
      'longitudeLampuMati': longitudeLampuMati,
      'resikoLampuMati': resikoLampuMati,
      'keterangan': keterangan,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory RondaLaporanModel.fromEntity(RondaLaporanEntity entity) {
    return RondaLaporanModel(
      id: entity.id,
      patrolTime: entity.patrolTime,
      waktuKejadian: entity.waktuKejadian,
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
      adaSampahMenumpuk: entity.adaSampahMenumpuk,
      waktuSampahMenumpuk: entity.waktuSampahMenumpuk,
      lokasiSampahMenumpuk: entity.lokasiSampahMenumpuk,
      jenisSampahDominan: entity.jenisSampahDominan,
      pengangkutanSesuaiJadwal: entity.pengangkutanSesuaiJadwal,
      alasanPengangkutan: entity.alasanPengangkutan,
      adaPembakaranSampah: entity.adaPembakaranSampah,
      waktuPembakaran: entity.waktuPembakaran,
      lokasiPembakaran: entity.lokasiPembakaran,
      pembakaranDiberiTindakan: entity.pembakaranDiberiTindakan,
      adaPencurian: entity.adaPencurian,
      waktuPencurian: entity.waktuPencurian,
      lokasiPencurian: entity.lokasiPencurian,
      pelakuPencurianDiketahui: entity.pelakuPencurianDiketahui,
      pencurianDilaporkanAparat: entity.pencurianDilaporkanAparat,
      adaTawuran: entity.adaTawuran,
      waktuTawuran: entity.waktuTawuran,
      lokasiTawuran: entity.lokasiTawuran,
      pelakuTawuranDiketahui: entity.pelakuTawuranDiketahui,
      tawuranDilaporkanAparat: entity.tawuranDilaporkanAparat,
      adaNarkoba: entity.adaNarkoba,
      narkobaDilaporkanAparat: entity.narkobaDilaporkanAparat,
      adaSelokanTersumbat: entity.adaSelokanTersumbat,
      waktuSelokanTersumbat: entity.waktuSelokanTersumbat,
      lokasiSelokanTersumbat: entity.lokasiSelokanTersumbat,
      resikoSelokanTersumbat: entity.resikoSelokanTersumbat,
      adaJalanRusak: entity.adaJalanRusak,
      lokasiJalanRusakGps: entity.lokasiJalanRusakGps,
      latitudeJalanRusak: entity.latitudeJalanRusak,
      longitudeJalanRusak: entity.longitudeJalanRusak,
      resikoJalanRusak: entity.resikoJalanRusak,
      adaLampuMati: entity.adaLampuMati,
      lokasiLampuMatiGps: entity.lokasiLampuMatiGps,
      latitudeLampuMati: entity.latitudeLampuMati,
      longitudeLampuMati: entity.longitudeLampuMati,
      resikoLampuMati: entity.resikoLampuMati,
      keterangan: entity.keterangan,
      timestamp: entity.timestamp,
    );
  }

  RondaLaporanModel copyWith({
    String? id,
    String? patrolTime,
    String? waktuKejadian,
    int? sampahMenumpuk,
    int? selokanMampet,
    int? fasilitasRusak,
    int? kegiatanMengganggu,
    int? potensiBahaya,
    int? jalanBerlubang,
    int? lampuMati,
    int? laporanKeamanan,
    int? wargaBertengkar,
    int? tempatKurangAman,
    int? kerumunanTidakTertib,
    int? perluBantuanPetugas,
    int? gangguanKamtibmas,
    int? aktivitasMencurigakan,
    int? kehilanganLingkungan,
    int? wargaButuhBantuan,
    int? kelompokBerselisih,
    int? keluhanWarga,
    int? kejadianMenggangguWarga,
    int? perluTerusanRTRW,
    int? permasalahanSosial,
    int? kasusPerzinahan,
    int? orangTerlantar,
    bool? adaSampahMenumpuk,
    String? waktuSampahMenumpuk,
    String? lokasiSampahMenumpuk,
    String? jenisSampahDominan,
    bool? pengangkutanSesuaiJadwal,
    String? alasanPengangkutan,
    bool? adaPembakaranSampah,
    String? waktuPembakaran,
    String? lokasiPembakaran,
    String? pembakaranDiberiTindakan,
    bool? adaPencurian,
    String? waktuPencurian,
    String? lokasiPencurian,
    String? pelakuPencurianDiketahui,
    String? pencurianDilaporkanAparat,
    bool? adaTawuran,
    String? waktuTawuran,
    String? lokasiTawuran,
    String? pelakuTawuranDiketahui,
    String? tawuranDilaporkanAparat,
    bool? adaNarkoba,
    String? narkobaDilaporkanAparat,
    bool? adaSelokanTersumbat,
    String? waktuSelokanTersumbat,
    String? lokasiSelokanTersumbat,
    String? resikoSelokanTersumbat,
    bool? adaJalanRusak,
    String? lokasiJalanRusakGps,
    double? latitudeJalanRusak,
    double? longitudeJalanRusak,
    String? resikoJalanRusak,
    bool? adaLampuMati,
    String? lokasiLampuMatiGps,
    double? latitudeLampuMati,
    double? longitudeLampuMati,
    String? resikoLampuMati,
    String? keterangan,
    DateTime? timestamp,
  }) {
    return RondaLaporanModel(
      id: id ?? this.id,
      patrolTime: patrolTime ?? this.patrolTime,
      waktuKejadian: waktuKejadian ?? this.waktuKejadian,
      sampahMenumpuk: sampahMenumpuk ?? this.sampahMenumpuk,
      selokanMampet: selokanMampet ?? this.selokanMampet,
      fasilitasRusak: fasilitasRusak ?? this.fasilitasRusak,
      kegiatanMengganggu: kegiatanMengganggu ?? this.kegiatanMengganggu,
      potensiBahaya: potensiBahaya ?? this.potensiBahaya,
      jalanBerlubang: jalanBerlubang ?? this.jalanBerlubang,
      lampuMati: lampuMati ?? this.lampuMati,
      laporanKeamanan: laporanKeamanan ?? this.laporanKeamanan,
      wargaBertengkar: wargaBertengkar ?? this.wargaBertengkar,
      tempatKurangAman: tempatKurangAman ?? this.tempatKurangAman,
      kerumunanTidakTertib: kerumunanTidakTertib ?? this.kerumunanTidakTertib,
      perluBantuanPetugas: perluBantuanPetugas ?? this.perluBantuanPetugas,
      gangguanKamtibmas: gangguanKamtibmas ?? this.gangguanKamtibmas,
      aktivitasMencurigakan:
          aktivitasMencurigakan ?? this.aktivitasMencurigakan,
      kehilanganLingkungan: kehilanganLingkungan ?? this.kehilanganLingkungan,
      wargaButuhBantuan: wargaButuhBantuan ?? this.wargaButuhBantuan,
      kelompokBerselisih: kelompokBerselisih ?? this.kelompokBerselisih,
      keluhanWarga: keluhanWarga ?? this.keluhanWarga,
      kejadianMenggangguWarga:
          kejadianMenggangguWarga ?? this.kejadianMenggangguWarga,
      perluTerusanRTRW: perluTerusanRTRW ?? this.perluTerusanRTRW,
      permasalahanSosial: permasalahanSosial ?? this.permasalahanSosial,
      kasusPerzinahan: kasusPerzinahan ?? this.kasusPerzinahan,
      orangTerlantar: orangTerlantar ?? this.orangTerlantar,
      adaSampahMenumpuk: adaSampahMenumpuk ?? this.adaSampahMenumpuk,
      waktuSampahMenumpuk: waktuSampahMenumpuk ?? this.waktuSampahMenumpuk,
      lokasiSampahMenumpuk: lokasiSampahMenumpuk ?? this.lokasiSampahMenumpuk,
      jenisSampahDominan: jenisSampahDominan ?? this.jenisSampahDominan,
      pengangkutanSesuaiJadwal:
          pengangkutanSesuaiJadwal ?? this.pengangkutanSesuaiJadwal,
      alasanPengangkutan: alasanPengangkutan ?? this.alasanPengangkutan,
      adaPembakaranSampah: adaPembakaranSampah ?? this.adaPembakaranSampah,
      waktuPembakaran: waktuPembakaran ?? this.waktuPembakaran,
      lokasiPembakaran: lokasiPembakaran ?? this.lokasiPembakaran,
      pembakaranDiberiTindakan:
          pembakaranDiberiTindakan ?? this.pembakaranDiberiTindakan,
      adaPencurian: adaPencurian ?? this.adaPencurian,
      waktuPencurian: waktuPencurian ?? this.waktuPencurian,
      lokasiPencurian: lokasiPencurian ?? this.lokasiPencurian,
      pelakuPencurianDiketahui:
          pelakuPencurianDiketahui ?? this.pelakuPencurianDiketahui,
      pencurianDilaporkanAparat:
          pencurianDilaporkanAparat ?? this.pencurianDilaporkanAparat,
      adaTawuran: adaTawuran ?? this.adaTawuran,
      waktuTawuran: waktuTawuran ?? this.waktuTawuran,
      lokasiTawuran: lokasiTawuran ?? this.lokasiTawuran,
      pelakuTawuranDiketahui:
          pelakuTawuranDiketahui ?? this.pelakuTawuranDiketahui,
      tawuranDilaporkanAparat:
          tawuranDilaporkanAparat ?? this.tawuranDilaporkanAparat,
      adaNarkoba: adaNarkoba ?? this.adaNarkoba,
      narkobaDilaporkanAparat:
          narkobaDilaporkanAparat ?? this.narkobaDilaporkanAparat,
      adaSelokanTersumbat: adaSelokanTersumbat ?? this.adaSelokanTersumbat,
      waktuSelokanTersumbat:
          waktuSelokanTersumbat ?? this.waktuSelokanTersumbat,
      lokasiSelokanTersumbat:
          lokasiSelokanTersumbat ?? this.lokasiSelokanTersumbat,
      resikoSelokanTersumbat:
          resikoSelokanTersumbat ?? this.resikoSelokanTersumbat,
      adaJalanRusak: adaJalanRusak ?? this.adaJalanRusak,
      lokasiJalanRusakGps: lokasiJalanRusakGps ?? this.lokasiJalanRusakGps,
      latitudeJalanRusak: latitudeJalanRusak ?? this.latitudeJalanRusak,
      longitudeJalanRusak: longitudeJalanRusak ?? this.longitudeJalanRusak,
      resikoJalanRusak: resikoJalanRusak ?? this.resikoJalanRusak,
      adaLampuMati: adaLampuMati ?? this.adaLampuMati,
      lokasiLampuMatiGps: lokasiLampuMatiGps ?? this.lokasiLampuMatiGps,
      latitudeLampuMati: latitudeLampuMati ?? this.latitudeLampuMati,
      longitudeLampuMati: longitudeLampuMati ?? this.longitudeLampuMati,
      resikoLampuMati: resikoLampuMati ?? this.resikoLampuMati,
      keterangan: keterangan ?? this.keterangan,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toDailyReportPayload() {
    final now = timestamp ?? DateTime.now();
    final defaultTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final effectivePatrolTime =
        (patrolTime != null && patrolTime!.trim().isNotEmpty)
            ? patrolTime!.trim()
            : defaultTime;

    final effectiveWaktuKejadian =
        (waktuKejadian != null && waktuKejadian!.trim().isNotEmpty)
            ? waktuKejadian!.trim()
            : defaultTime;

    // Penumpukan Sampah
    final penumpukanSampahMap = <String, dynamic>{
      'answer': adaSampahMenumpuk ? 'ya' : 'tidak',
    };
    if (adaSampahMenumpuk) {
      penumpukanSampahMap['waktu_kejadian'] =
          (waktuSampahMenumpuk != null && waktuSampahMenumpuk!.isNotEmpty)
              ? waktuSampahMenumpuk!
              : effectiveWaktuKejadian;
      penumpukanSampahMap['lokasi_kejadian'] = lokasiSampahMenumpuk ?? '';
      penumpukanSampahMap['jenis_sampah_dominan'] = jenisSampahDominan ?? '';
    }

    // Jadwal Pengangkutan
    final jadwalPengangkutanMap = <String, dynamic>{
      'answer': pengangkutanSesuaiJadwal ? 'ya' : 'tidak',
    };
    if (!pengangkutanSesuaiJadwal) {
      jadwalPengangkutanMap['alasan'] =
          (alasanPengangkutan != null && alasanPengangkutan!.isNotEmpty)
              ? alasanPengangkutan!
              : 'Truk pengangkut terlambat datang';
    }

    // Pembakaran Sampah
    final pembakaranSampahMap = <String, dynamic>{
      'answer': adaPembakaranSampah ? 'ya' : 'tidak',
    };
    if (adaPembakaranSampah) {
      pembakaranSampahMap['waktu_kejadian'] =
          (waktuPembakaran != null && waktuPembakaran!.isNotEmpty)
              ? waktuPembakaran!
              : effectiveWaktuKejadian;
      pembakaranSampahMap['lokasi_kejadian'] = lokasiPembakaran ?? '';
      pembakaranSampahMap['tindakan'] = pembakaranDiberiTindakan ?? '';
    }

    // Pencurian / Perampasan
    final pencurianPerampasanMap = <String, dynamic>{
      'answer': adaPencurian ? 'ya' : 'tidak',
      'pelaku_diketahui':
          (pelakuPencurianDiketahui?.toLowerCase() == 'ya' ||
                  pelakuPencurianDiketahui?.toLowerCase() == 'true')
              ? 'ya'
              : 'tidak',
      'lapor_aparat':
          (pencurianDilaporkanAparat?.toLowerCase() == 'ya' ||
                  pencurianDilaporkanAparat?.toLowerCase() == 'true')
              ? 'ya'
              : 'tidak',
    };
    if (adaPencurian) {
      pencurianPerampasanMap['waktu_kejadian'] =
          (waktuPencurian != null && waktuPencurian!.isNotEmpty)
              ? waktuPencurian!
              : effectiveWaktuKejadian;
      pencurianPerampasanMap['lokasi_kejadian'] = lokasiPencurian ?? '';
    }

    // Perkelahian Kelompok
    final perkelahianKelompokMap = <String, dynamic>{
      'answer': adaTawuran ? 'ya' : 'tidak',
    };
    if (adaTawuran) {
      perkelahianKelompokMap['waktu_kejadian'] =
          (waktuTawuran != null && waktuTawuran!.isNotEmpty)
              ? waktuTawuran!
              : effectiveWaktuKejadian;
      perkelahianKelompokMap['lokasi_kejadian'] = lokasiTawuran ?? '';
      perkelahianKelompokMap['pelaku_diketahui'] =
          (pelakuTawuranDiketahui?.toLowerCase() == 'ya') ? 'ya' : 'tidak';
      perkelahianKelompokMap['lapor_aparat'] =
          (tawuranDilaporkanAparat?.toLowerCase() == 'ya') ? 'ya' : 'tidak';
    }

    // Penyalahgunaan Narkoba
    final penyalahgunaanNarkobaMap = <String, dynamic>{
      'answer': adaNarkoba ? 'ya' : 'tidak',
    };
    if (adaNarkoba) {
      penyalahgunaanNarkobaMap['lapor_aparat'] =
          (narkobaDilaporkanAparat?.toLowerCase() == 'ya') ? 'ya' : 'tidak';
    }

    // Selokan Tersumbat
    final selokanTersumbatMap = <String, dynamic>{
      'answer': adaSelokanTersumbat ? 'ya' : 'tidak',
    };
    if (adaSelokanTersumbat) {
      selokanTersumbatMap['waktu_kejadian'] =
          (waktuSelokanTersumbat != null && waktuSelokanTersumbat!.isNotEmpty)
              ? waktuSelokanTersumbat!
              : effectiveWaktuKejadian;
      selokanTersumbatMap['lokasi_kejadian'] = lokasiSelokanTersumbat ?? '';
      selokanTersumbatMap['resiko'] = resikoSelokanTersumbat ?? '';
    }

    // Jalan Rusak
    double? resolvedLatJalanRusak = latitudeJalanRusak;
    double? resolvedLngJalanRusak = longitudeJalanRusak;
    if ((resolvedLatJalanRusak == null || resolvedLngJalanRusak == null) &&
        lokasiJalanRusakGps != null) {
      final match = RegExp(r'(-?\d+\.?\d*)\s*,\s*(-?\d+\.?\d*)')
          .firstMatch(lokasiJalanRusakGps!);
      if (match != null) {
        resolvedLatJalanRusak ??= double.tryParse(match.group(1)!);
        resolvedLngJalanRusak ??= double.tryParse(match.group(2)!);
      }
    }

    final jalanRusakMap = <String, dynamic>{
      'answer': adaJalanRusak ? 'ya' : 'tidak',
      'resiko': (resikoJalanRusak != null && resikoJalanRusak!.isNotEmpty)
          ? resikoJalanRusak!
          : 'str',
    };
    if (adaJalanRusak) {
      jalanRusakMap['lokasi_kejadian'] = lokasiJalanRusakGps ?? '';
      if (resolvedLatJalanRusak != null) {
        jalanRusakMap['latitude'] = resolvedLatJalanRusak;
      }
      if (resolvedLngJalanRusak != null) {
        jalanRusakMap['longitude'] = resolvedLngJalanRusak;
      }
    }

    // Lampu Mati
    double? resolvedLatLampuMati = latitudeLampuMati;
    double? resolvedLngLampuMati = longitudeLampuMati;
    if ((resolvedLatLampuMati == null || resolvedLngLampuMati == null) &&
        lokasiLampuMatiGps != null) {
      final match = RegExp(r'(-?\d+\.?\d*)\s*,\s*(-?\d+\.?\d*)')
          .firstMatch(lokasiLampuMatiGps!);
      if (match != null) {
        resolvedLatLampuMati ??= double.tryParse(match.group(1)!);
        resolvedLngLampuMati ??= double.tryParse(match.group(2)!);
      }
    }

    final lampuMatiMap = <String, dynamic>{
      'answer': adaLampuMati ? 'ya' : 'tidak',
    };
    if (adaLampuMati) {
      lampuMatiMap['lokasi_kejadian'] = lokasiLampuMatiGps ?? '';
      if (resolvedLatLampuMati != null) {
        lampuMatiMap['latitude'] = resolvedLatLampuMati;
      }
      if (resolvedLngLampuMati != null) {
        lampuMatiMap['longitude'] = resolvedLngLampuMati;
      }
      lampuMatiMap['resiko'] = resikoLampuMati ?? '';
    }

    return {
      'patrol_time': effectivePatrolTime,
      'waktu_kejadian': effectiveWaktuKejadian,
      'patrol_checklist': {
        'penumpukan_sampah': penumpukanSampahMap,
        'jadwal_pengangkutan': jadwalPengangkutanMap,
        'pembakaran_sampah': pembakaranSampahMap,
        'pencurian_perampasan': pencurianPerampasanMap,
        'perkelahian_kelompok': perkelahianKelompokMap,
        'penyalahgunaan_narkoba': penyalahgunaanNarkobaMap,
        'selokan_tersumbat': selokanTersumbatMap,
        'jalan_rusak': jalanRusakMap,
        'lampu_mati': lampuMatiMap,
      },
      'notes': keterangan,
    };
  }

  factory RondaLaporanModel.fromApiResponse(
    dynamic responseData, {
    RondaLaporanModel? fallback,
  }) {
    String? resolvedId;
    if (responseData is Map<String, dynamic>) {
      resolvedId = (responseData['id'] ??
              responseData['report_id'] ??
              responseData['data']?['id'] ??
              responseData['data']?['report_id'])
          ?.toString();
    } else if (responseData != null) {
      resolvedId = responseData.toString();
    }

    resolvedId ??= fallback?.id ??
        'RND-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    if (fallback != null) {
      return fallback.copyWith(id: resolvedId);
    }

    return RondaLaporanModel(
      id: resolvedId,
      timestamp: DateTime.now(),
    );
  }
}
