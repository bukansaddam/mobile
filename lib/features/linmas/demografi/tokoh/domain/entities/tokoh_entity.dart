import 'package:freezed_annotation/freezed_annotation.dart';

part 'tokoh_entity.freezed.dart';

@freezed
abstract class TokohEntity with _$TokohEntity {
  const TokohEntity._();

  const factory TokohEntity({
    String? id,
    required String nama,
    @Default('') String noTelp,
    @Default('Laki-laki') String jenisKelamin,
    required String profesi,
    @Default('Nasional') String wilayah,
    int? instituteId,
    @Default('') String namaInstitusi,
    @Default('') String jabatanInstitusi,
    required String afiliasi,
    int? organizationId,
    @Default('') String namaOrganisasi,
    @Default('') String jabatanOrganisasi,
    required String suku,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TokohEntity;
}

@freezed
abstract class TokohPaginatedEntity with _$TokohPaginatedEntity {
  const factory TokohPaginatedEntity({
    @Default(false) bool success,
    @Default(0) int total,
    @Default(1) int currentPage,
    @Default(1) int lastPage,
    @Default(10) int perPage,
    @Default([]) List<TokohEntity> data,
    String? message,
  }) = _TokohPaginatedEntity;
}
