import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/location_suggestion.dart';
import '../../domain/usecases/get_address_from_latlng_usecase.dart';
import '../../domain/usecases/get_current_location_usecase.dart';
import '../../domain/usecases/get_location_suggestions_usecase.dart';
import '../../domain/usecases/search_coordinates_usecase.dart';
import 'location_picker_state.dart';

class LocationPickerCubit extends Cubit<LocationPickerState> {
  final GetLocationSuggestionsUseCase getLocationSuggestionsUseCase;
  final GetAddressFromLatLngUseCase getAddressFromLatLngUseCase;
  final SearchCoordinatesUseCase searchCoordinatesUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  Timer? _debounceGeocodingTimer;
  Timer? _suggestionDebounceTimer;
  bool _isProgrammaticMove = false;

  LocationPickerCubit({
    required this.getLocationSuggestionsUseCase,
    required this.getAddressFromLatLngUseCase,
    required this.searchCoordinatesUseCase,
    required this.getCurrentLocationUseCase,
  }) : super(const LocationPickerState());

  void init(LatLng? initialPosition, String? initialAddress) {
    final target = initialPosition ?? LocationPickerState.defaultLocation;
    final address = (initialAddress != null && initialAddress.isNotEmpty)
        ? initialAddress
        : 'Mendeteksi alamat lokasi...';

    emit(
      state.copyWith(
        targetPosition: target,
        selectedAddress: address,
        animateTarget: target,
      ),
    );

    determineUserPosition();
  }

  Future<void> determineUserPosition() async {
    emit(state.copyWith(isLocatingUser: true));

    final result = await getCurrentLocationUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(isLocatingUser: false));
        fetchAddress(state.targetPosition);
      },
      (position) {
        _isProgrammaticMove = true;
        emit(
          state.copyWith(
            isLocatingUser: false,
            targetPosition: position,
            animateTarget: position,
          ),
        );
        fetchAddress(position);
      },
    );
  }

  void updateTargetPosition(LatLng position) {
    emit(
      state.copyWith(
        targetPosition: position,
        suggestions: state.suggestions.isNotEmpty
            ? const []
            : state.suggestions,
      ),
    );
  }

  void onCameraIdle(LatLng currentPosition) {
    emit(
      state.copyWith(
        targetPosition: currentPosition,
        suggestions: state.suggestions.isNotEmpty
            ? const []
            : state.suggestions,
      ),
    );

    if (_isProgrammaticMove) {
      _isProgrammaticMove = false;
      return;
    }

    _debounceGeocodingTimer?.cancel();
    _debounceGeocodingTimer = Timer(const Duration(milliseconds: 400), () {
      fetchAddress(currentPosition);
    });
  }

  Future<void> fetchAddress(LatLng position) async {
    emit(state.copyWith(isLoadingAddress: true));

    final result = await getAddressFromLatLngUseCase(position);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingAddress: false,
            selectedAddress:
                'Lat: ${position.latitude.toStringAsFixed(6)}, Long: ${position.longitude.toStringAsFixed(6)}',
          ),
        );
      },
      (address) {
        emit(state.copyWith(isLoadingAddress: false, selectedAddress: address));
      },
    );
  }

  void onSearchTextChanged(String query) {
    _suggestionDebounceTimer?.cancel();
    final trimmed = query.trim();

    if (trimmed.length < 3) {
      if (state.suggestions.isNotEmpty || state.isLoadingSuggestions) {
        emit(
          state.copyWith(suggestions: const [], isLoadingSuggestions: false),
        );
      }
      return;
    }

    _suggestionDebounceTimer = Timer(const Duration(milliseconds: 450), () {
      fetchSuggestions(trimmed);
    });
  }

  Future<void> fetchSuggestions(String query) async {
    emit(state.copyWith(isLoadingSuggestions: true));

    final result = await getLocationSuggestionsUseCase(query);
    result.fold(
      (failure) {
        emit(
          state.copyWith(suggestions: const [], isLoadingSuggestions: false),
        );
      },
      (suggestionsList) {
        emit(
          state.copyWith(
            suggestions: suggestionsList,
            isLoadingSuggestions: false,
          ),
        );
      },
    );
  }

  void clearSuggestions() {
    emit(state.copyWith(suggestions: const []));
  }

  Future<void> searchLocation(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    emit(state.copyWith(isSearching: true, clearErrorMessage: true));

    final result = await searchCoordinatesUseCase(trimmed);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSearching: false,
            errorMessage: 'Lokasi tidak ditemukan. Coba kata kunci lain.',
          ),
        );
      },
      (coordinates) {
        _isProgrammaticMove = true;
        emit(
          state.copyWith(
            isSearching: false,
            targetPosition: coordinates,
            animateTarget: coordinates,
            suggestions: const [],
          ),
        );
        fetchAddress(coordinates);
      },
    );
  }

  void selectSuggestion(LocationSuggestion suggestion) {
    final target = LatLng(suggestion.latitude, suggestion.longitude);
    _isProgrammaticMove = true;
    emit(
      state.copyWith(
        targetPosition: target,
        animateTarget: target,
        selectedAddress: suggestion.displayName,
        isLoadingAddress: false,
        suggestions: const [],
      ),
    );
  }

  void clearAnimateTarget() {
    emit(state.copyWith(clearAnimateTarget: true));
  }

  void clearErrorMessage() {
    emit(state.copyWith(clearErrorMessage: true));
  }

  @override
  Future<void> close() {
    _debounceGeocodingTimer?.cancel();
    _suggestionDebounceTimer?.cancel();
    return super.close();
  }
}
