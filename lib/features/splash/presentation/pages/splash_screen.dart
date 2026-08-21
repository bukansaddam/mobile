import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _loadingController;

  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _logoController.forward();
    _navigateToNextScreen();
    _startStaggeredAnimations();
  }

  void _startStaggeredAnimations() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _textController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _loadingController.repeat();
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    final authBloc = context.read<AuthBloc>();

    // Trigger check auth
    if (authBloc.state is AuthInitial) {
      authBloc.add(CheckAuthStatusEvent());
    }

    // Pastikan splash setidaknya tampil 2.5 detik untuk animasi yang halus
    final minSplashDelay = Future.delayed(const Duration(milliseconds: 2500));

    // Tunggu hingga pengecekan AuthBloc selesai
    if (authBloc.state is AuthInitial || authBloc.state is AuthChecking) {
      try {
        await authBloc.stream
            .firstWhere(
              (state) => state is! AuthInitial && state is! AuthChecking,
            )
            .timeout(const Duration(seconds: 5));
      } catch (_) {
        // Fallback jika timeout
      }
    }

    await minSplashDelay;

    if (mounted) {
      final state = authBloc.state;
      if (state is AuthAuthenticated) {
        final isOfficer = state.user.isOfficer;
        if (isOfficer) {
          context.read<TrackingBloc>().add(StartTrackingEvent());
          context.goNamed('main');
        } else {
          context.read<TrackingBloc>().add(StopTrackingEvent());
          context.goNamed('masyarakatMain');
        }
      } else {
        context.read<TrackingBloc>().add(StopTrackingEvent());
        context.goNamed('login');
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/logo.webp',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.location_on_rounded,
                            size: 64,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFadeAnimation.value,
                    child: SlideTransition(
                      position: _textSlideAnimation,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              AnimatedBuilder(
                animation: _loadingController,
                builder: (context, child) {
                  return SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFadeAnimation.value * 0.6,
                    child: child,
                  );
                },
                child: Text(
                  'v${AppConstants.appVersion}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
