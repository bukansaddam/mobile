import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:akar/features/linmas/panic/domain/entities/panic_entity.dart';
import 'package:akar/features/linmas/panic/domain/usecases/get_nearby_members_usecase.dart';
import 'package:akar/features/linmas/panic/domain/usecases/send_panic_alert_usecase.dart';

part 'panic_event.dart';
part 'panic_state.dart';

class PanicBloc extends Bloc<PanicEvent, PanicState> {
  final GetNearbyMembersUsecase getNearbyMembersUsecase;
  final SendPanicAlertUsecase sendPanicAlertUsecase;

  PanicBloc({
    required this.getNearbyMembersUsecase,
    required this.sendPanicAlertUsecase,
  }) : super(const PanicState()) {
    on<InitPanicLocationEvent>(_onInitLocation);
    on<SendPanicAlertEvent>(_onSendAlert);

    add(InitPanicLocationEvent());
  }

  Future<void> _onInitLocation(
    InitPanicLocationEvent event,
    Emitter<PanicState> emit,
  ) async {
    emit(state.copyWith(status: PanicStatus.loading, errorMessage: null));

    double lat = -6.2088;
    double lng = 106.8456;
    String fullAddress =
        'Jl. Medan Merdeka Barat No. 12, Gambir, Jakarta Pusat, DKI Jakarta';

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
          position = await Geolocator.getLastKnownPosition();
          position ??= await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          ).timeout(const Duration(seconds: 5));
        }
      }

      if (position != null) {
        lat = position.latitude;
        lng = position.longitude;
      }

      try {
        final geocoding = Geocoding();
        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          lat,
          lng,
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

      final members = await getNearbyMembersUsecase.call(
        latitude: lat,
        longitude: lng,
      );

      final leaders = [
        NearbyMemberEntity(
          id: 'tokoh_kades',
          name: 'Bpk. H. Sudirman, S.E.',
          role: 'Kepala Desa / Lurah',
          distanceText: '120m',
          latitude: lat + 0.0012,
          longitude: lng + 0.0009,
          phone: '081298765432',
          isOnline: true,
        ),
        NearbyMemberEntity(
          id: 'tokoh_babinsa',
          name: 'Sertu Bambang Wijaya',
          role: 'Babinsa (TNI AD)',
          distanceText: '210m',
          latitude: lat - 0.0015,
          longitude: lng + 0.0011,
          phone: '081388776655',
          isOnline: true,
        ),
        NearbyMemberEntity(
          id: 'tokoh_babinkamtibmas',
          name: 'Aiptu Hendra Kurniawan',
          role: 'Bhabinkamtibmas (Polri)',
          distanceText: '340m',
          latitude: lat + 0.0021,
          longitude: lng - 0.0018,
          phone: '081577665544',
          isOnline: true,
        ),
      ];

      emit(
        state.copyWith(
          status: PanicStatus.loaded,
          userLatitude: lat,
          userLongitude: lng,
          fullAddress: fullAddress,
          nearbyMembers: members,
          localLeaders: leaders,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PanicStatus.loaded,
          userLatitude: lat,
          userLongitude: lng,
          fullAddress: fullAddress,
        ),
      );
    }
  }

  Future<void> _onSendAlert(
    SendPanicAlertEvent event,
    Emitter<PanicState> emit,
  ) async {
    emit(state.copyWith(status: PanicStatus.sending, errorMessage: null));

    try {
      final result = await sendPanicAlertUsecase.call(
        latitude: state.userLatitude,
        longitude: state.userLongitude,
        selectedMemberId: event.selectedMemberId,
        note: event.note,
      );

      emit(state.copyWith(status: PanicStatus.success, lastResult: result));
    } catch (e) {
      emit(
        state.copyWith(
          status: PanicStatus.error,
          errorMessage: 'Gagal mengirimkan bantuan: $e',
        ),
      );
    }
  }
}
