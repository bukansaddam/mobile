import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/pages/activation_screen.dart';
import 'package:akar/features/linmas/analisis/presentation/pages/analisis_screen.dart';
import 'package:akar/features/linmas/home/presentation/pages/home_screen.dart';
import 'package:akar/features/linmas/home/presentation/widgets/notification_modal.dart';
import 'package:akar/features/linmas/profile/presentation/pages/profile_screen.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTabIndex = 0;
  bool _hasUnreadNotification = true;

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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        return Scaffold(
          backgroundColor: AppColors.background,
          floatingActionButton: SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              onPressed: () {
                _dismissSurveyIfSubmitted(context);
                context.pushNamed('panic');
              },
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(Icons.warning_amber_rounded, size: 30),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            foregroundColor: AppColors.textPrimary,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logo.webp',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.5,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'ASLINMAS',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_hasUnreadNotification) {
                            setState(() {
                              _hasUnreadNotification = false;
                            });
                          }
                          NotificationModalSheet.show(context);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.textPrimary,
                          size: 26,
                        ),
                        tooltip: 'Notifikasi Kegiatan',
                      ),
                      if (_hasUnreadNotification)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IgnorePointer(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: const Text(
                                '5',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: AppColors.white,
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
                    icon: Icons.flash_on_outlined,
                    label: 'Aktivasi',
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.15],
                ),
              ),
              child: user == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 80,
                              color: AppColors.grey400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sesi Pengguna Tidak Ditemukan',
                              style: AppTextStyles.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Silakan masuk terlebih dahulu untuk mengakses aplikasi.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => context.goNamed('login'),
                                    icon: const Icon(Icons.login),
                                    label: const Text('Masuk'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        context.goNamed('register'),
                                    icon: const Icon(Icons.person_add_outlined),
                                    label: const Text('Daftar'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : IndexedStack(
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
                        const AnalisisScreen(),
                        const ActivationScreen(),
                        const ProfileScreen(),
                      ],
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
              color: isSelected ? AppColors.primary : AppColors.grey500,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
