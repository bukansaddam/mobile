import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';
import 'package:akar/features/linmas/ronda_malam/domain/usecases/submit_ronda_laporan_usecase.dart';
import 'package:akar/utils/app_logger.dart';

part 'ronda_event.dart';
part 'ronda_state.dart';

class RondaBloc extends Bloc<RondaEvent, RondaState> {
  final SubmitRondaLaporanUsecase submitRondaLaporanUsecase;

  RondaBloc({required this.submitRondaLaporanUsecase})
    : super(const RondaInitial()) {
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
    emit(const RondaInitial());
  }

  Future<void> _onSubmitLaporan(
    SubmitRondaLaporanEvent event,
    Emitter<RondaState> emit,
  ) async {
    emit(state.toActionLoading());

    final now = DateTime.now();
    final timeNowStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final dataEntity = event.laporan ??
        state.toEntity(
          patrolTime: timeNowStr,
          waktuKejadian: timeNowStr,
          timestamp: now,
        );

    final result = await submitRondaLaporanUsecase(dataEntity);

    result.fold(
      (failure) {
        AppLogger.e('[RONDA_BLOC] Submit laporan failed: ${failure.message}');
        emit(state.toActionFailure(failure.message));
      },
      (dataResult) {
        AppLogger.i('[RONDA_BLOC] Submit laporan succeeded: ${dataResult.id}');
        emit(
          state.toActionSuccess(
            laporan: dataResult,
            message: 'Laporan ronda malam berhasil dikirim',
          ),
        );
      },
    );
  }
}
