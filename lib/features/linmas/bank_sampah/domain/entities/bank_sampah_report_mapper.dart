import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_report_model.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';

export 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';

extension BankSampahReportModelMapper on BankSampahReportModel {
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

extension BankSampahReportEntityMapper on BankSampahReportEntity {
  BankSampahReportModel toModel() => BankSampahReportModel.fromEntity(this);
}

extension BankSampahResponseModelMapper on BankSampahMyDepositsResponseModel {
  BankSampahPaginatedEntity toDomain() => BankSampahPaginatedEntity(
    success: success,
    message: message,
    data: data.map((e) => e.toDomain()).toList(),
    summary: summary?.toDomain(),
    total: meta?.total ?? data.length,
    currentPage: meta?.currentPage ?? 1,
    lastPage: meta?.lastPage ?? 1,
    perPage: meta?.perPage ?? 10,
  );
}
