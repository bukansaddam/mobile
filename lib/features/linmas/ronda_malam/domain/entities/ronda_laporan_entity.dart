import 'package:freezed_annotation/freezed_annotation.dart';

part 'ronda_laporan_entity.freezed.dart';
part 'ronda_laporan_entity.g.dart';

@freezed
abstract class RondaLaporanEntity with _$RondaLaporanEntity {
  const RondaLaporanEntity._();

  const factory RondaLaporanEntity({
    String? id,

    // Lingkungan
    @Default(1) int sampahMenumpuk,
    @Default(1) int selokanMampet,
    @Default(1) int fasilitasRusak,
    @Default(1) int kegiatanMengganggu,
    @Default(1) int potensiBahaya,
    @Default(1) int jalanBerlubang,
    @Default(1) int lampuMati,

    // Keamanan
    @Default(1) int laporanKeamanan,
    @Default(1) int wargaBertengkar,
    @Default(1) int tempatKurangAman,
    @Default(1) int kerumunanTidakTertib,
    @Default(1) int perluBantuanPetugas,
    @Default(1) int gangguanKamtibmas,
    @Default(1) int aktivitasMencurigakan,
    @Default(1) int kehilanganLingkungan,

    // Sosial
    @Default(1) int wargaButuhBantuan,
    @Default(1) int kelompokBerselisih,
    @Default(1) int keluhanWarga,
    @Default(1) int kejadianMenggangguWarga,
    @Default(1) int perluTerusanRTRW,
    @Default(1) int permasalahanSosial,
    @Default(1) int kasusPerzinahan,
    @Default(1) int orangTerlantar,

    // Detail Sampah
    @Default(false) bool adaSampahMenumpuk,
    String? waktuSampahMenumpuk,
    String? lokasiSampahMenumpuk,
    String? jenisSampahDominan,
    @Default(true) bool pengangkutanSesuaiJadwal,
    String? alasanPengangkutan,
    @Default(false) bool adaPembakaranSampah,
    String? waktuPembakaran,
    String? lokasiPembakaran,
    String? pembakaranDiberiTindakan,

    // Detail Keamanan
    @Default(false) bool adaPencurian,
    String? waktuPencurian,
    String? lokasiPencurian,
    String? pelakuPencurianDiketahui,
    String? pencurianDilaporkanAparat,
    @Default(false) bool adaTawuran,
    String? waktuTawuran,
    String? lokasiTawuran,
    String? pelakuTawuranDiketahui,
    String? tawuranDilaporkanAparat,
    @Default(false) bool adaNarkoba,
    String? narkobaDilaporkanAparat,

    // Detail Lingkungan
    @Default(false) bool adaSelokanTersumbat,
    String? waktuSelokanTersumbat,
    String? lokasiSelokanTersumbat,
    String? resikoSelokanTersumbat,
    @Default(false) bool adaJalanRusak,
    String? lokasiJalanRusakGps,
    double? latitudeJalanRusak,
    double? longitudeJalanRusak,
    String? resikoJalanRusak,
    @Default(false) bool adaLampuMati,
    String? lokasiLampuMatiGps,
    double? latitudeLampuMati,
    double? longitudeLampuMati,
    String? resikoLampuMati,

    String? patrolTime,
    String? waktuKejadian,
    @Default('') String keterangan,
    DateTime? timestamp,
  }) = _RondaLaporanEntity;

  factory RondaLaporanEntity.fromJson(Map<String, dynamic> json) =>
      _$RondaLaporanEntityFromJson(json);
}
