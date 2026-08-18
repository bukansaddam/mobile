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
    keterangan,
  ];
}

class ResetRondaFormEvent extends RondaEvent {}

class SubmitRondaLaporanEvent extends RondaEvent {}
