import 'package:equatable/equatable.dart';

class InstitusiEntity extends Equatable {
  final String? id;
  final String nama;
  final String
  scope; // Kelurahan, Kecamatan, Kabupaten/Kota, Provinsi, Nasional
  final String? alamat;
  final DateTime? createdAt;

  const InstitusiEntity({
    this.id,
    required this.nama,
    required this.scope,
    this.alamat,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, nama, scope, alamat, createdAt];
}
