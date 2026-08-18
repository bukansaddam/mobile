import 'package:equatable/equatable.dart';

class BankSampahLocationEntity extends Equatable {
  final String id;
  final String nama;
  final String alamat;
  final String kelurahan;
  final String pengelola;
  final String kontak;
  final double? latitude;
  final double? longitude;
  final double? latOffset;
  final double? lngOffset;
  final double? distanceMeters;

  const BankSampahLocationEntity({
    required this.id,
    required this.nama,
    required this.alamat,
    this.kelurahan = '',
    this.pengelola = '',
    this.kontak = '',
    this.latitude,
    this.longitude,
    this.latOffset,
    this.lngOffset,
    this.distanceMeters,
  });

  BankSampahLocationEntity copyWith({
    String? id,
    String? nama,
    String? alamat,
    String? kelurahan,
    String? pengelola,
    String? kontak,
    double? latitude,
    double? longitude,
    double? latOffset,
    double? lngOffset,
    double? distanceMeters,
  }) {
    return BankSampahLocationEntity(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      kelurahan: kelurahan ?? this.kelurahan,
      pengelola: pengelola ?? this.pengelola,
      kontak: kontak ?? this.kontak,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      latOffset: latOffset ?? this.latOffset,
      lngOffset: lngOffset ?? this.lngOffset,
      distanceMeters: distanceMeters ?? this.distanceMeters,
    );
  }

  /// Format jarak yang mudah dibaca (misal: "250 m" atau "1.2 km")
  String get formattedDistance {
    if (distanceMeters == null) return '';
    if (distanceMeters! < 1000) {
      return '${distanceMeters!.round()} m';
    } else {
      final inKm = distanceMeters! / 1000;
      return '${inKm.toStringAsFixed(1)} km';
    }
  }

  @override
  List<Object?> get props => [
    id,
    nama,
    alamat,
    kelurahan,
    pengelola,
    kontak,
    latitude,
    longitude,
    latOffset,
    lngOffset,
    distanceMeters,
  ];
}
