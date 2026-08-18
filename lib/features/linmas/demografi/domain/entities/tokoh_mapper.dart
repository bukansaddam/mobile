import 'package:akar/features/linmas/demografi/data/models/tokoh_model.dart';
import 'package:akar/features/linmas/demografi/domain/entities/tokoh_entity.dart';

export 'package:akar/features/linmas/demografi/domain/entities/tokoh_entity.dart';

extension TokohModelMapper on TokohModel {
  TokohEntity toDomain() {
    return TokohEntity(
      id: id,
      nama: nama,
      noTelp: noTelp,
      jenisKelamin: jenisKelamin,
      profesi: profesi,
      wilayah: wilayah,
      namaInstitusi: namaInstitusi,
      jabatanInstitusi: jabatanInstitusi,
      afiliasi: afiliasi,
      namaOrganisasi: namaOrganisasi,
      jabatanOrganisasi: jabatanOrganisasi,
      suku: suku,
      createdAt: createdAt,
    );
  }
}

extension TokohEntityMapper on TokohEntity {
  TokohModel toModel() {
    return TokohModel(
      id: id,
      nama: nama,
      noTelp: noTelp,
      jenisKelamin: jenisKelamin,
      profesi: profesi,
      wilayah: wilayah,
      namaInstitusi: namaInstitusi,
      jabatanInstitusi: jabatanInstitusi,
      afiliasi: afiliasi,
      namaOrganisasi: namaOrganisasi,
      jabatanOrganisasi: jabatanOrganisasi,
      suku: suku,
      createdAt: createdAt,
    );
  }
}
