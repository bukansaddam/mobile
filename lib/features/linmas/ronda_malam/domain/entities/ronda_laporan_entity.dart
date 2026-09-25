import 'package:equatable/equatable.dart';

class RondaLaporanEntity extends Equatable {
  final String? id;

  // Lingkungan
  final int sampahMenumpuk;
  final int selokanMampet;
  final int fasilitasRusak;
  final int kegiatanMengganggu;
  final int potensiBahaya;
  final int jalanBerlubang;
  final int lampuMati;

  // Keamanan
  final int laporanKeamanan;
  final int wargaBertengkar;
  final int tempatKurangAman;
  final int kerumunanTidakTertib;
  final int perluBantuanPetugas;
  final int gangguanKamtibmas;
  final int aktivitasMencurigakan;
  final int kehilanganLingkungan;

  // Sosial
  final int wargaButuhBantuan;
  final int kelompokBerselisih;
  final int keluhanWarga;
  final int kejadianMenggangguWarga;
  final int perluTerusanRTRW;
  final int permasalahanSosial;
  final int kasusPerzinahan;
  final int orangTerlantar;

  // Detail Sampah
  final bool adaSampahMenumpuk;
  final String? waktuSampahMenumpuk;
  final String? lokasiSampahMenumpuk;
  final String? jenisSampahDominan;
  final bool pengangkutanSesuaiJadwal;
  final String? alasanPengangkutan;
  final bool adaPembakaranSampah;
  final String? waktuPembakaran;
  final String? lokasiPembakaran;
  final String? pembakaranDiberiTindakan;

  // Detail Keamanan
  final bool adaPencurian;
  final String? waktuPencurian;
  final String? lokasiPencurian;
  final String? pelakuPencurianDiketahui;
  final String? pencurianDilaporkanAparat;
  final bool adaTawuran;
  final String? waktuTawuran;
  final String? lokasiTawuran;
  final String? pelakuTawuranDiketahui;
  final String? tawuranDilaporkanAparat;
  final bool adaNarkoba;
  final String? narkobaDilaporkanAparat;

  // Detail Lingkungan
  final bool adaSelokanTersumbat;
  final String? waktuSelokanTersumbat;
  final String? lokasiSelokanTersumbat;
  final String? resikoSelokanTersumbat;
  final bool adaJalanRusak;
  final String? lokasiJalanRusakGps;
  final double? latitudeJalanRusak;
  final double? longitudeJalanRusak;
  final String? resikoJalanRusak;
  final bool adaLampuMati;
  final String? lokasiLampuMatiGps;
  final double? latitudeLampuMati;
  final double? longitudeLampuMati;
  final String? resikoLampuMati;

  final String? patrolTime;
  final String? waktuKejadian;

  final String keterangan;
  final DateTime? timestamp;

  const RondaLaporanEntity({
    this.id,
    this.patrolTime,
    this.waktuKejadian,
    this.sampahMenumpuk = 1,
    this.selokanMampet = 1,
    this.fasilitasRusak = 1,
    this.kegiatanMengganggu = 1,
    this.potensiBahaya = 1,
    this.jalanBerlubang = 1,
    this.lampuMati = 1,
    this.laporanKeamanan = 1,
    this.wargaBertengkar = 1,
    this.tempatKurangAman = 1,
    this.kerumunanTidakTertib = 1,
    this.perluBantuanPetugas = 1,
    this.gangguanKamtibmas = 1,
    this.aktivitasMencurigakan = 1,
    this.kehilanganLingkungan = 1,
    this.wargaButuhBantuan = 1,
    this.kelompokBerselisih = 1,
    this.keluhanWarga = 1,
    this.kejadianMenggangguWarga = 1,
    this.perluTerusanRTRW = 1,
    this.permasalahanSosial = 1,
    this.kasusPerzinahan = 1,
    this.orangTerlantar = 1,
    this.adaSampahMenumpuk = false,
    this.waktuSampahMenumpuk,
    this.lokasiSampahMenumpuk,
    this.jenisSampahDominan,
    this.pengangkutanSesuaiJadwal = true,
    this.alasanPengangkutan,
    this.adaPembakaranSampah = false,
    this.waktuPembakaran,
    this.lokasiPembakaran,
    this.pembakaranDiberiTindakan,
    this.adaPencurian = false,
    this.waktuPencurian,
    this.lokasiPencurian,
    this.pelakuPencurianDiketahui,
    this.pencurianDilaporkanAparat,
    this.adaTawuran = false,
    this.waktuTawuran,
    this.lokasiTawuran,
    this.pelakuTawuranDiketahui,
    this.tawuranDilaporkanAparat,
    this.adaNarkoba = false,
    this.narkobaDilaporkanAparat,
    this.adaSelokanTersumbat = false,
    this.waktuSelokanTersumbat,
    this.lokasiSelokanTersumbat,
    this.resikoSelokanTersumbat,
    this.adaJalanRusak = false,
    this.lokasiJalanRusakGps,
    this.latitudeJalanRusak,
    this.longitudeJalanRusak,
    this.resikoJalanRusak,
    this.adaLampuMati = false,
    this.lokasiLampuMatiGps,
    this.latitudeLampuMati,
    this.longitudeLampuMati,
    this.resikoLampuMati,
    this.keterangan = '',
    this.timestamp,
  });

  @override
  List<Object?> get props => [
    id,
    sampahMenumpuk,
    selokanMampet,
    fasilitasRusak,
    kegiatanMengganggu,
    potensiBahaya,
    jalanBerlubang,
    lampuMati,
    laporanKeamanan,
    wargaBertengkar,
    tempatKurangAman,
    kerumunanTidakTertib,
    perluBantuanPetugas,
    gangguanKamtibmas,
    aktivitasMencurigakan,
    kehilanganLingkungan,
    wargaButuhBantuan,
    kelompokBerselisih,
    keluhanWarga,
    kejadianMenggangguWarga,
    perluTerusanRTRW,
    permasalahanSosial,
    kasusPerzinahan,
    orangTerlantar,
    adaSampahMenumpuk,
    waktuSampahMenumpuk,
    lokasiSampahMenumpuk,
    jenisSampahDominan,
    pengangkutanSesuaiJadwal,
    alasanPengangkutan,
    adaPembakaranSampah,
    waktuPembakaran,
    lokasiPembakaran,
    pembakaranDiberiTindakan,
    adaPencurian,
    waktuPencurian,
    lokasiPencurian,
    pelakuPencurianDiketahui,
    pencurianDilaporkanAparat,
    adaTawuran,
    waktuTawuran,
    lokasiTawuran,
    pelakuTawuranDiketahui,
    tawuranDilaporkanAparat,
    adaNarkoba,
    narkobaDilaporkanAparat,
    adaSelokanTersumbat,
    waktuSelokanTersumbat,
    lokasiSelokanTersumbat,
    resikoSelokanTersumbat,
    adaJalanRusak,
    lokasiJalanRusakGps,
    latitudeJalanRusak,
    longitudeJalanRusak,
    resikoJalanRusak,
    adaLampuMati,
    lokasiLampuMatiGps,
    latitudeLampuMati,
    longitudeLampuMati,
    resikoLampuMati,
    patrolTime,
    waktuKejadian,
    keterangan,
    timestamp,
  ];
}
