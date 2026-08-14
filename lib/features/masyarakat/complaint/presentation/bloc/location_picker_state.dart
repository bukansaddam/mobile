import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/location_suggestion.dart';

class LocationPickerState extends Equatable {
  static const LatLng defaultLocation = LatLng(-6.175392, 106.827153);

  final LatLng targetPosition;
  final String selectedAddress;
  final bool isLoadingAddress;
  final bool isLocatingUser;
  final bool isSearching;
  final bool isLoadingSuggestions;
  final List<LocationSuggestion> suggestions;
  final String? errorMessage;
  final LatLng? animateTarget;

  const LocationPickerState({
    this.targetPosition = defaultLocation,
    this.selectedAddress = 'Mendeteksi alamat lokasi...',
    this.isLoadingAddress = false,
    this.isLocatingUser = false,
    this.isSearching = false,
    this.isLoadingSuggestions = false,
    this.suggestions = const [],
    this.errorMessage,
    this.animateTarget,
  });

  LocationPickerState copyWith({
    LatLng? targetPosition,
    String? selectedAddress,
    bool? isLoadingAddress,
    bool? isLocatingUser,
    bool? isSearching,
    bool? isLoadingSuggestions,
    List<LocationSuggestion>? suggestions,
    String? errorMessage,
    bool clearErrorMessage = false,
    LatLng? animateTarget,
    bool clearAnimateTarget = false,
  }) {
    return LocationPickerState(
      targetPosition: targetPosition ?? this.targetPosition,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isLoadingAddress: isLoadingAddress ?? this.isLoadingAddress,
      isLocatingUser: isLocatingUser ?? this.isLocatingUser,
      isSearching: isSearching ?? this.isSearching,
      isLoadingSuggestions: isLoadingSuggestions ?? this.isLoadingSuggestions,
      suggestions: suggestions ?? this.suggestions,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      animateTarget: clearAnimateTarget
          ? null
          : (animateTarget ?? this.animateTarget),
    );
  }

  @override
  List<Object?> get props => [
    targetPosition,
    selectedAddress,
    isLoadingAddress,
    isLocatingUser,
    isSearching,
    isLoadingSuggestions,
    suggestions,
    errorMessage,
    animateTarget,
  ];
}
