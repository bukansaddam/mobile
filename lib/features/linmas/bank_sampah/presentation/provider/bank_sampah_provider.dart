import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/bank_sampah_constants.dart';
import '../../domain/entities/bank_sampah_location_entity.dart';
import '../../domain/entities/bank_sampah_report_entity.dart';
import '../../domain/usecases/add_bank_sampah_location_usecase.dart';
import '../../domain/usecases/add_bank_sampah_report_usecase.dart';
import '../../domain/usecases/delete_bank_sampah_report_usecase.dart';
import '../../domain/usecases/get_bank_sampah_locations_usecase.dart';
import '../../domain/usecases/get_bank_sampah_reports_usecase.dart';

enum BankSampahSortOption {
  terbaru('Terbaru', Icons.schedule_rounded),
  terlama('Terlama', Icons.history_rounded),
  bobotTerbanyak('Bobot Terbanyak', Icons.arrow_upward_rounded),
  bobotTersedikit('Bobot Tersedikit', Icons.arrow_downward_rounded),
  nilaiTertinggi('Nilai Tertinggi', Icons.payments_rounded);

  final String label;
  final IconData icon;
  const BankSampahSortOption(this.label, this.icon);
}

class BankSampahProvider extends ChangeNotifier {
  final GetBankSampahReportsUsecase getReportsUsecase;
  final AddBankSampahReportUsecase addReportUsecase;
  final DeleteBankSampahReportUsecase deleteReportUsecase;
  final GetBankSampahLocationsUsecase getLocationsUsecase;
  final AddBankSampahLocationUsecase addLocationUsecase;

  BankSampahProvider({
    required this.getReportsUsecase,
    required this.addReportUsecase,
    required this.deleteReportUsecase,
    required this.getLocationsUsecase,
    required this.addLocationUsecase,
  }) {
    fetchInitialData();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  bool _isFetchingLocation = false;
  bool get isFetchingLocation => _isFetchingLocation;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<BankSampahReportEntity> _reports = [];
  List<BankSampahReportEntity> get reports => _reports;

  List<BankSampahLocationEntity> _locations = [];
  List<BankSampahLocationEntity> get locations => _locations;

  double? _userLatitude;
  double? get userLatitude => _userLatitude;

  double? _userLongitude;
  double? get userLongitude => _userLongitude;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _selectedJenisSampahFilter;
  String? get selectedJenisSampahFilter => _selectedJenisSampahFilter;

  String? _selectedBankSampahFilter;
  String? get selectedBankSampahFilter => _selectedBankSampahFilter;

  BankSampahSortOption _selectedSortOption = BankSampahSortOption.terbaru;
  BankSampahSortOption get selectedSortOption => _selectedSortOption;

  bool get hasActiveFilter =>
      _selectedJenisSampahFilter != null ||
      _selectedBankSampahFilter != null ||
      _selectedSortOption != BankSampahSortOption.terbaru;

  Future<void> fetchInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.wait([_fetchReportsInternal(), _fetchLocationsInternal()]);

    await updateDistancesWithCurrentLocation(silent: true);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future.wait([_fetchReportsInternal(), _fetchLocationsInternal()]);
    await updateDistancesWithCurrentLocation(silent: true);
    notifyListeners();
  }

  Future<void> _fetchReportsInternal() async {
    final result = await getReportsUsecase();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (data) {
        _reports = data;
      },
    );
  }

  Future<void> _fetchLocationsInternal() async {
    final result = await getLocationsUsecase();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (data) {
        _locations = List<BankSampahLocationEntity>.from(data);
      },
    );
  }

  Future<void> updateDistancesWithCurrentLocation({bool silent = false}) async {
    if (!silent) {
      _isFetchingLocation = true;
      notifyListeners();
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _applyDefaultDistances();
        _isFetchingLocation = false;
        if (!silent) notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _applyDefaultDistances();
          _isFetchingLocation = false;
          if (!silent) notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _applyDefaultDistances();
        _isFetchingLocation = false;
        if (!silent) notifyListeners();
        return;
      }

      Position? pos = await Geolocator.getLastKnownPosition();
      pos ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      _userLatitude = pos.latitude;
      _userLongitude = pos.longitude;

      _calculateDistances(_userLatitude!, _userLongitude!);
    } catch (_) {
      _applyDefaultDistances();
    } finally {
      _isFetchingLocation = false;
      if (!silent) notifyListeners();
    }
  }

  void _calculateDistances(double userLat, double userLng) {
    final list = _locations.map<BankSampahLocationEntity>((loc) {
      double targetLat = loc.latitude ?? (userLat + (loc.latOffset ?? 0.002));
      double targetLng = loc.longitude ?? (userLng + (loc.lngOffset ?? 0.002));

      final distance = Geolocator.distanceBetween(
        userLat,
        userLng,
        targetLat,
        targetLng,
      );

      return loc.copyWith(distanceMeters: distance);
    }).toList();

    list.sort((a, b) {
      final distA = a.distanceMeters ?? double.infinity;
      final distB = b.distanceMeters ?? double.infinity;
      return distA.compareTo(distB);
    });

    _locations = list;
  }

  void _applyDefaultDistances() {
    const defaultMeters = [350.0, 750.0, 1200.0, 1800.0, 2600.0];
    final updatedList = <BankSampahLocationEntity>[];
    for (int i = 0; i < _locations.length; i++) {
      final loc = _locations[i];
      if (loc.distanceMeters == null) {
        final dist = i < defaultMeters.length
            ? defaultMeters[i]
            : (3000.0 + (i * 500));
        updatedList.add(loc.copyWith(distanceMeters: dist));
      } else {
        updatedList.add(loc);
      }
    }

    updatedList.sort((a, b) {
      final distA = a.distanceMeters ?? double.infinity;
      final distB = b.distanceMeters ?? double.infinity;
      return distA.compareTo(distB);
    });

    _locations = updatedList;
  }

  BankSampahLocationEntity? get nearestLocation {
    if (_locations.isEmpty) return null;
    return _locations.first;
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setSelectedJenisSampahFilter(String? jenis) {
    _selectedJenisSampahFilter = jenis;
    notifyListeners();
  }

  void setSelectedBankSampahFilter(String? bankSampahNama) {
    _selectedBankSampahFilter = bankSampahNama;
    notifyListeners();
  }

  void setSortOption(BankSampahSortOption sortOption) {
    _selectedSortOption = sortOption;
    notifyListeners();
  }

  void resetAllFilters() {
    _selectedJenisSampahFilter = null;
    _selectedBankSampahFilter = null;
    _selectedSortOption = BankSampahSortOption.terbaru;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    resetAllFilters();
  }

  List<BankSampahReportEntity> get filteredReports {
    final list = _reports.where((report) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          report.bankSampahNama.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          report.jenisSampah.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          report.catatan.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report.petugasNama.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesJenis =
          _selectedJenisSampahFilter == null ||
          _selectedJenisSampahFilter!.isEmpty ||
          report.jenisSampah.toLowerCase() ==
              _selectedJenisSampahFilter!.toLowerCase();

      final matchesBankSampah =
          _selectedBankSampahFilter == null ||
          _selectedBankSampahFilter!.isEmpty ||
          report.bankSampahNama.toLowerCase() ==
              _selectedBankSampahFilter!.toLowerCase();

      return matchesSearch && matchesJenis && matchesBankSampah;
    }).toList();

    switch (_selectedSortOption) {
      case BankSampahSortOption.terbaru:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case BankSampahSortOption.terlama:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case BankSampahSortOption.bobotTerbanyak:
        list.sort((a, b) => b.beratKg.compareTo(a.beratKg));
        break;
      case BankSampahSortOption.bobotTersedikit:
        list.sort((a, b) => a.beratKg.compareTo(b.beratKg));
        break;
      case BankSampahSortOption.nilaiTertinggi:
        list.sort((a, b) => b.nilaiRupiah.compareTo(a.nilaiRupiah));
        break;
    }

    return list;
  }

  int get totalLaporanCount => _reports.length;

  double get totalBeratKg =>
      _reports.fold(0.0, (sum, item) => sum + item.beratKg);

  double get totalNilaiRupiah =>
      _reports.fold(0.0, (sum, item) => sum + item.nilaiRupiah);

  Future<bool> addReport({
    required String bankSampahId,
    required String bankSampahNama,
    required String jenisSampah,
    required double beratKg,
    String? fotoPath,
    String? fotoUrl,
    String catatan = '',
    required String petugasNama,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final nilaiRupiah = beratKg * BankSampahConstants.hargaPerKg;
    final newReport = BankSampahReportEntity(
      id: '',
      bankSampahId: bankSampahId,
      bankSampahNama: bankSampahNama,
      jenisSampah: jenisSampah,
      beratKg: beratKg,
      nilaiRupiah: nilaiRupiah,
      fotoPath: fotoPath,
      fotoUrl: fotoUrl,
      catatan: catatan,
      petugasNama: petugasNama,
      createdAt: DateTime.now(),
    );

    final result = await addReportUsecase(newReport);
    _isSubmitting = false;

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (added) {
        _reports.insert(0, added);
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteReport(String id) async {
    final result = await deleteReportUsecase(id);
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (success) {
        _reports.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      },
    );
  }

  Future<BankSampahLocationEntity?> addLocation({
    required String nama,
    required String alamat,
    String kelurahan = '',
    String pengelola = '',
    String kontak = '',
  }) async {
    final newLocation = BankSampahLocationEntity(
      id: '',
      nama: nama,
      alamat: alamat,
      kelurahan: kelurahan,
      pengelola: pengelola,
      kontak: kontak,
      distanceMeters: 450.0,
    );

    final result = await addLocationUsecase(newLocation);
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return null;
      },
      (added) {
        _locations.insert(0, added);
        notifyListeners();
        return added;
      },
    );
  }
}
