import 'package:flutter/foundation.dart';
import '../../domain/entities/ronda_laporan_entity.dart';
import '../../domain/usecases/submit_ronda_laporan_usecase.dart';

enum RondaStatus { initial, submitting, success, failure }

class RondaProvider extends ChangeNotifier {
  final SubmitRondaLaporanUsecase submitRondaLaporanUsecase;

  RondaProvider({required this.submitRondaLaporanUsecase});

  RondaStatus _status = RondaStatus.initial;
  RondaStatus get status => _status;

  // Keamanan
  bool? _gangguanKamtibmas;
  bool? get gangguanKamtibmas => _gangguanKamtibmas;

  bool? _aktivitasMencurigakan;
  bool? get aktivitasMencurigakan => _aktivitasMencurigakan;

  bool? _kehilanganLingkungan;
  bool? get kehilanganLingkungan => _kehilanganLingkungan;

  // Lingkungan
  bool? _sampahMenumpuk;
  bool? get sampahMenumpuk => _sampahMenumpuk;

  bool? _jalanBerlubang;
  bool? get jalanBerlubang => _jalanBerlubang;

  bool? _lampuMati;
  bool? get lampuMati => _lampuMati;

  // Sosial
  bool? _permasalahanSosial;
  bool? get permasalahanSosial => _permasalahanSosial;

  bool? _kasusPerzinahan;
  bool? get kasusPerzinahan => _kasusPerzinahan;

  bool? _orangTerlantar;
  bool? get orangTerlantar => _orangTerlantar;

  String _keterangan = '';
  String get keterangan => _keterangan;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RondaLaporanEntity? _lastResult;
  RondaLaporanEntity? get lastResult => _lastResult;

  void setGangguanKamtibmas(bool val) {
    _gangguanKamtibmas = val;
    notifyListeners();
  }

  void setAktivitasMencurigakan(bool val) {
    _aktivitasMencurigakan = val;
    notifyListeners();
  }

  void setKehilanganLingkungan(bool val) {
    _kehilanganLingkungan = val;
    notifyListeners();
  }

  void setSampahMenumpuk(bool val) {
    _sampahMenumpuk = val;
    notifyListeners();
  }

  void setJalanBerlubang(bool val) {
    _jalanBerlubang = val;
    notifyListeners();
  }

  void setLampuMati(bool val) {
    _lampuMati = val;
    notifyListeners();
  }

  void setPermasalahanSosial(bool val) {
    _permasalahanSosial = val;
    notifyListeners();
  }

  void setKasusPerzinahan(bool val) {
    _kasusPerzinahan = val;
    notifyListeners();
  }

  void setOrangTerlantar(bool val) {
    _orangTerlantar = val;
    notifyListeners();
  }

  void updateKeterangan(String val) {
    _keterangan = val;
    notifyListeners();
  }

  void resetForm() {
    _gangguanKamtibmas = null;
    _aktivitasMencurigakan = null;
    _kehilanganLingkungan = null;
    _sampahMenumpuk = null;
    _jalanBerlubang = null;
    _lampuMati = null;
    _permasalahanSosial = null;
    _kasusPerzinahan = null;
    _orangTerlantar = null;
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
      gangguanKamtibmas: _gangguanKamtibmas ?? false,
      aktivitasMencurigakan: _aktivitasMencurigakan ?? false,
      kehilanganLingkungan: _kehilanganLingkungan ?? false,
      sampahMenumpuk: _sampahMenumpuk ?? false,
      jalanBerlubang: _jalanBerlubang ?? false,
      lampuMati: _lampuMati ?? false,
      permasalahanSosial: _permasalahanSosial ?? false,
      kasusPerzinahan: _kasusPerzinahan ?? false,
      orangTerlantar: _orangTerlantar ?? false,
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
