import 'package:flutter/foundation.dart';
import '../../domain/entities/ronda_laporan_entity.dart';
import '../../domain/usecases/submit_ronda_laporan_usecase.dart';

enum RondaStatus { initial, submitting, success, failure }

class RondaProvider extends ChangeNotifier {
  final SubmitRondaLaporanUsecase submitRondaLaporanUsecase;

  RondaProvider({required this.submitRondaLaporanUsecase});

  RondaStatus _status = RondaStatus.initial;
  RondaStatus get status => _status;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  // Step 1: Lingkungan
  int _sampahMenumpuk = 1;
  int get sampahMenumpuk => _sampahMenumpuk;

  int _selokanMampet = 1;
  int get selokanMampet => _selokanMampet;

  int _fasilitasRusak = 1;
  int get fasilitasRusak => _fasilitasRusak;

  int _kegiatanMengganggu = 1;
  int get kegiatanMengganggu => _kegiatanMengganggu;

  int _potensiBahaya = 1;
  int get potensiBahaya => _potensiBahaya;

  int _jalanBerlubang = 1;
  int get jalanBerlubang => _jalanBerlubang;

  int _lampuMati = 1;
  int get lampuMati => _lampuMati;

  // Step 2: Keamanan
  int _laporanKeamanan = 1;
  int get laporanKeamanan => _laporanKeamanan;

  int _wargaBertengkar = 1;
  int get wargaBertengkar => _wargaBertengkar;

  int _tempatKurangAman = 1;
  int get tempatKurangAman => _tempatKurangAman;

  int _kerumunanTidakTertib = 1;
  int get kerumunanTidakTertib => _kerumunanTidakTertib;

  int _perluBantuanPetugas = 1;
  int get perluBantuanPetugas => _perluBantuanPetugas;

  int _gangguanKamtibmas = 1;
  int get gangguanKamtibmas => _gangguanKamtibmas;

  int _aktivitasMencurigakan = 1;
  int get aktivitasMencurigakan => _aktivitasMencurigakan;

  int _kehilanganLingkungan = 1;
  int get kehilanganLingkungan => _kehilanganLingkungan;

  // Step 3: Sosial
  int _wargaButuhBantuan = 1;
  int get wargaButuhBantuan => _wargaButuhBantuan;

  int _kelompokBerselisih = 1;
  int get kelompokBerselisih => _kelompokBerselisih;

  int _keluhanWarga = 1;
  int get keluhanWarga => _keluhanWarga;

  int _kejadianMenggangguWarga = 1;
  int get kejadianMenggangguWarga => _kejadianMenggangguWarga;

  int _perluTerusanRTRW = 1;
  int get perluTerusanRTRW => _perluTerusanRTRW;

  int _permasalahanSosial = 1;
  int get permasalahanSosial => _permasalahanSosial;

  int _kasusPerzinahan = 1;
  int get kasusPerzinahan => _kasusPerzinahan;

  int _orangTerlantar = 1;
  int get orangTerlantar => _orangTerlantar;

  // Step 4: Tambahan
  String _keterangan = '';
  String get keterangan => _keterangan;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RondaLaporanEntity? _lastResult;
  RondaLaporanEntity? get lastResult => _lastResult;

  void setStep(int step) {
    if (step >= 0 && step <= 3) {
      _currentStep = step;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setSampahMenumpuk(int val) {
    _sampahMenumpuk = val;
    notifyListeners();
  }

  void setSelokanMampet(int val) {
    _selokanMampet = val;
    notifyListeners();
  }

  void setFasilitasRusak(int val) {
    _fasilitasRusak = val;
    notifyListeners();
  }

  void setKegiatanMengganggu(int val) {
    _kegiatanMengganggu = val;
    notifyListeners();
  }

  void setPotensiBahaya(int val) {
    _potensiBahaya = val;
    notifyListeners();
  }

  void setJalanBerlubang(int val) {
    _jalanBerlubang = val;
    notifyListeners();
  }

  void setLampuMati(int val) {
    _lampuMati = val;
    notifyListeners();
  }

  void setLaporanKeamanan(int val) {
    _laporanKeamanan = val;
    notifyListeners();
  }

  void setWargaBertengkar(int val) {
    _wargaBertengkar = val;
    notifyListeners();
  }

  void setTempatKurangAman(int val) {
    _tempatKurangAman = val;
    notifyListeners();
  }

  void setKerumunanTidakTertib(int val) {
    _kerumunanTidakTertib = val;
    notifyListeners();
  }

  void setPerluBantuanPetugas(int val) {
    _perluBantuanPetugas = val;
    notifyListeners();
  }

  void setGangguanKamtibmas(int val) {
    _gangguanKamtibmas = val;
    notifyListeners();
  }

  void setAktivitasMencurigakan(int val) {
    _aktivitasMencurigakan = val;
    notifyListeners();
  }

  void setKehilanganLingkungan(int val) {
    _kehilanganLingkungan = val;
    notifyListeners();
  }

  void setWargaButuhBantuan(int val) {
    _wargaButuhBantuan = val;
    notifyListeners();
  }

  void setKelompokBerselisih(int val) {
    _kelompokBerselisih = val;
    notifyListeners();
  }

  void setKeluhanWarga(int val) {
    _keluhanWarga = val;
    notifyListeners();
  }

  void setKejadianMenggangguWarga(int val) {
    _kejadianMenggangguWarga = val;
    notifyListeners();
  }

  void setPerluTerusanRTRW(int val) {
    _perluTerusanRTRW = val;
    notifyListeners();
  }

  void setPermasalahanSosial(int val) {
    _permasalahanSosial = val;
    notifyListeners();
  }

  void setKasusPerzinahan(int val) {
    _kasusPerzinahan = val;
    notifyListeners();
  }

  void setOrangTerlantar(int val) {
    _orangTerlantar = val;
    notifyListeners();
  }

  void updateKeterangan(String val) {
    _keterangan = val;
    notifyListeners();
  }

  void resetForm() {
    _currentStep = 0;
    _sampahMenumpuk = 1;
    _selokanMampet = 1;
    _fasilitasRusak = 1;
    _kegiatanMengganggu = 1;
    _potensiBahaya = 1;
    _jalanBerlubang = 1;
    _lampuMati = 1;
    _laporanKeamanan = 1;
    _wargaBertengkar = 1;
    _tempatKurangAman = 1;
    _kerumunanTidakTertib = 1;
    _perluBantuanPetugas = 1;
    _gangguanKamtibmas = 1;
    _aktivitasMencurigakan = 1;
    _kehilanganLingkungan = 1;
    _wargaButuhBantuan = 1;
    _kelompokBerselisih = 1;
    _keluhanWarga = 1;
    _kejadianMenggangguWarga = 1;
    _perluTerusanRTRW = 1;
    _permasalahanSosial = 1;
    _kasusPerzinahan = 1;
    _orangTerlantar = 1;
    _keterangan = '';
    _status = RondaStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitLaporan() async {
    _status = RondaStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    final dataEntity = RondaLaporanEntity(
      sampahMenumpuk: _sampahMenumpuk,
      selokanMampet: _selokanMampet,
      fasilitasRusak: _fasilitasRusak,
      kegiatanMengganggu: _kegiatanMengganggu,
      potensiBahaya: _potensiBahaya,
      jalanBerlubang: _jalanBerlubang,
      lampuMati: _lampuMati,
      laporanKeamanan: _laporanKeamanan,
      wargaBertengkar: _wargaBertengkar,
      tempatKurangAman: _tempatKurangAman,
      kerumunanTidakTertib: _kerumunanTidakTertib,
      perluBantuanPetugas: _perluBantuanPetugas,
      gangguanKamtibmas: _gangguanKamtibmas,
      aktivitasMencurigakan: _aktivitasMencurigakan,
      kehilanganLingkungan: _kehilanganLingkungan,
      wargaButuhBantuan: _wargaButuhBantuan,
      kelompokBerselisih: _kelompokBerselisih,
      keluhanWarga: _keluhanWarga,
      kejadianMenggangguWarga: _kejadianMenggangguWarga,
      perluTerusanRTRW: _perluTerusanRTRW,
      permasalahanSosial: _permasalahanSosial,
      kasusPerzinahan: _kasusPerzinahan,
      orangTerlantar: _orangTerlantar,
      keterangan: _keterangan,
      timestamp: DateTime.now(),
    );

    final result = await submitRondaLaporanUsecase.call(dataEntity);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _status = RondaStatus.failure;
        notifyListeners();
        return false;
      },
      (dataResult) {
        _lastResult = dataResult;
        _status = RondaStatus.success;
        notifyListeners();
        return true;
      },
    );
  }
}
