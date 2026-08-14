import 'package:equatable/equatable.dart';

class OrganisasiEntity extends Equatable {
  final String? id;
  final String nama;
  final int jumlahAnggota;
  final String
  bidang; // Usaha, Keagamaan, Politik, Kebudayaan, Kepemudaan, Lingkungan
  final String? alamatSekretariat;
  final DateTime? createdAt;

  const OrganisasiEntity({
    this.id,
    required this.nama,
    required this.jumlahAnggota,
    required this.bidang,
    this.alamatSekretariat,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    nama,
    jumlahAnggota,
    bidang,
    alamatSekretariat,
    createdAt,
  ];
}
