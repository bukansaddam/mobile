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
    final hasUrlPhoto = report.fotoUrl != null && report.fotoUrl!.isNotEmpty;
    final hasPhoto = hasLocalPhoto || hasUrlPhoto;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => BankSampahDetailSheet.show(context, report: report),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.bankSampahNama,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                            'id_ID',
                          ).format(report.createdAt),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          size: 12,
                          color: jenisColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          report.jenisSampah,
                          style: TextStyle(
                            color: jenisColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.grey200),
              const SizedBox(height: 12),

              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: hasPhoto
                          ? (hasLocalPhoto
                                ? Image.file(
                                    File(report.fotoPath!),
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) => const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: AppColors.grey400,
                                          size: 24,
                                        ),
                                  )
                                : Image.network(
                                    report.fotoUrl!,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) => const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: AppColors.grey400,
                                          size: 24,
                                        ),
                                  ))
                          : Center(
                              child: Icon(
                                _getJenisIcon(report.jenisSampah),
                                color: jenisColor,
                                size: 28,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Berat: ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${report.beratKg.toStringAsFixed(report.beratKg.truncateToDouble() == report.beratKg ? 0 : 1)} kg',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Nilai: ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              currencyFormatter.format(report.nilaiRupiah),
                              style: AppTextStyles.bodyMedium.copyWith(
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
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report.catatan,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
