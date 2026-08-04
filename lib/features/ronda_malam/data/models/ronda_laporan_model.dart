import '../../domain/entities/ronda_laporan_entity.dart';

class RondaLaporanModel extends RondaLaporanEntity {
  const RondaLaporanModel({
    super.id,
    super.gangguanKamtibmas,
    super.aktivitasMencurigakan,
    super.kehilanganLingkungan,
    super.sampahMenumpuk,
    super.jalanBerlubang,
    super.lampuMati,
    super.permasalahanSosial,
    super.kasusPerzinahan,
    super.orangTerlantar,
    super.keterangan,
    super.timestamp,
  });

  factory RondaLaporanModel.fromJson(Map<String, dynamic> json) {
    return RondaLaporanModel(
      id: json['id'] as String?,
      gangguanKamtibmas: json['gangguanKamtibmas'] as bool? ?? false,
      aktivitasMencurigakan: json['aktivitasMencurigakan'] as bool? ?? false,
      kehilanganLingkungan: json['kehilanganLingkungan'] as bool? ?? false,
      sampahMenumpuk: json['sampahMenumpuk'] as bool? ?? false,
      jalanBerlubang: json['jalanBerlubang'] as bool? ?? false,
      lampuMati: json['lampuMati'] as bool? ?? false,
      permasalahanSosial: json['permasalahanSosial'] as bool? ?? false,
      kasusPerzinahan: json['kasusPerzinahan'] as bool? ?? false,
      orangTerlantar: json['orangTerlantar'] as bool? ?? false,
      keterangan: json['keterangan'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gangguanKamtibmas': gangguanKamtibmas,
      'aktivitasMencurigakan': aktivitasMencurigakan,
      'kehilanganLingkungan': kehilanganLingkungan,
      'sampahMenumpuk': sampahMenumpuk,
      'jalanBerlubang': jalanBerlubang,
      'lampuMati': lampuMati,
      'permasalahanSosial': permasalahanSosial,
      'kasusPerzinahan': kasusPerzinahan,
      'orangTerlantar': orangTerlantar,
      'keterangan': keterangan,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory RondaLaporanModel.fromEntity(RondaLaporanEntity entity) {
    return RondaLaporanModel(
      id: entity.id,
      gangguanKamtibmas: entity.gangguanKamtibmas,
      aktivitasMencurigakan: entity.aktivitasMencurigakan,
      kehilanganLingkungan: entity.kehilanganLingkungan,
      sampahMenumpuk: entity.sampahMenumpuk,
      jalanBerlubang: entity.jalanBerlubang,
      lampuMati: entity.lampuMati,
      permasalahanSosial: entity.permasalahanSosial,
      kasusPerzinahan: entity.kasusPerzinahan,
      orangTerlantar: entity.orangTerlantar,
      keterangan: entity.keterangan,
      timestamp: entity.timestamp,
    );
  }
}
