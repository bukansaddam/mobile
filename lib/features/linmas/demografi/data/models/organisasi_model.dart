import '../../domain/entities/organisasi_entity.dart';

class OrganisasiModel extends OrganisasiEntity {
  const OrganisasiModel({
    super.id,
    required super.nama,
    required super.jumlahAnggota,
    required super.bidang,
    super.alamatSekretariat,
    super.createdAt,
  });

  factory OrganisasiModel.fromJson(Map<String, dynamic> json) {
    return OrganisasiModel(
      id: json['id'] as String?,
      nama: json['nama'] as String? ?? '',
      jumlahAnggota: json['jumlahAnggota'] as int? ?? 0,
      bidang: json['bidang'] as String? ?? 'Usaha',
      alamatSekretariat: json['alamatSekretariat'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'jumlahAnggota': jumlahAnggota,
      'bidang': bidang,
      if (alamatSekretariat != null) 'alamatSekretariat': alamatSekretariat,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory OrganisasiModel.fromEntity(OrganisasiEntity entity) {
    return OrganisasiModel(
      id: entity.id,
      nama: entity.nama,
      jumlahAnggota: entity.jumlahAnggota,
      bidang: entity.bidang,
      alamatSekretariat: entity.alamatSekretariat,
      createdAt: entity.createdAt,
    );
  }
}
