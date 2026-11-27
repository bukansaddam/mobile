import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_brand_logo.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/entrance_transition.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/auth/presentation/widgets/sliding_pill_tab_bar.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/permissions/data/services/app_permission_service.dart';

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
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _entranceController.dispose();
    super.dispose();
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

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      LoginEvent(
        username: _identifierController.text.trim(),
        password: _passwordController.text,
        expectOfficer: widget.role == null ? null : widget.role == 'linmas',
      ),
    );
  }

  String? get _roleTitle {
    switch (widget.role?.toLowerCase()) {
      case 'linmas':
        return 'Petugas Aslinmas';
      case 'masyarakat':
        return 'Masyarakat';
      default:
        return null;
    }
  }

  String get _subtitle {
    switch (widget.role?.toLowerCase()) {
      case 'linmas':
        return 'Akses operasional perlindungan masyarakat';
      case 'masyarakat':
        return 'Masuk untuk layanan aduan & informasi warga';
      default:
        return 'Masuk ke akun Anda untuk melanjutkan';
    }
  }

  AppBrandLogoVariant get _logoVariant {
    switch (widget.role?.toLowerCase()) {
      case 'masyarakat':
      case 'dumas':
        return AppBrandLogoVariant.dumas;
      case 'linmas':
        return AppBrandLogoVariant.linmas;
      default:
        return AppBrandLogoVariant.general;
    }
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
    final colors = context.appColors;
    final roleTitle = _roleTitle;

    return Scaffold(
      backgroundColor: colors.primaryLight,
      appBar: AppPageBar(
        title: roleTitle,
        transparentBackground: true,
        onBackPressed: _handleBack,
      ),
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
            stops: const [0.0, 0.35, 1.0],
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
                    final hasAllPermissions =
                        !sl.isRegistered<AppPermissionService>() ||
                        sl<AppPermissionService>()
                            .hasAllRequiredPermissionsSync(
                              isOfficer: isOfficer,
                            );

                    AppToast.showSuccess(
                      context,
                      message: state.message ?? "Login berhasil!",
                    );

                    if (!hasAllPermissions) {
                      context.read<TrackingBloc>().add(StopTrackingEvent());
                      context.goNamed(AppRouter.permissionSetup);
                      return;
                    }

                    if (isOfficer) {
                      context.read<TrackingBloc>().add(const StartTrackingEvent());
                      if (state.user.hasCompletedInitialQuiz) {
                        context.goNamed(AppRouter.main);
                      } else {
                        context.goNamed(AppRouter.initialSurvey);
                      }
                    } else {
                      context.read<TrackingBloc>().add(StopTrackingEvent());
                      context.goNamed(AppRouter.masyarakatMain);
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
                            child: AppBrandLogo(
                              variant: _logoVariant,
                              maxWidth: 168,
                              fallbackIconSize: 44,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        EntranceTransition(
                          animation: _entranceController,
                          start: 0.06,
                          end: 0.41,
                          child: Text(
                            'Selamat Datang',
                            style: AppTextStyles.headlineLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
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
                            _subtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textSecondary,
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
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: colors.isDark
                                  ? Border.all(color: colors.border)
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: colors.shadow,
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
                                                  color: colors.textPrimary,
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
                                                color: colors.textMuted,
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
                                              color: colors.textPrimary,
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
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: colors.textMuted,
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
                                              color: colors.textMuted,
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
                                        ? SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    colors.onPrimary,
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
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      'Daftar Sekarang',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: colors.primary,
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
