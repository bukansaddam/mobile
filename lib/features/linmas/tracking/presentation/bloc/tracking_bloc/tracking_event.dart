part of 'tracking_bloc.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class InitTrackingEvent extends TrackingEvent {}

class StartTrackingEvent extends TrackingEvent {
  final bool manual;

  const StartTrackingEvent({this.manual = false});

  @override
  List<Object?> get props => [manual];
}

class StopTrackingEvent extends TrackingEvent {}

class ChangeTrackingIntervalEvent extends TrackingEvent {
  final int intervalSeconds;

  const ChangeTrackingIntervalEvent(this.intervalSeconds);

  @override
  List<Object?> get props => [intervalSeconds];
}

class SendLocationNowEvent extends TrackingEvent {}

class ApplyCalibratedLocationEvent extends TrackingEvent {
  final double latitude;
  final double longitude;
  final double accuracyMeters;

  const ApplyCalibratedLocationEvent({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  @override
  List<Object?> get props => [latitude, longitude, accuracyMeters];
}

class SyncTrackingStatusEvent extends TrackingEvent {}

class GpsServiceStatusChangedEvent extends TrackingEvent {
  final bool isEnabled;

  const GpsServiceStatusChangedEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class UpdateTrackingDataEvent extends TrackingEvent {
  final double? lastLatitude;
  final double? lastLongitude;
  final double? lastAccuracyMeters;
  final DateTime? lastSentTime;
  final bool lastSuccess;
  final String? lastMessage;
  final String? lastAnomalyCode;
  final bool? isTrackingActive;

  const UpdateTrackingDataEvent({
    this.lastLatitude,
    this.lastLongitude,
    this.lastAccuracyMeters,
    this.lastSentTime,
    this.lastSuccess = true,
    this.lastMessage,
    this.lastAnomalyCode,
    this.isTrackingActive,
  });

  factory UpdateTrackingDataEvent.fromMap(Map<String, dynamic> map) {
    DateTime? sentTime;
    if (map['lastSentTime'] != null) {
      sentTime = DateTime.tryParse(map['lastSentTime'].toString());
    }
    return UpdateTrackingDataEvent(
      lastLatitude: (map['lastLatitude'] as num?)?.toDouble(),
      lastLongitude: (map['lastLongitude'] as num?)?.toDouble(),
      lastAccuracyMeters: (map['lastAccuracyMeters'] as num?)?.toDouble(),
      lastSentTime: sentTime,
      lastSuccess: map['lastSuccess'] as bool? ?? true,
      lastMessage: map['lastMessage'] as String?,
      lastAnomalyCode: map['lastAnomalyCode'] as String?,
      isTrackingActive: map['isTrackingActive'] as bool?,
    );
  }

  @override
  List<Object?> get props => [
    lastLatitude,
    lastLongitude,
    lastAccuracyMeters,
    lastSentTime,
    lastSuccess,
    lastMessage,
    lastAnomalyCode,
    isTrackingActive,
  ];
}
