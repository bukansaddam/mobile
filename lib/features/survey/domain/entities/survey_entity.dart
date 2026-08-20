import 'dart:convert';
import 'package:intl/intl.dart';

class SurveyEntity {
  final String id;
  final String period; // Format: "YYYY-MM", misal "2026-08"
  final String periodLabel; // Misal "Agustus 2026"
  final bool
  isMemilahSampah; // Q1: Apakah memilah sampah? (true = Sudah, false = Belum)
  final String tujuanSampahOrganik; // Q2: TPS, TPA, Dilokasi Sendiri
  final bool hasBankSampah; // Q3: Bank Sampah? (true = Sudah, false = Belum)
  final bool
  hasMesinPengolahOrganik; // Q4: Mesin Pengolah Organik? (true = Sudah, false = Belum)
  final bool
  hasAslinmas; // Q5: Anggota ASLINMAS? (true = Ada, false = Tidak Ada)
  final int? jumlahAnggotaAslinmas; // Input Jumlah jika hasAslinmas == true
  final bool hasRonda; // Q6: Masih ada ronda? (true = Ada, false = Tidak)
  final DateTime submittedAt;

  const SurveyEntity({
    required this.id,
    required this.period,
    required this.periodLabel,
    required this.isMemilahSampah,
    required this.tujuanSampahOrganik,
    required this.hasBankSampah,
    required this.hasMesinPengolahOrganik,
    required this.hasAslinmas,
    this.jumlahAnggotaAslinmas,
    required this.hasRonda,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'period': period,
      'periodLabel': periodLabel,
      'isMemilahSampah': isMemilahSampah,
      'tujuanSampahOrganik': tujuanSampahOrganik,
      'hasBankSampah': hasBankSampah,
      'hasMesinPengolahOrganik': hasMesinPengolahOrganik,
      'hasAslinmas': hasAslinmas,
      'jumlahAnggotaAslinmas': jumlahAnggotaAslinmas,
      'hasRonda': hasRonda,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory SurveyEntity.fromMap(Map<String, dynamic> map) {
    return SurveyEntity(
      id: map['id'] as String? ?? '',
      period: map['period'] as String? ?? '',
      periodLabel: map['periodLabel'] as String? ?? '',
      isMemilahSampah: map['isMemilahSampah'] as bool? ?? false,
      tujuanSampahOrganik: map['tujuanSampahOrganik'] as String? ?? 'TPS',
      hasBankSampah: map['hasBankSampah'] as bool? ?? false,
      hasMesinPengolahOrganik: map['hasMesinPengolahOrganik'] as bool? ?? false,
      hasAslinmas: map['hasAslinmas'] as bool? ?? false,
      jumlahAnggotaAslinmas: map['jumlahAnggotaAslinmas'] as int?,
      hasRonda: map['hasRonda'] as bool? ?? false,
      submittedAt: map['submittedAt'] != null
          ? DateTime.parse(map['submittedAt'] as String)
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SurveyEntity.fromJson(String source) =>
      SurveyEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  String get formattedSubmittedAt {
    try {
      return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(submittedAt);
    } catch (_) {
      return DateFormat('dd MMM yyyy, HH:mm').format(submittedAt);
    }
  }

  static String getCurrentPeriodKey([DateTime? date]) {
    final now = date ?? DateTime.now();
    return DateFormat('yyyy-MM').format(now);
  }

  static String getCurrentPeriodLabel([DateTime? date]) {
    final now = date ?? DateTime.now();
    try {
      return DateFormat('MMMM yyyy', 'id_ID').format(now);
    } catch (_) {
      return DateFormat('MMMM yyyy').format(now);
    }
  }
}
