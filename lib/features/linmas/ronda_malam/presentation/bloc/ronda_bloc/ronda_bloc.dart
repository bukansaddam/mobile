import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';
import 'package:akar/features/linmas/ronda_malam/domain/usecases/submit_ronda_laporan_usecase.dart';

part 'ronda_event.dart';
part 'ronda_state.dart';

class RondaBloc extends Bloc<RondaEvent, RondaState> {
  final SubmitRondaLaporanUsecase submitRondaLaporanUsecase;

  RondaBloc({required this.submitRondaLaporanUsecase})
    : super(const RondaState()) {
    on<SetRondaStepEvent>(_onSetStep);
    on<NextRondaStepEvent>(_onNextStep);
    on<PreviousRondaStepEvent>(_onPreviousStep);
    on<UpdateRondaFieldEvent>(_onUpdateField);
    on<ResetRondaFormEvent>(_onResetForm);
    on<SubmitRondaLaporanEvent>(_onSubmitLaporan);
  }

  void _onSetStep(SetRondaStepEvent event, Emitter<RondaState> emit) {
    if (event.step >= 0 && event.step <= 3) {
      emit(state.copyWith(currentStep: event.step));
    }
  }

  void _onNextStep(NextRondaStepEvent event, Emitter<RondaState> emit) {
    if (state.currentStep < 3) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void _onPreviousStep(PreviousRondaStepEvent event, Emitter<RondaState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateField(UpdateRondaFieldEvent event, Emitter<RondaState> emit) {
    emit(
      state.copyWith(
        sampahMenumpuk: event.sampahMenumpuk,
        selokanMampet: event.selokanMampet,
        fasilitasRusak: event.fasilitasRusak,
        kegiatanMengganggu: event.kegiatanMengganggu,
        potensiBahaya: event.potensiBahaya,
        jalanBerlubang: event.jalanBerlubang,
        lampuMati: event.lampuMati,
        laporanKeamanan: event.laporanKeamanan,
        wargaBertengkar: event.wargaBertengkar,
        tempatKurangAman: event.tempatKurangAman,
        kerumunanTidakTertib: event.kerumunanTidakTertib,
        perluBantuanPetugas: event.perluBantuanPetugas,
        gangguanKamtibmas: event.gangguanKamtibmas,
        aktivitasMencurigakan: event.aktivitasMencurigakan,
        kehilanganLingkungan: event.kehilanganLingkungan,
        wargaButuhBantuan: event.wargaButuhBantuan,
        kelompokBerselisih: event.kelompokBerselisih,
        keluhanWarga: event.keluhanWarga,
        kejadianMenggangguWarga: event.kejadianMenggangguWarga,
        perluTerusanRTRW: event.perluTerusanRTRW,
        permasalahanSosial: event.permasalahanSosial,
        kasusPerzinahan: event.kasusPerzinahan,
        orangTerlantar: event.orangTerlantar,
        adaSampahMenumpuk: event.adaSampahMenumpuk,
        waktuSampahMenumpuk: event.waktuSampahMenumpuk,
        lokasiSampahMenumpuk: event.lokasiSampahMenumpuk,
        jenisSampahDominan: event.jenisSampahDominan,
        pengangkutanSesuaiJadwal: event.pengangkutanSesuaiJadwal,
        alasanPengangkutan: event.alasanPengangkutan,
        adaPembakaranSampah: event.adaPembakaranSampah,
        waktuPembakaran: event.waktuPembakaran,
        lokasiPembakaran: event.lokasiPembakaran,
        pembakaranDiberiTindakan: event.pembakaranDiberiTindakan,
        adaPencurian: event.adaPencurian,
        waktuPencurian: event.waktuPencurian,
        lokasiPencurian: event.lokasiPencurian,
        pelakuPencurianDiketahui: event.pelakuPencurianDiketahui,
        pencurianDilaporkanAparat: event.pencurianDilaporkanAparat,
        adaTawuran: event.adaTawuran,
        waktuTawuran: event.waktuTawuran,
        lokasiTawuran: event.lokasiTawuran,
        pelakuTawuranDiketahui: event.pelakuTawuranDiketahui,
        tawuranDilaporkanAparat: event.tawuranDilaporkanAparat,
        adaNarkoba: event.adaNarkoba,
        narkobaDilaporkanAparat: event.narkobaDilaporkanAparat,
        adaSelokanTersumbat: event.adaSelokanTersumbat,
        waktuSelokanTersumbat: event.waktuSelokanTersumbat,
        lokasiSelokanTersumbat: event.lokasiSelokanTersumbat,
        resikoSelokanTersumbat: event.resikoSelokanTersumbat,
        adaJalanRusak: event.adaJalanRusak,
        lokasiJalanRusakGps: event.lokasiJalanRusakGps,
        latitudeJalanRusak: event.latitudeJalanRusak,
        longitudeJalanRusak: event.longitudeJalanRusak,
        resikoJalanRusak: event.resikoJalanRusak,
        adaLampuMati: event.adaLampuMati,
        lokasiLampuMatiGps: event.lokasiLampuMatiGps,
        latitudeLampuMati: event.latitudeLampuMati,
        longitudeLampuMati: event.longitudeLampuMati,
        resikoLampuMati: event.resikoLampuMati,
        patrolTime: event.patrolTime,
        waktuKejadian: event.waktuKejadian,
        keterangan: event.keterangan,
      ),
    );
  }

  void _onResetForm(ResetRondaFormEvent event, Emitter<RondaState> emit) {
    emit(const RondaState());
  }

  Future<void> _onSubmitLaporan(
    SubmitRondaLaporanEvent event,
    Emitter<RondaState> emit,
  ) async {
    emit(state.copyWith(status: RondaStatus.submitting, errorMessage: null));

    final now = DateTime.now();
    final timeNowStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final dataEntity = RondaLaporanEntity(
      sampahMenumpuk: state.sampahMenumpuk,
      selokanMampet: state.selokanMampet,
      fasilitasRusak: state.fasilitasRusak,
      kegiatanMengganggu: state.kegiatanMengganggu,
      potensiBahaya: state.potensiBahaya,
      jalanBerlubang: state.jalanBerlubang,
      lampuMati: state.lampuMati,
      laporanKeamanan: state.laporanKeamanan,
      wargaBertengkar: state.wargaBertengkar,
      tempatKurangAman: state.tempatKurangAman,
      kerumunanTidakTertib: state.kerumunanTidakTertib,
      perluBantuanPetugas: state.perluBantuanPetugas,
      gangguanKamtibmas: state.gangguanKamtibmas,
      aktivitasMencurigakan: state.aktivitasMencurigakan,
      kehilanganLingkungan: state.kehilanganLingkungan,
      wargaButuhBantuan: state.wargaButuhBantuan,
      kelompokBerselisih: state.kelompokBerselisih,
      keluhanWarga: state.keluhanWarga,
      kejadianMenggangguWarga: state.kejadianMenggangguWarga,
      perluTerusanRTRW: state.perluTerusanRTRW,
      permasalahanSosial: state.permasalahanSosial,
      kasusPerzinahan: state.kasusPerzinahan,
      orangTerlantar: state.orangTerlantar,
      adaSampahMenumpuk: state.adaSampahMenumpuk,
      waktuSampahMenumpuk: state.waktuSampahMenumpuk,
      lokasiSampahMenumpuk: state.lokasiSampahMenumpuk,
      jenisSampahDominan: state.jenisSampahDominan,
      pengangkutanSesuaiJadwal: state.pengangkutanSesuaiJadwal,
      alasanPengangkutan: state.alasanPengangkutan,
      adaPembakaranSampah: state.adaPembakaranSampah,
      waktuPembakaran: state.waktuPembakaran,
      lokasiPembakaran: state.lokasiPembakaran,
      pembakaranDiberiTindakan: state.pembakaranDiberiTindakan,
      adaPencurian: state.adaPencurian,
      waktuPencurian: state.waktuPencurian,
      lokasiPencurian: state.lokasiPencurian,
      pelakuPencurianDiketahui: state.pelakuPencurianDiketahui,
      pencurianDilaporkanAparat: state.pencurianDilaporkanAparat,
      adaTawuran: state.adaTawuran,
      waktuTawuran: state.waktuTawuran,
      lokasiTawuran: state.lokasiTawuran,
      pelakuTawuranDiketahui: state.pelakuTawuranDiketahui,
      tawuranDilaporkanAparat: state.tawuranDilaporkanAparat,
      adaNarkoba: state.adaNarkoba,
      narkobaDilaporkanAparat: state.narkobaDilaporkanAparat,
      adaSelokanTersumbat: state.adaSelokanTersumbat,
      waktuSelokanTersumbat: state.waktuSelokanTersumbat,
      lokasiSelokanTersumbat: state.lokasiSelokanTersumbat,
      resikoSelokanTersumbat: state.resikoSelokanTersumbat,
      adaJalanRusak: state.adaJalanRusak,
      lokasiJalanRusakGps: state.lokasiJalanRusakGps,
      latitudeJalanRusak: state.latitudeJalanRusak,
      longitudeJalanRusak: state.longitudeJalanRusak,
      resikoJalanRusak: state.resikoJalanRusak,
      adaLampuMati: state.adaLampuMati,
      lokasiLampuMatiGps: state.lokasiLampuMatiGps,
      latitudeLampuMati: state.latitudeLampuMati,
      longitudeLampuMati: state.longitudeLampuMati,
      resikoLampuMati: state.resikoLampuMati,
      patrolTime: timeNowStr,
      waktuKejadian: timeNowStr,
      keterangan: state.keterangan,
      timestamp: now,
    );

    final result = await submitRondaLaporanUsecase.call(dataEntity);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: RondaStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (dataResult) {
        emit(
          state.copyWith(status: RondaStatus.success, lastResult: dataResult),
        );
      },
    );
  }
}
