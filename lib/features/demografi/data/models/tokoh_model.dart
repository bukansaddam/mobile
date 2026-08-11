import '../../domain/entities/tokoh_entity.dart';

class TokohModel extends TokohEntity {
  const TokohModel({
    super.id,
    required super.nama,
    super.noTelp = '',
    super.jenisKelamin = 'Laki-laki',
    required super.profesi,
    super.wilayah = 'Nasional',
    super.namaInstitusi = '',
    super.jabatanInstitusi = '',
    required super.afiliasi,
    super.namaOrganisasi = '',
    super.jabatanOrganisasi = '',
    required super.suku,
    super.createdAt,
  });

  factory TokohModel.fromJson(Map<String, dynamic> json) {
    return TokohModel(
      id: json['id'] as String?,
      nama: json['nama'] as String? ?? '',
      noTelp: json['noTelp'] as String? ?? '',
      jenisKelamin: json['jenisKelamin'] as String? ?? 'Laki-laki',
      profesi: json['profesi'] as String? ?? 'Pejabat',
      wilayah:
          json['wilayah'] as String? ?? json['scope'] as String? ?? 'Nasional',
      namaInstitusi: json['namaInstitusi'] as String? ?? '',
      jabatanInstitusi: json['jabatanInstitusi'] as String? ?? '',
      afiliasi: json['afiliasi'] as String? ?? 'Politik',
      namaOrganisasi: json['namaOrganisasi'] as String? ?? '',
      jabatanOrganisasi: json['jabatanOrganisasi'] as String? ?? '',
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
      'jenisKelamin': jenisKelamin,
      'profesi': profesi,
      'wilayah': wilayah,
      'namaInstitusi': namaInstitusi,
      'jabatanInstitusi': jabatanInstitusi,
      'afiliasi': afiliasi,
      'namaOrganisasi': namaOrganisasi,
      'jabatanOrganisasi': jabatanOrganisasi,
      'suku': suku,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory TokohModel.fromEntity(TokohEntity entity) {
    return TokohModel(
      id: entity.id,
      nama: entity.nama,
      noTelp: entity.noTelp,
      jenisKelamin: entity.jenisKelamin,
      profesi: entity.profesi,
      wilayah: entity.wilayah,
      namaInstitusi: entity.namaInstitusi,
      jabatanInstitusi: entity.jabatanInstitusi,
      afiliasi: entity.afiliasi,
      namaOrganisasi: entity.namaOrganisasi,
      jabatanOrganisasi: entity.jabatanOrganisasi,
      suku: entity.suku,
      createdAt: entity.createdAt,
    );
  }
}
