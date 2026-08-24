import '../../domain/entities/institusi_entity.dart';

class InstitusiModel extends InstitusiEntity {
  const InstitusiModel({
    super.id,
    required super.nama,
    super.kategori = 'Pemerintahan & Birokrasi',
    required super.scope,
    super.alamat,
    super.createdAt,
  });

  factory InstitusiModel.fromJson(Map<String, dynamic> json) {
    return InstitusiModel(
      id: json['id'] as String?,
      nama: json['nama'] as String? ?? '',
      kategori: json['kategori'] as String? ?? 'Pemerintahan & Birokrasi',
      scope: json['scope'] as String? ?? 'Kelurahan',
      alamat: json['alamat'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'kategori': kategori,
      'scope': scope,
      if (alamat != null) 'alamat': alamat,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory InstitusiModel.fromEntity(InstitusiEntity entity) {
    return InstitusiModel(
      id: entity.id,
      nama: entity.nama,
      kategori: entity.kategori,
      scope: entity.scope,
      alamat: entity.alamat,
      createdAt: entity.createdAt,
    );
  }
}
