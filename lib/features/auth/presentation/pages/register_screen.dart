import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/entrance_transition.dart';
import 'package:akar/features/auth/domain/entities/ktp_ocr_entity.dart';
import 'package:akar/features/auth/domain/usecases/scan_ktp_usecase.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/auth/presentation/pages/ktp_camera_page.dart';
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
  final _passwordConfirmationController = TextEditingController();

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

  /// Cache OCR per foto: selama foto sama, server tidak dipanggil ulang.
  String? _ocrPhotoPath;
  KtpOcrEntity? _cachedOcr;
  bool _ocrPrompted = false;
  bool _ocrApplied = false;

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
  ];

  static const _subtitles = [
    'Posisikan seluruh e-KTP di dalam bingkai, lalu tekan Lanjut untuk memindai datanya.',
    'Lengkapi data kependudukan sesuai e-KTP, lalu periksa kembali sebelum lanjut ke pembuatan akun.',
    'Lengkapi kontak aktif dan kata sandi untuk login ke aplikasi AKAR.',
    'Pastikan seluruh data kependudukan dan akun Anda sudah sesuai sebelum menyelesaikan pendaftaran.',
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
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step > 0 && _ktpPhoto == null) return;
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _entranceController.forward(from: 0);
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

  void _handleNext() {
    switch (_step) {
      case 0:
        if (_ktpPhoto != null) _handleContinueToIdentity();
      case 1:
        _continueToAccount();
      case 2:
        _continueToReview();
      case 3:
        _handleRegister();
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

  void _handlePhotoPicked(File file) {
    setState(() {
      _ktpPhoto = file;
      _resetOcrCache();
    });
  }

  void _resetOcrCache() {
    _ocrPhotoPath = null;
    _cachedOcr = null;
    _ocrPrompted = false;
    _ocrApplied = false;
  }

  Future<void> _showPhotoSourceSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.white,
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
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Ambil dari Kamera'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.primary,
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

      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 85.6, ratioY: 53.98),
        maxWidth: 1280,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Sesuaikan e-KTP',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: AppColors.white,
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
      _birthDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(ocr.birthDate!);
    }
    if (ocr.address.isNotEmpty) {
      _addressController.text = ocr.address.toUpperCase();
    }
  }

  Future<void> _scanKtpInBackground() async {
    final photo = _ktpPhoto;
    if (photo == null) return;

    // Foto ini sudah pernah diproses: pakai cache, jangan panggil server lagi.
    if (_ocrPhotoPath == photo.path) {
      final ocr = _cachedOcr;
      if (ocr != null && !_ocrPrompted) await _promptApplyOcr(ocr);
      return;
    }

    if (_isScanningKtp) return;

    setState(() => _isScanningKtp = true);
    final result = await sl<ScanKtpUsecase>()(photo);
    if (!mounted) return;

    if (_ktpPhoto?.path != photo.path) {
      setState(() => _isScanningKtp = false);
      return;
    }

    final ocr = result.isRight ? result.right : null;
    final hasData =
        ocr != null &&
        (ocr.nik.isNotEmpty || ocr.name.isNotEmpty || ocr.address.isNotEmpty);

    setState(() {
      _isScanningKtp = false;
      _ocrPhotoPath = photo.path;
      _cachedOcr = hasData ? ocr : null;
    });

    // Bila user sudah pindah step, cache disimpan untuk dipakai saat kembali.
    if (hasData && _step == 1) await _promptApplyOcr(ocr);
  }

  Future<void> _promptApplyOcr(KtpOcrEntity ocr) async {
    if (_ocrPrompted) return;
    _ocrPrompted = true;

    final apply = await AppDialogs.showConfirmation(
      context,
      title: 'Data e-KTP Ditemukan',
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
    _goToStep(1);
    if (_ktpPhoto == null) return;
    _scanKtpInBackground();
  }

  void _clearPhoto() {
    setState(() {
      _ktpPhoto = null;
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
        passwordConfirmation: _passwordConfirmationController.text,
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
      default:
        return EktpScanStep(
          key: const ValueKey('ktp'),
          entrance: _entranceController,
          photo: _ktpPhoto,
          onClearPhoto: _clearPhoto,
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
    } else {
      onPrimary = _handleNext;
    }

    final primaryLabel = isFirstStep
        ? (hasPhoto ? 'Lanjut' : 'Ambil Gambar')
        : (_step == 3 ? 'Kirim' : 'Lanjut');

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
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
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.grey300),
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
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.white,
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
    final progress = (_step + 1) / 4;
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
                IconButton(
                  onPressed: _handleClose,
                  tooltip: 'Kembali ke login',
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                if (_canAutoFill)
                  TextButton(
                    onPressed: _applyCachedOcr,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
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
                    decoration: _input(
                      'Masukkan 16 digit NIK',
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
                  color: const Color(0xFF64748B),
                ),
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
                          color: const Color(0xFF94A3B8),
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
      child: Text.rich(
        TextSpan(
          text: text,
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.error),
            ),
          ],
        ),
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF374151),
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
