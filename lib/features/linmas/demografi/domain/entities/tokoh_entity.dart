import 'package:equatable/equatable.dart';

class TokohEntity extends Equatable {
  final String? id;
  final String nama;
  final String noTelp;
  final String jenisKelamin; // Laki-laki, Perempuan
  final String profesi;
  final String wilayah; // Scope: Nasional, Lokal
  final String namaInstitusi;
  final String jabatanInstitusi;
  final String afiliasi; // Politik, Ormas, Agama, Budaya, Pemuda, Pengusaha
  final String namaOrganisasi;
  final String jabatanOrganisasi;
  final String suku;
  final DateTime? createdAt;

  const TokohEntity({
    this.id,
    required this.nama,
    this.noTelp = '',
    this.jenisKelamin = 'Laki-laki',
    required this.profesi,
    this.wilayah = 'Nasional',
    this.namaInstitusi = '',
    this.jabatanInstitusi = '',
    required this.afiliasi,
    this.namaOrganisasi = '',
    this.jabatanOrganisasi = '',
    required this.suku,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    nama,
    noTelp,
    jenisKelamin,
    profesi,
    wilayah,
    namaInstitusi,
    jabatanInstitusi,
    afiliasi,
    namaOrganisasi,
    jabatanOrganisasi,
    suku,
    createdAt,
  ];
}
