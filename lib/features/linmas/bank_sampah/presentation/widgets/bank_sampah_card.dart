import 'dart:io';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/bank_sampah_report_entity.dart';
import 'bank_sampah_detail_sheet.dart';

class BankSampahCard extends StatelessWidget {
  final BankSampahReportEntity report;

  const BankSampahCard({super.key, required this.report});

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

  Color _getStatusColor(String status, AppColorScheme colors) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'terverifikasi':
        return colors.success;
      case 'pending':
      case 'menunggu':
        return colors.earth;
      case 'rejected':
      case 'ditolak':
        return colors.errorDark;
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
    final jenisColor = _getJenisColor(report.jenisSampah, colors);
    final statusColor = _getStatusColor(report.status, colors);
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => BankSampahDetailSheet.show(context, report: report),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: jenisColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: jenisColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: hasPhoto
                          ? (hasLocalPhoto
                                ? Image.file(
                                    File(report.fotoPath!),
                                    width: 42,
                                    height: 42,
                                    cacheWidth: 126,
                                    cacheHeight: 126,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          _getJenisIcon(report.jenisSampah),
                                          color: jenisColor,
                                          size: 24,
                                        ),
                                  )
                                : AppNetworkImage(
                                    imageUrl: photoUrl!,
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.cover,
                                    errorIcon: _getJenisIcon(
                                      report.jenisSampah,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ))
                          : Center(
                              child: Icon(
                                _getJenisIcon(report.jenisSampah),
                                color: jenisColor,
                                size: 24,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                report.bankSampahNama,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (report.statusLabel.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3.5,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: statusColor.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  report.statusLabel,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'dd MMMM yyyy, HH:mm',
                            'id_ID',
                          ).format(report.createdAt),
                          style: AppTextStyles.caption.copyWith(
                            color: colors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Berat: ',
                              style: AppTextStyles.caption.copyWith(
                                color: colors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${report.beratKg.toStringAsFixed(report.beratKg.truncateToDouble() == report.beratKg ? 0 : 1)} kg',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: TextStyle(
                                color: colors.textHint,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nilai: ',
                              style: AppTextStyles.caption.copyWith(
                                color: colors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  currencyFormatter.format(report.nilaiRupiah),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (report.catatan.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    report.catatan,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
