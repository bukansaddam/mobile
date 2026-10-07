import 'package:freezed_annotation/freezed_annotation.dart';

part 'ronda_laporan_model.freezed.dart';
part 'ronda_laporan_model.g.dart';

@freezed
abstract class RondaLaporanModel with _$RondaLaporanModel {
  const RondaLaporanModel._();

  const factory RondaLaporanModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'patrol_time') String? patrolTime,
    @JsonKey(name: 'waktu_kejadian') String? waktuKejadian,

    // Lingkungan
    @JsonKey(name: 'sampah_menumpuk') @Default(1) int sampahMenumpuk,
    @JsonKey(name: 'selokan_mampet') @Default(1) int selokanMampet,
    @JsonKey(name: 'fasilitas_rusak') @Default(1) int fasilitasRusak,
    @JsonKey(name: 'kegiatan_mengganggu') @Default(1) int kegiatanMengganggu,
    @JsonKey(name: 'potensi_bahaya') @Default(1) int potensiBahaya,
    @JsonKey(name: 'jalan_berlubang') @Default(1) int jalanBerlubang,
    @JsonKey(name: 'lampu_mati') @Default(1) int lampuMati,

    // Keamanan
    @JsonKey(name: 'laporan_keamanan') @Default(1) int laporanKeamanan,
    @JsonKey(name: 'warga_bertengkar') @Default(1) int wargaBertengkar,
    @JsonKey(name: 'tempat_kurang_aman') @Default(1) int tempatKurangAman,
    @JsonKey(name: 'kerumunan_tidak_tertib') @Default(1) int kerumunanTidakTertib,
    @JsonKey(name: 'perlu_bantuan_petugas') @Default(1) int perluBantuanPetugas,
    @JsonKey(name: 'gangguan_kamtibmas') @Default(1) int gangguanKamtibmas,
    @JsonKey(name: 'aktivitas_mencurigakan') @Default(1) int aktivitasMencurigakan,
    @JsonKey(name: 'kehilangan_lingkungan') @Default(1) int kehilanganLingkungan,

    // Sosial
    @JsonKey(name: 'warga_butuh_bantuan') @Default(1) int wargaButuhBantuan,
    @JsonKey(name: 'kelompok_berselisih') @Default(1) int kelompokBerselisih,
    @JsonKey(name: 'keluhan_warga') @Default(1) int keluhanWarga,
    @JsonKey(name: 'kejadian_mengganggu_warga') @Default(1) int kejadianMenggangguWarga,
    @JsonKey(name: 'perlu_terusan_rt_rw') @Default(1) int perluTerusanRTRW,
    @JsonKey(name: 'permasalahan_sosial') @Default(1) int permasalahanSosial,
    @JsonKey(name: 'kasus_perzinahan') @Default(1) int kasusPerzinahan,
    @JsonKey(name: 'orang_terlantar') @Default(1) int orangTerlantar,

    // Detail Sampah
    @JsonKey(name: 'ada_sampah_menumpuk') @Default(false) bool adaSampahMenumpuk,
    @JsonKey(name: 'waktu_sampah_menumpuk') String? waktuSampahMenumpuk,
    @JsonKey(name: 'lokasi_sampah_menumpuk') String? lokasiSampahMenumpuk,
    @JsonKey(name: 'jenis_sampah_dominan') String? jenisSampahDominan,
    @JsonKey(name: 'pengangkutan_sesuai_jadwal') @Default(true) bool pengangkutanSesuaiJadwal,
    @JsonKey(name: 'alasan_pengangkutan') String? alasanPengangkutan,
    @JsonKey(name: 'ada_pembakaran_sampah') @Default(false) bool adaPembakaranSampah,
    @JsonKey(name: 'waktu_pembakaran') String? waktuPembakaran,
    @JsonKey(name: 'lokasi_pembakaran') String? lokasiPembakaran,
    @JsonKey(name: 'pembakaran_diberi_tindakan') String? pembakaranDiberiTindakan,

    // Detail Keamanan
    @JsonKey(name: 'ada_pencurian') @Default(false) bool adaPencurian,
    @JsonKey(name: 'waktu_pencurian') String? waktuPencurian,
    @JsonKey(name: 'lokasi_pencurian') String? lokasiPencurian,
    @JsonKey(name: 'pelaku_pencurian_diketahui') String? pelakuPencurianDiketahui,
    @JsonKey(name: 'pencurian_dilaporkan_aparat') String? pencurianDilaporkanAparat,
    @JsonKey(name: 'ada_tawuran') @Default(false) bool adaTawuran,
    @JsonKey(name: 'waktu_tawuran') String? waktuTawuran,
    @JsonKey(name: 'lokasi_tawuran') String? lokasiTawuran,
    @JsonKey(name: 'pelaku_tawuran_diketahui') String? pelakuTawuranDiketahui,
    @JsonKey(name: 'tawuran_dilaporkan_aparat') String? tawuranDilaporkanAparat,
    @JsonKey(name: 'ada_narkoba') @Default(false) bool adaNarkoba,
    @JsonKey(name: 'narkoba_dilaporkan_aparat') String? narkobaDilaporkanAparat,

    // Detail Lingkungan
    @JsonKey(name: 'ada_selokan_tersumbat') @Default(false) bool adaSelokanTersumbat,
    @JsonKey(name: 'waktu_selokan_tersumbat') String? waktuSelokanTersumbat,
    @JsonKey(name: 'lokasi_selokan_tersumbat') String? lokasiSelokanTersumbat,
    @JsonKey(name: 'resiko_selokan_tersumbat') String? resikoSelokanTersumbat,
    @JsonKey(name: 'ada_jalan_rusak') @Default(false) bool adaJalanRusak,
    @JsonKey(name: 'lokasi_jalan_rusak_gps') String? lokasiJalanRusakGps,
    @JsonKey(name: 'latitude_jalan_rusak') double? latitudeJalanRusak,
    @JsonKey(name: 'longitude_jalan_rusak') double? longitudeJalanRusak,
    @JsonKey(name: 'resiko_jalan_rusak') String? resikoJalanRusak,
    @JsonKey(name: 'ada_lampu_mati') @Default(false) bool adaLampuMati,
    @JsonKey(name: 'lokasi_lampu_mati_gps') String? lokasiLampuMatiGps,
    @JsonKey(name: 'latitude_lampu_mati') double? latitudeLampuMati,
    @JsonKey(name: 'longitude_lampu_mati') double? longitudeLampuMati,
    @JsonKey(name: 'resiko_lampu_mati') String? resikoLampuMati,

    @JsonKey(name: 'keterangan') @Default('') String keterangan,
    @JsonKey(name: 'timestamp') DateTime? timestamp,
  }) = _RondaLaporanModel;

  factory RondaLaporanModel.fromJson(Map<String, dynamic> json) =>
      _$RondaLaporanModelFromJson(json);

  factory RondaLaporanModel.fromApiResponse(
    dynamic responseData, {
    RondaLaporanModel? fallback,
  }) {
    String? resolvedId;
    if (responseData is Map<String, dynamic>) {
      resolvedId =
          (responseData['id'] ??
                  responseData['report_id'] ??
                  responseData['data']?['id'] ??
                  responseData['data']?['report_id'])
              ?.toString();
    } else if (responseData != null) {
      resolvedId = responseData.toString();
    }

    resolvedId ??=
        fallback?.id ??
        'RND-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    if (fallback != null) {
      return fallback.copyWith(id: resolvedId);
    }

    return RondaLaporanModel(id: resolvedId, timestamp: DateTime.now());
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
      final match = RegExp(
        r'(-?\d+\.?\d*)\s*,\s*(-?\d+\.?\d*)',
      ).firstMatch(lokasiJalanRusakGps!);
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
      final match = RegExp(
        r'(-?\d+\.?\d*)\s*,\s*(-?\d+\.?\d*)',
      ).firstMatch(lokasiLampuMatiGps!);
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
}
