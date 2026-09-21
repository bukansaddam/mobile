import 'package:freezed_annotation/freezed_annotation.dart';

part 'institusi_entity.freezed.dart';

@freezed
abstract class InstitusiRegionEntity with _$InstitusiRegionEntity {
  const factory InstitusiRegionEntity({int? id, String? name, String? code}) =
      _InstitusiRegionEntity;
}

@freezed
abstract class InstitusiEntity with _$InstitusiEntity {
  const InstitusiEntity._();

  const factory InstitusiEntity({
    String? id,
    required String nama,
    required String scope,
    String? kategori,
    int? categoryId,
    String? alamat,
    int? provinceId,
    int? regencyId,
    int? districtId,
    int? villageId,
    int? figuresCount,
    InstitusiRegionEntity? province,
    InstitusiRegionEntity? regency,
    InstitusiRegionEntity? district,
    InstitusiRegionEntity? village,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InstitusiEntity;

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

  String get displayKategori {
    if (kategori == null || kategori!.trim().isEmpty) return 'Institusi';
    final s = kategori!.trim();
    if (s.startsWith('{') && s.contains('label:')) {
      final match = RegExp(r'label:\s*([^,}]+)').firstMatch(s);
      if (match != null && match.group(1) != null) {
        return match.group(1)!.trim();
      }
    }
    return s;
  }

  String get displayScope {
    final s = scope.trim().toLowerCase();
    if (s == 'kabupaten_kota' || s == 'kabupaten/kota') {
      return 'Kabupaten/Kota';
    }
    if (scope.isEmpty) return 'Kelurahan';
    return scope[0].toUpperCase() + scope.substring(1);
  }
}

@freezed
abstract class InstitusiPaginatedEntity with _$InstitusiPaginatedEntity {
  const factory InstitusiPaginatedEntity({
    @Default(false) bool success,
    @Default(0) int total,
    @Default(1) int currentPage,
    @Default(1) int lastPage,
    @Default(10) int perPage,
    @Default([]) List<InstitusiEntity> data,
    String? message,
  }) = _InstitusiPaginatedEntity;
}
