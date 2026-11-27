import 'package:akar/features/linmas/demografi/institusi/data/models/institusi_model.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/institusi/data/models/institusi_category_model.dart';
import 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_category_entity.dart';

export 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_entity.dart';
export 'package:akar/features/linmas/demografi/institusi/domain/entities/institusi_category_entity.dart';

extension InstitusiRegionModelMapper on InstitusiRegionModel {
  InstitusiRegionEntity toDomain() =>
      InstitusiRegionEntity(id: id, name: name, code: code);
}

extension InstitusiRegionEntityMapper on InstitusiRegionEntity {
  InstitusiRegionModel toModel() =>
      InstitusiRegionModel(id: id, name: name, code: code);
}

extension InstitusiModelMapper on InstitusiModel {
  InstitusiEntity toDomain() => InstitusiEntity(
    id: id,
    nama: nama,
    scope: scope,
    kategori: kategori,
    categoryId: categoryId,
    alamat: alamat,
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

extension InstitusiEntityMapper on InstitusiEntity {
  InstitusiModel toModel() => InstitusiModel(
    id: id,
    nama: nama,
    scope: scope,
    kategori: kategori,
    categoryId: categoryId,
    alamat: alamat,
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

extension InstitusiResponseModelMapper on InstitusiResponseModel {
  InstitusiPaginatedEntity toDomain() => InstitusiPaginatedEntity(
    success: success,
    message: message,
    data: data.map((e) => e.toDomain()).toList(),
    currentPage: meta?.currentPage ?? 1,
    lastPage: meta?.lastPage ?? 1,
    perPage: meta?.perPage ?? 10,
    total: meta?.total ?? data.length,
  );
}

extension InstitusiCategoryModelMapper on InstitusiCategoryModel {
  InstitusiCategoryEntity toDomain() => InstitusiCategoryEntity(
    id: id,
    label: label,
    code: code,
    isActive: isActive,
    domain: domain,
    color: color,
  );
}

extension InstitusiCategoryEntityMapper on InstitusiCategoryEntity {
  InstitusiCategoryModel toModel() => InstitusiCategoryModel(
    id: id,
    label: label,
    code: code,
    isActive: isActive,
    domain: domain,
    color: color,
  );
}
