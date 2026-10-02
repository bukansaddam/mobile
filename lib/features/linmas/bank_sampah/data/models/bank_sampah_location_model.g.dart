// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_sampah_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BankSampahLocationModel _$BankSampahLocationModelFromJson(
  Map<String, dynamic> json,
) => _BankSampahLocationModel(
  id: _readId(json, 'id') as String,
  nama: _readNama(json, 'nama') as String,
  alamat: _readAlamat(json, 'alamat') as String,
  kelurahan: _readKelurahan(json, 'kelurahan') as String? ?? '',
  pengelola: _readPengelola(json, 'pengelola') as String? ?? '',
  kontak: _readKontak(json, 'kontak') as String? ?? '',
  latitude: (_readLatitude(json, 'latitude') as num?)?.toDouble(),
  longitude: (_readLongitude(json, 'longitude') as num?)?.toDouble(),
  latOffset: (_readLatOffset(json, 'latOffset') as num?)?.toDouble(),
  lngOffset: (_readLngOffset(json, 'lngOffset') as num?)?.toDouble(),
  distanceMeters: (_readDistanceMeters(json, 'distanceMeters') as num?)
      ?.toDouble(),
);

Map<String, dynamic> _$BankSampahLocationModelToJson(
  _BankSampahLocationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.nama,
  'alamat': instance.alamat,
  'kelurahan': instance.kelurahan,
  'pengelola': instance.pengelola,
  'kontak': instance.kontak,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'latOffset': instance.latOffset,
  'lngOffset': instance.lngOffset,
  'distanceMeters': instance.distanceMeters,
};
