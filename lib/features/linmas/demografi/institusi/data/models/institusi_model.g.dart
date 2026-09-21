// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institusi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstitusiRegionModel _$InstitusiRegionModelFromJson(
  Map<String, dynamic> json,
) => _InstitusiRegionModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  code: json['code'] as String?,
);

Map<String, dynamic> _$InstitusiRegionModelToJson(
  _InstitusiRegionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
};

_InstitusiMetaModel _$InstitusiMetaModelFromJson(Map<String, dynamic> json) =>
    _InstitusiMetaModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$InstitusiMetaModelToJson(_InstitusiMetaModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };

_InstitusiResponseModel _$InstitusiResponseModelFromJson(
  Map<String, dynamic> json,
) => _InstitusiResponseModel(
  success: json['success'] as bool? ?? false,
  message: json['message'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => InstitusiModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  meta: json['meta'] == null
      ? null
      : InstitusiMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InstitusiResponseModelToJson(
  _InstitusiResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};

_InstitusiModel _$InstitusiModelFromJson(Map<String, dynamic> json) =>
    _InstitusiModel(
      id: _readId(json, 'id') as String?,
      nama: _readNama(json, 'name') as String,
      scope: _readScope(json, 'scope') as String,
      kategori: _readKategori(json, 'category') as String?,
      categoryId: (_readCategoryId(json, 'category_id') as num?)?.toInt(),
      alamat: _readAlamat(json, 'address') as String?,
      provinceId: (json['province_id'] as num?)?.toInt(),
      regencyId: (json['regency_id'] as num?)?.toInt(),
      districtId: (json['district_id'] as num?)?.toInt(),
      villageId: (json['village_id'] as num?)?.toInt(),
      figuresCount: (json['figures_count'] as num?)?.toInt(),
      province: _readRegion(json, 'province') == null
          ? null
          : InstitusiRegionModel.fromJson(
              _readRegion(json, 'province') as Map<String, dynamic>,
            ),
      regency: _readRegion(json, 'regency') == null
          ? null
          : InstitusiRegionModel.fromJson(
              _readRegion(json, 'regency') as Map<String, dynamic>,
            ),
      district: _readRegion(json, 'district') == null
          ? null
          : InstitusiRegionModel.fromJson(
              _readRegion(json, 'district') as Map<String, dynamic>,
            ),
      village: _readRegion(json, 'village') == null
          ? null
          : InstitusiRegionModel.fromJson(
              _readRegion(json, 'village') as Map<String, dynamic>,
            ),
      createdAt: _dateTimeFromJson(_readCreatedAt(json, 'created_at')),
      updatedAt: _dateTimeFromJson(_readUpdatedAt(json, 'updated_at')),
    );

Map<String, dynamic> _$InstitusiModelToJson(_InstitusiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.nama,
      'scope': instance.scope,
      'category': instance.kategori,
      'category_id': instance.categoryId,
      'address': instance.alamat,
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
