import 'package:freezed_annotation/freezed_annotation.dart';

part 'organisasi_entity.freezed.dart';

@freezed
abstract class OrganisasiRegionEntity with _$OrganisasiRegionEntity {
  const factory OrganisasiRegionEntity({int? id, String? name, String? code}) =
      _OrganisasiRegionEntity;
}

@freezed
abstract class OrganisasiEntity with _$OrganisasiEntity {
  const OrganisasiEntity._();

  const factory OrganisasiEntity({
    String? id,
    required String nama,
    required int jumlahAnggota,
    required String bidang,
    String? alamatSekretariat,
    int? provinceId,
    int? regencyId,
    int? districtId,
    int? villageId,
    int? figuresCount,
    OrganisasiRegionEntity? province,
    OrganisasiRegionEntity? regency,
    OrganisasiRegionEntity? district,
    OrganisasiRegionEntity? village,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OrganisasiEntity;

  String? get provinceName => province?.name;
  String? get regencyName => regency?.name;
  String? get districtName => district?.name;
  String? get villageName => village?.name;

  String get formattedWilayah {
    final parts = [
      villageName,
      districtName,
      regencyName,
    ].where((p) => p != null && p.trim().isNotEmpty).toList();
    return parts.join(', ');
  }
}

@freezed
abstract class OrganisasiPaginatedEntity with _$OrganisasiPaginatedEntity {
  const factory OrganisasiPaginatedEntity({
    @Default(false) bool success,
    @Default(0) int total,
    @Default(1) int currentPage,
    @Default(1) int lastPage,
    @Default(10) int perPage,
    @Default([]) List<OrganisasiEntity> data,
    String? message,
  }) = _OrganisasiPaginatedEntity;
}
