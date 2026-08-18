part of 'tracking_bloc.dart';

class TrackingState extends Equatable {
  final bool isTrackingActive;
  final int intervalSeconds;
  final double? lastLatitude;
  final double? lastLongitude;
  final DateTime? lastSentTime;
  final bool lastSuccess;
  final String? lastMessage;
  final bool isSending;

  const TrackingState({
    this.isTrackingActive = false,
    this.intervalSeconds = 900,
    this.lastLatitude,
    this.lastLongitude,
    this.lastSentTime,
    this.lastSuccess = true,
    this.lastMessage,
    this.isSending = false,
  });

  TrackingState copyWith({
    bool? isTrackingActive,
    int? intervalSeconds,
    double? lastLatitude,
    double? lastLongitude,
    DateTime? lastSentTime,
    bool? lastSuccess,
    String? lastMessage,
    bool? isSending,
  }) {
    return TrackingState(
      isTrackingActive: isTrackingActive ?? this.isTrackingActive,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      lastLatitude: lastLatitude ?? this.lastLatitude,
      lastLongitude: lastLongitude ?? this.lastLongitude,
      lastSentTime: lastSentTime ?? this.lastSentTime,
      lastSuccess: lastSuccess ?? this.lastSuccess,
      lastMessage: lastMessage ?? this.lastMessage,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [
    isTrackingActive,
    intervalSeconds,
    lastLatitude,
    lastLongitude,
    lastSentTime,
    lastSuccess,
    lastMessage,
    isSending,
  ];
}
