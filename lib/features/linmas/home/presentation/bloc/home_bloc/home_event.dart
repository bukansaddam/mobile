part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class InitHomeEvent extends HomeEvent {}

class StartHomeTrackingEvent extends HomeEvent {}

class StopHomeTrackingEvent extends HomeEvent {}

class ChangeHomeIntervalEvent extends HomeEvent {
  final int intervalSeconds;

  const ChangeHomeIntervalEvent(this.intervalSeconds);

  @override
  List<Object?> get props => [intervalSeconds];
}

class CaptureHomeLocationEvent extends HomeEvent {}

class SelectHomeLocationEvent extends HomeEvent {
  final TrackedLocation location;

  const SelectHomeLocationEvent(this.location);

  @override
  List<Object?> get props => [location];
}

class ClearHomeSelectedLocationEvent extends HomeEvent {}

class ClearHomeLocationsEvent extends HomeEvent {}
