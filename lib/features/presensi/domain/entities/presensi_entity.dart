import 'package:equatable/equatable.dart';

class PresensiDataEntity extends Equatable {
  final String? id;
  final String userName;
  final String address;
  final String kecamatan;
  final String kelurahan;
  final String rt;
  final String rw;
  final double latitude;
  final double longitude;
  final DateTime? timestamp;
  final bool isSuccess;

  const PresensiDataEntity({
    this.id,
    required this.userName,
    required this.address,
    required this.kecamatan,
    required this.kelurahan,
    required this.rt,
    required this.rw,
    required this.latitude,
    required this.longitude,
    this.timestamp,
    this.isSuccess = false,
  });

  @override
  List<Object?> get props => [
        id,
        userName,
        address,
        kecamatan,
        kelurahan,
        rt,
        rw,
        latitude,
        longitude,
        timestamp,
        isSuccess,
      ];
}
