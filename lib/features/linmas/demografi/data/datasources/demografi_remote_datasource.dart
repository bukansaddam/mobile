import '../models/tokoh_model.dart';
import '../models/institusi_model.dart';
import '../models/organisasi_model.dart';
import 'tokoh_mock_data.dart';
import 'institusi_mock_data.dart';
import 'organisasi_mock_data.dart';

abstract class DemografiRemoteDatasource {
  Future<List<TokohModel>> getTokohList();
  Future<TokohModel> addTokoh(TokohModel model);

  Future<List<InstitusiModel>> getInstitusiList();
  Future<InstitusiModel> addInstitusi(InstitusiModel model);

  Future<List<OrganisasiModel>> getOrganisasiList();
  Future<OrganisasiModel> addOrganisasi(OrganisasiModel model);
}

class DemografiRemoteDatasourceImpl implements DemografiRemoteDatasource {
  final List<TokohModel> _mockTokohData = rawTokohJsonList
      .map((json) => TokohModel.fromJson(json))
      .toList();

  final List<InstitusiModel> _mockInstitusiData = rawInstitusiJsonList
      .map((json) => InstitusiModel.fromJson(json))
      .toList();

  final List<OrganisasiModel> _mockOrganisasiData = rawOrganisasiJsonList
      .map((json) => OrganisasiModel.fromJson(json))
      .toList();

  // ------------------ Tokoh ------------------
  @override
  Future<List<TokohModel>> getTokohList() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockTokohData);
  }

  @override
  Future<TokohModel> addTokoh(TokohModel model) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newId = 'TKH-${(100 + _mockTokohData.length + 1)}';
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
    _mockTokohData.insert(0, newTokoh);
    return newTokoh;
  }

  // ------------------ Institusi ------------------
  @override
  Future<List<InstitusiModel>> getInstitusiList() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockInstitusiData);
  }

  @override
  Future<InstitusiModel> addInstitusi(InstitusiModel model) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newId = 'INS-${(100 + _mockInstitusiData.length + 1)}';
    final newInstitusi = InstitusiModel(
      id: newId,
      nama: model.nama,
      scope: model.scope,
      alamat: model.alamat,
      createdAt: DateTime.now(),
    );
    _mockInstitusiData.insert(0, newInstitusi);
    return newInstitusi;
  }

  // ------------------ Organisasi ------------------
  @override
  Future<List<OrganisasiModel>> getOrganisasiList() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockOrganisasiData);
  }

  @override
  Future<OrganisasiModel> addOrganisasi(OrganisasiModel model) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newId = 'ORG-${(100 + _mockOrganisasiData.length + 1)}';
    final newOrganisasi = OrganisasiModel(
      id: newId,
      nama: model.nama,
      jumlahAnggota: model.jumlahAnggota,
      bidang: model.bidang,
      alamatSekretariat: model.alamatSekretariat,
      createdAt: DateTime.now(),
    );
    _mockOrganisasiData.insert(0, newOrganisasi);
    return newOrganisasi;
  }
}
