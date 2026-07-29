import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akar/features/tracking/domain/usecases/send_location_usecase.dart';

class TrackingProvider extends ChangeNotifier {
  final SendLocationUsecase sendLocationUsecase;
  final SharedPreferences sharedPreferences;

  Timer? _statusRefreshTimer;
  bool _isTrackingActive = true;
  int _intervalSeconds = 900;
  double? _lastLatitude;
  double? _lastLongitude;
  DateTime? _lastSentTime;
  bool _lastSuccess = true;
  String? _lastMessage;
  bool _isSending = false;

  bool get isTrackingActive => _isTrackingActive;
  int get intervalSeconds => _intervalSeconds;
  double? get lastLatitude => _lastLatitude;
  double? get lastLongitude => _lastLongitude;
  DateTime? get lastSentTime => _lastSentTime;
  bool get lastSuccess => _lastSuccess;
  String? get lastMessage => _lastMessage;
  bool get isSending => _isSending;

  TrackingProvider({
    required this.sendLocationUsecase,
    required this.sharedPreferences,
  }) {
    _init();
  }

  void _init() {
    _isTrackingActive = sharedPreferences.getBool('isTrackingActive') ?? true;
    _intervalSeconds =
        sharedPreferences.getInt('trackingIntervalSeconds') ?? 900;
    _loadBackgroundStatus();

    // Periodically sync UI state with background service logs
    _statusRefreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _loadBackgroundStatus();
    });
  }

  Future<void> _loadBackgroundStatus() async {
    await sharedPreferences.reload();
    _lastLatitude =
        sharedPreferences.getDouble('LAST_TRACKING_LAT') ?? _lastLatitude;
    _lastLongitude =
        sharedPreferences.getDouble('LAST_TRACKING_LNG') ?? _lastLongitude;
    _lastMessage =
        sharedPreferences.getString('LAST_TRACKING_MSG') ?? _lastMessage;
    _lastSuccess =
        sharedPreferences.getBool('LAST_TRACKING_SUCCESS') ?? _lastSuccess;
    final timeStr = sharedPreferences.getString('LAST_TRACKING_TIME');
    if (timeStr != null) {
      _lastSentTime = DateTime.tryParse(timeStr);
    }
    notifyListeners();
  }

  Future<void> _captureAndSend() async {
    if (_isSending) return;

    _isSending = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _lastSuccess = false;
        _lastMessage = 'Layanan lokasi (GPS) tidak aktif';
        _isSending = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _lastSuccess = false;
          _lastMessage = 'Izin lokasi ditolak';
          _isSending = false;
          notifyListeners();
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _lastLatitude = position.latitude;
      _lastLongitude = position.longitude;

      final result = await sendLocationUsecase(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      result.fold(
        (failure) {
          _lastSuccess = false;
          _lastMessage = failure.message;
        },
        (entity) {
          _lastSuccess = entity.success;
          _lastMessage = entity.message;
          _lastSentTime = DateTime.now();
        },
      );
    } catch (e) {
      _lastSuccess = false;
      _lastMessage = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> startTracking() async {
    _isTrackingActive = true;
    await sharedPreferences.setBool('isTrackingActive', true);
    final service = FlutterBackgroundService();
    if (!await service.isRunning()) {
      await service.startService();
    } else {
      service.invoke('updateStatus', {'active': true});
    }
    notifyListeners();
  }

  Future<void> stopTracking() async {
    _isTrackingActive = false;
    await sharedPreferences.setBool('isTrackingActive', false);
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke('updateStatus', {'active': false});
    }
    notifyListeners();
  }

  Future<void> changeInterval(int seconds) async {
    if (_intervalSeconds == seconds) return;
    _intervalSeconds = seconds;
    await sharedPreferences.setInt('trackingIntervalSeconds', seconds);
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke('updateInterval', {'interval': seconds});
    }
    notifyListeners();
  }

  Future<void> sendLocationNow() async {
    await _captureAndSend();
  }

  @override
  void dispose() {
    _statusRefreshTimer?.cancel();
    super.dispose();
  }
}
