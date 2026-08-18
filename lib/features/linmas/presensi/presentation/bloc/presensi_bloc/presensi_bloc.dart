import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:akar/features/linmas/presensi/domain/entities/presensi_entity.dart';
import 'package:akar/features/linmas/presensi/domain/usecases/submit_presensi_usecase.dart';

part 'presensi_event.dart';
part 'presensi_state.dart';

class PresensiBloc extends Bloc<PresensiEvent, PresensiState> {
  final SubmitPresensiUsecase submitPresensiUsecase;

  PresensiBloc({required this.submitPresensiUsecase})
    : super(const PresensiState()) {
    on<InitPresensiLocationEvent>(_onInitLocation);
    on<UpdatePresensiFieldEvent>(_onUpdateField);
    on<SubmitPresensiEvent>(_onSubmitPresensi);
  }

  Future<void> _onInitLocation(
    InitPresensiLocationEvent event,
    Emitter<PresensiState> emit,
  ) async {
    final userName = event.userName.trim().isNotEmpty
        ? event.userName
        : state.userName;

    emit(
      state.copyWith(
        userName: userName,
        status: PresensiStatus.loadingLocation,
      ),
    );

    double lat = -6.2088;
    double lng = 106.8456;
    String kecamatan = 'Gambir';
    String kelurahan = 'Gambir';
    String address = 'Jl. Medan Merdeka Barat No. 12';
    String locationName = address;

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
            try {
              pos = await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.high,
                  timeLimit: Duration(seconds: 8),
                ),
              );
            } catch (_) {
              pos = await Geolocator.getLastKnownPosition();
            }
          }
        }
      } catch (_) {}

      if (pos != null) {
        lat = pos.latitude;
        lng = pos.longitude;
      }

      try {
        final geocoding = Geocoding();
        final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          kecamatan = place.locality ?? place.subAdministrativeArea ?? 'Gambir';
          kelurahan = place.subLocality ?? 'Gambir';

          final components = <String>[];
          if (place.street != null && place.street!.trim().isNotEmpty) {
            final s = place.street!.trim();
            if (!RegExp(r'-?\d+\.\d{3,}').hasMatch(s) && !s.contains('+')) {
              components.add(s);
            }
          } else if (place.thoroughfare != null &&
              place.thoroughfare!.trim().isNotEmpty) {
            components.add(place.thoroughfare!.trim());
          }

          if (place.subLocality != null &&
              place.subLocality!.trim().isNotEmpty) {
            components.add('Kel. ${place.subLocality!.trim()}');
          }

          if (place.locality != null && place.locality!.trim().isNotEmpty) {
            components.add('Kec. ${place.locality!.trim()}');
          }

          if (place.subAdministrativeArea != null &&
              place.subAdministrativeArea!.trim().isNotEmpty) {
            components.add(place.subAdministrativeArea!.trim());
          }

          if (place.administrativeArea != null &&
              place.administrativeArea!.trim().isNotEmpty) {
            components.add(place.administrativeArea!.trim());
          }

          if (place.postalCode != null && place.postalCode!.trim().isNotEmpty) {
            components.add(place.postalCode!.trim());
          }

          address = components.isNotEmpty
              ? components.join(', ')
              : 'Jl. Medan Merdeka Barat No. 12, Kel. Gambir, Kec. Gambir, Kota Jakarta Pusat, DKI Jakarta 10110';
          locationName = address;
        }
      } catch (_) {}

      emit(
        state.copyWith(
          status: PresensiStatus.loaded,
          userLatitude: lat,
          userLongitude: lng,
          kecamatan: kecamatan,
          kelurahan: kelurahan,
          address: address,
          locationName: locationName,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PresensiStatus.loaded,
          userLatitude: lat,
          userLongitude: lng,
        ),
      );
    }
  }

  void _onUpdateField(
    UpdatePresensiFieldEvent event,
    Emitter<PresensiState> emit,
  ) {
    emit(
      state.copyWith(
        rt: event.rt,
        rw: event.rw,
        kecamatan: event.kecamatan,
        kelurahan: event.kelurahan,
        address: event.address,
        isInsideWorkingArea: event.isInsideWorkingArea,
      ),
    );
  }

  Future<void> _onSubmitPresensi(
    SubmitPresensiEvent event,
    Emitter<PresensiState> emit,
  ) async {
    final currentType = state.presensiType;

    emit(state.copyWith(status: PresensiStatus.submitting, errorMessage: null));

    final dataEntity = PresensiDataEntity(
      userName: state.userName,
      address: state.address,
      kecamatan: state.kecamatan,
      kelurahan: state.kelurahan,
      rt: state.rt,
      rw: state.rw,
      latitude: state.userLatitude,
      longitude: state.userLongitude,
      timestamp: DateTime.now(),
    );

    final result = await submitPresensiUsecase.call(dataEntity);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: PresensiStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (dataResult) {
        emit(
          state.copyWith(
            status: PresensiStatus.success,
            lastResult: dataResult,
            lastSubmittedType: currentType,
            hasCheckedIn: !state.hasCheckedIn,
          ),
        );
      },
    );
  }
}
