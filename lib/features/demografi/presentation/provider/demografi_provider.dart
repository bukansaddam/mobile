import 'package:flutter/material.dart';
import '../../domain/entities/tokoh_entity.dart';
import '../../domain/usecases/add_tokoh_usecase.dart';
import '../../domain/usecases/get_tokoh_list_usecase.dart';

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

  DemografiProvider({
    required this.getTokohListUsecase,
    required this.addTokohUsecase,
  }) {
    fetchTokohList();
  }

  DemografiState _state = DemografiState.initial;
  DemografiState get state => _state;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<TokohEntity> _tokohList = [];
  List<TokohEntity> get tokohList => _filteredTokohList;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _selectedProfesiFilter;
  String? get selectedProfesiFilter => _selectedProfesiFilter;

  String? _selectedScopeFilter;
  String? get selectedScopeFilter => _selectedScopeFilter;

  String? _selectedAfiliasiFilter;
  String? get selectedAfiliasiFilter => _selectedAfiliasiFilter;

  DemografiSortOption _selectedSortOption = DemografiSortOption.terbaru;
  DemografiSortOption get selectedSortOption => _selectedSortOption;

  bool get hasActiveFilter =>
      _selectedProfesiFilter != null ||
      _selectedScopeFilter != null ||
      _selectedAfiliasiFilter != null ||
      _selectedSortOption != DemografiSortOption.terbaru;

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

  void setSortOption(DemografiSortOption option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void resetAllFilters() {
    _selectedProfesiFilter = null;
    _selectedScopeFilter = null;
    _selectedAfiliasiFilter = null;
    _selectedSortOption = DemografiSortOption.terbaru;
    notifyListeners();
  }

  List<TokohEntity> get _filteredTokohList {
    List<TokohEntity> list = List.from(_tokohList);

    // 1. Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((tokoh) {
        return tokoh.nama.toLowerCase().contains(q) ||
            tokoh.profesi.toLowerCase().contains(q) ||
            tokoh.namaOrganisasi.toLowerCase().contains(q) ||
            tokoh.afiliasi.toLowerCase().contains(q) ||
            tokoh.wilayah.toLowerCase().contains(q) ||
            tokoh.suku.toLowerCase().contains(q);
      }).toList();
    }

    // 2. Filter by Profesi
    if (_selectedProfesiFilter != null) {
      list = list.where((t) => t.profesi == _selectedProfesiFilter).toList();
    }

    // 3. Filter by Scope
    if (_selectedScopeFilter != null) {
      list = list.where((t) => t.wilayah == _selectedScopeFilter).toList();
    }

    // 4. Filter by Afiliasi
    if (_selectedAfiliasiFilter != null) {
      list = list.where((t) => t.afiliasi == _selectedAfiliasiFilter).toList();
    }

    // 5. Sorting
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

  Future<void> fetchTokohList() async {
    _state = DemografiState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getTokohListUsecase.call();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = DemografiState.failure;
        notifyListeners();
      },
      (data) {
        _tokohList = data;
        _state = DemografiState.success;
        notifyListeners();
      },
    );
  }

  Future<bool> addTokoh({
    required String nama,
    String noTelp = '',
    required String profesi,
    required String wilayah,
    required String afiliasi,
    String namaOrganisasi = '',
    required String suku,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final entity = TokohEntity(
      nama: nama,
      noTelp: noTelp,
      profesi: profesi,
      wilayah: wilayah,
      afiliasi: afiliasi,
      namaOrganisasi: namaOrganisasi,
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
}
