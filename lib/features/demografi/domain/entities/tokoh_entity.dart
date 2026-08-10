import 'package:equatable/equatable.dart';

class TokohEntity extends Equatable {
  final String? id;
  final String nama;
  final String noTelp;
  final String profesi;
  final String wilayah; // Scope: Nasional, Lokal
  final String afiliasi; // Politik, Ormas, Agama, Budaya, Pemuda, Pengusaha
  final String namaOrganisasi;
  final String suku;
  final DateTime? createdAt;

  const TokohEntity({
    this.id,
    required this.nama,
    this.noTelp = '',
    required this.profesi,
    required this.wilayah,
    required this.afiliasi,
    this.namaOrganisasi = '',
    required this.suku,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    nama,
    noTelp,
    profesi,
    wilayah,
    afiliasi,
    namaOrganisasi,
    suku,
    createdAt,
  ];
}
