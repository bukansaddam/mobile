import '../models/tokoh_model.dart';
import 'tokoh_mock_data.dart';

abstract class DemografiRemoteDatasource {
  Future<List<TokohModel>> getTokohList();
  Future<TokohModel> addTokoh(TokohModel model);
}

class DemografiRemoteDatasourceImpl implements DemografiRemoteDatasource {
  final List<TokohModel> _mockData = rawTokohJsonList
      .map((json) => TokohModel.fromJson(json))
      .toList();

  @override
  Future<List<TokohModel>> getTokohList() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockData);
  }

  @override
  Future<TokohModel> addTokoh(TokohModel model) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newId = 'TKH-${(100 + _mockData.length + 1)}';
    final newTokoh = TokohModel(
      id: newId,
      nama: model.nama,
      noTelp: model.noTelp,
      profesi: model.profesi,
      wilayah: model.wilayah,
      afiliasi: model.afiliasi,
      namaOrganisasi: model.namaOrganisasi,
      suku: model.suku,
      createdAt: DateTime.now(),
    );
    _mockData.insert(0, newTokoh);
    return newTokoh;
  }
}
