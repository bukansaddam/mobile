// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organisasi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganisasiRegionModel _$OrganisasiRegionModelFromJson(
  Map<String, dynamic> json,
) => _OrganisasiRegionModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  code: json['code'] as String?,
);

Map<String, dynamic> _$OrganisasiRegionModelToJson(
  _OrganisasiRegionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
};

_OrganisasiMetaModel _$OrganisasiMetaModelFromJson(Map<String, dynamic> json) =>
    _OrganisasiMetaModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OrganisasiMetaModelToJson(
  _OrganisasiMetaModel instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'total': instance.total,
};

_OrganisasiResponseModel _$OrganisasiResponseModelFromJson(
  Map<String, dynamic> json,
) => _OrganisasiResponseModel(
  success: json['success'] as bool? ?? false,
  message: json['message'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => OrganisasiModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  meta: json['meta'] == null
      ? null
      : OrganisasiMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrganisasiResponseModelToJson(
  _OrganisasiResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};

_OrganisasiModel _$OrganisasiModelFromJson(Map<String, dynamic> json) =>
    _OrganisasiModel(
      id: _readId(json, 'id') as String?,
      nama: _readNama(json, 'name') as String,
      jumlahAnggota: (_readJumlahAnggota(json, 'estimated_member_count') as num)
          .toInt(),
      bidang: _readBidang(json, 'field') as String,
      alamatSekretariat:
          _readAlamatSekretariat(json, 'secretariat_address') as String?,
      provinceId: (json['province_id'] as num?)?.toInt(),
      regencyId: (json['regency_id'] as num?)?.toInt(),
      districtId: (json['district_id'] as num?)?.toInt(),
      villageId: (json['village_id'] as num?)?.toInt(),
      figuresCount: (json['figures_count'] as num?)?.toInt(),
      province: _readRegion(json, 'province') == null
          ? null
          : OrganisasiRegionModel.fromJson(
              _readRegion(json, 'province') as Map<String, dynamic>,
            ),
      regency: _readRegion(json, 'regency') == null
          ? null
          : OrganisasiRegionModel.fromJson(
              _readRegion(json, 'regency') as Map<String, dynamic>,
            ),
      district: _readRegion(json, 'district') == null
          ? null
          : OrganisasiRegionModel.fromJson(
              _readRegion(json, 'district') as Map<String, dynamic>,
            ),
      village: _readRegion(json, 'village') == null
          ? null
          : OrganisasiRegionModel.fromJson(
              _readRegion(json, 'village') as Map<String, dynamic>,
            ),
      createdAt: _dateTimeFromJson(_readCreatedAt(json, 'created_at')),
      updatedAt: _dateTimeFromJson(_readUpdatedAt(json, 'updated_at')),
    );

Map<String, dynamic> _$OrganisasiModelToJson(_OrganisasiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.nama,
      'estimated_member_count': instance.jumlahAnggota,
      'field': instance.bidang,
      'secretariat_address': instance.alamatSekretariat,
      'province_id': instance.provinceId,
      'regency_id': instance.regencyId,
      'district_id': instance.districtId,
      'village_id': instance.villageId,
      'figures_count': instance.figuresCount,
      'province': instance.province,
      'regency': instance.regency,
      'district': instance.district,
      'village': instance.village,
      'created_at': _dateTimeToJson(instance.createdAt),
      'updated_at': _dateTimeToJson(instance.updatedAt),
    };
