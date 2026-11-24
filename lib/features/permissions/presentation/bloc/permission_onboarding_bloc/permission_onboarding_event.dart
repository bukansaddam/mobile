part of 'permission_onboarding_bloc.dart';

abstract class PermissionOnboardingEvent extends Equatable {
  const PermissionOnboardingEvent();

  @override
  List<Object?> get props => [];
}

class LoadPermissionsEvent extends PermissionOnboardingEvent {
  final bool isOfficer;

  const LoadPermissionsEvent({required this.isOfficer});

  @override
  List<Object?> get props => [isOfficer];
}

class RequestCurrentPermissionEvent extends PermissionOnboardingEvent {
  const RequestCurrentPermissionEvent();
}

class OpenPermissionSettingsEvent extends PermissionOnboardingEvent {
  const OpenPermissionSettingsEvent();
}

class RefreshPermissionsEvent extends PermissionOnboardingEvent {
  const RefreshPermissionsEvent();
}
