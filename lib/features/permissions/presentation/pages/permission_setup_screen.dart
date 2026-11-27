import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/presentation/bloc/permission_onboarding_bloc/permission_onboarding_bloc.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_action_footer.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_completed_view.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_progress_header.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_seamless_background.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_step_content.dart';
import 'package:akar/features/survey/data/datasources/survey_local_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Sequential mandatory permission onboarding wizard gated before app shells.
class PermissionSetupScreen extends StatefulWidget {
  const PermissionSetupScreen({super.key});

  @override
  State<PermissionSetupScreen> createState() => _PermissionSetupScreenState();
}

class _PermissionSetupScreenState extends State<PermissionSetupScreen>
    with WidgetsBindingObserver {
  bool _hasDispatchedCompletion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final authState = context.read<AuthBloc>().state;
    final isOfficer = authState is AuthAuthenticated
        ? authState.user.isOfficer
        : (authState.user?.isOfficer ?? false);
    context.read<PermissionOnboardingBloc>().add(
      LoadPermissionsEvent(isOfficer: isOfficer),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<PermissionOnboardingBloc>().add(
        const RefreshPermissionsEvent(),
      );
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Keluar dari Akun?',
      message:
          'Anda perlu masuk kembali dan menyelesaikan pengaturan izin untuk menggunakan aplikasi.',
      confirmText: 'Keluar',
      cancelText: 'Batal',
      isDestructive: true,
    );
    if (!mounted || !confirmed) return;
    context.read<TrackingBloc>().add(StopTrackingEvent());
    context.read<AuthBloc>().add(const LogoutEvent());
  }

  void _scheduleCompletionFallback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final router = GoRouter.maybeOf(context);
      if (router == null) return;

      final currentPath = router.routerDelegate.currentConfiguration.uri.path;
      if (currentPath != AppRouter.permissionSetupPath) return;

      final authState = context.read<AuthBloc>().state;
      final currentUser =
          authState is AuthAuthenticated ? authState.user : null;
      final hasCompletedSurvey =
          currentUser != null &&
          (currentUser.hasCompletedInitialQuiz ||
              (sl.isRegistered<SurveyLocalDatasource>() &&
                  sl<SurveyLocalDatasource>().isInitialSurveyCompletedSync(
                    currentUser.id,
                  )));

      final target = AppRouter.resolveRedirect(
        authState: authState,
        location: currentPath,
        hasAllPermissions: true,
        hasCompletedSurvey: hasCompletedSurvey,
      );
      if (target != null && target != currentPath) {
        router.go(target);
      }
    });
  }

  void _handlePrimaryAction(PermissionStepStatus status) {
    final bloc = context.read<PermissionOnboardingBloc>();
    if (status.requiresSettings) {
      bloc.add(const OpenPermissionSettingsEvent());
      return;
    }
    bloc.add(const RequestCurrentPermissionEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(child: PermissionSeamlessBackground()),
            SafeArea(
              child:
                  BlocConsumer<
                    PermissionOnboardingBloc,
                    PermissionOnboardingState
                  >(
                    listenWhen: (previous, current) =>
                        current is PermissionOnboardingLoaded &&
                        current.isCompleted &&
                        !_hasDispatchedCompletion,
                    listener: (context, state) {
                      if (state is PermissionOnboardingLoaded &&
                          state.isCompleted &&
                          !_hasDispatchedCompletion) {
                        _hasDispatchedCompletion = true;
                        if (state.isOfficer) {
                          context.read<TrackingBloc>().add(
                            const StartTrackingEvent(),
                          );
                        }
                        _scheduleCompletionFallback();
                      }
                    },
                    builder: (context, state) {
                      if (state is! PermissionOnboardingLoaded) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  color: colors.primary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Memeriksa izin aplikasi...',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 480,
                                ),
                                child: PermissionProgressHeader(
                                  currentStepNumber: state.activeStepIndex + 1,
                                  totalSteps: state.steps.length,
                                  steps: state.steps,
                                  statuses: state.statuses,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final illustrationHeight =
                                    (constraints.maxHeight * 0.42).clamp(
                                      130.0,
                                      220.0,
                                    );
                                final minHeight = (constraints.maxHeight - 24)
                                    .clamp(0.0, double.infinity);

                                return SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: minHeight,
                                    ),
                                    child: Center(
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 480,
                                        ),
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 260,
                                          ),
                                          switchInCurve: Curves.easeOutCubic,
                                          switchOutCurve: Curves.easeInCubic,
                                          transitionBuilder:
                                              (child, animation) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: const Offset(
                                                        0.04,
                                                        0,
                                                      ),
                                                      end: Offset.zero,
                                                    ).animate(animation),
                                                    child: child,
                                                  ),
                                                );
                                              },
                                          child: state.isCompleted
                                              ? const PermissionCompletedView(
                                                  key: ValueKey(
                                                    'permissions_completed',
                                                  ),
                                                )
                                              : PermissionStepContent(
                                                  key: ValueKey(
                                                    state.currentStep.type,
                                                  ),
                                                  spec: state.currentStep,
                                                  status: state.currentStatus,
                                                  illustrationHeight:
                                                      illustrationHeight,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (!state.isCompleted)
                            PermissionActionFooter(
                              spec: state.currentStep,
                              status: state.currentStatus,
                              isRequesting: state.isRequesting,
                              onPrimaryPressed: () =>
                                  _handlePrimaryAction(state.currentStatus),
                              onRefreshPressed: () => context
                                  .read<PermissionOnboardingBloc>()
                                  .add(const RefreshPermissionsEvent()),
                              onLogoutPressed: _handleLogout,
                            )
                          else
                            const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
