import 'dart:async';
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_bar_circle_button.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/entrance_transition.dart';
import 'package:akar/features/auth/domain/entities/ktp_ocr_entity.dart';
import 'package:akar/features/auth/domain/entities/otp_challenge_entity.dart';
import 'package:akar/features/auth/domain/usecases/scan_ktp_usecase.dart';
import 'package:akar/features/auth/domain/usecases/send_register_otp_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/auth/presentation/pages/ktp_camera_page.dart';
import 'package:akar/features/auth/presentation/widgets/ektp_scan_step.dart';
import 'package:akar/utils/app_logger.dart';

/// Pendaftaran masyarakat dalam lima langkah:
/// 1. foto e-KTP, 2. data kependudukan, 3. pembuatan akun, 4. review data,
/// 5. verifikasi OTP WhatsApp.
class RegisterScreen extends StatefulWidget {
  @visibleForTesting
  final Future<File?> Function(ImageSource source)? photoPickerOverride;

  const RegisterScreen({super.key, this.photoPickerOverride});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _identityFormKey = GlobalKey<FormState>();
  final _accountFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  final _nikController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _otpController = TextEditingController();

  late final AnimationController _entranceController;

  int _step = 0;
  File? _ktpPhoto;
  DateTime? _birthDate;
  double? _latitude;
  double? _longitude;
  bool _isPasswordObscured = true;
  bool _isPasswordConfirmationObscured = true;
  bool _isScanningKtp = false;
  bool _isPickingPhoto = false;
  bool _isSendingOtp = false;
  OtpChallengeEntity? _otpChallenge;
  DateTime? _otpChallengeReceivedAt;
  DateTime? _resendAvailableAt;
  String? _otpPhone;
  Timer? _otpTimer;

  /// Cache OCR per foto: selama foto sama, server tidak dipanggil ulang.
  String? _ocrPhotoPath;
  KtpOcrEntity? _cachedOcr;
  bool _ocrPrompted = false;
  bool _ocrApplied = false;
  bool _allowManualWithoutOcr = false;
  int _ocrRequestId = 0;

  bool get _canAutoFill => _step == 1 && _cachedOcr != null && !_ocrApplied;

  static final _uppercaseFormatter = TextInputFormatter.withFunction(
    (oldValue, newValue) =>
        newValue.copyWith(text: newValue.text.toUpperCase()),
  );

  static const _titles = [
    'Ambil Foto e-KTP',
    'Data Kependudukan',
    'Buat Akun Anda',
    'Review Data Pendaftaran',
    'Verifikasi WhatsApp',
  ];

  static const _subtitles = [
    'Posisikan seluruh e-KTP di dalam bingkai. Data e-KTP akan dipindai otomatis setelah foto dipilih.',
    'Lengkapi data kependudukan sesuai e-KTP, lalu periksa kembali sebelum lanjut ke pembuatan akun.',
    'Lengkapi kontak aktif dan kata sandi untuk login ke aplikasi ${AppConstants.appName}.',
    'Pastikan seluruh data kependudukan dan akun Anda sudah sesuai sebelum menyelesaikan pendaftaran.',
    'Masukkan kode OTP yang kami kirim ke nomor WhatsApp Anda.',
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
    _otpTimer?.cancel();
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
    _passwordConfirmationController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  OtpChallengeEntity? get _validOtpChallenge {
    final challenge = _otpChallenge;
    if (challenge == null) return null;
    if (_otpPhone != null && _otpPhone != _phoneController.text.trim()) {
      return null;
    }
    return challenge;
  }

  DateTime? get _otpExpiresAt {
    final challenge = _validOtpChallenge;
    if (challenge == null) return null;
    if (challenge.expiresIn > 1000000000) {
      return DateTime.fromMillisecondsSinceEpoch(challenge.expiresIn * 1000);
    }
    if (_otpChallengeReceivedAt != null) {
      return _otpChallengeReceivedAt!.add(
        Duration(seconds: challenge.expiresIn),
      );
    }
    return DateTime.fromMillisecondsSinceEpoch(challenge.expiresIn * 1000);
  }

  bool get _isOtpExpired {
    final expiresAt = _otpExpiresAt;
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt);
  }

  int get _remainingResendSeconds {
    final availableAt = _resendAvailableAt;
    if (availableAt == null) return 0;
    final diff = availableAt.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  Duration get _remainingOtpDuration {
    final expiresAt = _otpExpiresAt;
    if (expiresAt == null) return Duration.zero;
    final diff = expiresAt.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  String get _formattedRemainingTime {
    final duration = _remainingOtpDuration;
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes menit ${seconds.toString().padLeft(2, '0')} detik';
    }
    return '$seconds detik';
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();
    if (_validOtpChallenge == null) return;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_isOtpExpired && _remainingResendSeconds <= 0) {
        timer.cancel();
      }
      setState(() {});
    });
  }

  void _goToStep(int step) {
    if (step > 0 && _ktpPhoto == null) return;
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _entranceController.forward(from: 0);
    if (step == 4) {
      _startOtpTimer();
    }
  }

  void _handleBack() {
    if (_step > 0) _goToStep(_step - 1);
  }

  bool get _hasEnteredData =>
      _ktpPhoto != null ||
      _nikController.text.trim().isNotEmpty ||
      _nameController.text.trim().isNotEmpty ||
      _birthPlaceController.text.trim().isNotEmpty ||
      _addressController.text.trim().isNotEmpty ||
      _emailController.text.trim().isNotEmpty ||
      _phoneController.text.trim().isNotEmpty ||
      _usernameController.text.trim().isNotEmpty ||
      _passwordController.text.isNotEmpty;

  Future<void> _handleClose() async {
    if (_hasEnteredData) {
      final leave = await AppDialogs.showConfirmation(
        context,
        title: 'Keluar dari Pendaftaran?',
        message:
            'Data yang sudah Anda isi akan hilang jika keluar sekarang. '
            'Yakin ingin kembali ke halaman login?',
        confirmText: 'Keluar',
        cancelText: 'Lanjut Isi',
        isDestructive: true,
      );
      if (!mounted || !leave) return;
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('login', queryParameters: {'role': 'masyarakat'});
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

  void _handleNext() {
    switch (_step) {
      case 0:
        if (_ktpPhoto != null) _handleContinueToIdentity();
      case 1:
        _continueToAccount();
      case 2:
        _continueToReview();
      case 3:
        if (_validOtpChallenge != null && !_isOtpExpired) {
          _goToStep(4);
        } else {
          _handleSendOtp();
        }
      case 4:
        if (!_isOtpExpired) {
          _handleVerifyOtp();
        }
    }
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
            message: 'Izin lokasi ditolak secara permanen. Mohon ubah di Pengaturan.',
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

  void _handlePhotoPicked(File file) {
    setState(() {
      _ktpPhoto = file;
      _allowManualWithoutOcr = false;
      _resetOcrCache();
    });
    unawaited(_scanSelectedKtp(file));
  }

  void _resetOcrCache() {
    _ocrPhotoPath = null;
    _cachedOcr = null;
    _ocrPrompted = false;
    _ocrApplied = false;
  }

  Future<void> _showPhotoSourceSheet() async {
    if (_isPickingPhoto || _isScanningKtp) return;
    final colors = context.appColors;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.photo_camera_outlined, color: colors.primary),
              title: const Text('Ambil dari Kamera'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: colors.primary,
              ),
              title: const Text('Ambil dari Galeri'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (!mounted || source == null) return;
    final override = widget.photoPickerOverride;
    if (override != null) {
      setState(() => _isPickingPhoto = true);
      try {
        final file = await override(source);
        if (!mounted || file == null) return;
        _handlePhotoPicked(file);
      } finally {
        if (mounted) setState(() => _isPickingPhoto = false);
      }
      return;
    }

    if (source == ImageSource.camera) {
      await _captureKtp();
    } else {
      await _pickKtpFromGallery();
    }
  }

  Future<void> _captureKtp() async {
    if (_isPickingPhoto) return;
    setState(() => _isPickingPhoto = true);
    try {
      final file = await KtpCameraPage.open(context);
      if (!mounted || file == null) return;
      _handlePhotoPicked(file);
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  Future<void> _pickKtpFromGallery() async {
    if (_isPickingPhoto) return;
    setState(() => _isPickingPhoto = true);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 2400,
      );
      if (!mounted || picked == null) return;

      final colors = context.appColors;
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 85.6, ratioY: 53.98),
        maxWidth: 1280,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Sesuaikan e-KTP',
            toolbarColor: colors.primary,
            toolbarWidgetColor: colors.onPrimary,
            lockAspectRatio: true,
            freeStyleCropEnabled: true,
          ),
          IOSUiSettings(
            title: 'Sesuaikan e-KTP',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );
      if (!mounted || cropped == null) return;
      _handlePhotoPicked(File(cropped.path));
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: 'Gagal mengambil foto e-KTP.');
      }
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  void _applyOcrResult(KtpOcrEntity ocr) {
    if (ocr.nik.isNotEmpty) _nikController.text = ocr.nik;
    if (ocr.name.isNotEmpty) _nameController.text = ocr.name.toUpperCase();
    if (ocr.birthPlace.isNotEmpty) {
      _birthPlaceController.text = ocr.birthPlace.toUpperCase();
    }
    if (ocr.birthDate != null) {
      _birthDate = ocr.birthDate;
      _birthDateController.text = DateFormat('dd/MM/yyyy')
          .format(ocr.birthDate!);
    }
    if (ocr.address.isNotEmpty) {
      _addressController.text = ocr.address.toUpperCase();
    }
  }

  Future<void> _scanSelectedKtp(File photo) async {
    final requestId = ++_ocrRequestId;
    setState(() => _isScanningKtp = true);

    final result = await sl<ScanKtpUsecase>()(photo);
    if (!mounted || requestId != _ocrRequestId || _ktpPhoto?.path != photo.path) {
      return;
    }

    setState(() => _isScanningKtp = false);

    result.fold(
      (failure) {
        final colors = context.appColors;
        if (failure is ValidationFailure) {
          _clearPhoto();
          unawaited(
            AppDialogs.showFailed(
              context,
              title: 'Foto Bukan e-KTP',
              message: failure.message,
              primaryButtonText: 'Ambil Foto Ulang',
              primaryButtonColor: colors.primary,
              onPrimaryPressed: () => unawaited(_showPhotoSourceSheet()),
              secondaryButtonText: 'Tutup',
            ),
          );
          return;
        }

        unawaited(
          AppDialogs.showFailed(
            context,
            title: 'Gagal Memindai e-KTP',
            message:
                '${failure.message} Anda dapat mencoba memindai ulang atau '
                'mengisi data secara manual.',
            primaryButtonText: 'Coba Scan Ulang',
            primaryButtonColor: colors.primary,
            onPrimaryPressed: () => unawaited(_scanSelectedKtp(photo)),
            secondaryButtonText: 'Lanjut Manual',
            onSecondaryPressed: () {
              if (!mounted) return;
              setState(() => _allowManualWithoutOcr = true);
              _goToStep(1);
            },
          ),
        );
      },
      (ocr) {
        setState(() {
          _ocrPhotoPath = photo.path;
          _cachedOcr = ocr;
          _ocrPrompted = false;
          _ocrApplied = false;
          _allowManualWithoutOcr = false;
        });
        _goToStep(1);
        unawaited(_promptApplyOcrAfterStepReady(ocr, photo.path));
      },
    );
  }

  Future<void> _promptApplyOcrAfterStepReady(
    KtpOcrEntity ocr,
    String photoPath,
  ) async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || _step != 1 || _ocrPhotoPath != photoPath) return;
    await _promptApplyOcr(ocr);
  }

  Future<void> _promptApplyOcr(KtpOcrEntity ocr) async {
    if (_ocrPrompted) return;
    _ocrPrompted = true;

    final apply = await AppDialogs.showConfirmation(
      context,
      title: 'Scan KTP Berhasil',
      message:
          'Apakah Anda ingin mengisi formulir secara otomatis dari hasil '
          'pemindaian e-KTP?',
      confirmText: 'Isi Otomatis',
      cancelText: 'Isi Manual',
      icon: Icons.document_scanner_outlined,
    );
    if (!mounted || !apply) return;

    setState(() {
      _applyOcrResult(ocr);
      _ocrApplied = true;
    });
    AppToast.showSuccess(
      context,
      message: 'Data e-KTP berhasil terbaca. Periksa kembali.',
    );
  }

  void _applyCachedOcr() {
    final ocr = _cachedOcr;
    if (ocr == null) return;

    setState(() {
      _applyOcrResult(ocr);
      _ocrApplied = true;
    });
    AppToast.showSuccess(
      context,
      message: 'Data e-KTP berhasil diisi. Periksa kembali.',
    );
  }

  void _handleContinueToIdentity() {
    final photo = _ktpPhoto;
    if (photo == null || _isScanningKtp) return;
    if (_cachedOcr != null && _ocrPhotoPath == photo.path) {
      _goToStep(1);
      if (!_ocrPrompted) {
        unawaited(_promptApplyOcrAfterStepReady(_cachedOcr!, photo.path));
      }
      return;
    }
    if (_allowManualWithoutOcr) {
      _goToStep(1);
      return;
    }
    unawaited(_scanSelectedKtp(photo));
  }

  void _clearPhoto() {
    if (_isScanningKtp) return;
    _ocrRequestId++;
    setState(() {
      _ktpPhoto = null;
      _allowManualWithoutOcr = false;
      _resetOcrCache();
    });
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

  Future<void> _handleSendOtp({bool force = false}) async {
    if (_isSendingOtp) return;
    if (force && _remainingResendSeconds > 0) {
      AppToast.showWarning(
        context,
        message:
            'Mohon tunggu $_remainingResendSeconds detik sebelum kirim ulang.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      AppToast.showWarning(context, message: 'Nomor WhatsApp belum diisi.');
      return;
    }

    setState(() => _isSendingOtp = true);
    final result = await sl<SendRegisterOtpUsecase>()(phoneNumber: phone);
    if (!mounted) return;
    setState(() => _isSendingOtp = false);

    result.fold(
      (failure) => AppToast.showError(context, message: failure.message),
      (challenge) {
        _otpController.clear();
        final now = DateTime.now();
        final cooldownSeconds = challenge.resendAfter > 0
            ? challenge.resendAfter
            : 60;
        setState(() {
          _otpPhone = phone;
          _otpChallenge = challenge;
          _otpChallengeReceivedAt = now;
          _resendAvailableAt = now.add(Duration(seconds: cooldownSeconds));
        });
        _startOtpTimer();
        if (_step != 4) {
          _goToStep(4);
        } else {
          AppToast.showSuccess(
            context,
            message: 'Kode OTP baru berhasil dikirim ke WhatsApp Anda.',
          );
        }
      },
    );
  }

  void _handleVerifyOtp() {
    if (_otpFormKey.currentState?.validate() != true) return;

    final challenge = _validOtpChallenge;
    final photo = _ktpPhoto;
    if (challenge == null || photo == null || _isOtpExpired) {
      AppToast.showWarning(
        context,
        message: 'Kode OTP telah kedaluwarsa. Silakan kirim ulang OTP.',
      );
      return;
    }

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
        passwordConfirmation: _passwordConfirmationController.text,
        otpChallengeToken: challenge.challengeToken,
        otpCode: _otpController.text.trim(),
        ktpPhoto: photo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goToStep(_step - 1);
      },
      child: Scaffold(
        backgroundColor: colors.primaryLight,
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
                  message: state.message.isNotEmpty ? state.message : 'Akun Anda telah berhasil dibuat. Silakan login untuk melanjutkan.',
                  buttonText: 'Masuk ke Akun',
                  onPressed: () {
                    context.goNamed(
                      'login',
                      queryParameters: {'role': 'masyarakat'},
                    );
                  },
                );
              }
            },
            builder: (context, state) {
              final isLoading =
                  state is AuthLoading || _isSendingOtp || _isScanningKtp;

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
                        child: _buildStepBody(),
                      ),
                    ),
                  ),
                  _buildBottomBar(isLoading),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepBody() {
    switch (_step) {
      case 1:
        return _buildIdentityStep();
      case 2:
        return _buildAccountStep();
      case 3:
        return _buildReviewStep();
      case 4:
        return _buildOtpStep();
      default:
        return EktpScanStep(
          key: const ValueKey('ktp'),
          entrance: _entranceController,
          photo: _ktpPhoto,
          onClearPhoto: _clearPhoto,
          isScanning: _isScanningKtp,
        );
    }
  }

  Widget _buildBottomBar(bool isLoading) {
    final isFirstStep = _step == 0;
    final hasPhoto = _ktpPhoto != null;

    final VoidCallback? onPrimary;
    if (isLoading) {
      onPrimary = null;
    } else if (isFirstStep && !hasPhoto) {
      onPrimary = _isPickingPhoto ? null : _showPhotoSourceSheet;
    } else if (_step == 3) {
      onPrimary = (_validOtpChallenge != null && !_isOtpExpired)
          ? _handleNext
          : _handleSendOtp;
    } else if (_step == 4) {
      onPrimary = (_validOtpChallenge == null || _isOtpExpired)
          ? null
          : _handleVerifyOtp;
    } else {
      onPrimary = _handleNext;
    }

    final primaryLabel = isFirstStep
        ? (hasPhoto ? 'Lanjut' : 'Ambil Gambar')
        : switch (_step) {
            3 =>
              (_validOtpChallenge != null && !_isOtpExpired)
                  ? 'Lanjut'
                  : 'Kirim',
            4 => 'Verifikasi',
            _ => 'Lanjut',
          };

    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (!isFirstStep || hasPhoto) ...[
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : (isFirstStep ? _showPhotoSourceSheet : _handleBack),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.borderStrong),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isFirstStep ? 'Ambil Ulang' : 'Kembali',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: onPrimary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colors.onPrimary,
                          ),
                        )
                      : Text(
                          primaryLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = context.appColors;
    final progress = (_step + 1) / _titles.length;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 16, top: 4),
            child: Row(
              children: [
                AppBarCircleButton.back(
                  tooltip: 'Kembali ke login',
                  onPressed: _handleClose,
                ),
                const Spacer(),
                if (_canAutoFill)
                  TextButton(
                    onPressed: _applyCachedOcr,
                    style: TextButton.styleFrom(
                      foregroundColor: colors.primary,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Isi Otomatis'),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${_step + 1} of ${_titles.length}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.textMuted,
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
                      color: colors.primary,
                      backgroundColor: colors.border,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _titles[_step],
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _subtitles[_step],
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13,
                    color: colors.textSecondary,
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
    final colors = context.appColors;
    return SingleChildScrollView(
      key: const ValueKey('identity'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
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
                    decoration: _input('Masukkan 16 digit NIK')
                        .copyWith(counterText: ''),
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
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [_uppercaseFormatter],
                    decoration: _input('Nama sesuai e-KTP'),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLabel('Tempat Lahir'),
                            TextFormField(
                              controller: _birthPlaceController,
                              onTapOutside: (_) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [_uppercaseFormatter],
                              decoration: _input('Kota/kabupaten'),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLabel('Tanggal Lahir'),
                            TextFormField(
                              controller: _birthDateController,
                              readOnly: true,
                              onTap: _pickBirthDate,
                              decoration: _input('Pilih tanggal').copyWith(
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: colors.textHint,
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
                    inputFormatters: [_uppercaseFormatter],
                    minLines: 2,
                    maxLines: 3,
                    decoration: _input('Alamat lengkap sesuai e-KTP'),
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
                  color: colors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStep() {
    final colors = context.appColors;
    return SingleChildScrollView(
      key: const ValueKey('account'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
                    decoration: _input('Alamat email aktif'),
                    validator: (val) {
                      final email = val?.trim() ?? '';
                      if (email.isEmpty) return 'Email wajib diisi';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
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
                    decoration: _input('Nomor WhatsApp aktif'),
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
                    decoration: _input('Username yang diinginkan'),
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
                    decoration: _input('Minimal 8 karakter').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: colors.textHint,
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
                      if (val.length < 8) {
                        return 'Kata sandi minimal 8 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Konfirmasi Kata Sandi'),
                  TextFormField(
                    controller: _passwordConfirmationController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    obscureText: _isPasswordConfirmationObscured,
                    decoration: _input('Ulangi kata sandi').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordConfirmationObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: colors.textHint,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordConfirmationObscured =
                                !_isPasswordConfirmationObscured;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Konfirmasi kata sandi wajib diisi';
                      }
                      if (val != _passwordController.text) {
                        return 'Konfirmasi kata sandi tidak cocok';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStep() {
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
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    final colors = context.appColors;
    final phone = _phoneController.text.trim();
    final isExpired = _isOtpExpired;
    final hasChallenge = _validOtpChallenge != null;
    final resendSeconds = _remainingResendSeconds;

    return SingleChildScrollView(
      key: const ValueKey('otp'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Form(
        key: _otpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EntranceTransition(
              animation: _entranceController,
              start: 0,
              end: 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.primaryBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 18,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kode OTP dikirim ke $phone',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Kode OTP'),
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                    decoration: _input('Masukkan kode')
                        .copyWith(counterText: ''),
                    validator: (val) {
                      final code = val?.trim() ?? '';
                      if (code.isEmpty) return 'Kode OTP wajib diisi';
                      if (!RegExp(r'^\d{4,6}$').hasMatch(code)) {
                        return 'Kode OTP tidak valid';
                      }
                      return null;
                    },
                  ),
                  if (hasChallenge && !isExpired) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Kode OTP masih berlaku $_formattedRemainingTime.',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ] else if (hasChallenge && isExpired) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 14,
                          color: colors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Kode OTP telah kedaluwarsa.',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Center(
                    child: resendSeconds > 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: colors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Kirim ulang kode dalam ${resendSeconds}s',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 12,
                                  color: colors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : TextButton.icon(
                            onPressed: _isSendingOtp
                                ? null
                                : () => _handleSendOtp(force: true),
                            icon: _isSendingOtp
                                ? SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colors.primary,
                                    ),
                                  )
                                : const Icon(Icons.refresh_rounded, size: 16),
                            label: Text(
                              _isSendingOtp
                                  ? 'Mengirim ulang...'
                                  : 'Kirim Ulang Kode OTP',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKtpPreview(File photo) {
    final colors = context.appColors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1.586,
        child: Image.file(
          photo,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => ColoredBox(
            color: colors.surfaceElevated,
            child: Icon(Icons.broken_image_outlined, color: colors.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentitySummary() {
    final colors = context.appColors;
    return _buildSummaryCard(
      headerIcon: Icons.badge_outlined,
      headerColor: colors.success,
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
    final colors = context.appColors;
    return _buildSummaryCard(
      headerIcon: Icons.person_outline_rounded,
      headerColor: colors.info,
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
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
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
                  foregroundColor: colors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  editLabel,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
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
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              row.$2.isEmpty ? '-' : row.$2,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityPill() {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.successLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.primaryBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 15, color: colors.primaryDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Data Anda dienkripsi aman dan hanya digunakan untuk '
              'verifikasi identitas.',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: text,
          children: [
            TextSpan(
              text: ' *',
              style: TextStyle(color: colors.error),
            ),
          ],
        ),
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: colors.textSecondary,
        ),
      ),
    );
  }

  InputDecoration _input(String hint) {
    final colors = context.appColors;
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodySmall.copyWith(
        fontSize: 13,
        color: colors.textHint,
      ),
      filled: true,
      fillColor: colors.surfaceElevated,
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
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.error, width: 1.5),
      ),
    );
  }
}
