import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/tokoh_entity.dart';

part 'tokoh_model.freezed.dart';
part 'tokoh_model.g.dart';

Object? _readId(Map json, String key) => json['id']?.toString();

Object? _readNama(Map json, String key) =>
    (json['name'] ?? json['nama'] ?? '').toString();

Object? _readNoTelp(Map json, String key) =>
    (json['phone'] ?? json['no_telp'] ?? json['noTelp'] ?? '').toString();

Object? _readGender(Map json, String key) {
  final rawGender =
      (json['gender'] ??
              json['jenis_kelamin'] ??
              json['jenisKelamin'] ??
              'laki_laki')
          .toString()
          .toLowerCase();
  return (rawGender.contains('perempuan') || rawGender.contains('wanita'))
      ? 'Perempuan'
      : 'Laki-laki';
}

Object? _readInstituteId(Map json, String key) {
  final raw =
      json['institute_id'] ?? json['institution_id'] ?? json['institusi_id'];
  if (raw is int) return raw;
  if (raw is String) return int.tryParse(raw);
  if (json['institute'] is Map && json['institute']['id'] != null) {
    return int.tryParse(json['institute']['id'].toString());
  }
  if (json['institution'] is Map && json['institution']['id'] != null) {
    return int.tryParse(json['institution']['id'].toString());
  }
  return null;
}

Object? _readNamaInstitusi(Map json, String key) {
  final name = (json['institute_name'] ?? json['namaInstitusi'] ?? '')
      .toString();
  if (name.isNotEmpty) return name;
  if (json['institute'] is Map) {
    return (json['institute']['name'] ?? json['institute']['nama'] ?? '')
        .toString();
  }
  if (json['institution'] is Map) {
    return (json['institution']['name'] ?? json['institution']['nama'] ?? '')
        .toString();
  }
  return '';
}

Object? _readJabatanInstitusi(Map json, String key) =>
    (json['institute_position'] ??
            json['institution_position'] ??
            json['jabatan_institusi'] ??
            json['jabatanInstitusi'] ??
            '')
        .toString();

Object? _readAfiliasi(Map json, String key) =>
    (json['affiliations'] ??
            json['affiliation'] ??
            json['afiliasi'] ??
            'Politik')
        .toString();

Object? _readProfesi(Map json, String key) =>
    (json['professions'] ?? json['profession'] ?? json['profesi'] ?? 'Pejabat')
        .toString();

Object? _readOrganizationId(Map json, String key) {
  final raw = json['organization_id'] ?? json['organisasi_id'];
  if (raw is int) return raw;
  if (raw is String) return int.tryParse(raw);
  if (json['organization'] is Map && json['organization']['id'] != null) {
    return int.tryParse(json['organization']['id'].toString());
  }
  return null;
}

Object? _readNamaOrganisasi(Map json, String key) {
  final name = (json['organization_name'] ?? json['namaOrganisasi'] ?? '')
      .toString();
  if (name.isNotEmpty) return name;
  if (json['organization'] is Map) {
    return (json['organization']['name'] ?? json['organization']['nama'] ?? '')
        .toString();
  }
  return '';
}

Object? _readJabatanOrganisasi(Map json, String key) =>
    (json['organization_position'] ??
            json['jabatan_organisasi'] ??
            json['jabatanOrganisasi'] ??
            '')
        .toString();

Object? _readSuku(Map json, String key) =>
    (json['ethnic'] ?? json['suku'] ?? '').toString();

Object? _readWilayah(Map json, String key) =>
    (json['wilayah'] ?? json['scope'] ?? 'Nasional').toString();

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

Object? _readCurrentPage(Map json, String key) {
  final val = json['current_page'];
  if (val is int) return val;
  if (val is String) return int.tryParse(val) ?? 1;
  return 1;
}

Object? _readLastPage(Map json, String key) {
  final val = json['last_page'];
  if (val is int) return val;
  if (val is String) return int.tryParse(val) ?? 1;
  return 1;
}

Object? _readPerPage(Map json, String key) {
  final val = json['per_page'];
  if (val is int) return val;
  if (val is String) return int.tryParse(val) ?? 10;
  return 10;
}

Object? _readTotal(Map json, String key) {
  final val = json['total'];
  if (val is int) return val;
  if (val is String) return int.tryParse(val) ?? 0;
  return 0;
}

Object? _readDataList(Map json, String key) {
  final rawData = json['data'];
  if (rawData is List) {
    return rawData
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
  return [];
}

Object? _readMeta(Map json, String key) {
  if (json['meta'] is Map) {
    return json['meta'];
  } else if (json['current_page'] != null) {
    return json;
  }
  return null;
}

@freezed
abstract class TokohMetaModel with _$TokohMetaModel {
  const factory TokohMetaModel({
    @JsonKey(name: 'current_page', readValue: _readCurrentPage)
    @Default(1)
    int currentPage,
    @JsonKey(name: 'last_page', readValue: _readLastPage)
    @Default(1)
    int lastPage,
    @JsonKey(name: 'per_page', readValue: _readPerPage)
    @Default(10)
    int perPage,
    @JsonKey(name: 'total', readValue: _readTotal) @Default(0) int total,
  }) = _TokohMetaModel;

  factory TokohMetaModel.fromJson(Map<String, dynamic> json) =>
      _$TokohMetaModelFromJson(json);
}

@freezed
abstract class TokohResponseModel with _$TokohResponseModel {
  const TokohResponseModel._();

  const factory TokohResponseModel({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data', readValue: _readDataList)
    @Default([])
    List<TokohModel> data,
    @JsonKey(name: 'meta', readValue: _readMeta) TokohMetaModel? meta,
  }) = _TokohResponseModel;

  factory TokohResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TokohResponseModelFromJson(json);
}

@freezed
abstract class TokohModel with _$TokohModel {
  const TokohModel._();

  const factory TokohModel({
    @JsonKey(name: 'id', readValue: _readId) String? id,
    @JsonKey(name: 'name', readValue: _readNama) required String nama,
    @JsonKey(name: 'phone', readValue: _readNoTelp) @Default('') String noTelp,
    @JsonKey(name: 'gender', readValue: _readGender)
    @Default('Laki-laki')
    String jenisKelamin,
    @JsonKey(name: 'professions', readValue: _readProfesi)
    required String profesi,
    @JsonKey(name: 'wilayah', readValue: _readWilayah)
    @Default('Nasional')
    String wilayah,
    @JsonKey(name: 'institute_id', readValue: _readInstituteId)
    int? instituteId,
    @JsonKey(name: 'institute_name', readValue: _readNamaInstitusi)
    @Default('')
    String namaInstitusi,
    @JsonKey(name: 'institute_position', readValue: _readJabatanInstitusi)
    @Default('')
    String jabatanInstitusi,
    @JsonKey(name: 'affiliations', readValue: _readAfiliasi)
    required String afiliasi,
    @JsonKey(name: 'organization_id', readValue: _readOrganizationId)
    int? organizationId,
    @JsonKey(name: 'organization_name', readValue: _readNamaOrganisasi)
    @Default('')
    String namaOrganisasi,
    @JsonKey(name: 'organization_position', readValue: _readJabatanOrganisasi)
    @Default('')
    String jabatanOrganisasi,
    @JsonKey(name: 'ethnic', readValue: _readSuku) required String suku,
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
  }) = _TokohModel;

  factory TokohModel.fromJson(Map<String, dynamic> json) =>
      _$TokohModelFromJson(json);

  factory TokohModel.fromEntity(TokohEntity entity) => TokohModel(
    id: entity.id,
    nama: entity.nama,
    noTelp: entity.noTelp,
    jenisKelamin: entity.jenisKelamin,
    profesi: entity.profesi,
    wilayah: entity.wilayah,
    instituteId: entity.instituteId,
    namaInstitusi: entity.namaInstitusi,
    jabatanInstitusi: entity.jabatanInstitusi,
    afiliasi: entity.afiliasi,
    organizationId: entity.organizationId,
    namaOrganisasi: entity.namaOrganisasi,
    jabatanOrganisasi: entity.jabatanOrganisasi,
    suku: entity.suku,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  Map<String, dynamic> toApiJson() {
    String apiGender = 'laki_laki';
    final g = jenisKelamin
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    if (g.contains('perempuan') || g.contains('wanita')) {
      apiGender = 'perempuan';
    } else {
      apiGender = 'laki_laki';
    }

    return {
      'name': nama,
      'phone': noTelp,
      'gender': apiGender,
      'institute_id': instituteId ?? 0,
      'institute_position': jabatanInstitusi.trim(),
      'affiliations': afiliasi.trim(),
      'professions': profesi.trim(),
      'organization_id': organizationId ?? 0,
      'organization_position': jabatanOrganisasi.trim(),
      'ethnic': suku.trim(),
    };
  }
}
