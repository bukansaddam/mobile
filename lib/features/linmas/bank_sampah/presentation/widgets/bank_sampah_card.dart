import 'dart:io';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/bank_sampah_report_entity.dart';
import 'bank_sampah_detail_sheet.dart';

class BankSampahCard extends StatelessWidget {
  final BankSampahReportEntity report;

  const BankSampahCard({super.key, required this.report});

  Color _getJenisColor(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'organik':
        return const Color(0xFF16A34A);
      case 'anorganik':
        return const Color(0xFF0284C7);
      case 'botol plastik':
        return const Color(0xFF0284C7);
      case 'kardus':
        return const Color(0xFFD97706);
      case 'kertas':
        return const Color(0xFF4F46E5);
      case 'plastik kemasan':
        return const Color(0xFFDC2626);
      case 'campuran kering':
      default:
        return const Color(0xFF059669);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'terverifikasi':
        return const Color(0xFF16A34A);
      case 'pending':
      case 'menunggu':
        return const Color(0xFFD97706);
      case 'rejected':
      case 'ditolak':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF16A34A);
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
    final jenisColor = _getJenisColor(report.jenisSampah);
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
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.03),
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
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          _getJenisIcon(report.jenisSampah),
                                          color: jenisColor,
                                          size: 24,
                                        ),
                                  )
                                : Image.network(
                                    photoUrl!,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          _getJenisIcon(report.jenisSampah),
                                          color: jenisColor,
                                          size: 24,
                                        ),
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
                                  color: AppColors.textPrimary,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: jenisColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: jenisColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getJenisIcon(report.jenisSampah),
                                    size: 11,
                                    color: jenisColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    report.jenisSampah,
                                    style: TextStyle(
                                      color: jenisColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              DateFormat(
                                'dd MMMM yyyy, HH:mm',
                                'id_ID',
                              ).format(report.createdAt),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            if (report.statusLabel.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    report.status,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _getStatusColor(
                                      report.status,
                                    ).withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  report.statusLabel,
                                  style: TextStyle(
                                    color: _getStatusColor(report.status),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Berat: ',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${report.beratKg.toStringAsFixed(report.beratKg.truncateToDouble() == report.beratKg ? 0 : 1)} kg',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '•',
                              style: TextStyle(
                                color: AppColors.grey400,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Nilai: ',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              currencyFormatter.format(report.nilaiRupiah),
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
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
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    report.catatan,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
