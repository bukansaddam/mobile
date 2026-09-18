import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/organisasi_entity.dart';

part 'organisasi_model.freezed.dart';
part 'organisasi_model.g.dart';

Object? _readId(Map json, String key) => json['id']?.toString();

Object? _readNama(Map json, String key) =>
    (json['name'] ?? json['nama'] ?? '').toString();

Object? _readJumlahAnggota(Map json, String key) {
  final val = json['estimated_member_count'] ?? json['jumlahAnggota'];
  if (val is int) return val;
  if (val is String) return int.tryParse(val) ?? 0;
  return 0;
}

Object? _readBidang(Map json, String key) {
  final val = (json['field'] ?? json['bidang'] ?? 'Usaha').toString();
  if (val.isEmpty) return 'Usaha';
  return val[0].toUpperCase() + val.substring(1);
}

Object? _readAlamatSekretariat(Map json, String key) =>
    (json['secretariat_address'] ?? json['alamatSekretariat']) as String?;

Object? _readRegion(Map json, String key) {
  final val = json[key];
  if (val is Map) return val;
  if (val is String && val.isNotEmpty) return {'name': val};
  return null;
}

Object? _readCreatedAt(Map json, String key) =>
    json['created_at'] ?? json['createdAt'];

Object? _readUpdatedAt(Map json, String key) =>
    json['updated_at'] ?? json['updatedAt'];

DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();

@freezed
abstract class OrganisasiRegionModel with _$OrganisasiRegionModel {
  const OrganisasiRegionModel._();

  const factory OrganisasiRegionModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'code') String? code,
  }) = _OrganisasiRegionModel;

  factory OrganisasiRegionModel.fromJson(Map<String, dynamic> json) =>
      _$OrganisasiRegionModelFromJson(json);

  factory OrganisasiRegionModel.fromEntity(OrganisasiRegionEntity entity) =>
      OrganisasiRegionModel(
        id: entity.id,
        name: entity.name,
        code: entity.code,
      );
}

@freezed
abstract class OrganisasiMetaModel with _$OrganisasiMetaModel {
  const factory OrganisasiMetaModel({
    @JsonKey(name: 'current_page') @Default(1) int currentPage,
    @JsonKey(name: 'last_page') @Default(1) int lastPage,
    @JsonKey(name: 'per_page') @Default(10) int perPage,
    @JsonKey(name: 'total') @Default(0) int total,
  }) = _OrganisasiMetaModel;

  factory OrganisasiMetaModel.fromJson(Map<String, dynamic> json) =>
      _$OrganisasiMetaModelFromJson(json);
}

@freezed
abstract class OrganisasiResponseModel with _$OrganisasiResponseModel {
  const OrganisasiResponseModel._();

  const factory OrganisasiResponseModel({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') @Default([]) List<OrganisasiModel> data,
    @JsonKey(name: 'meta') OrganisasiMetaModel? meta,
  }) = _OrganisasiResponseModel;

  factory OrganisasiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrganisasiResponseModelFromJson(json);
}

@freezed
abstract class OrganisasiModel with _$OrganisasiModel {
  const OrganisasiModel._();

  const factory OrganisasiModel({
    @JsonKey(name: 'id', readValue: _readId) String? id,
    @JsonKey(name: 'name', readValue: _readNama) required String nama,
    @JsonKey(name: 'estimated_member_count', readValue: _readJumlahAnggota)
    required int jumlahAnggota,
    @JsonKey(name: 'field', readValue: _readBidang) required String bidang,
    @JsonKey(name: 'secretariat_address', readValue: _readAlamatSekretariat)
    String? alamatSekretariat,
    @JsonKey(name: 'province_id') int? provinceId,
    @JsonKey(name: 'regency_id') int? regencyId,
    @JsonKey(name: 'district_id') int? districtId,
    @JsonKey(name: 'village_id') int? villageId,
    @JsonKey(name: 'figures_count') int? figuresCount,
    @JsonKey(name: 'province', readValue: _readRegion)
    OrganisasiRegionModel? province,
    @JsonKey(name: 'regency', readValue: _readRegion)
    OrganisasiRegionModel? regency,
    @JsonKey(name: 'district', readValue: _readRegion)
    OrganisasiRegionModel? district,
    @JsonKey(name: 'village', readValue: _readRegion)
    OrganisasiRegionModel? village,
    @JsonKey(
      name: 'created_at',
      readValue: _readCreatedAt,
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    DateTime? createdAt,
    @JsonKey(
      name: 'updated_at',
      readValue: _readUpdatedAt,
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    DateTime? updatedAt,
  }) = _OrganisasiModel;

  factory OrganisasiModel.fromJson(Map<String, dynamic> json) =>
      _$OrganisasiModelFromJson(json);

  factory OrganisasiModel.fromEntity(OrganisasiEntity entity) =>
      OrganisasiModel(
        id: entity.id,
        nama: entity.nama,
        jumlahAnggota: entity.jumlahAnggota,
        bidang: entity.bidang,
        alamatSekretariat: entity.alamatSekretariat,
        provinceId: entity.provinceId,
        regencyId: entity.regencyId,
        districtId: entity.districtId,
        villageId: entity.villageId,
        figuresCount: entity.figuresCount,
        province: entity.province != null
            ? OrganisasiRegionModel.fromEntity(entity.province!)
            : null,
        regency: entity.regency != null
            ? OrganisasiRegionModel.fromEntity(entity.regency!)
            : null,
        district: entity.district != null
            ? OrganisasiRegionModel.fromEntity(entity.district!)
            : null,
        village: entity.village != null
            ? OrganisasiRegionModel.fromEntity(entity.village!)
            : null,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

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

  Map<String, dynamic> toApiJson() => {
    'name': nama,
    'estimated_member_count': jumlahAnggota,
    'field': bidang.toLowerCase(),
    'secretariat_address': alamatSekretariat?.trim() ?? '',
  };
}
