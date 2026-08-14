import 'dart:math' as math;
import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AnalisisSummaryChartCard extends StatelessWidget {
  final int totalTasks;
  final int totalAgendas;
  final int totalReports;

  const AnalisisSummaryChartCard({
    super.key,
    required this.totalTasks,
    required this.totalAgendas,
    required this.totalReports,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = math
        .max(totalTasks, math.max(totalAgendas, totalReports))
        .toDouble();
    final safeMax = maxVal == 0 ? 1.0 : maxVal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00875A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Color(0xFF00875A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grafik Status Kegiatan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Statistik perbandingan tugas, agenda, dan laporan',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          SizedBox(
            height: 105,
            child: Row(
              children: [
                Expanded(
                  child: _buildMiniCard(
                    count: totalTasks,
                    title: 'Daftar Tugas',
                    subtitle: 'Kegiatan aktif',
                    icon: Icons.assignment_outlined,
                    color: const Color(0xFF0F9F66),
                    gradientColors: const [
                      Color(0xFF0F9F66),
                      Color(0xFF0A754B),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMiniCard(
                    count: totalAgendas,
                    title: 'Agenda',
                    subtitle: 'Sedang jalan',
                    icon: Icons.event_note_rounded,
                    color: const Color(0xFFD99B00),
                    gradientColors: const [
                      Color(0xFFD99B00),
                      Color(0xFFB37B00),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMiniCard(
                    count: totalReports,
                    title: 'Laporan',
                    subtitle: 'Selesai',
                    icon: Icons.insert_drive_file_outlined,
                    color: const Color(0xFF5CB836),
                    gradientColors: const [
                      Color(0xFF5CB836),
                      Color(0xFF438A24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              children: [
                _buildBarItem(
                  label: 'Total Daftar Tugas',
                  value: totalTasks,
                  percentage: totalTasks / safeMax,
                  color: const Color(0xFF0F9F66),
                  icon: Icons.assignment_outlined,
                ),
                const SizedBox(height: 14),
                _buildBarItem(
                  label: 'Kegiatan Sedang Berjalan',
                  value: totalAgendas,
                  percentage: totalAgendas / safeMax,
                  color: const Color(0xFFD99B00),
                  icon: Icons.event_note_rounded,
                ),
                const SizedBox(height: 14),
                _buildBarItem(
                  label: 'Kegiatan Selesai',
                  value: totalReports,
                  percentage: totalReports / safeMax,
                  color: const Color(0xFF5CB836),
                  icon: Icons.insert_drive_file_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard({
    required int count,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    List<Color>? gradientColors,
  }) {
    final primaryColor = gradientColors?.first ?? color;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gradientColors == null ? color : null,
        gradient: gradientColors != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem({
    required String label,
    required int value,
    required double percentage,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$value Item',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage.clamp(0.05, 1.0),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
