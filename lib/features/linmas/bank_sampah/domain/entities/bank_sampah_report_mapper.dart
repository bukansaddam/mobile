import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_report_model.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';

export 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';

extension BankSampahReportModelMapper on BankSampahReportModel {
  BankSampahReportEntity toDomain() {
    return BankSampahReportEntity(
      id: id,
      bankSampahId: bankSampahId,
      bankSampahNama: bankSampahNama,
      jenisSampah: jenisSampah,
      beratKg: beratKg,
      nilaiRupiah: nilaiRupiah,
      fotoPath: fotoPath,
      fotoUrl: fotoUrl,
      catatan: catatan,
      petugasNama: petugasNama,
      createdAt: createdAt,
    );
  }
}

extension BankSampahReportEntityMapper on BankSampahReportEntity {
  BankSampahReportModel toModel() {
    return BankSampahReportModel(
      id: id,
      bankSampahId: bankSampahId,
      bankSampahNama: bankSampahNama,
      jenisSampah: jenisSampah,
      beratKg: beratKg,
      nilaiRupiah: nilaiRupiah,
      fotoPath: fotoPath,
      fotoUrl: fotoUrl,
      catatan: catatan,
      petugasNama: petugasNama,
      createdAt: createdAt,
    );
  }
}
