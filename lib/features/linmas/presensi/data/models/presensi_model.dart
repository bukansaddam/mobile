import '../../domain/entities/presensi_entity.dart';

class PresensiDataModel extends PresensiDataEntity {
  const PresensiDataModel({
    super.id,
    required super.userName,
    required super.address,
    required super.kecamatan,
    required super.kelurahan,
    required super.rt,
    required super.rw,
    required super.latitude,
    required super.longitude,
    super.timestamp,
    super.isSuccess,
  });

  factory PresensiDataModel.fromJson(Map<String, dynamic> json) {
    return PresensiDataModel(
      id: json['id'] as String?,
      userName: json['userName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      kecamatan: json['kecamatan'] as String? ?? '',
      kelurahan: json['kelurahan'] as String? ?? '',
      rt: json['rt'] as String? ?? '',
      rw: json['rw'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
      isSuccess: json['isSuccess'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'address': address,
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'rt': rt,
      'rw': rw,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp?.toIso8601String(),
      'isSuccess': isSuccess,
    };
  }

  factory PresensiDataModel.fromEntity(PresensiDataEntity entity) {
    return PresensiDataModel(
      id: entity.id,
      userName: entity.userName,
      address: entity.address,
      kecamatan: entity.kecamatan,
      kelurahan: entity.kelurahan,
      rt: entity.rt,
      rw: entity.rw,
      latitude: entity.latitude,
      longitude: entity.longitude,
      timestamp: entity.timestamp,
      isSuccess: entity.isSuccess,
    );
  }
}
