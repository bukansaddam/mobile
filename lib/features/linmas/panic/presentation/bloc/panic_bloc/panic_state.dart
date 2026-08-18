part of 'panic_bloc.dart';

enum PanicStatus { initial, loading, loaded, sending, success, error }

class PanicState extends Equatable {
  final PanicStatus status;
  final double userLatitude;
  final double userLongitude;
  final String fullAddress;
  final List<NearbyMemberEntity> nearbyMembers;
  final List<NearbyMemberEntity> localLeaders;
  final PanicAlertResultEntity? lastResult;
  final String? errorMessage;

  const PanicState({
    this.status = PanicStatus.initial,
    this.userLatitude = -6.2088,
    this.userLongitude = 106.8456,
    this.fullAddress =
        'Jl. Medan Merdeka Barat No. 12, Gambir, Jakarta Pusat, DKI Jakarta',
    this.nearbyMembers = const [],
    this.localLeaders = const [],
    this.lastResult,
    this.errorMessage,
  });

  PanicState copyWith({
    PanicStatus? status,
    double? userLatitude,
    double? userLongitude,
    String? fullAddress,
    List<NearbyMemberEntity>? nearbyMembers,
    List<NearbyMemberEntity>? localLeaders,
    PanicAlertResultEntity? lastResult,
    String? errorMessage,
  }) {
    return PanicState(
      status: status ?? this.status,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      fullAddress: fullAddress ?? this.fullAddress,
      nearbyMembers: nearbyMembers ?? this.nearbyMembers,
      localLeaders: localLeaders ?? this.localLeaders,
      lastResult: lastResult ?? this.lastResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userLatitude,
    userLongitude,
    fullAddress,
    nearbyMembers,
    localLeaders,
    lastResult,
    errorMessage,
  ];
}
