part of 'panic_bloc.dart';

abstract class PanicState extends Equatable {
  final bool isEmergencyActive;
  final double userLatitude;
  final double userLongitude;
  final String fullAddress;
  final List<NearbyMemberEntity> nearbyMembers;
  final List<NearbyMemberEntity> localLeaders;
  final PanicAlertResultEntity? lastResult;
  final String? errorMessage;

  const PanicState({
    this.isEmergencyActive = false,
    this.userLatitude = PanicConstants.defaultLatitude,
    this.userLongitude = PanicConstants.defaultLongitude,
    this.fullAddress = PanicConstants.defaultAddress,
    this.nearbyMembers = const [],
    this.localLeaders = const [],
    this.lastResult,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    isEmergencyActive,
    userLatitude,
    userLongitude,
    fullAddress,
    nearbyMembers,
    localLeaders,
    lastResult,
    errorMessage,
  ];
}

class PanicInitial extends PanicState {
  const PanicInitial() : super();
}

class PanicLoading extends PanicState {
  const PanicLoading({
    super.isEmergencyActive,
    super.userLatitude,
    super.userLongitude,
    super.fullAddress,
    super.nearbyMembers,
    super.localLeaders,
    super.lastResult,
  });
}

class PanicLoaded extends PanicState {
  const PanicLoaded({
    super.isEmergencyActive,
    super.userLatitude,
    super.userLongitude,
    super.fullAddress,
    super.nearbyMembers,
    super.localLeaders,
    super.lastResult,
  });
}

class PanicFailure extends PanicState {
  const PanicFailure(
    String errorMessage, {
    super.isEmergencyActive,
    super.userLatitude,
    super.userLongitude,
    super.fullAddress,
    super.nearbyMembers,
    super.localLeaders,
    super.lastResult,
  }) : super(errorMessage: errorMessage);

  @override
  List<Object?> get props => [...super.props, errorMessage];
}

class PanicActionLoading extends PanicState {
  const PanicActionLoading({
    super.isEmergencyActive,
    super.userLatitude,
    super.userLongitude,
    super.fullAddress,
    super.nearbyMembers,
    super.localLeaders,
    super.lastResult,
  });
}

class PanicActionSuccess extends PanicState {
  final String message;

  const PanicActionSuccess({
    required this.message,
    super.isEmergencyActive,
    super.userLatitude,
    super.userLongitude,
    super.fullAddress,
    super.nearbyMembers,
    super.localLeaders,
    super.lastResult,
  }) : super(errorMessage: null);

  @override
  List<Object?> get props => [...super.props, message];
}

class PanicActionFailure extends PanicState {
  const PanicActionFailure(
    String errorMessage, {
    super.isEmergencyActive,
    super.userLatitude,
    super.userLongitude,
    super.fullAddress,
    super.nearbyMembers,
    super.localLeaders,
    super.lastResult,
  }) : super(errorMessage: errorMessage);

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
