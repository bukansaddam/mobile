import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/bank_sampah_constants.dart';
import '../models/bank_sampah_location_model.dart';
import '../models/bank_sampah_report_model.dart';

abstract class BankSampahLocalDatasource {
  Future<List<BankSampahReportModel>> getReports();
  Future<BankSampahReportModel> addReport(BankSampahReportModel report);
  Future<bool> deleteReport(String id);
  Future<List<BankSampahLocationModel>> getLocations();
  Future<BankSampahLocationModel> addLocation(BankSampahLocationModel location);
}

class BankSampahLocalDatasourceImpl implements BankSampahLocalDatasource {
  static const String _keyReports = 'linmas_bank_sampah_reports_v2';
  static const String _keyLocations = 'linmas_bank_sampah_locations_v2';

  final SharedPreferences sharedPreferences;

  List<BankSampahReportModel>? _cachedReports;
  List<BankSampahLocationModel>? _cachedLocations;

  BankSampahLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<List<BankSampahLocationModel>> getLocations() async {
    if (_cachedLocations != null) {
      return List.from(_cachedLocations!);
    }

    final rawJson = sharedPreferences.getString(_keyLocations);
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
        _cachedLocations = decoded
            .map(
              (item) => BankSampahLocationModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
        return List.from(_cachedLocations!);
      } catch (_) {}
    }

    _cachedLocations = BankSampahConstants.defaultLocations
        .map((json) => BankSampahLocationModel.fromJson(json))
        .toList();
    await _saveLocationsToPrefs();
    return List.from(_cachedLocations!);
  }

  @override
  Future<BankSampahLocationModel> addLocation(
    BankSampahLocationModel location,
  ) async {
    await getLocations();
    final newId = location.id.isNotEmpty
        ? location.id
        : 'BS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final newLocation = BankSampahLocationModel(
      id: newId,
      nama: location.nama,
      alamat: location.alamat,
      kelurahan: location.kelurahan,
      pengelola: location.pengelola,
      kontak: location.kontak,
    );

    _cachedLocations!.insert(0, newLocation);
    await _saveLocationsToPrefs();
    return newLocation;
  }

  @override
  Future<List<BankSampahReportModel>> getReports() async {
    if (_cachedReports != null) {
      return List.from(_cachedReports!);
    }

    final rawJson = sharedPreferences.getString(_keyReports);
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
        _cachedReports = decoded
            .map(
              (item) =>
                  BankSampahReportModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return List.from(_cachedReports!);
      } catch (_) {}
    }

    _cachedReports = BankSampahConstants.defaultReports
        .map((json) => BankSampahReportModel.fromJson(json))
        .toList();
    await _saveReportsToPrefs();
    return List.from(_cachedReports!);
  }

  @override
  Future<BankSampahReportModel> addReport(BankSampahReportModel report) async {
    await getReports();
    final newId = report.id.isNotEmpty
        ? report.id
        : 'LBS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final newReport = BankSampahReportModel(
      id: newId,
      bankSampahId: report.bankSampahId,
      bankSampahNama: report.bankSampahNama,
      jenisSampah: report.jenisSampah,
      beratKg: report.beratKg,
      nilaiRupiah: report.nilaiRupiah,
      fotoPath: report.fotoPath,
      fotoUrl: report.fotoUrl,
      catatan: report.catatan,
      petugasNama: report.petugasNama,
      createdAt: report.createdAt,
    );

    _cachedReports!.insert(0, newReport);
    await _saveReportsToPrefs();
    return newReport;
  }

  @override
  Future<bool> deleteReport(String id) async {
    await getReports();
    _cachedReports!.removeWhere((item) => item.id == id);
    await _saveReportsToPrefs();
    return true;
  }

  Future<void> _saveReportsToPrefs() async {
    if (_cachedReports == null) return;
    final List<Map<String, dynamic>> rawList = _cachedReports!
        .map((item) => item.toJson())
        .toList();
    await sharedPreferences.setString(_keyReports, jsonEncode(rawList));
  }

  Future<void> _saveLocationsToPrefs() async {
    if (_cachedLocations == null) return;
    final List<Map<String, dynamic>> rawList = _cachedLocations!
        .map((item) => item.toJson())
        .toList();
    await sharedPreferences.setString(_keyLocations, jsonEncode(rawList));
  }
}
