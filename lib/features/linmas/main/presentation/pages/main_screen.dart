import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/custom_app_bar.dart';
import 'package:akar/features/ai_chat/presentation/widgets/ai_chat_floating_overlay.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/pages/activation_screen.dart';
import 'package:akar/features/linmas/analisis/presentation/pages/analisis_screen.dart';
import 'package:akar/features/linmas/home/presentation/pages/home_screen.dart';
import 'package:akar/features/linmas/home/presentation/widgets/tracking_config_modal.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_navigation_helper.dart';
import 'package:akar/features/profile/presentation/pages/linmas_profile_screen.dart';
import 'package:akar/features/linmas/panic/presentation/bloc/panic_bloc/panic_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final bool isExclusiveModeEnabled;
  final bool showNotificationButton;

  const MainScreen({
    super.key,
    this.isExclusiveModeEnabled = kDebugMode,
    this.showNotificationButton = true,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTabIndex = 0;
  int _logoTapCount = 0;
  DateTime? _lastLogoTapTime;

  bool get _isExclusiveModeActive =>
      kDebugMode && widget.isExclusiveModeEnabled;

  void _onLogoTap() {
    if (!_isExclusiveModeActive) return;

    final now = DateTime.now();
    if (_lastLogoTapTime != null &&
        now.difference(_lastLogoTapTime!).inSeconds > 3) {
      _logoTapCount = 0;
    }
    _lastLogoTapTime = now;
    _logoTapCount++;

    if (_logoTapCount >= 10) {
      _logoTapCount = 0;
      final colors = context.appColors;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.stars_rounded, color: colors.onPrimary),
              const SizedBox(width: 8),
              Text(
                'Mode Eksklusif: Membuka Pengaturan Tracking...',
                style: TextStyle(color: colors.onPrimary),
              ),
            ],
          ),
          backgroundColor: colors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      TrackingConfigModal.show(context);
    } else if (_logoTapCount >= 3) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mode Eksklusif: Tekan logo ASLINMAS $_logoTapCount/10 kali',
          ),
          duration: const Duration(milliseconds: 700),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _dismissSurveyIfSubmitted(BuildContext context) {
    final surveyBloc = context.read<SurveyBloc>();
    final state = surveyBloc.state;
    if (state is SurveyStatusLoadedState &&
        state.isSubmitted &&
        !state.isDismissed) {
      surveyBloc.add(const DismissSurveyCardEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        return Scaffold(
          backgroundColor: colors.background,
          floatingActionButton: BlocBuilder<PanicBloc, PanicState>(
            builder: (context, panicState) {
              final isEmergency = panicState.isEmergencyActive;
              return SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    _dismissSurveyIfSubmitted(context);
                    context.pushNamed('panic');
                  },
                  backgroundColor: colors.errorSolid,
                  foregroundColor: colors.onErrorSolid,
                  elevation: 6,
                  shape: const CircleBorder(),
                  child: Icon(
                    isEmergency
                        ? Icons.emergency_rounded
                        : Icons.warning_amber_rounded,
                    size: 30,
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: CustomAppBar.linmas(
            showNotificationButton: widget.showNotificationButton,
            onLogoTap: _isExclusiveModeActive ? _onLogoTap : null,
            onNotificationPressed: () {
              _dismissSurveyIfSubmitted(context);
              NotificationNavigationHelper.openNotificationCenter(context);
            },
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: colors.surface,
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'Home',
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.analytics_outlined,
                    label: 'Analisis',
                  ),
                  const SizedBox(width: 48),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.assignment_outlined,
                    label: 'Penugasan',
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.person_outline_rounded,
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              color: colors.background,
              child: user == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: 80,
                              color: colors.textHint,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sesi Pengguna Tidak Ditemukan',
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Silakan masuk terlebih dahulu untuk mengakses aplikasi.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => context.goNamed(
                                  'login',
                                  queryParameters: {'role': 'linmas'},
                                ),
                                icon: const Icon(Icons.login),
                                label: const Text('Masuk'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : AiChatFloatingOverlay(
                      onTap: () => AppRouter.toAiChat(context),
                      child: IndexedStack(
                        index: _currentTabIndex,
                        children: [
                          HomeScreen(
                            onNavigateToTab: (index) {
                              _dismissSurveyIfSubmitted(context);
                              setState(() {
                                _currentTabIndex = index;
                              });
                            },
                          ),
                          AnalisisScreen(
                            onNavigateToTab: (index) {
                              _dismissSurveyIfSubmitted(context);
                              setState(() {
                                _currentTabIndex = index;
                              });
                            },
                          ),
                          const ActivationScreen(),
                          const LinmasProfileScreen(),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final colors = context.appColors;
    final isSelected = _currentTabIndex == index;
    return InkWell(
      onTap: () {
        if (_currentTabIndex == 0 && index != 0) {
          _dismissSurveyIfSubmitted(context);
        }
        setState(() {
          _currentTabIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? colors.primary : colors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colors.primary : colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
