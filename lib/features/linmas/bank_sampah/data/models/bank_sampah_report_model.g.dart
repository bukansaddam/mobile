// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_sampah_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BankSampahSummaryModel _$BankSampahSummaryModelFromJson(
  Map<String, dynamic> json,
) => _BankSampahSummaryModel(
  totalKg: (json['total_kg'] as num?)?.toDouble() ?? 0.0,
  totalPendapatan: (json['total_pendapatan'] as num?)?.toDouble() ?? 0.0,
  totalSetoran: (json['total_setoran'] as num?)?.toInt() ?? 0,
  verifiedKg: (json['verified_kg'] as num?)?.toDouble() ?? 0.0,
  verifiedPendapatan: (json['verified_pendapatan'] as num?)?.toDouble() ?? 0.0,
  pendingKg: (json['pending_kg'] as num?)?.toDouble() ?? 0.0,
  pendingPendapatan: (json['pending_pendapatan'] as num?)?.toDouble() ?? 0.0,
  conversionPricePerKg:
      (json['conversion_price_per_kg'] as num?)?.toDouble() ?? 5000.0,
);

Map<String, dynamic> _$BankSampahSummaryModelToJson(
  _BankSampahSummaryModel instance,
) => <String, dynamic>{
  'total_kg': instance.totalKg,
  'total_pendapatan': instance.totalPendapatan,
  'total_setoran': instance.totalSetoran,
  'verified_kg': instance.verifiedKg,
  'verified_pendapatan': instance.verifiedPendapatan,
  'pending_kg': instance.pendingKg,
  'pending_pendapatan': instance.pendingPendapatan,
  'conversion_price_per_kg': instance.conversionPricePerKg,
};

_BankSampahMetaModel _$BankSampahMetaModelFromJson(Map<String, dynamic> json) =>
    _BankSampahMetaModel(
      total: (json['total'] as num?)?.toInt() ?? 0,
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$BankSampahMetaModelToJson(
  _BankSampahMetaModel instance,
) => <String, dynamic>{
  'total': instance.total,
  'current_page': instance.currentPage,
  'per_page': instance.perPage,
  'last_page': instance.lastPage,
};

_BankSampahReportModel _$BankSampahReportModelFromJson(
  Map<String, dynamic> json,
) => _BankSampahReportModel(
  id: _readId(json, 'id') as String,
  bankSampahId: _readBankSampahId(json, 'bankSampahId') as String? ?? '',
  bankSampahNama: _readBankSampahNama(json, 'bankSampahNama') as String,
  bankSampahRegion:
      _readBankSampahRegion(json, 'bankSampahRegion') as String? ?? '',
  jenisSampah: _readJenisSampah(json, 'jenisSampah') as String,
  beratKg: (_readBeratKg(json, 'beratKg') as num).toDouble(),
  nilaiRupiah: (_readNilaiRupiah(json, 'nilaiRupiah') as num).toDouble(),
  status: _readStatus(json, 'status') as String? ?? 'verified',
  statusLabel:
      _readStatusLabel(json, 'statusLabel') as String? ?? 'Terverifikasi',
  fotoPath: json['fotoPath'] as String?,
  fotoUrl: _readFotoUrl(json, 'fotoUrl') as String?,
  catatan: _readCatatan(json, 'catatan') as String? ?? '',
  petugasNama: json['petugasNama'] as String? ?? '',
  createdAt: DateTime.parse(_readCreatedAt(json, 'createdAt') as String),
);

Map<String, dynamic> _$BankSampahReportModelToJson(
  _BankSampahReportModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'bankSampahId': instance.bankSampahId,
  'bankSampahNama': instance.bankSampahNama,
  'bankSampahRegion': instance.bankSampahRegion,
  'jenisSampah': instance.jenisSampah,
  'beratKg': instance.beratKg,
  'nilaiRupiah': instance.nilaiRupiah,
  'status': instance.status,
  'statusLabel': instance.statusLabel,
  'fotoPath': instance.fotoPath,
  'fotoUrl': instance.fotoUrl,
  'catatan': instance.catatan,
  'petugasNama': instance.petugasNama,
  'createdAt': _dateTimeToJson(instance.createdAt),
};

_BankSampahMyDepositsResponseModel _$BankSampahMyDepositsResponseModelFromJson(
  Map<String, dynamic> json,
) => _BankSampahMyDepositsResponseModel(
  success: json['success'] as bool? ?? false,
  message: json['message'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => BankSampahReportModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  summary: json['summary'] == null
      ? null
      : BankSampahSummaryModel.fromJson(
          json['summary'] as Map<String, dynamic>,
        ),
  meta: json['meta'] == null
      ? null
      : BankSampahMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BankSampahMyDepositsResponseModelToJson(
  _BankSampahMyDepositsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'summary': instance.summary,
  'meta': instance.meta,
};
