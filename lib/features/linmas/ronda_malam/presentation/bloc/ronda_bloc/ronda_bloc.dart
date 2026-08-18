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
      keterangan: state.keterangan,
      timestamp: DateTime.now(),
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
