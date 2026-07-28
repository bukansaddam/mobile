import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akar/features/home/domain/entities/tracked_location.dart';

class HomeProvider extends ChangeNotifier {
  List<TrackedLocation> _locations = [];
  TrackedLocation? _selectedLocation;
  bool _isTrackingEnabled = true;
  int _intervalSeconds = 10;
  Timer? _timer;
  bool _isLoading = true;
  String? _errorMessage;

  List<TrackedLocation> get locations => _locations;
  TrackedLocation? get selectedLocation => _selectedLocation;
  bool get isTrackingEnabled => _isTrackingEnabled;
  int get intervalSeconds => _intervalSeconds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HomeProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadFromPrefs();
    await initTracking();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isTrackingEnabled = prefs.getBool('isTrackingEnabled') ?? true;
      _intervalSeconds = prefs.getInt('intervalSeconds') ?? 10;

      final locationsJson = prefs.getStringList('trackedLocations') ?? [];
      _locations = locationsJson.map((item) {
        return TrackedLocation.fromJson(jsonDecode(item));
      }).toList();
    } catch (e) {
      debugPrint("Error loading from SharedPreferences: $e");
    }
  }

  Future<void> _saveLocationsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = _locations
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      await prefs.setStringList('trackedLocations', locationsJson);
    } catch (e) {
      debugPrint("Error saving locations: $e");
    }
  }

  Future<void> _saveSettingsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isTrackingEnabled', _isTrackingEnabled);
      await prefs.setInt('intervalSeconds', _intervalSeconds);
    } catch (e) {
      debugPrint("Error saving settings: $e");
    }
  }

  Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _errorMessage = "Location services are disabled. Please enable them.";
      notifyListeners();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _errorMessage = "Location permissions are denied.";
        notifyListeners();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _errorMessage = "Location permissions are permanently denied.";
      notifyListeners();
      return false;
    }

    _errorMessage = null;
    return true;
  }

  Future<void> initTracking() async {
    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      return;
    }

    if (_isTrackingEnabled) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _captureLocation();
    _timer = Timer.periodic(Duration(seconds: _intervalSeconds), (timer) {
      _captureLocation();
    });
  }

  Future<void> _captureLocation() async {
    if (!_isTrackingEnabled) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      String address = "Address not resolved";
      try {
        final geocoding = Geocoding();
        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          List<String> addressParts = [];

          if (place.street != null && place.street!.isNotEmpty) {
            addressParts.add(place.street!);
          }
          if (place.subLocality != null &&
              place.subLocality!.isNotEmpty &&
              place.subLocality != place.street) {
            addressParts.add(place.subLocality!);
          }
          if (place.locality != null && place.locality!.isNotEmpty) {
            addressParts.add(place.locality!);
          }
          if (place.country != null && place.country!.isNotEmpty) {
            addressParts.add(place.country!);
          }
          address = addressParts.isNotEmpty
              ? addressParts.join(', ')
              : "Street details not available";
        }
      } catch (geocodingError) {
        debugPrint("Geocoding failed: $geocodingError");
        address = "Street details not available (Network/service error)";
      }

      final newLoc = TrackedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        address: address,
      );

      _locations.add(newLoc);
      await _saveLocationsToPrefs();
      notifyListeners();
    } catch (e) {
      debugPrint("Error capturing location: $e");
    }
  }

  void startTracking() {
    if (_isTrackingEnabled) return;
    _isTrackingEnabled = true;
    _saveSettingsToPrefs();
    _startTimer();
    notifyListeners();
  }

  void stopTracking() {
    _isTrackingEnabled = false;
    _saveSettingsToPrefs();
    _timer?.cancel();
    notifyListeners();
  }

  void changeInterval(int seconds) {
    if (_intervalSeconds == seconds) return;
    _intervalSeconds = seconds;
    _saveSettingsToPrefs();
    if (_isTrackingEnabled) {
      _startTimer();
    }
    notifyListeners();
  }

  void clearLocations() {
    _locations.clear();
    _selectedLocation = null;
    _saveLocationsToPrefs();
    notifyListeners();
  }

  void selectLocation(TrackedLocation loc) {
    _selectedLocation = loc;
    notifyListeners();
  }

  void clearSelectedLocation() {
    _selectedLocation = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
