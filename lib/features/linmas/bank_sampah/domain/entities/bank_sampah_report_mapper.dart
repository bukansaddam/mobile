import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_report_model.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';

export 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';

extension BankSampahReportEntityMapper on BankSampahReportEntity {
  BankSampahReportModel toModel() => BankSampahReportModel.fromEntity(this);
}
