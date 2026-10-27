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
  static const Duration _fadeOutDuration = Duration(milliseconds: 220);

  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;

  bool _leaving = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeOut);
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeOut);

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted && !MediaQuery.of(context).disableAnimations) {
        _pulseController.repeat(reverse: true);
      }
    });

    _navigateToNextScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _logoController.value = 1;
      _textController.value = 1;
    }
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

    if (!mounted) return;

    // Fade out sebelum pindah layar.
    if (!MediaQuery.of(context).disableAnimations) {
      setState(() => _leaving = true);
      await Future.delayed(_fadeOutDuration);
      if (!mounted) return;
    }

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
      context.goNamed('welcome');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 207, 240, 209),
              Color(0xFFF7FBF8),
              Colors.white,
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedOpacity(
            opacity: _leaving ? 0 : 1,
            duration: _fadeOutDuration,
            curve: Curves.easeIn,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoFade.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) => Transform.scale(
                        scale: 1 + 0.015 * _pulseController.value,
                        child: child,
                      ),
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              'assets/logo.webp',
                              width: 84,
                              height: 84,
                              cacheWidth: 252,
                              cacheHeight: 252,
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
                  ),

                  const SizedBox(height: 32),

                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      final progress = _textController.value;
                      return Opacity(
                        opacity: _textFade.value,
                        child: Transform.translate(
                          offset: Offset(0, 12 * (1 - progress)),
                          child: Text(
                            AppConstants.appName,
                            style: AppTextStyles.displayLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 20 + 8 * (1 - progress),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) =>
                        Opacity(opacity: _textFade.value, child: child),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        width: 96,
                        child: LinearProgressIndicator(
                          minHeight: 3,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.15,
                          ),
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) =>
                        Opacity(opacity: _textFade.value * 0.6, child: child),
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
        ),
      ),
    );
  }
}
