import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:akar/core/constants/api_constants.dart';
import '../../domain/entities/bank_sampah_report_entity.dart';

part 'bank_sampah_report_model.freezed.dart';
part 'bank_sampah_report_model.g.dart';

Object? _readId(Map json, String key) => json['id']?.toString() ?? '';

Object? _readBankSampahId(Map json, String key) {
  if (json['bankSampahId'] != null) return json['bankSampahId'].toString();
  if (json['bank'] is Map && json['bank']['id'] != null) {
    return json['bank']['id'].toString();
  }
  return '';
}

Object? _readBankSampahNama(Map json, String key) {
  if (json['bankSampahNama'] != null) return json['bankSampahNama'].toString();
  if (json['bank'] is Map && json['bank']['name'] != null) {
    return json['bank']['name'].toString();
  }
  return '';
}

Object? _readBankSampahRegion(Map json, String key) {
  if (json['bankSampahRegion'] != null) {
    return json['bankSampahRegion'].toString();
  }
  if (json['bank'] is Map && json['bank']['region'] != null) {
    return json['bank']['region'].toString();
  }
  return '';
}

Object? _readJenisSampah(Map json, String key) {
  if (json['jenisSampah'] != null) return json['jenisSampah'].toString();
  if (json['wasteType'] is Map && json['wasteType']['name'] != null) {
    return json['wasteType']['name'].toString();
  }
  return 'Organik';
}

Object? _readBeratKg(Map json, String key) {
  final val = json['weight'] ?? json['weight_kg'] ?? json['beratKg'];
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

Object? _readNilaiRupiah(Map json, String key) {
  final val = json['value'] ?? json['total_pendapatan'] ?? json['nilaiRupiah'];
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0.0;
  return 0.0;
}

Object? _readStatus(Map json, String key) =>
    json['status']?.toString() ?? 'verified';

Object? _readStatusLabel(Map json, String key) =>
    json['statusLabel']?.toString() ?? 'Terverifikasi';

Object? _readFotoUrl(Map json, String key) {
  final raw =
      (json['photo_url'] ??
              json['photoUrl'] ??
              json['photo'] ??
              json['photo_path'])
          ?.toString();

  if (raw == null || raw.trim().isEmpty) return null;

  final trimmed = raw.trim();
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
    return cleanBase.isNotEmpty ? '$cleanBase/storage/$path' : '/storage/$path';
  }
}

Object? _readCatatan(Map json, String key) =>
    (json['notes'] ?? json['catatan'] ?? '').toString();

String _readCreatedAt(Map json, String key) {
  final raw = json['createdAt'];
  if (raw != null) {
    if (raw is DateTime) return raw.toIso8601String();
    return raw.toString();
  }
  final date = json['reportDate']?.toString();
  final time = json['time']?.toString();
  if (date != null && date.isNotEmpty) {
    if (time != null && time.isNotEmpty) {
      final formattedTime = time.length == 5 ? '$time:00' : time;
      return '${date}T$formattedTime';
    }
    return '${date}T00:00:00';
  }
  return DateTime.now().toIso8601String();
}

String _dateTimeToJson(DateTime date) => date.toIso8601String();

@freezed
abstract class BankSampahSummaryModel with _$BankSampahSummaryModel {
  const BankSampahSummaryModel._();

  const factory BankSampahSummaryModel({
    @JsonKey(name: 'total_kg') @Default(0.0) double totalKg,
    @JsonKey(name: 'total_pendapatan') @Default(0.0) double totalPendapatan,
    @JsonKey(name: 'total_setoran') @Default(0) int totalSetoran,
    @JsonKey(name: 'verified_kg') @Default(0.0) double verifiedKg,
    @JsonKey(name: 'verified_pendapatan')
    @Default(0.0)
    double verifiedPendapatan,
    @JsonKey(name: 'pending_kg') @Default(0.0) double pendingKg,
    @JsonKey(name: 'pending_pendapatan') @Default(0.0) double pendingPendapatan,
    @JsonKey(name: 'conversion_price_per_kg')
    @Default(5000.0)
    double conversionPricePerKg,
  }) = _BankSampahSummaryModel;

  factory BankSampahSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$BankSampahSummaryModelFromJson(json);

  BankSampahSummaryEntity toDomain() => BankSampahSummaryEntity(
    totalKg: totalKg,
    totalPendapatan: totalPendapatan,
    totalSetoran: totalSetoran,
    verifiedKg: verifiedKg,
    verifiedPendapatan: verifiedPendapatan,
    pendingKg: pendingKg,
    pendingPendapatan: pendingPendapatan,
    conversionPricePerKg: conversionPricePerKg,
  );
}

@freezed
abstract class BankSampahMetaModel with _$BankSampahMetaModel {
  const factory BankSampahMetaModel({
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'current_page') @Default(1) int currentPage,
    @JsonKey(name: 'per_page') @Default(20) int perPage,
    @JsonKey(name: 'last_page') @Default(1) int lastPage,
  }) = _BankSampahMetaModel;

  factory BankSampahMetaModel.fromJson(Map<String, dynamic> json) =>
      _$BankSampahMetaModelFromJson(json);
}

@freezed
abstract class BankSampahReportModel with _$BankSampahReportModel {
  const BankSampahReportModel._();

  const factory BankSampahReportModel({
    @JsonKey(name: 'id', readValue: _readId) required String id,
    @JsonKey(name: 'bankSampahId', readValue: _readBankSampahId)
    @Default('')
    String bankSampahId,
    @JsonKey(name: 'bankSampahNama', readValue: _readBankSampahNama)
    required String bankSampahNama,
    @JsonKey(name: 'bankSampahRegion', readValue: _readBankSampahRegion)
    @Default('')
    String bankSampahRegion,
    @JsonKey(name: 'jenisSampah', readValue: _readJenisSampah)
    required String jenisSampah,
    @JsonKey(name: 'beratKg', readValue: _readBeratKg) required double beratKg,
    @JsonKey(name: 'nilaiRupiah', readValue: _readNilaiRupiah)
    required double nilaiRupiah,
    @JsonKey(name: 'status', readValue: _readStatus)
    @Default('verified')
    String status,
    @JsonKey(name: 'statusLabel', readValue: _readStatusLabel)
    @Default('Terverifikasi')
    String statusLabel,
    @JsonKey(name: 'fotoPath') String? fotoPath,
    @JsonKey(name: 'fotoUrl', readValue: _readFotoUrl) String? fotoUrl,
    @JsonKey(name: 'catatan', readValue: _readCatatan)
    @Default('')
    String catatan,
    @JsonKey(name: 'petugasNama') @Default('') String petugasNama,
    @JsonKey(
      name: 'createdAt',
      readValue: _readCreatedAt,
      toJson: _dateTimeToJson,
    )
    required DateTime createdAt,
  }) = _BankSampahReportModel;

  factory BankSampahReportModel.fromJson(Map<String, dynamic> json) =>
      _$BankSampahReportModelFromJson(json);

  factory BankSampahReportModel.fromEntity(BankSampahReportEntity entity) =>
      BankSampahReportModel(
        id: entity.id,
        bankSampahId: entity.bankSampahId,
        bankSampahNama: entity.bankSampahNama,
        bankSampahRegion: entity.bankSampahRegion,
        jenisSampah: entity.jenisSampah,
        beratKg: entity.beratKg,
        nilaiRupiah: entity.nilaiRupiah,
        status: entity.status,
        statusLabel: entity.statusLabel,
        fotoPath: entity.fotoPath,
        fotoUrl: entity.fotoUrl,
        catatan: entity.catatan,
        petugasNama: entity.petugasNama,
        createdAt: entity.createdAt,
      );

  BankSampahReportEntity toDomain() => BankSampahReportEntity(
    id: id,
    bankSampahId: bankSampahId,
    bankSampahNama: bankSampahNama,
    bankSampahRegion: bankSampahRegion,
    jenisSampah: jenisSampah,
    beratKg: beratKg,
    nilaiRupiah: nilaiRupiah,
    status: status,
    statusLabel: statusLabel,
    fotoPath: fotoPath,
    fotoUrl: fotoUrl,
    catatan: catatan,
    petugasNama: petugasNama,
    createdAt: createdAt,
  );
}

@freezed
abstract class BankSampahMyDepositsResponseModel
    with _$BankSampahMyDepositsResponseModel {
  const BankSampahMyDepositsResponseModel._();

  const factory BankSampahMyDepositsResponseModel({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') @Default([]) List<BankSampahReportModel> data,
    @JsonKey(name: 'summary') BankSampahSummaryModel? summary,
    @JsonKey(name: 'meta') BankSampahMetaModel? meta,
  }) = _BankSampahMyDepositsResponseModel;

  factory BankSampahMyDepositsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$BankSampahMyDepositsResponseModelFromJson(json);

  BankSampahReportsDataEntity toDomain() => BankSampahReportsDataEntity(
    reports: data.map((e) => e.toDomain()).toList(),
    summary: summary?.toDomain(),
    total: meta?.total ?? data.length,
    currentPage: meta?.currentPage ?? 1,
    lastPage: meta?.lastPage ?? 1,
  );
}
