part of 'tracking_bloc.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class InitTrackingEvent extends TrackingEvent {}

class StartTrackingEvent extends TrackingEvent {}

class StopTrackingEvent extends TrackingEvent {}

class ChangeTrackingIntervalEvent extends TrackingEvent {
  final int intervalSeconds;

  const ChangeTrackingIntervalEvent(this.intervalSeconds);

  @override
  List<Object?> get props => [intervalSeconds];
}

class SendLocationNowEvent extends TrackingEvent {}

class SyncTrackingStatusEvent extends TrackingEvent {}
