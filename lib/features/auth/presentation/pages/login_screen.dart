import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/entrance_transition.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/auth/presentation/widgets/sliding_pill_tab_bar.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';

import 'package:akar/utils/app_logger.dart';

class LoginScreen extends StatefulWidget {
  final String? role;

  const LoginScreen({super.key, this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  _LoginMethod _loginMethod = _LoginMethod.username;
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (e) {
      AppLogger.w('[LOGIN] Gagal meminta izin lokasi: $e');
    }
  }

  String? _validateIdentifier(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '${_loginMethod.fieldLabel} wajib diisi';

    switch (_loginMethod) {
      case _LoginMethod.nik:
        if (!RegExp(r'^\d{16}$').hasMatch(text)) {
          return 'NIK harus 16 digit angka';
        }
      case _LoginMethod.phone:
        if (!RegExp(r'^\d{10,15}$').hasMatch(text)) {
          return 'Nomor HP harus 10-15 digit angka';
        }
      case _LoginMethod.username:
        break;
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    await _requestLocationPermission();

    if (!mounted) return;
    context.read<AuthBloc>().add(
      LoginEvent(
        username: _identifierController.text.trim(),
        password: _passwordController.text,
        expectOfficer: widget.role == null ? null : widget.role == 'linmas',
      ),
    );
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Kembali',
          onPressed: _handleBack,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFF7FBF8), Colors.white],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 32.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    AppToast.showError(context, message: state.message);
                  } else if (state is AuthAuthenticated) {
                    final isOfficer = state.user.isOfficer;
                    if (isOfficer) {
                      context.read<TrackingBloc>().add(StartTrackingEvent());
                    } else {
                      context.read<TrackingBloc>().add(StopTrackingEvent());
                    }

                    AppToast.showSuccess(
                      context,
                      message: state.message ?? "Login berhasil!",
                    );

                    if (isOfficer) {
                      if (state.user.hasCompletedInitialQuiz) {
                        context.goNamed('main');
                      } else {
                        context.goNamed('initialSurvey');
                      }
                    } else {
                      context.goNamed('masyarakatMain');
                    }
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  final showRegister = widget.role != 'linmas';

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        EntranceTransition(
                          animation: _entranceController,
                          start: 0,
                          end: 0.35,
                          child: Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.asset(
                                  'assets/logo.webp',
                                  width: 60,
                                  height: 60,
                                  cacheWidth: 180,
                                  cacheHeight: 180,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.location_on_rounded,
                                        size: 44,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        EntranceTransition(
                          animation: _entranceController,
                          start: 0.06,
                          end: 0.41,
                          child: Text(
                            'Selamat Datang',
                            style: AppTextStyles.headlineLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),

                        EntranceTransition(
                          animation: _entranceController,
                          start: 0.12,
                          end: 0.47,
                          child: Text(
                            'Masuk ke akun Anda untuk melanjutkan',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 28),

                        EntranceTransition(
                          animation: _entranceController,
                          start: 0.16,
                          end: 0.52,
                          child: Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.07),
                                  blurRadius: 28,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                EntranceTransition(
                                  animation: _entranceController,
                                  start: 0.28,
                                  end: 0.58,
                                  child: SlidingPillTabBar(
                                    selectedIndex: _LoginMethod.values.indexOf(
                                      _loginMethod,
                                    ),
                                    tabs: [
                                      for (final method in _LoginMethod.values)
                                        PillTabItem(label: method.tabLabel),
                                    ],
                                    onTabSelected: (index) {
                                      final selectedMethod =
                                          _LoginMethod.values[index];
                                      if (selectedMethod == _loginMethod) {
                                        return;
                                      }
                                      _identifierController.clear();
                                      setState(
                                        () => _loginMethod = selectedMethod,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 22),

                                EntranceTransition(
                                  animation: _entranceController,
                                  start: 0.34,
                                  end: 0.64,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 240),
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
                                    child: KeyedSubtree(
                                      key: ValueKey(_loginMethod),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            _loginMethod.fieldLabel,
                                            style: AppTextStyles.labelLarge
                                                .copyWith(
                                                  color: AppColors.textPrimary,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: _identifierController,
                                            onTapOutside: (event) =>
                                                FocusManager
                                                    .instance
                                                    .primaryFocus
                                                    ?.unfocus(),
                                            keyboardType:
                                                _loginMethod ==
                                                    _LoginMethod.username
                                                ? TextInputType.text
                                                : TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            autofillHints:
                                                _loginMethod ==
                                                    _LoginMethod.username
                                                ? const [AutofillHints.username]
                                                : null,
                                            decoration: InputDecoration(
                                              hintText: _loginMethod.hint,
                                              prefixIcon: Icon(
                                                _loginMethod.icon,
                                                color: AppColors.grey600,
                                              ),
                                            ),
                                            validator: _validateIdentifier,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                EntranceTransition(
                                  animation: _entranceController,
                                  start: 0.4,
                                  end: 0.7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Kata Sandi',
                                        style: AppTextStyles.labelLarge
                                            .copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _passwordController,
                                        onTapOutside: (event) => FocusManager
                                            .instance
                                            .primaryFocus
                                            ?.unfocus(),
                                        obscureText: _isPasswordObscured,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        textInputAction: TextInputAction.done,
                                        autofillHints: const [
                                          AutofillHints.password,
                                        ],
                                        onFieldSubmitted: (_) {
                                          if (!isLoading) _handleLogin();
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Masukkan kata sandi',
                                          prefixIcon: const Icon(
                                            Icons.lock_outline,
                                            color: AppColors.grey600,
                                          ),
                                          suffixIcon: IconButton(
                                            tooltip: _isPasswordObscured
                                                ? 'Tampilkan kata sandi'
                                                : 'Sembunyikan kata sandi',
                                            icon: Icon(
                                              _isPasswordObscured
                                                  ? Icons
                                                        .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: AppColors.grey600,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordObscured =
                                                    !_isPasswordObscured;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Kata sandi wajib diisi';
                                          }
                                          if (value.length < 6) {
                                            return 'Kata sandi minimal 6 karakter';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 26),

                                EntranceTransition(
                                  animation: _entranceController,
                                  start: 0.46,
                                  end: 0.76,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _handleLogin,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    AppColors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text('Masuk'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (showRegister) ...[
                          const SizedBox(height: 20),
                          EntranceTransition(
                            animation: _entranceController,
                            start: 0.56,
                            end: 0.88,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                context.pushNamed('register');
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Belum memiliki akun? ',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      'Daftar Sekarang',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _LoginMethod {
  nik(
    tabLabel: 'NIK',
    fieldLabel: 'NIK',
    hint: 'Masukkan 16 digit NIK',
    icon: Icons.badge_outlined,
  ),
  phone(
    tabLabel: 'No. HP',
    fieldLabel: 'Nomor HP',
    hint: 'Masukkan nomor HP',
    icon: Icons.phone_outlined,
  ),
  username(
    tabLabel: 'Username',
    fieldLabel: 'Username',
    hint: 'Masukkan username',
    icon: Icons.person_outline,
  );

  const _LoginMethod({
    required this.tabLabel,
    required this.fieldLabel,
    required this.hint,
    required this.icon,
  });

  final String tabLabel;
  final String fieldLabel;
  final String hint;
  final IconData icon;
}
