import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_sampah_location_entity.freezed.dart';

@freezed
abstract class BankSampahLocationEntity with _$BankSampahLocationEntity {
  const BankSampahLocationEntity._();

  const factory BankSampahLocationEntity({
    required String id,
    required String nama,
    required String alamat,
    @Default('') String kelurahan,
    @Default('') String pengelola,
    @Default('') String kontak,
    double? latitude,
    double? longitude,
    double? latOffset,
    double? lngOffset,
    double? distanceMeters,
  }) = _BankSampahLocationEntity;

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
}
