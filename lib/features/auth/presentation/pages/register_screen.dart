import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/entrance_transition.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/auth/presentation/widgets/ektp_scan_step.dart';
import 'package:akar/utils/app_logger.dart';

/// Pendaftaran masyarakat dalam satu halaman, empat langkah:
/// 1. foto e-KTP, 2. data kependudukan, 3. pembuatan akun, 4. review data.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _identityFormKey = GlobalKey<FormState>();
  final _accountFormKey = GlobalKey<FormState>();

  final _nikController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _entranceController;

  int _step = 0;
  File? _ktpPhoto;
  DateTime? _birthDate;
  double? _latitude;
  double? _longitude;
  bool _isPasswordObscured = true;

  static const _titles = [
    'Ambil Foto e-KTP',
    'Data Kependudukan',
    'Buat Akun Anda',
    'Review Data Pendaftaran',
  ];

  static const _subtitles = [
    'Posisikan e-KTP Anda di dalam bingkai agar sistem dapat membaca data '
        'identitas secara otomatis.',
    'Lengkapi data sesuai e-KTP Anda. Verifikasi otomatis akan aktif setelah '
        'layanan OCR tersedia.',
    'Lengkapi kontak aktif dan kata sandi untuk login ke aplikasi AKAR.',
    'Pastikan seluruh data kependudukan dan akun Anda sudah sesuai sebelum '
        'menyelesaikan pendaftaran.',
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _nikController.dispose();
    _nameController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step > 0 && _ktpPhoto == null) return;
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _entranceController.forward(from: 0);
  }

  void _handleBack() {
    if (_step > 0) {
      _goToStep(_step - 1);
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('login');
    }
  }

  void _continueToAccount() {
    if (_identityFormKey.currentState?.validate() != true) return;
    _goToStep(2);
  }

  void _continueToReview() {
    if (_accountFormKey.currentState?.validate() != true) return;
    _goToStep(3);
  }

  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppToast.showWarning(
            context,
            message: 'Layanan lokasi (GPS) belum aktif. Aktifkan GPS Anda.',
          );
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            AppToast.showError(context, message: 'Izin lokasi ditolak.');
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          AppToast.showError(
            context,
            message:
                'Izin lokasi ditolak secara permanen. Mohon ubah di Pengaturan.',
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      AppLogger.w('[REGISTER] Gagal mengambil lokasi otomatis: $e');
    }
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1995, 1, 1),
      firstDate: DateTime(1945),
      lastDate: DateTime.now(),
      helpText: 'Tanggal Lahir',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _birthDate = picked;
      _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }

  void _handleRegister() {
    FocusScope.of(context).unfocus();

    context.read<AuthBloc>().add(
      RegisterEvent(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        nik: _nikController.text.trim(),
        birthPlace: _birthPlaceController.text.trim(),
        birthDate: _birthDate == null
            ? ''
            : DateFormat('yyyy-MM-dd').format(_birthDate!),
        address: _addressController.text.trim(),
        latitude: _latitude ?? 0.0,
        longitude: _longitude ?? 0.0,
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goToStep(_step - 1);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5E9),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE8F5E9), Color(0xFFF7FBF8), Colors.white],
              stops: [0.0, 0.35, 1.0],
            ),
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                AppToast.showError(context, message: state.message);
              } else if (state is AuthAuthenticated) {
                AppToast.showSuccess(
                  context,
                  message: state.message ?? 'Registrasi berhasil!',
                );
                context.goNamed('masyarakatMain');
              } else if (state is RegisterSuccess) {
                AppDialogs.showSuccess(
                  context,
                  title: 'Registrasi Berhasil',
                  message: state.message.isNotEmpty
                      ? state.message
                      : 'Akun Anda telah berhasil dibuat. Silakan login untuk melanjutkan.',
                  buttonText: 'Masuk ke Akun',
                  onPressed: () {
                    context.goNamed('login');
                  },
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SafeArea(
                      top: false,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        layoutBuilder: (currentChild, previousChildren) =>
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [...previousChildren, ?currentChild],
                            ),
                        transitionBuilder: (child, animation) {
                          if (MediaQuery.of(context).disableAnimations) {
                            return child;
                          }
                          final curved = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                            reverseCurve: Curves.easeInCubic,
                          );
                          return FadeTransition(
                            opacity: curved,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.03),
                                end: Offset.zero,
                              ).animate(curved),
                              child: child,
                            ),
                          );
                        },
                        child: _buildStepBody(isLoading),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepBody(bool isLoading) {
    switch (_step) {
      case 1:
        return _buildIdentityStep();
      case 2:
        return _buildAccountStep();
      case 3:
        return _buildReviewStep(isLoading);
      default:
        return EktpScanStep(
          key: const ValueKey('ktp'),
          entrance: _entranceController,
          photo: _ktpPhoto,
          onPhotoPicked: (file) => setState(() => _ktpPhoto = file),
          onClearPhoto: () => setState(() => _ktpPhoto = null),
          onContinue: (_) => _goToStep(1),
        );
    }
  }

  Widget _buildHeader() {
    final progress = (_step + 1) / 4;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: IconButton(
              onPressed: _handleBack,
              tooltip: 'Kembali',
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF111827),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${_step + 1} of 4',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 4,
                      color: AppColors.primary,
                      backgroundColor: const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _titles[_step],
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _subtitles[_step],
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF4B5563),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityStep() {
    return SingleChildScrollView(
      key: const ValueKey('identity'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Form(
        key: _identityFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EntranceTransition(
              animation: _entranceController,
              start: 0.1,
              end: 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLabel('NIK (16 Digit)'),
                  TextFormField(
                    controller: _nikController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: _input(
                      '3201234567890001',
                    ).copyWith(counterText: ''),
                    validator: (val) {
                      final nik = val?.trim() ?? '';
                      if (nik.isEmpty) return 'NIK wajib diisi';
                      if (!RegExp(r'^\d{16}$').hasMatch(nik)) {
                        return 'NIK harus 16 digit angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Nama Lengkap Sesuai KTP'),
                  TextFormField(
                    controller: _nameController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    textCapitalization: TextCapitalization.words,
                    decoration: _input('SADDAM HUSSEIN'),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLabel('Tempat Lahir'),
                            TextFormField(
                              controller: _birthPlaceController,
                              onTapOutside: (_) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              textCapitalization: TextCapitalization.characters,
                              decoration: _input('JAKARTA'),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Wajib diisi'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLabel('Tanggal Lahir'),
                            TextFormField(
                              controller: _birthDateController,
                              readOnly: true,
                              onTap: _pickBirthDate,
                              decoration: _input('15/08/1995').copyWith(
                                suffixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              validator: (_) =>
                                  _birthDate == null ? 'Wajib diisi' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Alamat Lengkap Sesuai KTP'),
                  TextFormField(
                    controller: _addressController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    textCapitalization: TextCapitalization.characters,
                    minLines: 2,
                    maxLines: 3,
                    decoration: _input(
                      'JL. MERDEKA RAYA NO. 12, JAKARTA SELATAN',
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Alamat wajib diisi'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            EntranceTransition(
              animation: _entranceController,
              start: 0.4,
              end: 0.8,
              child: Text(
                'Anda dapat mengedit kolom di atas jika ada karakter yang '
                'belum sesuai.',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => _goToStep(0),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Foto kurang jelas? Pindai ulang e-KTP'),
              ),
            ),
            const SizedBox(height: 22),
            EntranceTransition(
              animation: _entranceController,
              start: 0.55,
              end: 0.95,
              child: _buildPrimaryButton(
                label: 'Lanjut ke Pembuatan Akun',
                onPressed: _continueToAccount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStep() {
    return SingleChildScrollView(
      key: const ValueKey('account'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Form(
        key: _accountFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EntranceTransition(
              animation: _entranceController,
              start: 0,
              end: 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLabel('Email Aktif'),
                  TextFormField(
                    controller: _emailController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    keyboardType: TextInputType.emailAddress,
                    decoration: _input('saddam.naradata@akar.co.id'),
                    validator: (val) {
                      final email = val?.trim() ?? '';
                      if (email.isEmpty) return 'Email wajib diisi';
                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Nomor WhatsApp'),
                  TextFormField(
                    controller: _phoneController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    keyboardType: TextInputType.phone,
                    decoration: _input('0812-3456-7890'),
                    validator: (val) {
                      final phone = (val ?? '').replaceAll(
                        RegExp(r'[\s-]'),
                        '',
                      );
                      if (phone.isEmpty) {
                        return 'Nomor WhatsApp wajib diisi';
                      }
                      if (!RegExp(r'^\+?\d{10,15}$').hasMatch(phone)) {
                        return 'Nomor WhatsApp harus 10-15 digit angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Username'),
                  TextFormField(
                    controller: _usernameController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: _input('saddam_naradata'),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Username wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Kata Sandi Akun'),
                  TextFormField(
                    controller: _passwordController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    obscureText: _isPasswordObscured,
                    decoration: _input('Minimal 6 karakter').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: const Color(0xFF94A3B8),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Kata sandi wajib diisi';
                      }
                      if (val.length < 6) {
                        return 'Kata sandi minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed('login');
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Sudah memiliki akun? Masuk di sini'),
              ),
            ),
            const SizedBox(height: 22),
            EntranceTransition(
              animation: _entranceController,
              start: 0.5,
              end: 0.95,
              child: _buildPrimaryButton(
                label: 'Tinjau Data Pendaftaran',
                onPressed: _continueToReview,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStep(bool isLoading) {
    return SingleChildScrollView(
      key: const ValueKey('review'),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EntranceTransition(
            animation: _entranceController,
            start: 0,
            end: 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_ktpPhoto != null) ...[
                  _buildKtpPreview(_ktpPhoto!),
                  const SizedBox(height: 16),
                ],
                _buildIdentitySummary(),
                const SizedBox(height: 16),
                _buildAccountSummary(),
                const SizedBox(height: 18),
                _buildSecurityPill(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => _goToStep(2),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                textStyle: AppTextStyles.caption.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Kembali untuk memeriksa ulang data'),
            ),
          ),
          const SizedBox(height: 22),
          EntranceTransition(
            animation: _entranceController,
            start: 0.5,
            end: 0.95,
            child: SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: isLoading ? null : _handleRegister,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Kirim & Buat Akun Sekarang',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKtpPreview(File photo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1.586,
        child: Image.file(
          photo,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const ColoredBox(
            color: Color(0xFF1E293B),
            child: Icon(Icons.broken_image_outlined, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentitySummary() {
    return _buildSummaryCard(
      headerIcon: Icons.badge_outlined,
      headerColor: const Color(0xFF15803D),
      header: 'DATA IDENTITAS e-KTP',
      editLabel: 'Ubah Data',
      onEdit: () => _goToStep(1),
      rows: [
        ('NIK', _nikController.text),
        ('Nama Lengkap', _nameController.text),
        (
          'Tempat, Tanggal Lahir',
          [
            _birthPlaceController.text,
            _birthDateController.text,
          ].where((value) => value.isNotEmpty).join(', '),
        ),
        ('Alamat KTP', _addressController.text),
      ],
    );
  }

  Widget _buildAccountSummary() {
    return _buildSummaryCard(
      headerIcon: Icons.person_outline_rounded,
      headerColor: const Color(0xFF2563EB),
      header: 'INFORMASI AKUN & KONTAK',
      editLabel: 'Ubah Akun',
      onEdit: () => _goToStep(2),
      rows: [
        (
          'Username',
          _usernameController.text.isEmpty
              ? ''
              : '@${_usernameController.text}',
        ),
        ('Email Aktif', _emailController.text),
        ('Nomor WhatsApp', _phoneController.text),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData headerIcon,
    required Color headerColor,
    required String header,
    required String editLabel,
    required VoidCallback onEdit,
    required List<(String, String)> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(headerIcon, size: 14, color: headerColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  header,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    color: headerColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  editLabel,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          for (final row in rows) ...[
            const SizedBox(height: 10),
            Text(
              row.$1,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              row.$2.isEmpty ? '-' : row.$2,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 15,
            color: Color(0xFF065F46),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Data Anda dienkripsi aman dan hanya digunakan untuk '
              'verifikasi identitas.',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF065F46),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodySmall.copyWith(
        fontSize: 13,
        color: const Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}
