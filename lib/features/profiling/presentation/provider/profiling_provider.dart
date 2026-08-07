import 'package:flutter/foundation.dart';
import '../../domain/entities/tokoh_entity.dart';
import '../../domain/usecases/add_tokoh_usecase.dart';
import '../../domain/usecases/get_tokoh_list_usecase.dart';

enum ProfilingState { initial, loading, success, failure }

class ProfilingProvider extends ChangeNotifier {
  final GetTokohListUsecase getTokohListUsecase;
  final AddTokohUsecase addTokohUsecase;

  ProfilingProvider({
    required this.getTokohListUsecase,
    required this.addTokohUsecase,
  }) {
    fetchTokohList();
  }

  ProfilingState _state = ProfilingState.initial;
  ProfilingState get state => _state;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<TokohEntity> _tokohList = [];
  List<TokohEntity> get tokohList => _filteredTokohList;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<TokohEntity> get _filteredTokohList {
    if (_searchQuery.trim().isEmpty) {
      return _tokohList;
    }
    final q = _searchQuery.toLowerCase();
    return _tokohList.where((tokoh) {
      return tokoh.nama.toLowerCase().contains(q) ||
          tokoh.namaOrganisasi.toLowerCase().contains(q) ||
          tokoh.afiliasi.toLowerCase().contains(q) ||
          tokoh.wilayah.toLowerCase().contains(q);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchTokohList() async {
    _state = ProfilingState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getTokohListUsecase.call();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = ProfilingState.failure;
        notifyListeners();
      },
      (data) {
        _tokohList = data;
        _state = ProfilingState.success;
        notifyListeners();
      },
    );
  }

  Future<bool> addTokoh({
    required String nama,
    required String noTelp,
    required String wilayah,
    required String afiliasi,
    required String namaOrganisasi,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final entity = TokohEntity(
      nama: nama,
      noTelp: noTelp,
      wilayah: wilayah,
      afiliasi: afiliasi,
      namaOrganisasi: namaOrganisasi,
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
