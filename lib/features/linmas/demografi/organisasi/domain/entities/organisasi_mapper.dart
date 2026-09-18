import 'package:akar/features/linmas/demografi/organisasi/data/models/organisasi_model.dart';
import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';

export 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';

extension OrganisasiRegionModelMapper on OrganisasiRegionModel {
  OrganisasiRegionEntity toDomain() =>
      OrganisasiRegionEntity(id: id, name: name, code: code);
}

extension OrganisasiRegionEntityMapper on OrganisasiRegionEntity {
  OrganisasiRegionModel toModel() =>
      OrganisasiRegionModel(id: id, name: name, code: code);
}

extension OrganisasiModelMapper on OrganisasiModel {
  OrganisasiEntity toDomain() => OrganisasiEntity(
    id: id,
    nama: nama,
    jumlahAnggota: jumlahAnggota,
    bidang: bidang,
    alamatSekretariat: alamatSekretariat,
    provinceId: provinceId,
    regencyId: regencyId,
    districtId: districtId,
    villageId: villageId,
    figuresCount: figuresCount,
    province: province?.toDomain(),
    regency: regency?.toDomain(),
    district: district?.toDomain(),
    village: village?.toDomain(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension OrganisasiEntityMapper on OrganisasiEntity {
  OrganisasiModel toModel() => OrganisasiModel(
    id: id,
    nama: nama,
    jumlahAnggota: jumlahAnggota,
    bidang: bidang,
    alamatSekretariat: alamatSekretariat,
    provinceId: provinceId,
    regencyId: regencyId,
    districtId: districtId,
    villageId: villageId,
    figuresCount: figuresCount,
    province: province?.toModel(),
    regency: regency?.toModel(),
    district: district?.toModel(),
    village: village?.toModel(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension OrganisasiResponseModelMapper on OrganisasiResponseModel {
  OrganisasiPaginatedEntity toDomain() => OrganisasiPaginatedEntity(
    success: success,
    message: message,
    data: data.map((e) => e.toDomain()).toList(),
    currentPage: meta?.currentPage ?? 1,
    lastPage: meta?.lastPage ?? 1,
    perPage: meta?.perPage ?? 10,
    total: meta?.total ?? data.length,
  );
}
