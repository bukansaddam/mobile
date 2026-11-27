import 'dart:async';

import 'package:akar/features/masyarakat/complaint/domain/entities/location_suggestion.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_address_from_latlng_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_current_location_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/get_location_suggestions_usecase.dart';
import 'package:akar/features/masyarakat/complaint/domain/usecases/search_coordinates_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_picker_event.dart';
part 'location_picker_state.dart';

class LocationPickerBloc
    extends Bloc<LocationPickerEvent, LocationPickerState> {
  final GetLocationSuggestionsUseCase getLocationSuggestionsUseCase;
  final GetAddressFromLatLngUseCase getAddressFromLatLngUseCase;
  final SearchCoordinatesUseCase searchCoordinatesUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  Timer? _debounceGeocodingTimer;
  Timer? _suggestionDebounceTimer;
  bool _isProgrammaticMove = false;

  LocationPickerBloc({
    required this.getLocationSuggestionsUseCase,
    required this.getAddressFromLatLngUseCase,
    required this.searchCoordinatesUseCase,
    required this.getCurrentLocationUseCase,
  }) : super(const LocationPickerState()) {
    on<LocationPickerInitialized>(_onInitialized);
    on<LocationPickerDetermineUserPosition>(_onDetermineUserPosition);
    on<LocationPickerTargetPositionUpdated>(_onTargetPositionUpdated);
    on<LocationPickerCameraIdle>(_onCameraIdle);
    on<LocationPickerFetchAddress>(_onFetchAddress);
    on<LocationPickerSearchTextChanged>(_onSearchTextChanged);
    on<LocationPickerFetchSuggestions>(_onFetchSuggestions);
    on<LocationPickerClearSuggestions>(_onClearSuggestions);
    on<LocationPickerSearchLocation>(_onSearchLocation);
    on<LocationPickerSuggestionSelected>(_onSuggestionSelected);
    on<LocationPickerClearAnimateTarget>(_onClearAnimateTarget);
    on<LocationPickerClearErrorMessage>(_onClearErrorMessage);
  }

  void _onInitialized(
    LocationPickerInitialized event,
    Emitter<LocationPickerState> emit,
  ) {
    final target = event.initialPosition ?? LocationPickerState.defaultLocation;
    final address =
        (event.initialAddress != null && event.initialAddress!.isNotEmpty)
        ? event.initialAddress!
        : 'Mendeteksi alamat lokasi...';

    emit(
      state.copyWith(
        targetPosition: target,
        selectedAddress: address,
        animateTarget: target,
      ),
    );

    add(const LocationPickerDetermineUserPosition());
  }

  Future<void> _onDetermineUserPosition(
    LocationPickerDetermineUserPosition event,
    Emitter<LocationPickerState> emit,
  ) async {
    emit(state.copyWith(isLocatingUser: true));

    final result = await getCurrentLocationUseCase();
    if (isClosed) return;
    result.fold(
      (failure) {
        emit(state.copyWith(isLocatingUser: false));
        add(LocationPickerFetchAddress(state.targetPosition));
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
        add(LocationPickerFetchAddress(position));
      },
    );
  }

  void _onTargetPositionUpdated(
    LocationPickerTargetPositionUpdated event,
    Emitter<LocationPickerState> emit,
  ) {
    emit(
      state.copyWith(
        targetPosition: event.position,
        suggestions: state.suggestions.isNotEmpty
            ? const []
            : state.suggestions,
      ),
    );
  }

  void _onCameraIdle(
    LocationPickerCameraIdle event,
    Emitter<LocationPickerState> emit,
  ) {
    emit(
      state.copyWith(
        targetPosition: event.currentPosition,
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
      if (!isClosed) {
        add(LocationPickerFetchAddress(event.currentPosition));
      }
    });
  }

  Future<void> _onFetchAddress(
    LocationPickerFetchAddress event,
    Emitter<LocationPickerState> emit,
  ) async {
    emit(state.copyWith(isLoadingAddress: true));

    final result = await getAddressFromLatLngUseCase(event.position);
    if (isClosed) return;
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingAddress: false,
            selectedAddress:
                'Lat: ${event.position.latitude.toStringAsFixed(6)}, Long: ${event.position.longitude.toStringAsFixed(6)}',
          ),
        );
      },
      (address) {
        emit(state.copyWith(isLoadingAddress: false, selectedAddress: address));
      },
    );
  }

  void _onSearchTextChanged(
    LocationPickerSearchTextChanged event,
    Emitter<LocationPickerState> emit,
  ) {
    _suggestionDebounceTimer?.cancel();
    final trimmed = event.query.trim();

    if (trimmed.length < 3) {
      if (state.suggestions.isNotEmpty || state.isLoadingSuggestions) {
        emit(
          state.copyWith(suggestions: const [], isLoadingSuggestions: false),
        );
      }
      return;
    }

    _suggestionDebounceTimer = Timer(const Duration(milliseconds: 450), () {
      if (!isClosed) {
        add(LocationPickerFetchSuggestions(trimmed));
      }
    });
  }

  Future<void> _onFetchSuggestions(
    LocationPickerFetchSuggestions event,
    Emitter<LocationPickerState> emit,
  ) async {
    emit(state.copyWith(isLoadingSuggestions: true));

    final result = await getLocationSuggestionsUseCase(event.query);
    if (isClosed) return;
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

  void _onClearSuggestions(
    LocationPickerClearSuggestions event,
    Emitter<LocationPickerState> emit,
  ) {
    emit(state.copyWith(suggestions: const []));
  }

  Future<void> _onSearchLocation(
    LocationPickerSearchLocation event,
    Emitter<LocationPickerState> emit,
  ) async {
    final trimmed = event.query.trim();
    if (trimmed.isEmpty) return;

    emit(state.copyWith(isSearching: true, clearErrorMessage: true));

    final result = await searchCoordinatesUseCase(trimmed);
    if (isClosed) return;
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
        add(LocationPickerFetchAddress(coordinates));
      },
    );
  }

  void _onSuggestionSelected(
    LocationPickerSuggestionSelected event,
    Emitter<LocationPickerState> emit,
  ) {
    final target = LatLng(
      event.suggestion.latitude,
      event.suggestion.longitude,
    );
    _isProgrammaticMove = true;
    emit(
      state.copyWith(
        targetPosition: target,
        animateTarget: target,
        selectedAddress: event.suggestion.displayName,
        isLoadingAddress: false,
        suggestions: const [],
      ),
    );
  }

  void _onClearAnimateTarget(
    LocationPickerClearAnimateTarget event,
    Emitter<LocationPickerState> emit,
  ) {
    emit(state.copyWith(clearAnimateTarget: true));
  }

  void _onClearErrorMessage(
    LocationPickerClearErrorMessage event,
    Emitter<LocationPickerState> emit,
  ) {
    emit(state.copyWith(clearErrorMessage: true));
  }

  @override
  Future<void> close() {
    _debounceGeocodingTimer?.cancel();
    _suggestionDebounceTimer?.cancel();
    return super.close();
  }
}
