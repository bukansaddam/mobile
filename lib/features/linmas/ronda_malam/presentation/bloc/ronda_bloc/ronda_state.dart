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

  // Step 1 Sampah Detailed Fields
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

  // Step 2 Keamanan Detailed Fields
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

  // Step 3 Lingkungan Detailed Fields
  final bool adaSelokanTersumbat;
  final String? waktuSelokanTersumbat;
  final String? lokasiSelokanTersumbat;
  final String? resikoSelokanTersumbat;
  final bool adaJalanRusak;
  final String? lokasiJalanRusakGps;
  final String? resikoJalanRusak;
  final bool adaLampuMati;
  final String? lokasiLampuMatiGps;
  final String? resikoLampuMati;

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
    this.resikoJalanRusak,
    this.adaLampuMati = false,
    this.lokasiLampuMatiGps,
    this.resikoLampuMati,
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
    String? resikoJalanRusak,
    bool? adaLampuMati,
    String? lokasiLampuMatiGps,
    String? resikoLampuMati,
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
      resikoJalanRusak: resikoJalanRusak ?? this.resikoJalanRusak,
      adaLampuMati: adaLampuMati ?? this.adaLampuMati,
      lokasiLampuMatiGps: lokasiLampuMatiGps ?? this.lokasiLampuMatiGps,
      resikoLampuMati: resikoLampuMati ?? this.resikoLampuMati,
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
    resikoJalanRusak,
    adaLampuMati,
    lokasiLampuMatiGps,
    resikoLampuMati,
    keterangan,
    errorMessage,
    lastResult,
  ];
}
