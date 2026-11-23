import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/presensi/presentation/bloc/presensi_bloc/presensi_bloc.dart';

class PresensiScreen extends StatefulWidget {
  const PresensiScreen({super.key});

  @override
  State<PresensiScreen> createState() => _PresensiScreenState();
}

class _PresensiScreenState extends State<PresensiScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isCameraError = false;

  Timer? _timer;
  final ValueNotifier<DateTime> _currentTimeNotifier = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _startTimer();
    _initCamera();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      final userName = authState is AuthAuthenticated
          ? authState.user.name ?? 'Pengguna'
          : 'Pengguna';
      context.read<PresensiBloc>().add(
        InitPresensiLocationEvent(userName: userName),
      );
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _currentTimeNotifier.value = DateTime.now();
      }
    });
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final frontCam = _cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras.first,
        );

        _cameraController = CameraController(
          frontCam,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } else {
        if (mounted) setState(() => _isCameraError = true);
      }
    } catch (e) {
      if (mounted) setState(() => _isCameraError = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _currentTimeNotifier.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PresensiBloc, PresensiState>(
      listener: (context, state) {
        if (state.status == PresensiStatus.success) {
          _showSuccessPresensiDialog(context, state);
        } else if (state.status == PresensiStatus.failure) {
          try {
            if (_cameraController != null &&
                _cameraController!.value.isInitialized) {
              _cameraController!.resumePreview();
            }
          } catch (_) {}

          if (state.errorMessage != null) {
            AppToast.showError(context, message: state.errorMessage!);
          }
        }
      },
      builder: (context, state) {
        final colors = context.appColors;
        const camBg = Colors.black; // media-overlay
        const camFallbackTop = Color(0xFF1E2638); // media-overlay
        const camFallbackBottom = Color(0xFF0F141F); // media-overlay
        const camWhite = Colors.white; // media-overlay
        const camWhiteMuted = Colors.white70; // media-overlay
        const camScrim = Colors.black54; // media-overlay
        return Scaffold(
          backgroundColor: camBg,
          appBar: const AppPageBar(title: 'Perbarui Posisi'),
          body: Stack(
            children: [
              Positioned.fill(
                bottom: 90,
                child:
                    _isCameraInitialized &&
                        _cameraController != null &&
                        _cameraController!.value.isInitialized
                    ? ClipRect(
                        child: SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width:
                                  _cameraController!
                                      .value
                                      .previewSize
                                      ?.height ??
                                  MediaQuery.of(context).size.width,
                              height:
                                  _cameraController!.value.previewSize?.width ??
                                  MediaQuery.of(context).size.height,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [camFallbackTop, camFallbackBottom],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: camWhite.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_front_rounded,
                                  color: camWhiteMuted,
                                  size: 54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isCameraError
                                    ? 'Kamera tidak tersedia'
                                    : 'Membuka kamera...',
                                style: const TextStyle(
                                  color: camWhiteMuted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [camScrim, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, color: camWhite, size: 20),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<DateTime>(
                      valueListenable: _currentTimeNotifier,
                      builder: (context, currentTime, _) {
                        return Text(
                          DateFormat('HH:mm').format(currentTime),
                          style: const TextStyle(
                            color: camWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                blurRadius: 6,
                                color: camScrim,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              Positioned.fill(
                child: Align(
                  alignment: const Alignment(0, -0.55),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomPaint(
                        size: const Size(270, 270),
                        painter: CornerBracketPainter(
                          color: colors.primary,
                          strokeWidth: 4.0,
                          cornerLength: 32.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              state.hasCheckedIn
                                  ? Icons.logout_rounded
                                  : Icons.login_rounded,
                              color: colors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            state.presensiTypeTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Transform.rotate(
                            angle: 0.4,
                            child: Icon(
                              Icons.navigation_outlined,
                              color: colors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Lokasi GPS Terkini',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          if (state.status == PresensiStatus.loadingLocation)
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.primary,
                              ),
                            )
                          else
                            IconButton(
                              onPressed: () {
                                final authState = context
                                    .read<AuthBloc>()
                                    .state;
                                final userName = authState is AuthAuthenticated
                                    ? authState.user.name ?? 'Pengguna'
                                    : 'Pengguna';
                                context.read<PresensiBloc>().add(
                                  InitPresensiLocationEvent(userName: userName),
                                );
                              },
                              icon: Icon(
                                Icons.refresh_rounded,
                                color: colors.textSecondary,
                                size: 22,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: 'Refresh Location',
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      if (state.status == PresensiStatus.loadingLocation)
                        Text(
                          'Mendeteksi Koordinat GPS & Lokasi...',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        Text(
                          state.address,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            height: 1.35,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.status == PresensiStatus.submitting
                              ? null
                              : () async {
                                  final presensiBloc = context
                                      .read<PresensiBloc>();

                                  try {
                                    if (_cameraController != null &&
                                        _cameraController!
                                            .value
                                            .isInitialized) {
                                      await _cameraController!.pausePreview();
                                    }
                                  } catch (_) {}

                                  presensiBloc.add(SubmitPresensiEvent());
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: state.status == PresensiStatus.submitting
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: colors.onPrimary,
                                  ),
                                )
                              : Text(
                                  state.presensiTypeTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
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
        );
      },
    );
  }

  void _showSuccessPresensiDialog(BuildContext context, PresensiState state) {
    final colors = context.appColors;
    final result = state.lastResult;
    final isKeluar = state.lastSubmittedType == PresensiType.keluar;

    final detailContent = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderStrong),
      ),
      child: Column(
        children: [
          _buildDialogRow(context, 'Nama', result?.userName ?? '-'),
          const SizedBox(height: 6),
          _buildDialogRow(context, 'Tipe', state.lastSubmittedTypeTitle),
          const SizedBox(height: 6),
          _buildDialogRow(context, 'Lokasi', state.address),
          const SizedBox(height: 6),
          _buildDialogRow(
            context,
            'Waktu',
            DateFormat('dd MMM yyyy, HH:mm')
                .format(result?.timestamp ?? DateTime.now()),
          ),
        ],
      ),
    );

    if (isKeluar) {
      AppDialogs.showSuccess(
        context,
        title: 'Posisi Berhasil Diperbarui!',
        message: 'Bukti pembaruan posisi Anda telah tercatat pada sistem.',
        customContent: detailContent,
        buttonText: 'ISI LAPORAN HARIAN',
        buttonColor: colors.primary,
        onPressed: () {
          context.pushReplacementNamed('rondaMalam');
        },
        secondaryButtonText: 'KEMBALI KE HALAMAN UTAMA',
        onSecondaryPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      AppDialogs.showSuccess(
        context,
        title: 'Posisi Berhasil Diperbarui!',
        message: 'Bukti pembaruan posisi Anda telah tercatat pada sistem.',
        customContent: detailContent,
        buttonText: 'KEMBALI KE HALAMAN UTAMA',
        buttonColor: colors.primary,
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
  }

  Widget _buildDialogRow(BuildContext context, String label, String value) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: colors.textSecondary),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class CornerBracketPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;

  CornerBracketPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final w = size.width;
    final h = size.height;
    final l = cornerLength;

    canvas.drawLine(const Offset(0, 0), Offset(l, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, l), paint);

    canvas.drawLine(Offset(w, 0), Offset(w - l, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, l), paint);

    canvas.drawLine(Offset(0, h), Offset(l, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - l), paint);

    canvas.drawLine(Offset(w, h), Offset(w - l, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - l), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
