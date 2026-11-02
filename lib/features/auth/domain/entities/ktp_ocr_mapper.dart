import 'package:akar/features/auth/data/models/ktp_ocr_model.dart';
import 'package:akar/features/auth/domain/entities/ktp_ocr_entity.dart';
import 'package:intl/intl.dart';

const _birthDateFormats = [
  'yyyy-MM-dd',
  'dd-MM-yyyy',
  'dd/MM/yyyy',
  'd-M-yyyy',
];

DateTime? _parseBirthDate(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return null;
  for (final pattern in _birthDateFormats) {
    try {
      return DateFormat(pattern).parseStrict(value);
    } on FormatException {
      continue;
    }
  }
  return null;
}

extension KtpOcrModelMapper on KtpOcrModel {
  KtpOcrEntity toDomain() => KtpOcrEntity(
    nik: nik,
    name: name,
    birthPlace: birthPlace,
    birthDate: _parseBirthDate(birthDate),
    address: address,
  );
}
