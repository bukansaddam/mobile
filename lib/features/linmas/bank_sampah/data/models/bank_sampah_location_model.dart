import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/bank_sampah_location_entity.dart';

part 'bank_sampah_location_model.freezed.dart';
part 'bank_sampah_location_model.g.dart';

Object? _readId(Map json, String key) => json['id']?.toString() ?? '';

Object? _readNama(Map json, String key) =>
    (json['nama'] ?? json['name'] ?? '').toString();

Object? _readAlamat(Map json, String key) {
  String alamat = (json['alamat'] ?? json['address'] ?? '').toString();
  if (alamat.isEmpty) {
    final parts = [
      json['villageName']?.toString(),
      json['districtName']?.toString(),
      json['regencyName']?.toString(),
    ].where((s) => s != null && s.isNotEmpty).toList();
    if (parts.isNotEmpty) {
      alamat = parts.join(', ');
    }
  }
  return alamat;
}

Object? _readKelurahan(Map json, String key) =>
    (json['kelurahan'] ?? json['villageName'] ?? '').toString();

Object? _readPengelola(Map json, String key) =>
    (json['pengelola'] ?? json['manager'] ?? '').toString();

Object? _readKontak(Map json, String key) =>
    (json['kontak'] ?? json['phone'] ?? '').toString();

double? _parseDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

Object? _readLatitude(Map json, String key) =>
    _parseDouble(json['latitude'] ?? json['lat']);

Object? _readLongitude(Map json, String key) =>
    _parseDouble(json['longitude'] ?? json['lng']);

Object? _readLatOffset(Map json, String key) =>
    _parseDouble(json['latOffset']);

Object? _readLngOffset(Map json, String key) =>
    _parseDouble(json['lngOffset']);

Object? _readDistanceMeters(Map json, String key) =>
    _parseDouble(json['distanceMeters']);

@freezed
abstract class BankSampahLocationModel with _$BankSampahLocationModel {
  const BankSampahLocationModel._();

  const factory BankSampahLocationModel({
    @JsonKey(name: 'id', readValue: _readId) required String id,
    @JsonKey(name: 'nama', readValue: _readNama) required String nama,
    @JsonKey(name: 'alamat', readValue: _readAlamat) required String alamat,
    @JsonKey(name: 'kelurahan', readValue: _readKelurahan)
    @Default('')
    String kelurahan,
    @JsonKey(name: 'pengelola', readValue: _readPengelola)
    @Default('')
    String pengelola,
    @JsonKey(name: 'kontak', readValue: _readKontak)
    @Default('')
    String kontak,
    @JsonKey(name: 'latitude', readValue: _readLatitude) double? latitude,
    @JsonKey(name: 'longitude', readValue: _readLongitude) double? longitude,
    @JsonKey(name: 'latOffset', readValue: _readLatOffset) double? latOffset,
    @JsonKey(name: 'lngOffset', readValue: _readLngOffset) double? lngOffset,
    @JsonKey(name: 'distanceMeters', readValue: _readDistanceMeters)
    double? distanceMeters,
  }) = _BankSampahLocationModel;

  factory BankSampahLocationModel.fromJson(Map<String, dynamic> json) =>
      _$BankSampahLocationModelFromJson(json);

  factory BankSampahLocationModel.fromEntity(BankSampahLocationEntity entity) =>
      BankSampahLocationModel(
        id: entity.id,
        nama: entity.nama,
        alamat: entity.alamat,
        kelurahan: entity.kelurahan,
        pengelola: entity.pengelola,
        kontak: entity.kontak,
        latitude: entity.latitude,
        longitude: entity.longitude,
        latOffset: entity.latOffset,
        lngOffset: entity.lngOffset,
        distanceMeters: entity.distanceMeters,
      );

  Map<String, dynamic> toApiJson() => {
    'id': id,
    'name': nama,
    'address': alamat,
    'kelurahan': kelurahan,
    'manager': pengelola,
    'phone': kontak,
    'latitude': latitude,
    'longitude': longitude,
  };
}
