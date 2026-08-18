part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<TrackedLocation> locations;
  final TrackedLocation? selectedLocation;
  final bool isTrackingEnabled;
  final int intervalSeconds;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.locations = const [],
    this.selectedLocation,
    this.isTrackingEnabled = true,
    this.intervalSeconds = 10,
    this.isLoading = true,
    this.errorMessage,
  });

  HomeState copyWith({
    List<TrackedLocation>? locations,
    TrackedLocation? selectedLocation,
    bool clearSelectedLocation = false,
    bool? isTrackingEnabled,
    int? intervalSeconds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      locations: locations ?? this.locations,
      selectedLocation: clearSelectedLocation
          ? null
          : (selectedLocation ?? this.selectedLocation),
      isTrackingEnabled: isTrackingEnabled ?? this.isTrackingEnabled,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    locations,
    selectedLocation,
    isTrackingEnabled,
    intervalSeconds,
    isLoading,
    errorMessage,
  ];
}
