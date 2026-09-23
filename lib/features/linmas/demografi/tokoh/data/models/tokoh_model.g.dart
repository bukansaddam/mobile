// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokoh_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokohMetaModel _$TokohMetaModelFromJson(Map<String, dynamic> json) =>
    _TokohMetaModel(
      currentPage:
          (_readCurrentPage(json, 'current_page') as num?)?.toInt() ?? 1,
      lastPage: (_readLastPage(json, 'last_page') as num?)?.toInt() ?? 1,
      perPage: (_readPerPage(json, 'per_page') as num?)?.toInt() ?? 10,
      total: (_readTotal(json, 'total') as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TokohMetaModelToJson(_TokohMetaModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };

_TokohResponseModel _$TokohResponseModelFromJson(Map<String, dynamic> json) =>
    _TokohResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data:
          (_readDataList(json, 'data') as List<dynamic>?)
              ?.map((e) => TokohModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: _readMeta(json, 'meta') == null
          ? null
          : TokohMetaModel.fromJson(
              _readMeta(json, 'meta') as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TokohResponseModelToJson(_TokohResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'meta': instance.meta,
    };

_TokohModel _$TokohModelFromJson(Map<String, dynamic> json) => _TokohModel(
  id: _readId(json, 'id') as String?,
  nama: _readNama(json, 'name') as String,
  noTelp: _readNoTelp(json, 'phone') as String? ?? '',
  jenisKelamin: _readGender(json, 'gender') as String? ?? 'Laki-laki',
  profesi: _readProfesi(json, 'professions') as String,
  wilayah: _readWilayah(json, 'wilayah') as String? ?? 'Nasional',
  instituteId: (_readInstituteId(json, 'institute_id') as num?)?.toInt(),
  namaInstitusi: _readNamaInstitusi(json, 'institute_name') as String? ?? '',
  jabatanInstitusi:
      _readJabatanInstitusi(json, 'institute_position') as String? ?? '',
  afiliasi: _readAfiliasi(json, 'affiliations') as String,
  organizationId: (_readOrganizationId(json, 'organization_id') as num?)
      ?.toInt(),
  namaOrganisasi:
      _readNamaOrganisasi(json, 'organization_name') as String? ?? '',
  jabatanOrganisasi:
      _readJabatanOrganisasi(json, 'organization_position') as String? ?? '',
  suku: _readSuku(json, 'ethnic') as String,
  createdAt: _dateTimeFromJson(_readCreatedAt(json, 'created_at')),
  updatedAt: _dateTimeFromJson(_readUpdatedAt(json, 'updated_at')),
);

Map<String, dynamic> _$TokohModelToJson(_TokohModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.nama,
      'phone': instance.noTelp,
      'gender': instance.jenisKelamin,
      'professions': instance.profesi,
      'wilayah': instance.wilayah,
      'institute_id': instance.instituteId,
      'institute_name': instance.namaInstitusi,
      'institute_position': instance.jabatanInstitusi,
      'affiliations': instance.afiliasi,
      'organization_id': instance.organizationId,
      'organization_name': instance.namaOrganisasi,
      'organization_position': instance.jabatanOrganisasi,
      'ethnic': instance.suku,
      'created_at': _dateTimeToJson(instance.createdAt),
      'updated_at': _dateTimeToJson(instance.updatedAt),
    };
