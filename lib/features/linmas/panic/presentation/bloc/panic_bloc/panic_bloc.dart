import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:akar/features/linmas/panic/core/constants/panic_constants.dart';
import 'package:akar/features/linmas/panic/domain/entities/panic_entity.dart';
import 'package:akar/features/linmas/panic/domain/usecases/get_nearby_members_usecase.dart';
import 'package:akar/features/linmas/panic/domain/usecases/send_panic_alert_usecase.dart';

part 'panic_event.dart';
part 'panic_state.dart';

class PanicBloc extends Bloc<PanicEvent, PanicState> {
  final GetNearbyMembersUsecase getNearbyMembersUsecase;
  final SendPanicAlertUsecase sendPanicAlertUsecase;

  bool isEmergencyActive = false;
  double userLatitude = PanicConstants.defaultLatitude;
  double userLongitude = PanicConstants.defaultLongitude;
  String fullAddress = PanicConstants.defaultAddress;

  List<NearbyMemberEntity> nearbyMembers = [];
  List<NearbyMemberEntity> localLeaders = [];
  PanicAlertResultEntity? lastResult;

  List<NearbyMemberEntity> get filteredMembers => nearbyMembers;
  List<NearbyMemberEntity> get filteredLeaders => localLeaders;

  PanicBloc({
    required this.getNearbyMembersUsecase,
    required this.sendPanicAlertUsecase,
  }) : super(const PanicInitial()) {
    on<InitPanicLocationEvent>(_onInitLocation);
    on<GetPanicNearbyMembersEvent>(_onGetNearbyMembers);
    on<RefreshPanicEvent>(_onRefreshPanic);
    on<SendPanicAlertEvent>(_onSendAlert);
  }

  PanicLoaded _createLoadedState() {
    return PanicLoaded(
      isEmergencyActive: isEmergencyActive,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      fullAddress: fullAddress,
      nearbyMembers: nearbyMembers,
      localLeaders: localLeaders,
      lastResult: lastResult,
    );
  }

  PanicLoading _createLoadingState() {
    return PanicLoading(
      isEmergencyActive: isEmergencyActive,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      fullAddress: fullAddress,
      nearbyMembers: nearbyMembers,
      localLeaders: localLeaders,
      lastResult: lastResult,
    );
  }

  PanicFailure _createFailureState(String message) {
    return PanicFailure(
      message,
      isEmergencyActive: isEmergencyActive,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      fullAddress: fullAddress,
      nearbyMembers: nearbyMembers,
      localLeaders: localLeaders,
      lastResult: lastResult,
    );
  }

  Future<void> _fetchMembers(Emitter<PanicState> emit) async {
    emit(_createLoadingState());

    final result = await getNearbyMembersUsecase(
      latitude: userLatitude,
      longitude: userLongitude,
    );

    result.fold((failure) => emit(_createFailureState(failure.message)), (
      members,
    ) {
      nearbyMembers = members;
      emit(_createLoadedState());
    });
  }

  Future<void> _resolveUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          Position? position = await Geolocator.getLastKnownPosition();
          position ??= await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          ).timeout(const Duration(seconds: 5));

          userLatitude = position.latitude;
          userLongitude = position.longitude;
        }
      }

      try {
        final geocoding = Geocoding();
        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          userLatitude,
          userLongitude,
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
                if (RegExp(r'-?\d+\.\d{3,}').hasMatch(trimmed) ||
                    trimmed.contains('+')) {
                  return false;
                }
                return true;
              })
              .toSet()
              .toList();

          if (parts.isNotEmpty) {
            fullAddress = parts.join(', ');
          }
        }
      } catch (_) {}
    } catch (_) {}

    localLeaders = [
      NearbyMemberEntity(
        id: 'tokoh_kades',
        name: 'Bpk. H. Sudirman, S.E.',
        role: 'Kepala Desa / Lurah',
        distanceText: '120m',
        latitude: userLatitude + 0.0012,
        longitude: userLongitude + 0.0009,
        phone: '081298765432',
        isOnline: true,
      ),
      NearbyMemberEntity(
        id: 'tokoh_babinsa',
        name: 'Sertu Bambang Wijaya',
        role: 'Babinsa (TNI AD)',
        distanceText: '210m',
        latitude: userLatitude - 0.0015,
        longitude: userLongitude + 0.0011,
        phone: '081388776655',
        isOnline: true,
      ),
      NearbyMemberEntity(
        id: 'tokoh_babinkamtibmas',
        name: 'Aiptu Hendra Kurniawan',
        role: 'Bhabinkamtibmas (Polri)',
        distanceText: '340m',
        latitude: userLatitude + 0.0021,
        longitude: userLongitude - 0.0018,
        phone: '081577665544',
        isOnline: true,
      ),
    ];
  }

  Future<void> _onInitLocation(
    InitPanicLocationEvent event,
    Emitter<PanicState> emit,
  ) async {
    emit(_createLoadingState());
    await _resolveUserLocation();
    await _fetchMembers(emit);
  }

  Future<void> _onGetNearbyMembers(
    GetPanicNearbyMembersEvent event,
    Emitter<PanicState> emit,
  ) async {
    await _fetchMembers(emit);
  }

  Future<void> _onRefreshPanic(
    RefreshPanicEvent event,
    Emitter<PanicState> emit,
  ) async {
    add(const InitPanicLocationEvent());
  }

  Future<void> _onSendAlert(
    SendPanicAlertEvent event,
    Emitter<PanicState> emit,
  ) async {
    emit(
      PanicActionLoading(
        isEmergencyActive: isEmergencyActive,
        userLatitude: userLatitude,
        userLongitude: userLongitude,
        fullAddress: fullAddress,
        nearbyMembers: nearbyMembers,
        localLeaders: localLeaders,
        lastResult: lastResult,
      ),
    );

    final result = await sendPanicAlertUsecase.call(
      latitude: userLatitude,
      longitude: userLongitude,
      isEmergency: event.isEmergency,
      selectedMemberId: event.selectedMemberId,
      note: event.note,
    );

    result.fold(
      (failure) {
        emit(
          PanicActionFailure(
            failure.message,
            isEmergencyActive: isEmergencyActive,
            userLatitude: userLatitude,
            userLongitude: userLongitude,
            fullAddress: fullAddress,
            nearbyMembers: nearbyMembers,
            localLeaders: localLeaders,
            lastResult: lastResult,
          ),
        );
      },
      (alertResult) {
        isEmergencyActive = event.isEmergency;
        lastResult = alertResult;
        emit(
          PanicActionSuccess(
            message: alertResult.message,
            isEmergencyActive: isEmergencyActive,
            userLatitude: userLatitude,
            userLongitude: userLongitude,
            fullAddress: fullAddress,
            nearbyMembers: nearbyMembers,
            localLeaders: localLeaders,
            lastResult: lastResult,
          ),
        );
      },
    );
  }
}
