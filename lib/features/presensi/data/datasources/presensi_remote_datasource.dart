import '../models/presensi_model.dart';

abstract class PresensiRemoteDatasource {
  Future<PresensiDataModel> submitPresensi(PresensiDataModel model);
}

class PresensiRemoteDatasourceImpl implements PresensiRemoteDatasource {
  @override
  Future<PresensiDataModel> submitPresensi(PresensiDataModel model) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final generatedId =
        'PRS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    return PresensiDataModel(
      id: generatedId,
      userName: model.userName,
      address: model.address,
      kecamatan: model.kecamatan,
      kelurahan: model.kelurahan,
      rt: model.rt,
      rw: model.rw,
      latitude: model.latitude,
      longitude: model.longitude,
      timestamp: DateTime.now(),
      isSuccess: true,
    );
  }
}
