import 'package:akar/features/permissions/data/services/app_permission_service.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'permission_onboarding_event.dart';
part 'permission_onboarding_state.dart';

/// Pure event-driven BLoC orchestrating the sequential permission onboarding wizard.
class PermissionOnboardingBloc
    extends Bloc<PermissionOnboardingEvent, PermissionOnboardingState> {
  final AppPermissionService _permissionService;

  PermissionOnboardingBloc({
    required this._permissionService,
  }) : super(const PermissionOnboardingInitial()) {
    on<LoadPermissionsEvent>(_onLoadPermissions);
    on<RequestCurrentPermissionEvent>(_onRequestCurrentPermission);
    on<OpenPermissionSettingsEvent>(_onOpenPermissionSettings);
    on<RefreshPermissionsEvent>(_onRefreshPermissions);
  }

  Future<void> _onLoadPermissions(
    LoadPermissionsEvent event,
    Emitter<PermissionOnboardingState> emit,
  ) async {
    final currentState = state;
    if (currentState is PermissionOnboardingLoading) return;
    if (currentState is PermissionOnboardingLoaded && currentState.isRequesting) {
      return;
    }
    emit(const PermissionOnboardingLoading());

    final steps = _permissionService.stepsForRole(isOfficer: event.isOfficer);
    final statuses = await _permissionService.refreshStatuses(
      isOfficer: event.isOfficer,
    );

    emit(
      _buildLoadedState(
        isOfficer: event.isOfficer,
        steps: steps,
        statuses: statuses,
      ),
    );
  }

  Future<void> _onRequestCurrentPermission(
    RequestCurrentPermissionEvent event,
    Emitter<PermissionOnboardingState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PermissionOnboardingLoaded) return;
    if (currentState.isRequesting || currentState.isCompleted) return;

    emit(currentState.copyWith(isRequesting: true));

    final requestedType = currentState.currentStep.type;
    final resolvedStatus = await _permissionService.requestPermission(
      requestedType,
      isOfficer: currentState.isOfficer,
    );

    final updatedStatuses =
        Map<AppPermissionType, PermissionStepStatus>.from(currentState.statuses)
          ..addAll(_permissionService.cachedStatuses)
          ..[requestedType] = resolvedStatus;

    emit(
      _buildLoadedState(
        isOfficer: currentState.isOfficer,
        steps: currentState.steps,
        statuses: updatedStatuses,
      ),
    );
  }

  Future<void> _onOpenPermissionSettings(
    OpenPermissionSettingsEvent event,
    Emitter<PermissionOnboardingState> emit,
  ) async {
    await _permissionService.openAppSettings();
  }

  Future<void> _onRefreshPermissions(
    RefreshPermissionsEvent event,
    Emitter<PermissionOnboardingState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PermissionOnboardingLoaded) return;
    if (currentState.isRequesting) return;

    final statuses = await _permissionService.refreshStatuses(
      isOfficer: currentState.isOfficer,
    );

    emit(
      _buildLoadedState(
        isOfficer: currentState.isOfficer,
        steps: currentState.steps,
        statuses: statuses,
      ),
    );
  }

  PermissionOnboardingLoaded _buildLoadedState({
    required bool isOfficer,
    required List<PermissionStepSpec> steps,
    required Map<AppPermissionType, PermissionStepStatus> statuses,
  }) {
    final firstUngrantedIndex = steps.indexWhere(
      (step) => !(statuses[step.type]?.isGranted ?? false),
    );
    final isCompleted = firstUngrantedIndex == -1;
    final activeStepIndex = isCompleted
        ? (steps.isEmpty ? 0 : steps.length - 1)
        : firstUngrantedIndex;

    return PermissionOnboardingLoaded(
      isOfficer: isOfficer,
      steps: List<PermissionStepSpec>.unmodifiable(steps),
      statuses: Map<AppPermissionType, PermissionStepStatus>.unmodifiable(
        statuses,
      ),
      activeStepIndex: activeStepIndex,
      isRequesting: false,
      isCompleted: isCompleted,
    );
  }
}
