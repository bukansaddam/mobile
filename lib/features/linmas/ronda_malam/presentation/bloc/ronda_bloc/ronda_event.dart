part of 'ronda_bloc.dart';

abstract class RondaEvent extends Equatable {
  const RondaEvent();

  @override
  List<Object?> get props => [];
}

class SetRondaStepEvent extends RondaEvent {
  final int step;

  const SetRondaStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

class NextRondaStepEvent extends RondaEvent {}

class PreviousRondaStepEvent extends RondaEvent {}

class UpdateRondaFieldEvent extends RondaEvent {
  final int? sampahMenumpuk;
  final int? selokanMampet;
  final int? fasilitasRusak;
  final int? kegiatanMengganggu;
  final int? potensiBahaya;
  final int? jalanBerlubang;
  final int? lampuMati;
  final int? laporanKeamanan;
  final int? wargaBertengkar;
  final int? tempatKurangAman;
  final int? kerumunanTidakTertib;
  final int? perluBantuanPetugas;
  final int? gangguanKamtibmas;
  final int? aktivitasMencurigakan;
  final int? kehilanganLingkungan;
  final int? wargaButuhBantuan;
  final int? kelompokBerselisih;
  final int? keluhanWarga;
  final int? kejadianMenggangguWarga;
  final int? perluTerusanRTRW;
  final int? permasalahanSosial;
  final int? kasusPerzinahan;
  final int? orangTerlantar;
  final bool? adaSampahMenumpuk;
  final String? waktuSampahMenumpuk;
  final String? lokasiSampahMenumpuk;
  final String? jenisSampahDominan;
  final bool? pengangkutanSesuaiJadwal;
  final String? alasanPengangkutan;
  final bool? adaPembakaranSampah;
  final String? waktuPembakaran;
  final String? lokasiPembakaran;
  final String? pembakaranDiberiTindakan;

  final bool? adaPencurian;
  final String? waktuPencurian;
  final String? lokasiPencurian;
  final String? pelakuPencurianDiketahui;
  final String? pencurianDilaporkanAparat;
  final bool? adaTawuran;
  final String? waktuTawuran;
  final String? lokasiTawuran;
  final String? pelakuTawuranDiketahui;
  final String? tawuranDilaporkanAparat;
  final bool? adaNarkoba;
  final String? narkobaDilaporkanAparat;

  final bool? adaSelokanTersumbat;
  final String? waktuSelokanTersumbat;
  final String? lokasiSelokanTersumbat;
  final String? resikoSelokanTersumbat;
  final bool? adaJalanRusak;
  final String? lokasiJalanRusakGps;
  final String? resikoJalanRusak;
  final bool? adaLampuMati;
  final String? lokasiLampuMatiGps;
  final String? resikoLampuMati;

  final String? keterangan;

  const UpdateRondaFieldEvent({
    this.sampahMenumpuk,
    this.selokanMampet,
    this.fasilitasRusak,
    this.kegiatanMengganggu,
    this.potensiBahaya,
    this.jalanBerlubang,
    this.lampuMati,
    this.laporanKeamanan,
    this.wargaBertengkar,
    this.tempatKurangAman,
    this.kerumunanTidakTertib,
    this.perluBantuanPetugas,
    this.gangguanKamtibmas,
    this.aktivitasMencurigakan,
    this.kehilanganLingkungan,
    this.wargaButuhBantuan,
    this.kelompokBerselisih,
    this.keluhanWarga,
    this.kejadianMenggangguWarga,
    this.perluTerusanRTRW,
    this.permasalahanSosial,
    this.kasusPerzinahan,
    this.orangTerlantar,
    this.adaSampahMenumpuk,
    this.waktuSampahMenumpuk,
    this.lokasiSampahMenumpuk,
    this.jenisSampahDominan,
    this.pengangkutanSesuaiJadwal,
    this.alasanPengangkutan,
    this.adaPembakaranSampah,
    this.waktuPembakaran,
    this.lokasiPembakaran,
    this.pembakaranDiberiTindakan,
    this.adaPencurian,
    this.waktuPencurian,
    this.lokasiPencurian,
    this.pelakuPencurianDiketahui,
    this.pencurianDilaporkanAparat,
    this.adaTawuran,
    this.waktuTawuran,
    this.lokasiTawuran,
    this.pelakuTawuranDiketahui,
    this.tawuranDilaporkanAparat,
    this.adaNarkoba,
    this.narkobaDilaporkanAparat,
    this.adaSelokanTersumbat,
    this.waktuSelokanTersumbat,
    this.lokasiSelokanTersumbat,
    this.resikoSelokanTersumbat,
    this.adaJalanRusak,
    this.lokasiJalanRusakGps,
    this.resikoJalanRusak,
    this.adaLampuMati,
    this.lokasiLampuMatiGps,
    this.resikoLampuMati,
    this.keterangan,
  });

  @override
  List<Object?> get props => [
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
  ];
}

class ResetRondaFormEvent extends RondaEvent {}

class SubmitRondaLaporanEvent extends RondaEvent {}
