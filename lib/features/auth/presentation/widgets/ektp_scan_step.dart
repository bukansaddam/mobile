import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/entrance_transition.dart';

/// Langkah 1 pendaftaran: ambil foto e-KTP.
///
/// OCR belum aktif (menunggu API), jadi foto hanya dipakai sebagai pratinjau.
class EktpScanStep extends StatefulWidget {
  final Animation<double> entrance;
  final File? photo;
  final ValueChanged<File> onPhotoPicked;
  final VoidCallback onClearPhoto;
  final ValueChanged<String> onContinue;

  const EktpScanStep({
    super.key,
    required this.entrance,
    required this.photo,
    required this.onPhotoPicked,
    required this.onClearPhoto,
    required this.onContinue,
  });

  @override
  State<EktpScanStep> createState() => _EktpScanStepState();
}

class _EktpScanStepState extends State<EktpScanStep>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();

  late final AnimationController _laserController;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.photo != null) _laserController.forward();
  }

  @override
  void didUpdateWidget(covariant EktpScanStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isNewPhoto =
        widget.photo != null && widget.photo!.path != oldWidget.photo?.path;
    if (isNewPhoto &&
        !(MediaQuery.maybeOf(context)?.disableAnimations ?? false)) {
      _laserController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    if (_isPicking) return;
    setState(() => _isPicking = true);

    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2000,
      );
      if (!mounted || file == null) return;
      widget.onPhotoPicked(File(file.path));
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: 'Gagal mengambil foto e-KTP.');
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EntranceTransition(
            animation: widget.entrance,
            start: 0,
            end: 0.5,
            child: _buildScannerCard(),
          ),
          const SizedBox(height: 20),
          EntranceTransition(
            animation: widget.entrance,
            start: 0.15,
            end: 0.65,
            child: _buildTips(),
          ),
          const SizedBox(height: 20),
          EntranceTransition(
            animation: widget.entrance,
            start: 0.35,
            end: 0.85,
            child: _buildActions(),
          ),
          const SizedBox(height: 14),
          EntranceTransition(
            animation: widget.entrance,
            start: 0.6,
            end: 1,
            child: Column(
              children: [
                _buildNote(
                  Icons.info_outline_rounded,
                  'Foto e-KTP wajib diambil untuk melanjutkan pendaftaran',
                ),
                const SizedBox(height: 6),
                _buildNote(
                  Icons.lock_outline_rounded,
                  'Data identitas Anda dienkripsi aman dan tidak dibagikan '
                  'ke pihak ketiga',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.586,
            child: widget.photo == null
                ? _buildMockCard()
                : _buildPhotoPreview(widget.photo!),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.photo == null
                      ? Icons.photo_camera_outlined
                      : Icons.check_circle_outline_rounded,
                  size: 15,
                  color: AppColors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.photo == null
                      ? 'Posisikan e-KTP di Sini'
                      : 'Foto e-KTP Siap',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF08A),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFDE047)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'REPUBLIK INDONESIA',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'NIK: 3 2 0 1 • • • • • • • • • •',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nama: S A D D A M   H • • •',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 9,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 56,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF94A3B8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 28,
              color: Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPreview(File photo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            photo,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const ColoredBox(
              color: Color(0xFF1E293B),
              child: Icon(Icons.broken_image_outlined, color: AppColors.white),
            ),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF22C55E), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _laserController,
              builder: (context, _) {
                final t = MediaQuery.of(context).disableAnimations
                    ? 0.5
                    : Curves.easeInOutCubic.transform(_laserController.value);
                return Align(
                  alignment: Alignment(0, -1 + 2 * t),
                  child: Container(
                    height: 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF4ADE80),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTip('Pencahayaan terang & tidak ada pantulan blitz'),
          _buildTip('Seluruh 4 sudut e-KTP masuk ke dalam bingkai'),
          _buildTip('Huruf NIK & Nama tidak tertutup jari tangan'),
          _buildTip('Gunakan fisik e-KTP asli (bukan fotokopi)'),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_rounded, size: 15, color: Color(0xFF16A34A)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                color: const Color(0xFF374151),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (widget.photo != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPrimaryButton(
            label: 'Lanjut ke Data Kependudukan',
            onPressed: () => widget.onContinue(widget.photo!.path),
          ),
          const SizedBox(height: 10),
          _buildSecondaryButton(
            label: 'Ambil Ulang Foto',
            onPressed: () => _pickPhoto(ImageSource.camera),
          ),
          TextButton(
            onPressed: widget.onClearPhoto,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF64748B),
              textStyle: AppTextStyles.caption.copyWith(fontSize: 12),
            ),
            child: const Text('Hapus Foto'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPrimaryButton(
          label: 'Ambil Foto Sekarang',
          onPressed: () => _pickPhoto(ImageSource.camera),
        ),
        const SizedBox(height: 10),
        _buildSecondaryButton(
          label: 'Unggah dari Galeri Foto',
          onPressed: () => _pickPhoto(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: _isPicking ? null : onPressed,
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

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 50,
      child: FilledButton(
        onPressed: _isPicking ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNote(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              fontSize: 10.5,
              color: const Color(0xFF94A3B8),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
