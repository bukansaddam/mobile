import 'dart:io';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';

class BankSampahDetailSheet extends StatelessWidget {
  final BankSampahReportEntity report;

  const BankSampahDetailSheet({super.key, required this.report});

  static Future<void> show(
    BuildContext context, {
    required BankSampahReportEntity report,
  }) {
    final colors = context.appColors;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => BankSampahDetailSheet(report: report),
    );
  }

  Color _getJenisColor(String jenis, AppColorScheme colors) {
    switch (jenis.toLowerCase()) {
      case 'organik':
        return colors.primary;
      case 'anorganik':
        return colors.info;
      case 'botol plastik':
        return colors.info;
      case 'kardus':
        return colors.warning;
      case 'kertas':
        return colors.indigo;
      case 'plastik kemasan':
        return colors.error;
      case 'campuran kering':
      default:
        return colors.success;
    }
  }

  IconData _getJenisIcon(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'organik':
        return Icons.eco_rounded;
      case 'anorganik':
        return Icons.recycling_rounded;
      case 'botol plastik':
        return Icons.local_drink_rounded;
      case 'kardus':
        return Icons.inventory_2_rounded;
      case 'kertas':
        return Icons.newspaper_rounded;
      case 'plastik kemasan':
        return Icons.shopping_bag_rounded;
      case 'campuran kering':
      default:
        return Icons.delete_sweep_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const photoOverlayBg = Color(0xA6000000); // media-overlay
    const photoOverlayFg = Color(0xFFFFFFFF); // media-overlay
    final heroText = colors.isDark ? colors.textPrimary : colors.onPrimary;
    final jenisColor = _getJenisColor(report.jenisSampah, colors);
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final hasLocalPhoto =
        report.fotoPath != null &&
        report.fotoPath!.isNotEmpty &&
        File(report.fotoPath!).existsSync();
    final photoUrl = report.displayPhotoUrl ?? report.fotoUrl;
    final hasUrlPhoto = photoUrl != null && photoUrl.isNotEmpty;
    final hasPhoto = hasLocalPhoto || hasUrlPhoto;
    final photoTarget = hasLocalPhoto
        ? report.fotoPath!
        : (hasUrlPhoto ? photoUrl : '');

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Laporan Sampah',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${report.id}',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (hasPhoto) ...[
                GestureDetector(
                  onTap: () {
                    FullscreenImageViewer.show(
                      context,
                      imagePathOrUrl: photoTarget,
                      title: 'Foto Sampah - ${report.jenisSampah}',
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colors.border,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: hasLocalPhoto
                              ? Image.file(
                                  File(report.fotoPath!),
                                  fit: BoxFit.cover,
                                  cacheHeight: 600,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image_rounded,
                                          size: 48,
                                        ),
                                      ),
                                )
                              : AppNetworkImage(
                                  imageUrl: photoUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorIcon: Icons.broken_image_rounded,
                                ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: photoOverlayBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.fullscreen_rounded,
                                color: photoOverlayFg,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Lihat Foto Penuh',
                                style: TextStyle(
                                  color: photoOverlayFg,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.account_balance_rounded,
                        color: colors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Bank Sampah',
                            style: AppTextStyles.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            report.bankSampahNama,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: jenisColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: jenisColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getJenisIcon(report.jenisSampah),
                                color: jenisColor,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Jenis Sampah',
                                style: AppTextStyles.caption.copyWith(
                                  color: jenisColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            report.jenisSampah,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.scale_rounded,
                                color: colors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Total Berat',
                                style: AppTextStyles.caption.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${report.beratKg.toStringAsFixed(report.beratKg.truncateToDouble() == report.beratKg ? 0 : 1)} kg',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: colors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Nilai Dihasilkan',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: heroText.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(report.nilaiRupiah),
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: heroText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: heroText.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Rp 5.000 / kg',
                        style: AppTextStyles.caption.copyWith(
                          color: heroText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (report.catatan.isNotEmpty) ...[
                Text(
                  'Catatan Laporan',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    report.catatan,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status: ',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (report.status.toLowerCase() == 'verified'
                                        ? colors.success
                                        : colors.earth)
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  (report.status.toLowerCase() == 'verified'
                                          ? colors.success
                                          : colors.earth)
                                      .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            report.statusLabel,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: report.status.toLowerCase() == 'verified'
                                  ? colors.success
                                  : colors.earth,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Waktu Laporan: ',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(report.createdAt)} WIB',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.textPrimary,
                    side: BorderSide(color: colors.borderStrong),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
