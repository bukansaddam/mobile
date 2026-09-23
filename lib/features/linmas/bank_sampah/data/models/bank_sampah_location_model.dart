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
    String alamat = (json['alamat'] ?? json['address'] ?? '').toString();
    if (alamat.isEmpty) {
      final parts = [
        json['villageName']?.toString(),
        json['districtName']?.toString(),
        json['regencyName']?.toString(),
      ].where((s) => s != null && s.isNotEmpty).toList();
      if (parts.isNotEmpty) {
        alamat = parts.join(', ');
      }
    }

    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return BankSampahLocationModel(
      id: json['id'] != null ? json['id'].toString() : '',
      nama: (json['nama'] ?? json['name'] ?? '').toString(),
      alamat: alamat,
      kelurahan: (json['kelurahan'] ?? json['villageName'] ?? '').toString(),
      pengelola: (json['pengelola'] ?? json['manager'] ?? '').toString(),
      kontak: (json['kontak'] ?? json['phone'] ?? '').toString(),
      latitude: parseDouble(json['latitude'] ?? json['lat']),
      longitude: parseDouble(json['longitude'] ?? json['lng']),
      latOffset: parseDouble(json['latOffset']),
      lngOffset: parseDouble(json['lngOffset']),
      distanceMeters: parseDouble(json['distanceMeters']),
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
