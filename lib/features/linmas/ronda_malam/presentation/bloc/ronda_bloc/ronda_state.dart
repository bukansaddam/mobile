part of 'ronda_bloc.dart';

enum RondaStatus { initial, submitting, success, failure }

class RondaState extends Equatable {
  final RondaStatus status;
  final int currentStep;

  // Step 1: Lingkungan
  final int sampahMenumpuk;
  final int selokanMampet;
  final int fasilitasRusak;
  final int kegiatanMengganggu;
  final int potensiBahaya;
  final int jalanBerlubang;
  final int lampuMati;

  // Step 2: Keamanan
  final int laporanKeamanan;
  final int wargaBertengkar;
  final int tempatKurangAman;
  final int kerumunanTidakTertib;
  final int perluBantuanPetugas;
  final int gangguanKamtibmas;
  final int aktivitasMencurigakan;
  final int kehilanganLingkungan;

  // Step 3: Sosial
  final int wargaButuhBantuan;
  final int kelompokBerselisih;
  final int keluhanWarga;
  final int kejadianMenggangguWarga;
  final int perluTerusanRTRW;
  final int permasalahanSosial;
  final int kasusPerzinahan;
  final int orangTerlantar;

  // Step 4: Tambahan
  final String keterangan;
  final String? errorMessage;
  final RondaLaporanEntity? lastResult;

  const RondaState({
    this.status = RondaStatus.initial,
    this.currentStep = 0,
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
    this.errorMessage,
    this.lastResult,
  });

  RondaState copyWith({
    RondaStatus? status,
    int? currentStep,
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
    String? keterangan,
    String? errorMessage,
    RondaLaporanEntity? lastResult,
  }) {
    return RondaState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
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
      keterangan: keterangan ?? this.keterangan,
      errorMessage: errorMessage,
      lastResult: lastResult ?? this.lastResult,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentStep,
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
    errorMessage,
    lastResult,
  ];
}
