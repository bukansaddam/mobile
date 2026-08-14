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

  final String keterangan;
  final DateTime? timestamp;

  const RondaLaporanEntity({
    this.id,
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
    keterangan,
    timestamp,
  ];
}
