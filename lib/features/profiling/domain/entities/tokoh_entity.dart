import 'package:equatable/equatable.dart';

class TokohEntity extends Equatable {
  final String? id;
  final String nama;
  final String noTelp;
  final String wilayah; // Lokal, Nasional
  final String afiliasi; // Politik, Agama, Suku, Pemuda
  final String namaOrganisasi;
  final DateTime? createdAt;

  const TokohEntity({
    this.id,
    required this.nama,
    required this.noTelp,
    required this.wilayah,
    required this.afiliasi,
    required this.namaOrganisasi,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    nama,
    noTelp,
    wilayah,
    afiliasi,
    namaOrganisasi,
    createdAt,
  ];
}
