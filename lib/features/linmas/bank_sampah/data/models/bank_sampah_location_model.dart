import '../../domain/entities/bank_sampah_location_entity.dart';

class BankSampahLocationModel extends BankSampahLocationEntity {
  const BankSampahLocationModel({
    required super.id,
    required super.nama,
    required super.alamat,
    super.kelurahan,
    super.pengelola,
    super.kontak,
    super.latitude,
    super.longitude,
    super.latOffset,
    super.lngOffset,
    super.distanceMeters,
  });

  factory BankSampahLocationModel.fromJson(Map<String, dynamic> json) {
    return BankSampahLocationModel(
      id: json['id'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      alamat: json['alamat'] as String? ?? '',
      kelurahan: json['kelurahan'] as String? ?? '',
      pengelola: json['pengelola'] as String? ?? '',
      kontak: json['kontak'] as String? ?? '',
      latitude:
          (json['latitude'] as num?)?.toDouble() ??
          (json['lat'] as num?)?.toDouble(),
      longitude:
          (json['longitude'] as num?)?.toDouble() ??
          (json['lng'] as num?)?.toDouble(),
      latOffset: (json['latOffset'] as num?)?.toDouble(),
      lngOffset: (json['lngOffset'] as num?)?.toDouble(),
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'kelurahan': kelurahan,
      'pengelola': pengelola,
      'kontak': kontak,
      'latitude': latitude,
      'longitude': longitude,
      'latOffset': latOffset,
      'lngOffset': lngOffset,
      'distanceMeters': distanceMeters,
    };
  }

  factory BankSampahLocationModel.fromEntity(BankSampahLocationEntity entity) {
    return BankSampahLocationModel(
      id: entity.id,
      nama: entity.nama,
      alamat: entity.alamat,
      kelurahan: entity.kelurahan,
      pengelola: entity.pengelola,
      kontak: entity.kontak,
      latitude: entity.latitude,
      longitude: entity.longitude,
      latOffset: entity.latOffset,
      lngOffset: entity.lngOffset,
      distanceMeters: entity.distanceMeters,
    );
  }
}
