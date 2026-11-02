import 'package:freezed_annotation/freezed_annotation.dart';

part 'ktp_ocr_model.freezed.dart';

@freezed
abstract class KtpOcrModel with _$KtpOcrModel {
  const factory KtpOcrModel({
    @Default('') String nik,
    @Default('') String name,
    @Default('') String birthPlace,
    @Default('') String birthDate,
    @Default('') String address,
  }) = _KtpOcrModel;

  /// Menerima respons bertingkat (`data.all_fields`) maupun flat.
  /// Juga mendukung struktur di mana field berada di `raw_texts` array.
  factory KtpOcrModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    // Cek apakah field tersedia di payload atau di raw_texts
    final fields = payload['all_fields'] is Map
        ? Map<String, dynamic>.from(payload['all_fields'] as Map)
        : payload;

    // Helper function to read field from fields map
    String readFromFields(String key) => (fields[key] ?? '').toString().trim();

    // Helper to extract value from raw_texts based on pattern matching
    String extractField(String pattern, String fallback) {
      final rawTexts = fields['raw_texts'];
      if (rawTexts is List) {
        for (final text in rawTexts) {
          if (text is String && text.contains(pattern)) {
            // Extract value after the pattern
            final parts = text.split(':');
            if (parts.length > 1) {
              return parts[1].trim();
            }
          }
        }
      }
      return fallback;
    }

    // Extract fields from fields map first, fallback to raw_texts
    final extractedNik = readFromFields('nik') != ''
        ? readFromFields('nik')
        : extractField('NIK', '');
    final extractedName = readFromFields('nama') != ''
        ? readFromFields('nama')
        : extractField('Nama', '');
    final extractedTempatLahir = readFromFields('tempat_lahir') != ''
        ? readFromFields('tempat_lahir')
        : extractField('Tempat/Tgl Lahir', '');
    final extractedTanggalLahir = readFromFields('tanggal_lahir') != ''
        ? readFromFields('tanggal_lahir')
        : extractField('Tgl Lahir', '');

    // Extract rt/rw
    final rt = readFromFields('rt') != ''
        ? readFromFields('rt')
        : extractField('RT/', '');
    final rw = readFromFields('rw') != ''
        ? readFromFields('rw')
        : extractField('RW/', '');
    final rtRw = rt.isNotEmpty || rw.isNotEmpty
        ? 'RT $rt/RW $rw'
        : readFromFields('rt_rw');

    // Parse ttl if needed
    String birthPlace = extractedTempatLahir;
    String birthDate = extractedTanggalLahir;
    if (birthPlace.isEmpty || birthDate.isEmpty) {
      final ttl = readFromFields('ttl').split(',');
      if (birthPlace.isEmpty && ttl.length > 1) birthPlace = ttl.first.trim();
      if (birthDate.isEmpty && ttl.length > 1) birthDate = ttl.last.trim();
    }

    return KtpOcrModel(
      nik: extractedNik.isNotEmpty
          ? extractedNik
          : (payload['nik'] ?? '').toString().trim(),
      name: extractedName,
      birthPlace: birthPlace,
      birthDate: birthDate,
      address: [
        readFromFields('alamat') != ''
            ? readFromFields('alamat')
            : extractField('Alamat', ''),
        rtRw,
        readFromFields('kel_desa') != ''
            ? readFromFields('kel_desa')
            : extractField('Kel/Desa', ''),
        readFromFields('kecamatan') != ''
            ? readFromFields('kecamatan')
            : extractField('Kecamatan', ''),
        readFromFields('kab_kota') != ''
            ? readFromFields('kab_kota')
            : extractField('Kota', ''),
        readFromFields('provinsi') != ''
            ? readFromFields('provinsi')
            : extractField('Provinsi', ''),
      ].where((part) => part.isNotEmpty).join(', '),
    );
  }
}
