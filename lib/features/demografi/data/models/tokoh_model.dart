import '../../domain/entities/tokoh_entity.dart';

class TokohModel extends TokohEntity {
  const TokohModel({
    super.id,
    required super.nama,
    super.noTelp = '',
    required super.profesi,
    required super.wilayah,
    required super.afiliasi,
    super.namaOrganisasi = '',
    required super.suku,
    super.createdAt,
  });

  factory TokohModel.fromJson(Map<String, dynamic> json) {
    return TokohModel(
      id: json['id'] as String?,
      nama: json['nama'] as String? ?? '',
      noTelp: json['noTelp'] as String? ?? '',
      profesi: json['profesi'] as String? ?? 'Pejabat',
      wilayah:
          json['wilayah'] as String? ?? json['scope'] as String? ?? 'Nasional',
      afiliasi: json['afiliasi'] as String? ?? 'Politik',
      namaOrganisasi: json['namaOrganisasi'] as String? ?? '',
      suku: json['suku'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'noTelp': noTelp,
      'profesi': profesi,
      'wilayah': wilayah,
      'afiliasi': afiliasi,
      'namaOrganisasi': namaOrganisasi,
      'suku': suku,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory TokohModel.fromEntity(TokohEntity entity) {
    return TokohModel(
      id: entity.id,
      nama: entity.nama,
      noTelp: entity.noTelp,
      profesi: entity.profesi,
      wilayah: entity.wilayah,
      afiliasi: entity.afiliasi,
      namaOrganisasi: entity.namaOrganisasi,
      suku: entity.suku,
      createdAt: entity.createdAt,
    );
  }
}
