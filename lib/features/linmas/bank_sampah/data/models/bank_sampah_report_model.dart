import '../../domain/entities/bank_sampah_report_entity.dart';

class BankSampahReportModel extends BankSampahReportEntity {
  const BankSampahReportModel({
    required super.id,
    required super.bankSampahId,
    required super.bankSampahNama,
    required super.jenisSampah,
    required super.beratKg,
    required super.nilaiRupiah,
    super.fotoPath,
    super.fotoUrl,
    super.catatan = '',
    required super.petugasNama,
    required super.createdAt,
  });

  factory BankSampahReportModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['createdAt'] is String) {
      parsedDate =
          DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final rawJenis = json['jenisSampah'] as String? ?? 'Organik';
    final normalizedJenis = rawJenis.toLowerCase() == 'organik'
        ? 'Organik'
        : 'Anorganik';

    return BankSampahReportModel(
      id: json['id'] as String? ?? '',
      bankSampahId: json['bankSampahId'] as String? ?? '',
      bankSampahNama: json['bankSampahNama'] as String? ?? '',
      jenisSampah: normalizedJenis,
      beratKg: (json['beratKg'] as num?)?.toDouble() ?? 0.0,
      nilaiRupiah: (json['nilaiRupiah'] as num?)?.toDouble() ?? 0.0,
      fotoPath: json['fotoPath'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
      catatan: json['catatan'] as String? ?? '',
      petugasNama: json['petugasNama'] as String? ?? 'Petugas Linmas',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankSampahId': bankSampahId,
      'bankSampahNama': bankSampahNama,
      'jenisSampah': jenisSampah,
      'beratKg': beratKg,
      'nilaiRupiah': nilaiRupiah,
      'fotoPath': fotoPath,
      'fotoUrl': fotoUrl,
      'catatan': catatan,
      'petugasNama': petugasNama,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BankSampahReportModel.fromEntity(BankSampahReportEntity entity) {
    return BankSampahReportModel(
      id: entity.id,
      bankSampahId: entity.bankSampahId,
      bankSampahNama: entity.bankSampahNama,
      jenisSampah: entity.jenisSampah,
      beratKg: entity.beratKg,
      nilaiRupiah: entity.nilaiRupiah,
      fotoPath: entity.fotoPath,
      fotoUrl: entity.fotoUrl,
      catatan: entity.catatan,
      petugasNama: entity.petugasNama,
      createdAt: entity.createdAt,
    );
  }
}
