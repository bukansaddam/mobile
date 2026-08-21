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
  State<BankSampahAnalisisCard> createState() =>
      _BankSampahAnalisisCardState();
}

class _BankSampahAnalisisCardState extends State<BankSampahAnalisisCard> {
  BankSampahTimeframe _selectedTimeframe = BankSampahTimeframe.mingguan;
  DateTimeRange? _selectedWeekRange;
  DateTime? _selectedMonth;

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

  Future<void> _showMonthYearPicker() async {
    final now = DateTime.now();
    int tempYear = (_selectedMonth ?? now).year;
    int tempMonth = (_selectedMonth ?? now).month;

    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final result = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: tempYear > 2020
                        ? () {
                            setDialogState(() {
                              tempYear--;
                            });
                          }
                        : null,
                  ),
                  Text(
                    '$tempYear',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: tempYear < now.year + 5
                        ? () {
                            setDialogState(() {
                              tempYear++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
              content: SizedBox(
                width: 280,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final monthNumber = index + 1;
                    final isSelected = (monthNumber == tempMonth &&
                        tempYear == (_selectedMonth ?? now).year);
                    final isFuture = (tempYear > now.year ||
                        (tempYear == now.year && monthNumber > now.month));

                    return InkWell(
                      onTap: isFuture
                          ? null
                          : () {
                              Navigator.pop(
                                context,
                                DateTime(tempYear, monthNumber),
                              );
                            },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : (isFuture
                                  ? AppColors.grey100
                                  : AppColors.grey50),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey200,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          months[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isFuture
                                    ? AppColors.grey400
                                    : AppColors.textPrimary),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('BATAL'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedMonth = result;
        _selectedTimeframe = BankSampahTimeframe.bulanan;
      });
    }
  }

  Future<void> _selectWeekRange() async {
    final now = DateTime.now();
    final initialRange = _selectedWeekRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 6)),
          end: now,
        );

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
      helpText: 'Pilih Rentang Mingguan',
      cancelText: 'BATAL',
      confirmText: 'TERAPKAN',
      saveText: 'SIMPAN',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedWeekRange = picked;
        _selectedTimeframe = BankSampahTimeframe.mingguan;
      });
    }
  }

  String _getTimeframeSubtitle(BankSampahTimeframe timeframe) {
    final now = DateTime.now();
    switch (timeframe) {
      case BankSampahTimeframe.mingguan:
        if (_selectedWeekRange != null) {
          final startStr =
              DateFormat('d MMM', 'id_ID').format(_selectedWeekRange!.start);
          final endStr =
              DateFormat('d MMM yyyy', 'id_ID').format(_selectedWeekRange!.end);
          return 'Periode: $startStr - $endStr';
        }
        final sevenDaysAgo = now.subtract(const Duration(days: 6));
        final startStr = DateFormat('d MMM', 'id_ID').format(sevenDaysAgo);
        final endStr = DateFormat('d MMM yyyy', 'id_ID').format(now);
        return 'Periode: $startStr - $endStr';
      case BankSampahTimeframe.bulanan:
        final targetMonth = _selectedMonth ?? now;
        final monthStr = DateFormat('MMMM yyyy', 'id_ID').format(targetMonth);
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
        if (_selectedWeekRange != null) {
          final start = DateTime(
            _selectedWeekRange!.start.year,
            _selectedWeekRange!.start.month,
            _selectedWeekRange!.start.day,
          );
          final end = DateTime(
            _selectedWeekRange!.end.year,
            _selectedWeekRange!.end.month,
            _selectedWeekRange!.end.day,
            23,
            59,
            59,
          );
          return widget.reports
              .where(
                (r) =>
                    !r.createdAt.isBefore(start) &&
                    !r.createdAt.isAfter(end),
              )
              .toList();
        }
        final sevenDaysAgo = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 6));
        return widget.reports
            .where(
              (r) => r.createdAt.isAfter(
                sevenDaysAgo.subtract(const Duration(seconds: 1)),
              ),
            )
            .toList();
      case BankSampahTimeframe.bulanan:
        final targetMonth = _selectedMonth ?? now;
        return widget.reports
            .where(
              (r) =>
                  r.createdAt.year == targetMonth.year &&
                  r.createdAt.month == targetMonth.month,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
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
              if (_selectedTimeframe != BankSampahTimeframe.total)
                InkWell(
                  onTap: () {
                    if (_selectedTimeframe == BankSampahTimeframe.bulanan) {
                      _showMonthYearPicker();
                    } else if (_selectedTimeframe ==
                        BankSampahTimeframe.mingguan) {
                      _selectWeekRange();
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ubah',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.edit_calendar_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
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
                color:
                    isSelected ? AppColors.primary : AppColors.textSecondary,
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
