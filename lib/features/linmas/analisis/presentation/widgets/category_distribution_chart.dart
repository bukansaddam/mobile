import 'dart:math' as math;
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/linmas/analisis/presentation/bloc/analisis_bloc/analisis_bloc.dart';
import 'package:flutter/material.dart';

class CategoryDistributionChartCard extends StatelessWidget {
  final List<CategoryData> categoryData;

  const CategoryDistributionChartCard({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    final totalItems = categoryData.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );

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
          const Text(
            'Distribusi Kategori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Proporsi kegiatan berdasarkan kategori',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Donut Chart Canvas
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  categoryData: categoryData,
                  totalItems: totalItems,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Legend Items Wrap
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 10,
            children: categoryData.map((item) {
              final isZero = item.count == 0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isZero ? AppColors.grey400 : item.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${item.label} (${item.count} item • ${item.percentage.toInt()}%)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isZero ? FontWeight.normal : FontWeight.w600,
                      color: isZero
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<CategoryData> categoryData;
  final int totalItems;

  _DonutChartPainter({required this.categoryData, required this.totalItems});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final strokeWidth = 36.0;
    final chartRadius = outerRadius - (strokeWidth / 2);

    final totalValue = categoryData.fold<double>(
      0,
      (sum, item) => sum + item.percentage,
    );

    // Draw Center Donut Hole Content (Total Count & Label)
    final countSpan = TextSpan(
      text: '$totalItems',
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
    final countPainter = TextPainter(
      text: countSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final labelSpan = const TextSpan(
      text: 'Kegiatan',
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
    final labelPainter = TextPainter(
      text: labelSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final totalHeight = countPainter.height + labelPainter.height + 2;
    final startY = center.dy - (totalHeight / 2);

    countPainter.paint(
      canvas,
      Offset(center.dx - (countPainter.width / 2), startY),
    );
    labelPainter.paint(
      canvas,
      Offset(
        center.dx - (labelPainter.width / 2),
        startY + countPainter.height + 2,
      ),
    );

    if (totalValue <= 0) {
      final emptyPaint = Paint()
        ..color = AppColors.grey200
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, chartRadius, emptyPaint);
      return;
    }

    double startAngle = -math.pi / 2; // Start from top 12 o'clock

    for (final item in categoryData) {
      if (item.percentage <= 0) continue;
      final sweepAngle = (item.percentage / totalValue) * 2 * math.pi;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      // Draw Donut Segment Arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: chartRadius),
        startAngle,
        sweepAngle - 0.03, // Small gap between segments
        false,
        paint,
      );

      // Calculate position for Percentage Text Label
      final midAngle = startAngle + (sweepAngle / 2);
      final labelRadius = chartRadius;
      final labelX = center.dx + labelRadius * math.cos(midAngle);
      final labelY = center.dy + labelRadius * math.sin(midAngle);

      final textSpan = TextSpan(
        text: '${item.percentage.toInt()}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          labelX - (textPainter.width / 2),
          labelY - (textPainter.height / 2),
        ),
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.categoryData != categoryData ||
        oldDelegate.totalItems != totalItems;
  }
}
