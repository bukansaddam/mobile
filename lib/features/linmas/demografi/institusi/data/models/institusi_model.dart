import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/institusi_entity.dart';

part 'institusi_model.freezed.dart';
part 'institusi_model.g.dart';

Object? _readId(Map json, String key) => json['id']?.toString();

Object? _readNama(Map json, String key) =>
    (json['name'] ?? json['nama'] ?? '').toString();

Object? _readScope(Map json, String key) {
  final val = (json['scope'] ?? 'Kelurahan').toString().trim();
  if (val.isEmpty) return 'Kelurahan';
  final lower = val.toLowerCase();
  if (lower == 'kabupaten_kota' || lower == 'kabupaten/kota') {
    return 'Kabupaten/Kota';
  }
  return val[0].toUpperCase() + val.substring(1);
}

Object? _readKategori(Map json, String key) {
  // 1. If category is an object/map: {"id": 16, "label": "Pendidikan & Akademik", ...}
  final cat = json['category'];
  if (cat is Map) {
    final label = cat['label'] ?? cat['name'] ?? cat['title'];
    if (label != null && label.toString().trim().isNotEmpty) {
      return label.toString().trim();
    }
  } else if (cat is String && cat.trim().isNotEmpty) {
    final s = cat.trim();
    if (s.startsWith('{') && s.contains('label:')) {
      final match = RegExp(r'label:\s*([^,}]+)').firstMatch(s);
      if (match != null && match.group(1) != null) {
        return match.group(1)!.trim();
      }
    }
    return s;
  }

  // 2. If direct 'label' is provided
  final directLabel = json['label'];
  if (directLabel is String && directLabel.trim().isNotEmpty) {
    return directLabel.trim();
  } else if (directLabel is Map) {
    final l = directLabel['label'] ?? directLabel['name'];
    if (l != null && l.toString().trim().isNotEmpty) {
      return l.toString().trim();
    }
  }

  // 3. If direct 'kategori' is provided
  final kat = json['kategori'];
  if (kat is Map) {
    final l = kat['label'] ?? kat['name'];
    if (l != null && l.toString().trim().isNotEmpty) {
      return l.toString().trim();
    }
  } else if (kat is String && kat.trim().isNotEmpty) {
    final s = kat.trim();
    if (s.startsWith('{') && s.contains('label:')) {
      final match = RegExp(r'label:\s*([^,}]+)').firstMatch(s);
      if (match != null && match.group(1) != null) {
        return match.group(1)!.trim();
      }
    }
    return s;
  }

  return 'Pemerintahan & Birokrasi';
}

Object? _readCategoryId(Map json, String key) {
  final direct = json['category_id'] ?? json['categoryId'];
  if (direct is int) return direct;
  if (direct is String) return int.tryParse(direct);

  final cat = json['category'];
  if (cat is Map) {
    final id = cat['id'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
  }
  return null;
}

Object? _readAlamat(Map json, String key) =>
    (json['institution_address'] ??
            json['address'] ??
            json['alamat'] ??
            json['secretariat_address'])
        as String?;

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
abstract class InstitusiRegionModel with _$InstitusiRegionModel {
  const InstitusiRegionModel._();

  const factory InstitusiRegionModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'code') String? code,
  }) = _InstitusiRegionModel;

  factory InstitusiRegionModel.fromJson(Map<String, dynamic> json) =>
      _$InstitusiRegionModelFromJson(json);

  factory InstitusiRegionModel.fromEntity(InstitusiRegionEntity entity) =>
      InstitusiRegionModel(id: entity.id, name: entity.name, code: entity.code);
}

@freezed
abstract class InstitusiMetaModel with _$InstitusiMetaModel {
  const factory InstitusiMetaModel({
    @JsonKey(name: 'current_page') @Default(1) int currentPage,
    @JsonKey(name: 'last_page') @Default(1) int lastPage,
    @JsonKey(name: 'per_page') @Default(10) int perPage,
    @JsonKey(name: 'total') @Default(0) int total,
  }) = _InstitusiMetaModel;

  factory InstitusiMetaModel.fromJson(Map<String, dynamic> json) =>
      _$InstitusiMetaModelFromJson(json);
}

@freezed
abstract class InstitusiResponseModel with _$InstitusiResponseModel {
  const InstitusiResponseModel._();

  const factory InstitusiResponseModel({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') @Default([]) List<InstitusiModel> data,
    @JsonKey(name: 'meta') InstitusiMetaModel? meta,
  }) = _InstitusiResponseModel;

  factory InstitusiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InstitusiResponseModelFromJson(json);
}

@freezed
abstract class InstitusiModel with _$InstitusiModel {
  const InstitusiModel._();

  const factory InstitusiModel({
    @JsonKey(name: 'id', readValue: _readId) String? id,
    @JsonKey(name: 'name', readValue: _readNama) required String nama,
    @JsonKey(name: 'scope', readValue: _readScope) required String scope,
    @JsonKey(name: 'category', readValue: _readKategori) String? kategori,
    @JsonKey(name: 'category_id', readValue: _readCategoryId) int? categoryId,
    @JsonKey(name: 'address', readValue: _readAlamat) String? alamat,
    @JsonKey(name: 'province_id') int? provinceId,
    @JsonKey(name: 'regency_id') int? regencyId,
    @JsonKey(name: 'district_id') int? districtId,
    @JsonKey(name: 'village_id') int? villageId,
    @JsonKey(name: 'figures_count') int? figuresCount,
    @JsonKey(name: 'province', readValue: _readRegion)
    InstitusiRegionModel? province,
    @JsonKey(name: 'regency', readValue: _readRegion)
    InstitusiRegionModel? regency,
    @JsonKey(name: 'district', readValue: _readRegion)
    InstitusiRegionModel? district,
    @JsonKey(name: 'village', readValue: _readRegion)
    InstitusiRegionModel? village,
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
  }) = _InstitusiModel;

  factory InstitusiModel.fromJson(Map<String, dynamic> json) =>
      _$InstitusiModelFromJson(json);

  factory InstitusiModel.fromEntity(InstitusiEntity entity) => InstitusiModel(
    id: entity.id,
    nama: entity.nama,
    scope: entity.scope,
    kategori: entity.kategori,
    categoryId: entity.categoryId,
    alamat: entity.alamat,
    provinceId: entity.provinceId,
    regencyId: entity.regencyId,
    districtId: entity.districtId,
    villageId: entity.villageId,
    figuresCount: entity.figuresCount,
    province: entity.province != null
        ? InstitusiRegionModel.fromEntity(entity.province!)
        : null,
    regency: entity.regency != null
        ? InstitusiRegionModel.fromEntity(entity.regency!)
        : null,
    district: entity.district != null
        ? InstitusiRegionModel.fromEntity(entity.district!)
        : null,
    village: entity.village != null
        ? InstitusiRegionModel.fromEntity(entity.village!)
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

  Map<String, dynamic> toApiJson() {
    String apiScope = scope.trim().toLowerCase();
    if (apiScope == 'kabupaten/kota' || apiScope == 'kabupaten_kota') {
      apiScope = 'kabupaten_kota';
    }
    return {
      'name': nama,
      'scope': apiScope,
      'category_id': categoryId ?? 0,
      'institution_address': alamat?.trim() ?? '',
    };
  }
}
