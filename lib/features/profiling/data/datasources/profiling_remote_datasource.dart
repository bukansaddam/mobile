import '../models/tokoh_model.dart';

abstract class ProfilingRemoteDatasource {
  Future<List<TokohModel>> getTokohList();
  Future<TokohModel> addTokoh(TokohModel model);
}

class ProfilingRemoteDatasourceImpl implements ProfilingRemoteDatasource {
  final List<TokohModel> _mockData = [
    TokohModel(
      id: 'TKH-001',
      nama: 'H. Ahmad Subardjo',
      noTelp: '081234567890',
      wilayah: 'Lokal',
      afiliasi: 'Agama',
      namaOrganisasi: 'Majelis Taklim Nurul Iman',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TokohModel(
      id: 'TKH-002',
      nama: 'Bambang Sudarsono, S.T.',
      noTelp: '085712345678',
      wilayah: 'Nasional',
      afiliasi: 'Politik',
      namaOrganisasi: 'DPC Partai Reformasi',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

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
      wilayah: model.wilayah,
      afiliasi: model.afiliasi,
      namaOrganisasi: model.namaOrganisasi,
      createdAt: DateTime.now(),
    );
    _mockData.insert(0, newTokoh);
    return newTokoh;
  }
}
