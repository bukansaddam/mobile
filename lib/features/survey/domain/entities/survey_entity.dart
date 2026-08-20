import 'dart:convert';
import 'package:intl/intl.dart';

enum DynamicQuestionType {
  singleChoice,
  multipleChoice,
  booleanChoice,
  textInput,
  numberInput,
}

class DynamicQuestionEntity {
  final String id;
  final String question;
  final DynamicQuestionType type;
  final List<String> options;
  final bool isRequired;

  const DynamicQuestionEntity({
    required this.id,
    required this.question,
    required this.type,
    this.options = const [],
    this.isRequired = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'type': type.name,
      'options': options,
      'isRequired': isRequired,
    };
  }

  factory DynamicQuestionEntity.fromMap(Map<String, dynamic> map) {
    return DynamicQuestionEntity(
      id: map['id'] as String? ?? '',
      question: map['question'] as String? ?? '',
      type: DynamicQuestionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => DynamicQuestionType.singleChoice,
      ),
      options:
          (map['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isRequired: map['isRequired'] as bool? ?? true,
    );
  }
}

class MonthlySurveyFormEntity {
  final String id;
  final String title;
  final String description;
  final String period; // Format: YYYY-MM
  final String periodLabel;
  final List<DynamicQuestionEntity> questions;

  const MonthlySurveyFormEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.period,
    required this.periodLabel,
    required this.questions,
  });
}

class DynamicSurveyResponseItem {
  final String questionId;
  final String questionText;
  final dynamic answer;

  const DynamicSurveyResponseItem({
    required this.questionId,
    required this.questionText,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'answer': answer,
    };
  }

  factory DynamicSurveyResponseItem.fromMap(Map<String, dynamic> map) {
    return DynamicSurveyResponseItem(
      questionId: map['questionId'] as String? ?? '',
      questionText: map['questionText'] as String? ?? '',
      answer: map['answer'],
    );
  }
}

class DynamicMonthlySurveyEntity {
  final String id;
  final String period;
  final String periodLabel;
  final List<DynamicSurveyResponseItem> responses;
  final DateTime submittedAt;

  const DynamicMonthlySurveyEntity({
    required this.id,
    required this.period,
    required this.periodLabel,
    required this.responses,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'period': period,
      'periodLabel': periodLabel,
      'responses': responses.map((e) => e.toMap()).toList(),
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory DynamicMonthlySurveyEntity.fromMap(Map<String, dynamic> map) {
    return DynamicMonthlySurveyEntity(
      id: map['id'] as String? ?? '',
      period: map['period'] as String? ?? '',
      periodLabel: map['periodLabel'] as String? ?? '',
      responses:
          (map['responses'] as List<dynamic>?)
              ?.map(
                (e) => DynamicSurveyResponseItem.fromMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      submittedAt: map['submittedAt'] != null
          ? DateTime.parse(map['submittedAt'] as String)
          : DateTime.now(),
    );
  }
}

class InitialSurveyEntity {
  final String id;
  final bool isMemilahSampah;
  final String tujuanSampahOrganik;
  final bool hasBankSampah;
  final bool hasMesinPengolahOrganik;
  final bool hasAslinmas;
  final int? jumlahAnggotaAslinmas;
  final bool hasRonda;
  final DateTime submittedAt;

  const InitialSurveyEntity({
    required this.id,
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

  factory InitialSurveyEntity.fromMap(Map<String, dynamic> map) {
    return InitialSurveyEntity(
      id: map['id'] as String? ?? '',
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
}

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
