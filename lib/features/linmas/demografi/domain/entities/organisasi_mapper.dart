import 'package:akar/features/linmas/demografi/data/models/organisasi_model.dart';
import 'package:akar/features/linmas/demografi/domain/entities/organisasi_entity.dart';

export 'package:akar/features/linmas/demografi/domain/entities/organisasi_entity.dart';

extension OrganisasiModelMapper on OrganisasiModel {
  OrganisasiEntity toDomain() {
    return OrganisasiEntity(
      id: id,
      nama: nama,
      jumlahAnggota: jumlahAnggota,
      bidang: bidang,
      alamatSekretariat: alamatSekretariat,
      createdAt: createdAt,
    );
  }
}

extension OrganisasiEntityMapper on OrganisasiEntity {
  OrganisasiModel toModel() {
    return OrganisasiModel(
      id: id,
      nama: nama,
      jumlahAnggota: jumlahAnggota,
      bidang: bidang,
      alamatSekretariat: alamatSekretariat,
      createdAt: createdAt,
    );
  }
}
