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

class UpdateTrackingDataEvent extends TrackingEvent {
  final double? lastLatitude;
  final double? lastLongitude;
  final DateTime? lastSentTime;
  final bool lastSuccess;
  final String? lastMessage;
  final bool? isTrackingActive;

  const UpdateTrackingDataEvent({
    this.lastLatitude,
    this.lastLongitude,
    this.lastSentTime,
    this.lastSuccess = true,
    this.lastMessage,
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
      lastSentTime: sentTime,
      lastSuccess: map['lastSuccess'] as bool? ?? true,
      lastMessage: map['lastMessage'] as String?,
      isTrackingActive: map['isTrackingActive'] as bool?,
    );
  }

  @override
  List<Object?> get props => [
    lastLatitude,
    lastLongitude,
    lastSentTime,
    lastSuccess,
    lastMessage,
    isTrackingActive,
  ];
}
