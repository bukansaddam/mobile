import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/presensi_entity.dart';
import '../../domain/usecases/submit_presensi_usecase.dart';

enum PresensiStatus {
  initial,
  loadingLocation,
  loaded,
  submitting,
  success,
  failure,
}

class PresensiProvider extends ChangeNotifier {
  final SubmitPresensiUsecase submitPresensiUsecase;

  PresensiProvider({required this.submitPresensiUsecase});

  PresensiStatus _status = PresensiStatus.initial;
  PresensiStatus get status => _status;

  double? _userLatitude;
  double? get userLatitude => _userLatitude;

  double? _userLongitude;
  double? get userLongitude => _userLongitude;

  String _userName = 'Pengguna';
  String get userName => _userName;

  String _kecamatan = 'Gambir';
  String get kecamatan => _kecamatan;

  String _kelurahan = 'Gambir';
  String get kelurahan => _kelurahan;

  String _address = 'Jl. Medan Merdeka Barat No. 12';
  String get address => _address;

  String _rt = '005';
  String get rt => _rt;

  String _rw = '002';
  String get rw => _rw;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PresensiDataEntity? _lastResult;
  PresensiDataEntity? get lastResult => _lastResult;

  void updateRt(String val) {
    _rt = val;
    notifyListeners();
  }

  void updateRw(String val) {
    _rw = val;
    notifyListeners();
  }

  void updateKecamatan(String val) {
    _kecamatan = val;
    notifyListeners();
  }

  void updateKelurahan(String val) {
    _kelurahan = val;
    notifyListeners();
  }

  void updateAddress(String val) {
    _address = val;
    notifyListeners();
  }

  Future<void> initLocation(String userName) async {
    if (userName.trim().isNotEmpty) {
      _userName = userName;
    }
    _status = PresensiStatus.loadingLocation;
    notifyListeners();

    try {
      Position? pos;
      try {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          var permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission != LocationPermission.denied &&
              permission != LocationPermission.deniedForever) {
            pos = await Geolocator.getLastKnownPosition();
            pos ??= await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
              ),
            ).timeout(const Duration(seconds: 5));
          }
        }
      } catch (_) {}

      _userLatitude = pos?.latitude ?? -6.2088;
      _userLongitude = pos?.longitude ?? 106.8456;

      try {
        final geocoding = Geocoding();
        final placemarks = await geocoding.placemarkFromCoordinates(
          _userLatitude!,
          _userLongitude!,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          _kecamatan =
              place.locality ?? place.subAdministrativeArea ?? 'Gambir';
          _kelurahan = place.subLocality ?? 'Gambir';

          final parts =
              [
                    place.street,
                    place.subLocality,
                    place.locality,
                    place.subAdministrativeArea,
                  ]
                  .where((p) {
                    final str = p.toString().trim();
                    if (str.isEmpty) return false;
                    if (RegExp(r'-?\d+\.\d{3,}').hasMatch(str) ||
                        str.contains('+')) {
                      return false;
                    }
                    return true;
                  })
                  .cast<String>()
                  .toSet()
                  .toList();

          _address = parts.isNotEmpty
              ? parts.join(', ')
              : 'Jl. Medan Merdeka Barat No. 12';
        }
      } catch (_) {}

      _status = PresensiStatus.loaded;
    } catch (e) {
      _userLatitude ??= -6.2088;
      _userLongitude ??= 106.8456;
      _status = PresensiStatus.loaded;
    }
    notifyListeners();
  }

  Future<bool> submitPresensi() async {
    _status = PresensiStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    final dataEntity = PresensiDataEntity(
      userName: _userName,
      address: _address,
      kecamatan: _kecamatan,
      kelurahan: _kelurahan,
      rt: _rt,
      rw: _rw,
      latitude: _userLatitude ?? -6.2088,
      longitude: _userLongitude ?? 106.8456,
      timestamp: DateTime.now(),
    );

    final result = await submitPresensiUsecase.call(dataEntity);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _status = PresensiStatus.failure;
        notifyListeners();
        return false;
      },
      (dataResult) {
        _lastResult = dataResult;
        _status = PresensiStatus.success;
        notifyListeners();
        return true;
      },
    );
  }
}
