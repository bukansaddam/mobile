import 'package:equatable/equatable.dart';

class InstitusiEntity extends Equatable {
  final String? id;
  final String nama;
  final String
  kategori; // Predefined admin category: 'Pemerintahan & Birokrasi', etc.
  final String
  scope; // Kelurahan, Kecamatan, Kabupaten/Kota, Provinsi, Nasional
  final String? alamat;
  final DateTime? createdAt;

  const InstitusiEntity({
    this.id,
    required this.nama,
    this.kategori = 'Pemerintahan & Birokrasi',
    required this.scope,
    this.alamat,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, nama, kategori, scope, alamat, createdAt];
}
