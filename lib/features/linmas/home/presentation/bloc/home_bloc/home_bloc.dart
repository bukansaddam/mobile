import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akar/features/linmas/home/domain/entities/tracked_location.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Timer? _timer;

  HomeBloc() : super(const HomeState()) {
    on<InitHomeEvent>(_onInitHome);
    on<StartHomeTrackingEvent>(_onStartTracking);
    on<StopHomeTrackingEvent>(_onStopTracking);
    on<ChangeHomeIntervalEvent>(_onChangeInterval);
    on<CaptureHomeLocationEvent>(_onCaptureLocation);
    on<SelectHomeLocationEvent>(_onSelectLocation);
    on<ClearHomeSelectedLocationEvent>(_onClearSelectedLocation);
    on<ClearHomeLocationsEvent>(_onClearLocations);

    add(InitHomeEvent());
  }

  Future<void> _onInitHome(InitHomeEvent event, Emitter<HomeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool('isTrackingEnabled') ?? true;
      final interval = prefs.getInt('intervalSeconds') ?? 10;
      final locationsJson = prefs.getStringList('trackedLocations') ?? [];
      final locations = locationsJson.map((item) {
        return TrackedLocation.fromJson(jsonDecode(item));
      }).toList();

      emit(
        state.copyWith(
          locations: locations,
          isTrackingEnabled: isEnabled,
          intervalSeconds: interval,
          isLoading: false,
        ),
      );

      if (isEnabled) {
        _startTimer();
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat riwayat lokasi: $e',
        ),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    add(CaptureHomeLocationEvent());
    _timer = Timer.periodic(Duration(seconds: state.intervalSeconds), (_) {
      add(CaptureHomeLocationEvent());
    });
  }

  Future<void> _onCaptureLocation(
    CaptureHomeLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (!state.isTrackingEnabled) return;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            errorMessage: 'Layanan lokasi (GPS) tidak aktif. Silakan aktifkan.',
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(errorMessage: 'Izin lokasi ditolak.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(errorMessage: 'Izin lokasi ditolak secara permanen.'),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      String address = 'Address not resolved';
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
              : 'Street details not available';
        }
      } catch (geocodingError) {
        debugPrint('Geocoding failed: $geocodingError');
        address = 'Street details not available (Network/service error)';
      }

      final newLoc = TrackedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        address: address,
      );

      final updatedLocations = List<TrackedLocation>.from(state.locations)
        ..add(newLoc);

      final prefs = await SharedPreferences.getInstance();
      final locationsJson = updatedLocations
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      await prefs.setStringList('trackedLocations', locationsJson);

      emit(state.copyWith(locations: updatedLocations, errorMessage: null));
    } catch (e) {
      debugPrint('Error capturing location in HomeBloc: $e');
    }
  }

  Future<void> _onStartTracking(
    StartHomeTrackingEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isTrackingEnabled) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTrackingEnabled', true);

    emit(state.copyWith(isTrackingEnabled: true));
    _startTimer();
  }

  Future<void> _onStopTracking(
    StopHomeTrackingEvent event,
    Emitter<HomeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTrackingEnabled', false);
    _timer?.cancel();

    emit(state.copyWith(isTrackingEnabled: false));
  }

  Future<void> _onChangeInterval(
    ChangeHomeIntervalEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.intervalSeconds == event.intervalSeconds) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('intervalSeconds', event.intervalSeconds);

    emit(state.copyWith(intervalSeconds: event.intervalSeconds));
    if (state.isTrackingEnabled) {
      _startTimer();
    }
  }

  void _onSelectLocation(
    SelectHomeLocationEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedLocation: event.location));
  }

  void _onClearSelectedLocation(
    ClearHomeSelectedLocationEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(clearSelectedLocation: true));
  }

  Future<void> _onClearLocations(
    ClearHomeLocationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('trackedLocations');

    emit(state.copyWith(locations: const [], clearSelectedLocation: true));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
