import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:akar/core/constants/api_constants.dart';

part 'bank_sampah_report_entity.freezed.dart';

@freezed
abstract class BankSampahSummaryEntity with _$BankSampahSummaryEntity {
  const factory BankSampahSummaryEntity({
    @Default(0.0) double totalKg,
    @Default(0.0) double totalPendapatan,
    @Default(0) int totalSetoran,
    @Default(0.0) double verifiedKg,
    @Default(0.0) double verifiedPendapatan,
    @Default(0.0) double pendingKg,
    @Default(0.0) double pendingPendapatan,
    @Default(5000.0) double conversionPricePerKg,
  }) = _BankSampahSummaryEntity;
}

@freezed
abstract class BankSampahReportEntity with _$BankSampahReportEntity {
  const BankSampahReportEntity._();

  const factory BankSampahReportEntity({
    required String id,
    @Default('') String bankSampahId,
    required String bankSampahNama,
    @Default('') String bankSampahRegion,
    required String jenisSampah,
    required double beratKg,
    required double nilaiRupiah,
    @Default('verified') String status,
    @Default('Terverifikasi') String statusLabel,
    String? fotoPath,
    String? fotoUrl,
    @Default('') String catatan,
    @Default('') String petugasNama,
    required DateTime createdAt,
  }) = _BankSampahReportEntity;

  String? get displayPhotoUrl {
    if (fotoUrl == null || fotoUrl!.trim().isEmpty) return null;
    final trimmed = fotoUrl!.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    String cleanBase = '';
    try {
      cleanBase = ApiConstants.baseUrl;
      if (cleanBase.endsWith('/')) {
        cleanBase = cleanBase.substring(0, cleanBase.length - 1);
      }
    } catch (_) {
      cleanBase = '';
    }

    String path = trimmed;
    if (path.startsWith('public/')) {
      path = path.substring(7);
    } else if (path.startsWith('/public/')) {
      path = path.substring(8);
    }

    if (path.startsWith('/storage/')) {
      return cleanBase.isNotEmpty ? '$cleanBase$path' : path;
    } else if (path.startsWith('storage/')) {
      return cleanBase.isNotEmpty ? '$cleanBase/$path' : '/$path';
    } else if (path.startsWith('/')) {
      return cleanBase.isNotEmpty ? '$cleanBase/storage$path' : '/storage$path';
    } else {
      return cleanBase.isNotEmpty
          ? '$cleanBase/storage/$path'
          : '/storage/$path';
    }
  }
}

@freezed
abstract class BankSampahReportsDataEntity with _$BankSampahReportsDataEntity {
  const factory BankSampahReportsDataEntity({
    @Default([]) List<BankSampahReportEntity> reports,
    BankSampahSummaryEntity? summary,
    @Default(0) int total,
    @Default(1) int currentPage,
    @Default(1) int lastPage,
  }) = _BankSampahReportsDataEntity;
}
