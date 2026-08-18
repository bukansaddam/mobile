import 'package:equatable/equatable.dart';

class BankSampahReportEntity extends Equatable {
  final String id;
  final String bankSampahId;
  final String bankSampahNama;
  final String jenisSampah;
  final double beratKg;
  final double nilaiRupiah;
  final String? fotoPath;
  final String? fotoUrl;
  final String catatan;
  final String petugasNama;
  final DateTime createdAt;

  const BankSampahReportEntity({
    required this.id,
    required this.bankSampahId,
    required this.bankSampahNama,
    required this.jenisSampah,
    required this.beratKg,
    required this.nilaiRupiah,
    this.fotoPath,
    this.fotoUrl,
    this.catatan = '',
    required this.petugasNama,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    bankSampahId,
    bankSampahNama,
    jenisSampah,
    beratKg,
    nilaiRupiah,
    fotoPath,
    fotoUrl,
    catatan,
    petugasNama,
    createdAt,
  ];
}
