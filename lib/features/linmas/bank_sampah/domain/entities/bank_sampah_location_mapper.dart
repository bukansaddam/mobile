import 'package:akar/features/linmas/bank_sampah/data/models/bank_sampah_location_model.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';

export 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';

extension BankSampahLocationModelMapper on BankSampahLocationModel {
  BankSampahLocationEntity toDomain() {
    return BankSampahLocationEntity(
      id: id,
      nama: nama,
      alamat: alamat,
      kelurahan: kelurahan,
      pengelola: pengelola,
      kontak: kontak,
      latitude: latitude,
      longitude: longitude,
      latOffset: latOffset,
      lngOffset: lngOffset,
      distanceMeters: distanceMeters,
    );
  }
}

extension BankSampahLocationEntityMapper on BankSampahLocationEntity {
  BankSampahLocationModel toModel() {
    return BankSampahLocationModel(
      id: id,
      nama: nama,
      alamat: alamat,
      kelurahan: kelurahan,
      pengelola: pengelola,
      kontak: kontak,
      latitude: latitude,
      longitude: longitude,
      latOffset: latOffset,
      lngOffset: lngOffset,
      distanceMeters: distanceMeters,
    );
  }
}
