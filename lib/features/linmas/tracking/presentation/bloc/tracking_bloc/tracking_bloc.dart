import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akar/core/services/gps_calibration_helper.dart';
import 'package:akar/features/linmas/tracking/domain/usecases/send_location_usecase.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final SendLocationUsecase sendLocationUsecase;
  final SharedPreferences sharedPreferences;
  final bool isDebugMode;
  final FlutterBackgroundService _service;
  final Future<bool> Function() _isLocationServiceEnabled;
  final bool _shouldAutoCheckGpsService;
  StreamSubscription<Map<String, dynamic>?>? _serviceSubscription;
  StreamSubscription<ServiceStatus>? _gpsServiceSubscription;

  TrackingBloc({
    required this.sendLocationUsecase,
    required this.sharedPreferences,
    this.isDebugMode = kDebugMode,
    FlutterBackgroundService? backgroundService,
    Stream<ServiceStatus>? serviceStatusStream,
    Future<bool> Function()? isLocationServiceEnabled,
  }) : _service = backgroundService ?? FlutterBackgroundService(),
       _isLocationServiceEnabled =
           isLocationServiceEnabled ?? Geolocator.isLocationServiceEnabled,
       _shouldAutoCheckGpsService =
           isLocationServiceEnabled != null || backgroundService == null,
       super(const TrackingState()) {
    on<InitTrackingEvent>(_onInitTracking);
    on<StartTrackingEvent>(_onStartTracking);
    on<StopTrackingEvent>(_onStopTracking);
    on<ChangeTrackingIntervalEvent>(_onChangeTrackingInterval);
    on<SendLocationNowEvent>(_onSendLocationNow);
    on<ApplyCalibratedLocationEvent>(_onApplyCalibratedLocation);
    on<SyncTrackingStatusEvent>(_onSyncTrackingStatus);
    on<GpsServiceStatusChangedEvent>(_onGpsServiceStatusChanged);
    on<UpdateTrackingDataEvent>(_onUpdateTrackingData);

    add(InitTrackingEvent());

    _serviceSubscription = _service.on('locationUpdated').listen((event) {
      if (event != null) {
        add(UpdateTrackingDataEvent.fromMap(event));
      }
    });

    if (serviceStatusStream != null || backgroundService == null) {
      try {
        final gpsStream =
            serviceStatusStream ?? Geolocator.getServiceStatusStream();
        _gpsServiceSubscription = gpsStream.listen((status) {
          add(GpsServiceStatusChangedEvent(status == ServiceStatus.enabled));
        }, onError: (_, _) {});
      } catch (_) {
        // Abaikan jika plugin platform tidak tersedia.
      }
    }
  }

  Future<void> _onInitTracking(
    InitTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    final bool active;
    if (isDebugMode) {
      // Mode debug default off agar tidak mengirim lokasi otomatis saat pengembangan.
      await sharedPreferences.setBool('isTrackingActive', false);
      await sharedPreferences.setBool('isTrackingEnabled', false);
      active = false;
    } else {
      active =
          sharedPreferences.getBool('isTrackingActive') ??
          sharedPreferences.getBool('isTrackingEnabled') ??
          false;
    }
    final interval =
        sharedPreferences.getInt('trackingIntervalSeconds') ??
        sharedPreferences.getInt('intervalSeconds') ??
        900;
    final lastLat = sharedPreferences.getDouble('LAST_TRACKING_LAT');
    final lastLng = sharedPreferences.getDouble('LAST_TRACKING_LNG');
    final lastAccuracy = sharedPreferences.getDouble('LAST_TRACKING_ACCURACY');
    String? lastMsg = sharedPreferences.getString('LAST_TRACKING_MSG');
    final rawAnomaly = sharedPreferences.getString('LAST_TRACKING_ANOMALY');
    String? lastAnomaly = (rawAnomaly != null && rawAnomaly.trim().isNotEmpty)
        ? rawAnomaly
        : null;
    bool lastSucc = sharedPreferences.getBool('LAST_TRACKING_SUCCESS') ?? true;
    final timeStr = sharedPreferences.getString('LAST_TRACKING_TIME');
    DateTime? lastTime;
    if (timeStr != null) {
      lastTime = DateTime.tryParse(timeStr);
    }

    if (_shouldAutoCheckGpsService) {
      try {
        final serviceEnabled = await _isLocationServiceEnabled().timeout(
          const Duration(seconds: 2),
        );
        if (!serviceEnabled) {
          lastAnomaly = GpsAnomalyReason.serviceDisabled.code;
          lastMsg = GpsAnomalyReason.serviceDisabled.userMessage;
          lastSucc = false;
        } else if (lastAnomaly == GpsAnomalyReason.serviceDisabled.code) {
          lastAnomaly = null;
          lastSucc = true;
        }
      } catch (_) {}
    }

    emit(
      state.copyWith(
        isTrackingActive: active,
        intervalSeconds: interval,
        lastLatitude: lastLat,
        lastLongitude: lastLng,
        lastAccuracyMeters: lastAccuracy,
        lastMessage: lastMsg,
        lastAnomalyCode: lastAnomaly,
        clearAnomaly: lastAnomaly == null,
        lastSuccess: lastSucc,
        lastSentTime: lastTime,
      ),
    );
  }

  Future<void> _onSyncTrackingStatus(
    SyncTrackingStatusEvent event,
    Emitter<TrackingState> emit,
  ) async {
    await sharedPreferences.reload();
    final active =
        sharedPreferences.getBool('isTrackingActive') ??
        sharedPreferences.getBool('isTrackingEnabled') ??
        state.isTrackingActive;
    final interval =
        sharedPreferences.getInt('trackingIntervalSeconds') ??
        sharedPreferences.getInt('intervalSeconds') ??
        state.intervalSeconds;
    final lastLat =
        sharedPreferences.getDouble('LAST_TRACKING_LAT') ?? state.lastLatitude;
    final lastLng =
        sharedPreferences.getDouble('LAST_TRACKING_LNG') ?? state.lastLongitude;
    final lastAccuracy =
        sharedPreferences.getDouble('LAST_TRACKING_ACCURACY') ??
        state.lastAccuracyMeters;
    final lastMsg =
        sharedPreferences.getString('LAST_TRACKING_MSG') ?? state.lastMessage;
    final rawAnomaly = sharedPreferences.getString('LAST_TRACKING_ANOMALY');
    final hasStoredAnomalyKey = rawAnomaly != null;
    final normalizedAnomaly =
        (rawAnomaly != null && rawAnomaly.trim().isNotEmpty)
        ? rawAnomaly
        : null;
    final lastSucc =
        sharedPreferences.getBool('LAST_TRACKING_SUCCESS') ?? state.lastSuccess;
    final timeStr = sharedPreferences.getString('LAST_TRACKING_TIME');
    DateTime? lastTime = state.lastSentTime;
    if (timeStr != null) {
      lastTime = DateTime.tryParse(timeStr) ?? state.lastSentTime;
    }

    emit(
      state.copyWith(
        isTrackingActive: active,
        intervalSeconds: interval,
        lastLatitude: lastLat,
        lastLongitude: lastLng,
        lastAccuracyMeters: lastAccuracy,
        lastMessage: lastMsg,
        lastAnomalyCode: normalizedAnomaly,
        clearAnomaly: hasStoredAnomalyKey && normalizedAnomaly == null,
        lastSuccess: lastSucc,
        lastSentTime: lastTime,
      ),
    );
  }

  Future<void> _onStartTracking(
    StartTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    if (isDebugMode && !event.manual) return;
    await sharedPreferences.setBool('isTrackingActive', true);
    await sharedPreferences.setBool('isTrackingEnabled', true);
    if (!await _service.isRunning()) {
      await _service.startService();
    } else {
      _service.invoke('updateStatus', {'active': true});
    }
    emit(state.copyWith(isTrackingActive: true));
  }

  Future<void> _onStopTracking(
    StopTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    await sharedPreferences.setBool('isTrackingActive', false);
    await sharedPreferences.setBool('isTrackingEnabled', false);
    if (await _service.isRunning()) {
      _service.invoke('updateStatus', {'active': false});
      _service.invoke('stopService');
    }
    emit(state.copyWith(isTrackingActive: false));
  }

  Future<void> _onChangeTrackingInterval(
    ChangeTrackingIntervalEvent event,
    Emitter<TrackingState> emit,
  ) async {
    if (state.intervalSeconds == event.intervalSeconds) return;
    await sharedPreferences.setInt(
      'trackingIntervalSeconds',
      event.intervalSeconds,
    );
    await sharedPreferences.setInt('intervalSeconds', event.intervalSeconds);
    if (await _service.isRunning()) {
      _service.invoke('updateInterval', {'interval': event.intervalSeconds});
    }
    emit(state.copyWith(intervalSeconds: event.intervalSeconds));
  }

  Future<void> _onSendLocationNow(
    SendLocationNowEvent event,
    Emitter<TrackingState> emit,
  ) async {
    if (state.isSending) return;
    emit(state.copyWith(isSending: true));

    try {
      final serviceEnabled = await _isLocationServiceEnabled();
      if (!serviceEnabled) {
        await sharedPreferences.setString(
          'LAST_TRACKING_ANOMALY',
          GpsAnomalyReason.serviceDisabled.code,
        );
        await sharedPreferences.setString(
          'LAST_TRACKING_MSG',
          GpsAnomalyReason.serviceDisabled.userMessage,
        );
        await sharedPreferences.setBool('LAST_TRACKING_SUCCESS', false);
        emit(
          state.copyWith(
            isSending: false,
            lastSuccess: false,
            lastAnomalyCode: GpsAnomalyReason.serviceDisabled.code,
            lastMessage: GpsAnomalyReason.serviceDisabled.userMessage,
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          emit(
            state.copyWith(
              isSending: false,
              lastSuccess: false,
              lastMessage: 'Izin lokasi ditolak',
            ),
          );
          return;
        }
      }

      final fix = await GpsCalibrationHelper.acquireValidatedBackgroundPosition(
        previousLat: state.lastLatitude,
        previousLng: state.lastLongitude,
        previousTimestamp: state.lastSentTime,
      );

      if (!fix.isValid) {
        final reason = fix.validation.reason;
        final msg = fix.validation.message;
        await sharedPreferences.setString('LAST_TRACKING_ANOMALY', reason.code);
        await sharedPreferences.setString('LAST_TRACKING_MSG', msg);
        await sharedPreferences.setBool('LAST_TRACKING_SUCCESS', false);
        emit(
          state.copyWith(
            isSending: false,
            lastSuccess: false,
            lastMessage: msg,
            lastAnomalyCode: reason.code,
          ),
        );
        return;
      }

      final position = fix.position!;
      final result = await sendLocationUsecase(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await result.fold(
        (failure) async {
          emit(
            state.copyWith(
              isSending: false,
              lastSuccess: false,
              lastMessage: failure.message,
              lastLatitude: position.latitude,
              lastLongitude: position.longitude,
              lastAccuracyMeters: position.accuracy,
            ),
          );
        },
        (entity) async {
          final now = DateTime.now();
          await sharedPreferences.setString(
            'LAST_TRACKING_TIME',
            now.toIso8601String(),
          );
          await sharedPreferences.setDouble(
            'LAST_TRACKING_LAT',
            position.latitude,
          );
          await sharedPreferences.setDouble(
            'LAST_TRACKING_LNG',
            position.longitude,
          );
          await sharedPreferences.setDouble(
            'LAST_TRACKING_ACCURACY',
            position.accuracy,
          );
          await sharedPreferences.setString('LAST_TRACKING_ANOMALY', '');
          await sharedPreferences.setString(
            'LAST_TRACKING_MSG',
            entity.message,
          );
          await sharedPreferences.setBool(
            'LAST_TRACKING_SUCCESS',
            entity.success,
          );
          emit(
            state.copyWith(
              isSending: false,
              lastSuccess: entity.success,
              lastMessage: entity.message,
              lastLatitude: position.latitude,
              lastLongitude: position.longitude,
              lastAccuracyMeters: position.accuracy,
              lastSentTime: now,
              clearAnomaly: true,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSending: false,
          lastSuccess: false,
          lastMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onApplyCalibratedLocation(
    ApplyCalibratedLocationEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(isSending: true));
    try {
      final result = await sendLocationUsecase(
        latitude: event.latitude,
        longitude: event.longitude,
      );
      await result.fold(
        (failure) async {
          emit(
            state.copyWith(
              isSending: false,
              lastSuccess: false,
              lastMessage: failure.message,
              lastLatitude: event.latitude,
              lastLongitude: event.longitude,
              lastAccuracyMeters: event.accuracyMeters,
            ),
          );
        },
        (entity) async {
          final now = DateTime.now();
          await sharedPreferences.setString(
            'LAST_TRACKING_TIME',
            now.toIso8601String(),
          );
          await sharedPreferences.setDouble(
            'LAST_TRACKING_LAT',
            event.latitude,
          );
          await sharedPreferences.setDouble(
            'LAST_TRACKING_LNG',
            event.longitude,
          );
          await sharedPreferences.setDouble(
            'LAST_TRACKING_ACCURACY',
            event.accuracyMeters,
          );
          await sharedPreferences.setBool('LAST_TRACKING_MOCKED', false);
          await sharedPreferences.setString('LAST_TRACKING_ANOMALY', '');
          await sharedPreferences.setString(
            'LAST_TRACKING_MSG',
            entity.message,
          );
          await sharedPreferences.setBool(
            'LAST_TRACKING_SUCCESS',
            entity.success,
          );
          emit(
            state.copyWith(
              isSending: false,
              lastSuccess: entity.success,
              lastMessage: entity.message,
              lastLatitude: event.latitude,
              lastLongitude: event.longitude,
              lastAccuracyMeters: event.accuracyMeters,
              lastSentTime: now,
              clearAnomaly: true,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSending: false,
          lastSuccess: false,
          lastMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGpsServiceStatusChanged(
    GpsServiceStatusChangedEvent event,
    Emitter<TrackingState> emit,
  ) async {
    if (!event.isEnabled) {
      await sharedPreferences.setString(
        'LAST_TRACKING_ANOMALY',
        GpsAnomalyReason.serviceDisabled.code,
      );
      await sharedPreferences.setString(
        'LAST_TRACKING_MSG',
        GpsAnomalyReason.serviceDisabled.userMessage,
      );
      await sharedPreferences.setBool('LAST_TRACKING_SUCCESS', false);
      emit(
        state.copyWith(
          lastSuccess: false,
          lastAnomalyCode: GpsAnomalyReason.serviceDisabled.code,
          lastMessage: GpsAnomalyReason.serviceDisabled.userMessage,
        ),
      );
      return;
    }

    if (state.lastAnomalyCode == GpsAnomalyReason.serviceDisabled.code) {
      await sharedPreferences.setString('LAST_TRACKING_ANOMALY', '');
      await sharedPreferences.setBool('LAST_TRACKING_SUCCESS', true);
      emit(
        state.copyWith(
          clearAnomaly: true,
          lastSuccess: true,
          lastMessage: 'Layanan lokasi (GPS) aktif kembali.',
        ),
      );
      if (state.isTrackingActive) {
        add(SendLocationNowEvent());
      }
    }
  }

  void _onUpdateTrackingData(
    UpdateTrackingDataEvent event,
    Emitter<TrackingState> emit,
  ) {
    final hasExplicitAnomalyKey = event.lastAnomalyCode != null;
    final normalizedAnomaly =
        (event.lastAnomalyCode != null &&
            event.lastAnomalyCode!.trim().isNotEmpty)
        ? event.lastAnomalyCode
        : null;
    emit(
      state.copyWith(
        isTrackingActive: event.isTrackingActive ?? state.isTrackingActive,
        lastLatitude: event.lastLatitude ?? state.lastLatitude,
        lastLongitude: event.lastLongitude ?? state.lastLongitude,
        lastAccuracyMeters:
            event.lastAccuracyMeters ?? state.lastAccuracyMeters,
        lastSentTime: event.lastSentTime ?? state.lastSentTime,
        lastSuccess: event.lastSuccess,
        lastMessage: event.lastMessage ?? state.lastMessage,
        lastAnomalyCode: normalizedAnomaly,
        clearAnomaly: hasExplicitAnomalyKey && normalizedAnomaly == null,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _serviceSubscription?.cancel();
    try {
      await _gpsServiceSubscription?.cancel();
    } catch (_) {}
    return super.close();
  }
}
