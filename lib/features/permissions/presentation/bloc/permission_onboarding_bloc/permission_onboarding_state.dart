part of 'permission_onboarding_bloc.dart';

abstract class PermissionOnboardingState extends Equatable {
  const PermissionOnboardingState();

  @override
  List<Object?> get props => [];
}

class PermissionOnboardingInitial extends PermissionOnboardingState {
  const PermissionOnboardingInitial();
}

class PermissionOnboardingLoading extends PermissionOnboardingState {
  const PermissionOnboardingLoading();
}

class PermissionOnboardingLoaded extends PermissionOnboardingState {
  final bool isOfficer;
  final List<PermissionStepSpec> steps;
  final Map<AppPermissionType, PermissionStepStatus> statuses;
  final int activeStepIndex;
  final bool isRequesting;
  final bool isCompleted;

  const PermissionOnboardingLoaded({
    required this.isOfficer,
    required this.steps,
    required this.statuses,
    required this.activeStepIndex,
    this.isRequesting = false,
    this.isCompleted = false,
  });

  PermissionStepSpec get currentStep => steps[activeStepIndex];

  PermissionStepStatus get currentStatus =>
      statuses[currentStep.type] ?? PermissionStepStatus.notRequested;

  int get grantedCount =>
      steps.where((step) => statuses[step.type]?.isGranted ?? false).length;

  PermissionOnboardingLoaded copyWith({
    bool? isOfficer,
    List<PermissionStepSpec>? steps,
    Map<AppPermissionType, PermissionStepStatus>? statuses,
    int? activeStepIndex,
    bool? isRequesting,
    bool? isCompleted,
  }) {
    return PermissionOnboardingLoaded(
      isOfficer: isOfficer ?? this.isOfficer,
      steps: List<PermissionStepSpec>.unmodifiable(steps ?? this.steps),
      statuses: Map<AppPermissionType, PermissionStepStatus>.unmodifiable(
        statuses ?? this.statuses,
      ),
      activeStepIndex: activeStepIndex ?? this.activeStepIndex,
      isRequesting: isRequesting ?? this.isRequesting,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        isOfficer,
        steps,
        statuses,
        activeStepIndex,
        isRequesting,
        isCompleted,
      ];
}
