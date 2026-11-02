import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/entrance_transition.dart';

/// Langkah 1 pendaftaran: pratinjau foto e-KTP.
///
/// Aksi ambil foto dikendalikan `RegisterScreen`; widget ini hanya menampilkan
/// pratinjau dan tombol hapus.
class EktpScanStep extends StatefulWidget {
  final Animation<double> entrance;
  final File? photo;
  final VoidCallback onClearPhoto;

  const EktpScanStep({
    super.key,
    required this.entrance,
    required this.photo,
    required this.onClearPhoto,
  });

  @override
  State<EktpScanStep> createState() => _EktpScanStepState();
}

class _EktpScanStepState extends State<EktpScanStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _laserController;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Lebar mengikuti layar; mengecil bila tinggi terbatas.
                final width = math.min(
                  constraints.maxWidth,
                  constraints.maxHeight * 1.586,
                );
                return Center(
                  child: SizedBox(
                    width: width,
                    child: AspectRatio(
                      aspectRatio: 1.586,
                      child: EntranceTransition(
                        animation: widget.entrance,
                        start: 0,
                        end: 0.5,
                        child: _buildScannerCard(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          EntranceTransition(
            animation: widget.entrance,
            start: 0.15,
            end: 0.65,
            child: _buildTips(),
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
      child: widget.photo == null
          ? _buildMockCard()
          : _buildPhotoPreview(widget.photo!),
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
                  'NIK: • • • • • • • • • • • • • • • •',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nama: • • • • • • • • •',
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
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: widget.onClearPhoto,
              tooltip: 'Hapus foto',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.error,
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
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
