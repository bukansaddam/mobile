import 'package:flutter/material.dart';
import '../../domain/entities/tokoh_entity.dart';
import '../../domain/entities/institusi_entity.dart';
import '../../domain/entities/organisasi_entity.dart';
import '../../domain/usecases/add_tokoh_usecase.dart';
import '../../domain/usecases/get_tokoh_list_usecase.dart';
import '../../domain/usecases/add_institusi_usecase.dart';
import '../../domain/usecases/get_institusi_list_usecase.dart';
import '../../domain/usecases/add_organisasi_usecase.dart';
import '../../domain/usecases/get_organisasi_list_usecase.dart';

enum DemografiState { initial, loading, success, failure }

enum DemografiSortOption {
  terbaru('Terbaru', Icons.schedule_rounded),
  namaAz('Nama (A - Z)', Icons.sort_by_alpha_rounded),
  namaZa('Nama (Z - A)', Icons.sort_by_alpha_rounded);

  final String label;
  final IconData icon;

  const DemografiSortOption(this.label, this.icon);
}

class DemografiProvider extends ChangeNotifier {
  final GetTokohListUsecase getTokohListUsecase;
  final AddTokohUsecase addTokohUsecase;
  final GetInstitusiListUsecase getInstitusiListUsecase;
  final AddInstitusiUsecase addInstitusiUsecase;
  final GetOrganisasiListUsecase getOrganisasiListUsecase;
  final AddOrganisasiUsecase addOrganisasiListUsecase;

  DemografiProvider({
    required this.getTokohListUsecase,
    required this.addTokohUsecase,
    required this.getInstitusiListUsecase,
    required this.addInstitusiUsecase,
    required this.getOrganisasiListUsecase,
    required this.addOrganisasiListUsecase,
  }) {
    fetchAllData();
  }

  DemografiState _state = DemografiState.initial;
  DemografiState get state => _state;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Active Tab Index (0: Tokoh, 1: Institusi, 2: Organisasi)
  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  void setActiveTabIndex(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  // Raw Lists
  List<TokohEntity> _tokohList = [];
  List<InstitusiEntity> _institusiList = [];
  List<OrganisasiEntity> _organisasiList = [];

  // Filtered Getters
  List<TokohEntity> get tokohList => _filteredTokohList;
  List<InstitusiEntity> get institusiList => _filteredInstitusiList;
  List<OrganisasiEntity> get organisasiList => _filteredOrganisasiList;

  // Raw List Getters (Full Unfiltered Lists for Dropdowns)
  List<InstitusiEntity> get allInstitusiList => _institusiList;
  List<OrganisasiEntity> get allOrganisasiList => _organisasiList;

  // Search Query
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Tokoh Filters
  String? _selectedProfesiFilter;
  String? get selectedProfesiFilter => _selectedProfesiFilter;

  String? _selectedScopeFilter;
  String? get selectedScopeFilter => _selectedScopeFilter;

  String? _selectedAfiliasiFilter;
  String? get selectedAfiliasiFilter => _selectedAfiliasiFilter;

  // Institusi Filters
  String? _selectedInstitusiScopeFilter;
  String? get selectedInstitusiScopeFilter => _selectedInstitusiScopeFilter;

  // Organisasi Filters
  String? _selectedOrganisasiBidangFilter;
  String? get selectedOrganisasiBidangFilter => _selectedOrganisasiBidangFilter;

  // Sorting
  DemografiSortOption _selectedSortOption = DemografiSortOption.terbaru;
  DemografiSortOption get selectedSortOption => _selectedSortOption;

  bool get hasActiveFilter {
    if (_activeTabIndex == 0) {
      return _selectedProfesiFilter != null ||
          _selectedScopeFilter != null ||
          _selectedAfiliasiFilter != null ||
          _selectedSortOption != DemografiSortOption.terbaru;
    } else if (_activeTabIndex == 1) {
      return _selectedInstitusiScopeFilter != null ||
          _selectedSortOption != DemografiSortOption.terbaru;
    } else {
      return _selectedOrganisasiBidangFilter != null ||
          _selectedSortOption != DemografiSortOption.terbaru;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void setProfesiFilter(String? profesi) {
    _selectedProfesiFilter = profesi;
    notifyListeners();
  }

  void setScopeFilter(String? scope) {
    _selectedScopeFilter = scope;
    notifyListeners();
  }

  void setAfiliasiFilter(String? afiliasi) {
    _selectedAfiliasiFilter = afiliasi;
    notifyListeners();
  }

  void setInstitusiScopeFilter(String? scope) {
    _selectedInstitusiScopeFilter = scope;
    notifyListeners();
  }

  void setOrganisasiBidangFilter(String? bidang) {
    _selectedOrganisasiBidangFilter = bidang;
    notifyListeners();
  }

  void setSortOption(DemografiSortOption option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void resetAllFilters() {
    _selectedProfesiFilter = null;
    _selectedScopeFilter = null;
    _selectedAfiliasiFilter = null;
    _selectedInstitusiScopeFilter = null;
    _selectedOrganisasiBidangFilter = null;
    _selectedSortOption = DemografiSortOption.terbaru;
    notifyListeners();
  }

  // ------------------ Filtered Lists Logic ------------------
  List<TokohEntity> get _filteredTokohList {
    List<TokohEntity> list = List.from(_tokohList);

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((tokoh) {
        return tokoh.nama.toLowerCase().contains(q);
      }).toList();
    }

    if (_selectedProfesiFilter != null) {
      list = list.where((t) => t.profesi == _selectedProfesiFilter).toList();
    }
    if (_selectedScopeFilter != null) {
      list = list.where((t) => t.wilayah == _selectedScopeFilter).toList();
    }
    if (_selectedAfiliasiFilter != null) {
      list = list.where((t) => t.afiliasi == _selectedAfiliasiFilter).toList();
    }

    switch (_selectedSortOption) {
      case DemografiSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case DemografiSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case DemografiSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }

    return list;
  }

  List<InstitusiEntity> get _filteredInstitusiList {
    List<InstitusiEntity> list = List.from(_institusiList);

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((ins) {
        return ins.nama.toLowerCase().contains(q);
      }).toList();
    }

    if (_selectedInstitusiScopeFilter != null) {
      list = list
          .where((i) => i.scope == _selectedInstitusiScopeFilter)
          .toList();
    }

    switch (_selectedSortOption) {
      case DemografiSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case DemografiSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case DemografiSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }

    return list;
  }

  List<OrganisasiEntity> get _filteredOrganisasiList {
    List<OrganisasiEntity> list = List.from(_organisasiList);

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((org) {
        return org.nama.toLowerCase().contains(q);
      }).toList();
    }

    if (_selectedOrganisasiBidangFilter != null) {
      list = list
          .where((o) => o.bidang == _selectedOrganisasiBidangFilter)
          .toList();
    }

    switch (_selectedSortOption) {
      case DemografiSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case DemografiSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case DemografiSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }

    return list;
  }

  // ------------------ Fetch Methods ------------------
  Future<void> fetchAllData() async {
    _state = DemografiState.loading;
    _errorMessage = null;
    notifyListeners();

    final resTokoh = await getTokohListUsecase.call();
    final resInstitusi = await getInstitusiListUsecase.call();
    final resOrganisasi = await getOrganisasiListUsecase.call();

    resTokoh.fold(
      (f) => _errorMessage = f.message,
      (data) => _tokohList = data,
    );

    resInstitusi.fold(
      (f) => _errorMessage ??= f.message,
      (data) => _institusiList = data,
    );

    resOrganisasi.fold(
      (f) => _errorMessage ??= f.message,
      (data) => _organisasiList = data,
    );

    if (_errorMessage != null &&
        _tokohList.isEmpty &&
        _institusiList.isEmpty &&
        _organisasiList.isEmpty) {
      _state = DemografiState.failure;
    } else {
      _state = DemografiState.success;
    }

    notifyListeners();
  }

  Future<void> fetchTokohList() async {
    final result = await getTokohListUsecase.call();
    result.fold((failure) => _errorMessage = failure.message, (data) {
      _tokohList = data;
      _state = DemografiState.success;
    });
    notifyListeners();
  }

  Future<void> fetchInstitusiList() async {
    final result = await getInstitusiListUsecase.call();
    result.fold((failure) => _errorMessage = failure.message, (data) {
      _institusiList = data;
      _state = DemografiState.success;
    });
    notifyListeners();
  }

  Future<void> fetchOrganisasiList() async {
    final result = await getOrganisasiListUsecase.call();
    result.fold((failure) => _errorMessage = failure.message, (data) {
      _organisasiList = data;
      _state = DemografiState.success;
    });
    notifyListeners();
  }

  // ------------------ Add Methods ------------------
  Future<bool> addTokoh({
    required String nama,
    String noTelp = '',
    String jenisKelamin = 'Laki-laki',
    required String profesi,
    String wilayah = 'Nasional',
    String namaInstitusi = '',
    String jabatanInstitusi = '',
    required String afiliasi,
    String namaOrganisasi = '',
    String jabatanOrganisasi = '',
    required String suku,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final entity = TokohEntity(
      nama: nama,
      noTelp: noTelp,
      jenisKelamin: jenisKelamin,
      profesi: profesi,
      wilayah: wilayah,
      namaInstitusi: namaInstitusi,
      jabatanInstitusi: jabatanInstitusi,
      afiliasi: afiliasi,
      namaOrganisasi: namaOrganisasi,
      jabatanOrganisasi: jabatanOrganisasi,
      suku: suku,
      createdAt: DateTime.now(),
    );

    final result = await addTokohUsecase.call(entity);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isSubmitting = false;
        notifyListeners();
        return false;
      },
      (newTokoh) {
        _tokohList.insert(0, newTokoh);
        _isSubmitting = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> addInstitusi({
    required String nama,
    required String scope,
    String? alamat,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final entity = InstitusiEntity(
      nama: nama,
      scope: scope,
      alamat: alamat,
      createdAt: DateTime.now(),
    );

    final result = await addInstitusiUsecase.call(entity);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isSubmitting = false;
        notifyListeners();
        return false;
      },
      (newInstitusi) {
        _institusiList.insert(0, newInstitusi);
        _isSubmitting = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> addOrganisasi({
    required String nama,
    required int jumlahAnggota,
    required String bidang,
    String? alamatSekretariat,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final entity = OrganisasiEntity(
      nama: nama,
      jumlahAnggota: jumlahAnggota,
      bidang: bidang,
      alamatSekretariat: alamatSekretariat,
      createdAt: DateTime.now(),
    );

    final result = await addOrganisasiListUsecase.call(entity);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isSubmitting = false;
        notifyListeners();
        return false;
      },
      (newOrganisasi) {
        _organisasiList.insert(0, newOrganisasi);
        _isSubmitting = false;
        notifyListeners();
        return true;
      },
    );
  }
}
