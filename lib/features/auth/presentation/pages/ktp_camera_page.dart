import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_toast.dart';

/// Halaman kamera in-app untuk memotret e-KTP dengan bingkai panduan.
///
/// `image_picker` memakai kamera bawaan OS sehingga overlay tidak mungkin
/// digambar. Halaman ini memakai plugin `camera` agar bingkai bisa ditampilkan.
class KtpCameraPage extends StatefulWidget {
  const KtpCameraPage({super.key});

  static Future<File?> open(BuildContext context) {
    return Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (_) => const KtpCameraPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<KtpCameraPage> createState() => _KtpCameraPageState();
}

class _KtpCameraPageState extends State<KtpCameraPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isReady = false;
  bool _isError = false;
  bool _isTaking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller = null;
      controller.dispose();
      if (mounted) setState(() => _isReady = false);
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _isError = true);
        return;
      }
      final back = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        back,
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );
      _controller = controller;
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _isReady = true);
    } catch (_) {
      if (mounted) setState(() => _isError = true);
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (_isTaking || controller == null || !controller.value.isInitialized) {
      return;
    }

    setState(() => _isTaking = true);
    try {
      final shot = await controller.takePicture();
      if (!mounted) return;

      final viewport = MediaQuery.sizeOf(context);
      final frame = computeKtpFrameRect(viewport);
      final cropped = await cropKtpImage(
        File(shot.path),
        viewport: viewport,
        frame: frame,
      );
      if (!mounted) return;

      Navigator.pop(context, cropped ?? File(shot.path));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isTaking = false);
      AppToast.showError(context, message: 'Gagal mengambil foto e-KTP.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: _buildPreview()),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final hole = computeKtpFrameRect(constraints.biggest);
                return CustomPaint(painter: _KtpFramePainter(hole: hole));
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _buildCircleButton(
                      icon: Icons.close_rounded,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'Foto e-KTP',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24, top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Posisikan seluruh e-KTP di dalam bingkai',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildShutter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final controller = _controller;
    if (_isError) {
      return Center(
        child: Text(
          'Kamera tidak tersedia',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
        ),
      );
    }
    if (!_isReady || controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      );
    }

    final previewSize = controller.value.previewSize;
    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize?.height ?? MediaQuery.of(context).size.width,
            height: previewSize?.width ?? MediaQuery.of(context).size.height,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildShutter() {
    return GestureDetector(
      onTap: _isTaking ? null : _capture,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 4),
        ),
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isTaking ? AppColors.grey400 : AppColors.white,
            ),
            child: _isTaking
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.4),
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: 'Tutup',
        icon: Icon(icon, color: AppColors.white, size: 22),
      ),
    );
  }
}

/// Rasio kartu e-KTP (85,6 mm x 53,98 mm).
const double ktpAspectRatio = 85.6 / 53.98;

/// Bingkai panduan di tengah layar.
///
/// Lebar mengikuti [widthFactor] layar, tetapi dibatasi agar tinggi bingkai
/// tidak melebihi 80% tinggi layar (mis. saat perangkat landscape).
Rect computeKtpFrameRect(
  Size size, {
  double widthFactor = 0.86,
  double aspectRatio = ktpAspectRatio,
}) {
  final width = math.min(
    size.width * widthFactor,
    size.height * 0.8 * aspectRatio,
  );
  final height = width / aspectRatio;
  return Rect.fromLTWH(
    (size.width - width) / 2,
    (size.height - height) / 2,
    width,
    height,
  );
}

/// Area gambar yang dipotong agar sesuai bingkai panduan.
///
/// Preview memakai `BoxFit.cover`, jadi bingkai di layar dipetakan dulu ke
/// koordinat piksel gambar sebelum dipotong.
Rect computeKtpCropRect({
  required Size imageSize,
  required Size viewport,
  required Rect frame,
  double margin = 1.08,
}) {
  final scale = math.max(
    viewport.width / imageSize.width,
    viewport.height / imageSize.height,
  );
  final visibleWidth = viewport.width / scale;
  final visibleHeight = viewport.height / scale;

  var width = math.min(frame.width * margin / scale, visibleWidth);
  var height = width / ktpAspectRatio;
  if (height > visibleHeight) {
    height = visibleHeight;
    width = height * ktpAspectRatio;
  }
  width = math.min(width, imageSize.width);
  height = math.min(height, imageSize.height);

  return Rect.fromLTWH(
    (imageSize.width - width) / 2,
    (imageSize.height - height) / 2,
    width,
    height,
  );
}

/// Memotong foto e-KTP sesuai bingkai, lalu mengecilkan dan mengompresnya.
///
/// Dijalankan di isolate terpisah agar UI tidak tersendat saat decode/encode.
/// Mengembalikan `null` bila gambar gagal dibaca; pemanggil memakai file asli.
Future<File?> cropKtpImage(
  File source, {
  required Size viewport,
  required Rect frame,
}) {
  return compute(_cropKtpImageTask, (
    source: source,
    viewport: viewport,
    frame: frame,
  ));
}

Future<File?> _cropKtpImageTask(
  ({File source, Size viewport, Rect frame}) args,
) async {
  try {
    var decoded = img.decodeImage(await args.source.readAsBytes());
    if (decoded == null) return null;
    decoded = img.bakeOrientation(decoded);

    final crop = computeKtpCropRect(
      imageSize: Size(decoded.width.toDouble(), decoded.height.toDouble()),
      viewport: args.viewport,
      frame: args.frame,
    );
    var result = img.copyCrop(
      decoded,
      x: crop.left.round(),
      y: crop.top.round(),
      width: crop.width.round(),
      height: crop.height.round(),
    );
    if (result.width > 1280) {
      result = img.copyResize(result, width: 1280);
    }

    final output = File(
      '${Directory.systemTemp.path}/ktp_'
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await output.writeAsBytes(img.encodeJpg(result, quality: 85));
    return output;
  } catch (_) {
    return null;
  }
}

class _KtpFramePainter extends CustomPainter {
  const _KtpFramePainter({required this.hole});

  final Rect hole;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(hole.width * 0.035);
    final scrim = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(hole, radius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      scrim,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(hole, radius),
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _KtpFramePainter oldDelegate) {
    return oldDelegate.hole != hole;
  }
}
