import 'package:akar/features/linmas/demografi/tokoh/data/models/tokoh_model.dart';
import 'package:akar/features/linmas/demografi/tokoh/domain/entities/tokoh_entity.dart';

export 'package:akar/features/linmas/demografi/tokoh/domain/entities/tokoh_entity.dart';

extension TokohModelMapper on TokohModel {
  TokohEntity toDomain() => TokohEntity(
    id: id,
    nama: nama,
    noTelp: noTelp,
    jenisKelamin: jenisKelamin,
    profesi: profesi,
    wilayah: wilayah,
    instituteId: instituteId,
    namaInstitusi: namaInstitusi,
    jabatanInstitusi: jabatanInstitusi,
    afiliasi: afiliasi,
    organizationId: organizationId,
    namaOrganisasi: namaOrganisasi,
    jabatanOrganisasi: jabatanOrganisasi,
    suku: suku,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension TokohEntityMapper on TokohEntity {
  TokohModel toModel() => TokohModel(
    id: id,
    nama: nama,
    noTelp: noTelp,
    jenisKelamin: jenisKelamin,
    profesi: profesi,
    wilayah: wilayah,
    instituteId: instituteId,
    namaInstitusi: namaInstitusi,
    jabatanInstitusi: jabatanInstitusi,
    afiliasi: afiliasi,
    organizationId: organizationId,
    namaOrganisasi: namaOrganisasi,
    jabatanOrganisasi: jabatanOrganisasi,
    suku: suku,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension TokohResponseModelMapper on TokohResponseModel {
  TokohPaginatedEntity toDomain() => TokohPaginatedEntity(
    success: success,
    message: message,
    data: data.map((e) => e.toDomain()).toList(),
    currentPage: meta?.currentPage ?? 1,
    lastPage: meta?.lastPage ?? 1,
    perPage: meta?.perPage ?? 10,
    total: meta?.total ?? data.length,
  );
}
