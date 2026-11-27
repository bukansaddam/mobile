part of 'location_picker_bloc.dart';

sealed class LocationPickerEvent extends Equatable {
  const LocationPickerEvent();

  @override
  List<Object?> get props => [];
}

class LocationPickerInitialized extends LocationPickerEvent {
  final LatLng? initialPosition;
  final String? initialAddress;

  const LocationPickerInitialized({this.initialPosition, this.initialAddress});

  @override
  List<Object?> get props => [initialPosition, initialAddress];
}

class LocationPickerDetermineUserPosition extends LocationPickerEvent {
  const LocationPickerDetermineUserPosition();
}

class LocationPickerTargetPositionUpdated extends LocationPickerEvent {
  final LatLng position;

  const LocationPickerTargetPositionUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

class LocationPickerCameraIdle extends LocationPickerEvent {
  final LatLng currentPosition;

  const LocationPickerCameraIdle(this.currentPosition);

  @override
  List<Object?> get props => [currentPosition];
}

class LocationPickerFetchAddress extends LocationPickerEvent {
  final LatLng position;

  const LocationPickerFetchAddress(this.position);

  @override
  List<Object?> get props => [position];
}

class LocationPickerSearchTextChanged extends LocationPickerEvent {
  final String query;

  const LocationPickerSearchTextChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class LocationPickerFetchSuggestions extends LocationPickerEvent {
  final String query;

  const LocationPickerFetchSuggestions(this.query);

  @override
  List<Object?> get props => [query];
}

class LocationPickerClearSuggestions extends LocationPickerEvent {
  const LocationPickerClearSuggestions();
}

class LocationPickerSearchLocation extends LocationPickerEvent {
  final String query;

  const LocationPickerSearchLocation(this.query);

  @override
  List<Object?> get props => [query];
}

class LocationPickerSuggestionSelected extends LocationPickerEvent {
  final LocationSuggestion suggestion;

  const LocationPickerSuggestionSelected(this.suggestion);

  @override
  List<Object?> get props => [suggestion];
}

class LocationPickerClearAnimateTarget extends LocationPickerEvent {
  const LocationPickerClearAnimateTarget();
}

class LocationPickerClearErrorMessage extends LocationPickerEvent {
  const LocationPickerClearErrorMessage();
}
