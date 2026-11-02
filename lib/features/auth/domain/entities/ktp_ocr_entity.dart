import 'package:freezed_annotation/freezed_annotation.dart';

part 'ktp_ocr_entity.freezed.dart';

@freezed
abstract class KtpOcrEntity with _$KtpOcrEntity {
  const factory KtpOcrEntity({
    @Default('') String nik,
    @Default('') String name,
    @Default('') String birthPlace,
    DateTime? birthDate,
    @Default('') String address,
  }) = _KtpOcrEntity;
}
