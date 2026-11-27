import 'dart:io';
import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
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
  final bool isScanning;

  const EktpScanStep({
    super.key,
    required this.entrance,
    required this.photo,
    required this.onClearPhoto,
    this.isScanning = false,
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLaserAnimation();
  }

  @override
  void didUpdateWidget(covariant EktpScanStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning != oldWidget.isScanning ||
        widget.photo?.path != oldWidget.photo?.path) {
      _syncLaserAnimation();
    }
  }

  void _syncLaserAnimation() {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.isScanning && widget.photo != null && !disableAnimations) {
      if (!_laserController.isAnimating) {
        _laserController.repeat(reverse: true);
      }
    } else if (_laserController.isAnimating || _laserController.value != 0) {
      _laserController.stop();
      _laserController.value = 0;
    }
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
                        child: _buildScannerCard(colors),
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
            child: _buildTips(colors),
          ),
          const SizedBox(height: 14),
          EntranceTransition(
            animation: widget.entrance,
            start: 0.6,
            end: 1,
            child: Column(
              children: [
                _buildNote(
                  colors,
                  Icons.info_outline_rounded,
                  'Foto e-KTP wajib diambil untuk melanjutkan pendaftaran',
                ),
                const SizedBox(height: 6),
                _buildNote(
                  colors,
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

  Widget _buildScannerCard(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: widget.photo == null
          ? _buildMockCard(colors)
          : _buildPhotoPreview(colors, widget.photo!),
    );
  }

  Widget _buildMockCard(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.infoLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.info.withValues(alpha: 0.35)),
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
                        color: colors.warningLight,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colors.warningBorder),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'REPUBLIK INDONESIA',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colors.info,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'NIK: • • • • • • • • • • • • • • • •',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colors.info,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nama: • • • • • • • • •',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 9,
                    color: colors.info,
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
              color: colors.borderStrong,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 28,
              color: colors.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPreview(AppColorScheme colors, File photo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            photo,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => ColoredBox(
              color: colors.surfaceElevated,
              child: Icon(
                Icons.broken_image_outlined,
                color: colors.textPrimary,
              ),
            ),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: colors.primary, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (widget.isScanning) ...[
            Positioned.fill(
              child: ColoredBox(color: colors.scrim),
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
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            colors.success,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Memindai data e-KTP...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: widget.onClearPhoto,
                tooltip: 'Hapus foto',
                style: IconButton.styleFrom(
                  backgroundColor: colors.surface,
                  foregroundColor: colors.error,
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTips(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTip(colors, 'Pencahayaan terang & tidak ada pantulan blitz'),
          _buildTip(colors, 'Seluruh 4 sudut e-KTP masuk ke dalam bingkai'),
          _buildTip(colors, 'Huruf NIK & Nama tidak tertutup jari tangan'),
          _buildTip(colors, 'Gunakan fisik e-KTP asli (bukan fotokopi)'),
        ],
      ),
    );
  }

  Widget _buildTip(AppColorScheme colors, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 15, color: colors.success),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                color: colors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(AppColorScheme colors, IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 13, color: colors.textHint),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              fontSize: 10.5,
              color: colors.textHint,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
