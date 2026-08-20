import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum BankSampahTimeframe { mingguan, bulanan, total }

class BankSampahAnalisisCard extends StatefulWidget {
  final List<BankSampahReportEntity> reports;

  const BankSampahAnalisisCard({super.key, required this.reports});

  @override
  State<BankSampahAnalisisCard> createState() => _BankSampahAnalisisCardState();
}

class _BankSampahAnalisisCardState extends State<BankSampahAnalisisCard> {
  BankSampahTimeframe _selectedTimeframe = BankSampahTimeframe.mingguan;

  String _formatBerat(double kg) {
    if (kg % 1 == 0) {
      return '${kg.toInt()} Kg';
    }
    return '${kg.toStringAsFixed(1)} Kg';
  }

  String _formatRupiah(double rupiah) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(rupiah);
  }

  String _getTimeframeSubtitle(BankSampahTimeframe timeframe) {
    final now = DateTime.now();
    switch (timeframe) {
      case BankSampahTimeframe.mingguan:
        final sevenDaysAgo = now.subtract(const Duration(days: 6));
        final startStr = DateFormat('d MMM', 'id_ID').format(sevenDaysAgo);
        final endStr = DateFormat('d MMM yyyy', 'id_ID').format(now);
        return 'Periode: $startStr - $endStr';
      case BankSampahTimeframe.bulanan:
        final monthStr = DateFormat('MMMM yyyy', 'id_ID').format(now);
        return 'Periode: $monthStr';
      case BankSampahTimeframe.total:
        return 'Periode: Semua Waktu';
    }
  }

  List<BankSampahReportEntity> _getFilteredReports(
    BankSampahTimeframe timeframe,
  ) {
    final now = DateTime.now();
    switch (timeframe) {
      case BankSampahTimeframe.mingguan:
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        return widget.reports
            .where((r) => r.createdAt.isAfter(sevenDaysAgo))
            .toList();
      case BankSampahTimeframe.bulanan:
        return widget.reports
            .where(
              (r) =>
                  r.createdAt.year == now.year &&
                  r.createdAt.month == now.month,
            )
            .toList();
      case BankSampahTimeframe.total:
        return widget.reports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeReports = _getFilteredReports(_selectedTimeframe);
    final count = activeReports.length;
    final totalBerat = activeReports.fold<double>(
      0.0,
      (sum, item) => sum + item.beratKg,
    );
    final totalNilai = activeReports.fold<double>(
      0.0,
      (sum, item) => sum + item.nilaiRupiah,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.recycling_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Analisis Bank Sampah',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Timeframe Selector Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTimeframeTab('Mingguan', BankSampahTimeframe.mingguan),
                _buildTimeframeTab('Bulanan', BankSampahTimeframe.bulanan),
                _buildTimeframeTab('Total', BankSampahTimeframe.total),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Date / Period Range Text
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 13,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                _getTimeframeSubtitle(_selectedTimeframe),
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3 Stat Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricBox(
                  title: 'Jumlah Laporan',
                  value: '$count Laporan',
                  icon: Icons.assignment_outlined,
                  iconColor: const Color(0xFF0284C7),
                  bgColor: const Color(0xFFE0F2FE),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricBox(
                  title: 'Total Bobot',
                  value: _formatBerat(totalBerat),
                  icon: Icons.scale_rounded,
                  iconColor: AppColors.primary,
                  bgColor: const Color(0xFFDCFCE7),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricBox(
                  title: 'Total Nilai',
                  value: _formatRupiah(totalNilai),
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: const Color(0xFFB45309),
                  bgColor: const Color(0xFFFEF08A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeTab(String label, BankSampahTimeframe timeframe) {
    final isSelected = _selectedTimeframe == timeframe;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTimeframe = timeframe;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBox({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
