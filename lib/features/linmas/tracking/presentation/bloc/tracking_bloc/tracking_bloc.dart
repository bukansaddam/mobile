import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akar/features/linmas/tracking/domain/usecases/send_location_usecase.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final SendLocationUsecase sendLocationUsecase;
  final SharedPreferences sharedPreferences;
  Timer? _statusRefreshTimer;

  TrackingBloc({
    required this.sendLocationUsecase,
    required this.sharedPreferences,
  }) : super(const TrackingState()) {
    on<InitTrackingEvent>(_onInitTracking);
    on<StartTrackingEvent>(_onStartTracking);
    on<StopTrackingEvent>(_onStopTracking);
    on<ChangeTrackingIntervalEvent>(_onChangeTrackingInterval);
    on<SendLocationNowEvent>(_onSendLocationNow);
    on<SyncTrackingStatusEvent>(_onSyncTrackingStatus);

    add(InitTrackingEvent());

    _statusRefreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(SyncTrackingStatusEvent());
    });
  }

  Future<void> _onInitTracking(
    InitTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    final active =
        sharedPreferences.getBool('isTrackingActive') ??
        sharedPreferences.getBool('isTrackingEnabled') ??
        false;
    final interval =
        sharedPreferences.getInt('trackingIntervalSeconds') ??
        sharedPreferences.getInt('intervalSeconds') ??
        900;
    final lastLat = sharedPreferences.getDouble('LAST_TRACKING_LAT');
    final lastLng = sharedPreferences.getDouble('LAST_TRACKING_LNG');
    final lastMsg = sharedPreferences.getString('LAST_TRACKING_MSG');
    final lastSucc = sharedPreferences.getBool('LAST_TRACKING_SUCCESS') ?? true;
    final timeStr = sharedPreferences.getString('LAST_TRACKING_TIME');
    DateTime? lastTime;
    if (timeStr != null) {
      lastTime = DateTime.tryParse(timeStr);
    }

    emit(
      state.copyWith(
        isTrackingActive: active,
        intervalSeconds: interval,
        lastLatitude: lastLat,
        lastLongitude: lastLng,
        lastMessage: lastMsg,
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
    final lastMsg =
        sharedPreferences.getString('LAST_TRACKING_MSG') ?? state.lastMessage;
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
        lastMessage: lastMsg,
        lastSuccess: lastSucc,
        lastSentTime: lastTime,
      ),
    );
  }

  Future<void> _onStartTracking(
    StartTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    await sharedPreferences.setBool('isTrackingActive', true);
    await sharedPreferences.setBool('isTrackingEnabled', true);
    final service = FlutterBackgroundService();
    if (!await service.isRunning()) {
      await service.startService();
    } else {
      service.invoke('updateStatus', {'active': true});
    }
    emit(state.copyWith(isTrackingActive: true));
  }

  Future<void> _onStopTracking(
    StopTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    await sharedPreferences.setBool('isTrackingActive', false);
    await sharedPreferences.setBool('isTrackingEnabled', false);
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke('updateStatus', {'active': false});
      service.invoke('stopService');
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
    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke('updateInterval', {'interval': event.intervalSeconds});
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
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            isSending: false,
            lastSuccess: false,
            lastMessage: 'Layanan lokasi (GPS) tidak aktif',
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

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final result = await sendLocationUsecase(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              isSending: false,
              lastSuccess: false,
              lastMessage: failure.message,
              lastLatitude: position.latitude,
              lastLongitude: position.longitude,
            ),
          );
        },
        (entity) {
          emit(
            state.copyWith(
              isSending: false,
              lastSuccess: entity.success,
              lastMessage: entity.message,
              lastLatitude: position.latitude,
              lastLongitude: position.longitude,
              lastSentTime: DateTime.now(),
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

  @override
  Future<void> close() {
    _statusRefreshTimer?.cancel();
    return super.close();
  }
}
