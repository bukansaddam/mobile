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
import 'package:akar/features/permissions/presentation/widgets/permission_progress_header.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_step_card.dart';
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.primaryLight,
                colors.surfaceVariant,
                colors.isDark ? colors.background : colors.surface,
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
          child: SafeArea(
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
                        context.read<TrackingBloc>().add(StartTrackingEvent());
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
                              CircularProgressIndicator(color: colors.primary),
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

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final minHeight = (constraints.maxHeight - 32).clamp(
                          0.0,
                          double.infinity,
                        );
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: minHeight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 480,
                                    ),
                                    child: PermissionProgressHeader(
                                      roleLabel: state.isOfficer
                                          ? 'Petugas Linmas'
                                          : 'Masyarakat',
                                      currentStepNumber:
                                          state.activeStepIndex + 1,
                                      totalSteps: state.steps.length,
                                      steps: state.steps,
                                      statuses: state.statuses,
                                      onLogoutPressed: _handleLogout,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 480,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 260,
                                        ),
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        transitionBuilder: (child, animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(0.04, 0),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: state.isCompleted
                                            ? Container(
                                                key: const ValueKey(
                                                  'permissions_completed',
                                                ),
                                                padding: const EdgeInsets.all(
                                                  28,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: colors.surface,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  border: Border.all(
                                                    color: colors.border,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      size: 48,
                                                      color: colors.success,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'Semua Izin Lengkap',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppTextStyles
                                                          .headlineSmall
                                                          .copyWith(
                                                            color: colors
                                                                .textPrimary,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Membuka halaman utama aplikasi...',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppTextStyles
                                                          .bodyMedium
                                                          .copyWith(
                                                            color: colors
                                                                .textSecondary,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : PermissionStepCard(
                                                key: ValueKey(
                                                  state.currentStep.type,
                                                ),
                                                spec: state.currentStep,
                                                status: state.currentStatus,
                                                isRequesting:
                                                    state.isRequesting,
                                                onPrimaryPressed: () =>
                                                    _handlePrimaryAction(
                                                      state.currentStatus,
                                                    ),
                                                onRefreshPressed: () => context
                                                    .read<
                                                      PermissionOnboardingBloc
                                                    >()
                                                    .add(
                                                      const RefreshPermissionsEvent(),
                                                    ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
