import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/panic_entity.dart';
import '../../domain/usecases/get_nearby_members_usecase.dart';
import '../../domain/usecases/send_panic_alert_usecase.dart';

enum PanicStatus { initial, loading, loaded, sending, success, error }

class PanicProvider extends ChangeNotifier {
  final GetNearbyMembersUsecase getNearbyMembersUsecase;
  final SendPanicAlertUsecase sendPanicAlertUsecase;

  PanicStatus _status = PanicStatus.initial;
  double? _userLatitude;
  double? _userLongitude;
  String? _fullAddress;
  List<NearbyMemberEntity> _nearbyMembers = [];
  PanicAlertResultEntity? _lastResult;
  String? _errorMessage;

  PanicStatus get status => _status;
  double? get userLatitude => _userLatitude;
  double? get userLongitude => _userLongitude;
  String? get fullAddress => _fullAddress;
  List<NearbyMemberEntity> get nearbyMembers => _nearbyMembers;
  PanicAlertResultEntity? get lastResult => _lastResult;
  String? get errorMessage => _errorMessage;

  PanicProvider({
    required this.getNearbyMembersUsecase,
    required this.sendPanicAlertUsecase,
  }) {
    initEmergencyLocation();
  }

  Future<void> initEmergencyLocation() async {
    _status = PanicStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      Position? position;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          ).timeout(const Duration(seconds: 5));
        }
      }

      _userLatitude = position?.latitude ?? -6.2088;
      _userLongitude = position?.longitude ?? 106.8456;

      try {
        final geocoding = Geocoding();
        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          _userLatitude!,
          _userLongitude!,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final street = place.street ?? '';
          final subLocality = place.subLocality ?? '';
          final locality = place.locality ?? '';
          final subAdmin = place.subAdministrativeArea ?? '';
          final admin = place.administrativeArea ?? '';

          final parts = [street, subLocality, locality, subAdmin, admin]
              .where((p) {
                final trimmed = p.trim();
                if (trimmed.isEmpty) return false;
                // Filter out string if it contains raw coordinate patterns (e.g. -6.2088) or plus codes (e.g. 7Q53+2X)
                if (RegExp(r'-?\d+\.\d{3,}').hasMatch(trimmed) ||
                    trimmed.contains('+')) {
                  return false;
                }
                return true;
              })
              .toSet()
              .toList();

          _fullAddress = parts.isNotEmpty
              ? parts.join(', ')
              : 'Jl. Medan Merdeka Barat No. 12, Gambir, Jakarta Pusat, DKI Jakarta';
        } else {
          _fullAddress =
              'Jl. Medan Merdeka Barat No. 12, Gambir, Jakarta Pusat, DKI Jakarta';
        }
      } catch (_) {
        _fullAddress =
            'Jl. Medan Merdeka Barat No. 12, Gambir, Jakarta Pusat, DKI Jakarta';
      }

      _nearbyMembers = await getNearbyMembersUsecase.call(
        latitude: _userLatitude!,
        longitude: _userLongitude!,
      );

      _status = PanicStatus.loaded;
    } catch (e) {
      _userLatitude ??= -6.2088;
      _userLongitude ??= 106.8456;
      _fullAddress ??=
          'Jl. Medan Merdeka Barat No. 12, Gambir, Jakarta Pusat, DKI Jakarta';
      _status = PanicStatus.loaded;
    }
    notifyListeners();
  }

  Future<bool> sendEmergencyRequest({String? note}) async {
    _status = PanicStatus.sending;
    _errorMessage = null;
    notifyListeners();

    try {
      final lat = _userLatitude ?? -6.2088;
      final lng = _userLongitude ?? 106.8456;

      _lastResult = await sendPanicAlertUsecase.call(
        latitude: lat,
        longitude: lng,
        selectedMemberId: null,
        note: note,
      );

      _status = PanicStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = PanicStatus.error;
      _errorMessage = 'Gagal mengirimkan bantuan: $e';
      notifyListeners();
      return false;
    }
  }
}
