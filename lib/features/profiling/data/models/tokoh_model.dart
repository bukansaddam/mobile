import '../../domain/entities/tokoh_entity.dart';

class TokohModel extends TokohEntity {
  const TokohModel({
    super.id,
    required super.nama,
    required super.noTelp,
    required super.wilayah,
    required super.afiliasi,
    required super.namaOrganisasi,
    super.createdAt,
  });

  factory TokohModel.fromJson(Map<String, dynamic> json) {
    return TokohModel(
      id: json['id'] as String?,
      nama: json['nama'] as String? ?? '',
      noTelp: json['noTelp'] as String? ?? '',
      wilayah: json['wilayah'] as String? ?? 'Lokal',
      afiliasi: json['afiliasi'] as String? ?? 'Politik',
      namaOrganisasi: json['namaOrganisasi'] as String? ?? '',
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
      'wilayah': wilayah,
      'afiliasi': afiliasi,
      'namaOrganisasi': namaOrganisasi,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory TokohModel.fromEntity(TokohEntity entity) {
    return TokohModel(
      id: entity.id,
      nama: entity.nama,
      noTelp: entity.noTelp,
      wilayah: entity.wilayah,
      afiliasi: entity.afiliasi,
      namaOrganisasi: entity.namaOrganisasi,
      createdAt: entity.createdAt,
    );
  }
}
