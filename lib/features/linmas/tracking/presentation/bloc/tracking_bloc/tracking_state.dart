part of 'tracking_bloc.dart';

class TrackingState extends Equatable {
  final bool isTrackingActive;
  final int intervalSeconds;
  final double? lastLatitude;
  final double? lastLongitude;
  final double? lastAccuracyMeters;
  final DateTime? lastSentTime;
  final bool lastSuccess;
  final String? lastMessage;
  final String? lastAnomalyCode;
  final bool isSending;

  const TrackingState({
    this.isTrackingActive = false,
    this.intervalSeconds = 900,
    this.lastLatitude,
    this.lastLongitude,
    this.lastAccuracyMeters,
    this.lastSentTime,
    this.lastSuccess = true,
    this.lastMessage,
    this.lastAnomalyCode,
    this.isSending = false,
  });

  bool get hasGpsAnomaly =>
      lastAnomalyCode != null && lastAnomalyCode!.trim().isNotEmpty;

  TrackingState copyWith({
    bool? isTrackingActive,
    int? intervalSeconds,
    double? lastLatitude,
    double? lastLongitude,
    double? lastAccuracyMeters,
    DateTime? lastSentTime,
    bool? lastSuccess,
    String? lastMessage,
    String? lastAnomalyCode,
    bool clearAnomaly = false,
    bool? isSending,
  }) {
    return TrackingState(
      isTrackingActive: isTrackingActive ?? this.isTrackingActive,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      lastLatitude: lastLatitude ?? this.lastLatitude,
      lastLongitude: lastLongitude ?? this.lastLongitude,
      lastAccuracyMeters: lastAccuracyMeters ?? this.lastAccuracyMeters,
      lastSentTime: lastSentTime ?? this.lastSentTime,
      lastSuccess: lastSuccess ?? this.lastSuccess,
      lastMessage: lastMessage ?? this.lastMessage,
      lastAnomalyCode: clearAnomaly
          ? null
          : (lastAnomalyCode ?? this.lastAnomalyCode),
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [
    isTrackingActive,
    intervalSeconds,
    lastLatitude,
    lastLongitude,
    lastAccuracyMeters,
    lastSentTime,
    lastSuccess,
    lastMessage,
    lastAnomalyCode,
    isSending,
  ];
}
