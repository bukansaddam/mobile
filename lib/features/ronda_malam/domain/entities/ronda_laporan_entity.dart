import 'package:equatable/equatable.dart';

class RondaLaporanEntity extends Equatable {
  final String? id;
  // Keamanan
  final bool gangguanKamtibmas;
  final bool aktivitasMencurigakan;
  final bool kehilanganLingkungan;

  // Lingkungan
  final bool sampahMenumpuk;
  final bool jalanBerlubang;
  final bool lampuMati;

  // Sosial
  final bool permasalahanSosial;
  final bool kasusPerzinahan;
  final bool orangTerlantar;

  final String keterangan;
  final DateTime? timestamp;

  const RondaLaporanEntity({
    this.id,
    this.gangguanKamtibmas = false,
    this.aktivitasMencurigakan = false,
    this.kehilanganLingkungan = false,
    this.sampahMenumpuk = false,
    this.jalanBerlubang = false,
    this.lampuMati = false,
    this.permasalahanSosial = false,
    this.kasusPerzinahan = false,
    this.orangTerlantar = false,
    this.keterangan = '',
    this.timestamp,
  });

  @override
  List<Object?> get props => [
    id,
    gangguanKamtibmas,
    aktivitasMencurigakan,
    kehilanganLingkungan,
    sampahMenumpuk,
    jalanBerlubang,
    lampuMati,
    permasalahanSosial,
    kasusPerzinahan,
    orangTerlantar,
    keterangan,
    timestamp,
  ];
}
