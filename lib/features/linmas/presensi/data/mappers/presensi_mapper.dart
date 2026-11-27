import 'package:akar/features/linmas/presensi/data/models/presensi_model.dart';
import 'package:akar/features/linmas/presensi/domain/entities/presensi_entity.dart';

export 'package:akar/features/linmas/presensi/domain/entities/presensi_entity.dart';

extension PresensiModelMapper on PresensiDataModel {
  PresensiDataEntity toDomain() {
    return PresensiDataEntity(
      id: id,
      userName: userName,
      address: address,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
      rt: rt,
      rw: rw,
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      isSuccess: isSuccess,
    );
  }
}

extension PresensiEntityMapper on PresensiDataEntity {
  PresensiDataModel toModel() {
    return PresensiDataModel(
      id: id,
      userName: userName,
      address: address,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
      rt: rt,
      rw: rw,
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      isSuccess: isSuccess,
    );
  }
}
