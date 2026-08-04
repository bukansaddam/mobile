import 'dart:math' as math;
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/analisis/presentation/provider/analisis_provider.dart';
import 'package:flutter/material.dart';

class CategoryDistributionChartCard extends StatelessWidget {
  final List<CategoryData> categoryData;

  const CategoryDistributionChartCard({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
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
            'Proporsi pengaduan berdasarkan kategori',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Donut Chart Canvas
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: _DonutChartPainter(categoryData: categoryData),
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
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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

  _DonutChartPainter({required this.categoryData});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final strokeWidth = 38.0;
    final chartRadius = outerRadius - (strokeWidth / 2);

    final totalValue = categoryData.fold<double>(
      0,
      (sum, item) => sum + item.percentage,
    );

    double startAngle = -math.pi / 2; // Start from top 12 o'clock

    for (final item in categoryData) {
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
          color: Color(0xFF1E293B),
          fontSize: 12,
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
    return oldDelegate.categoryData != categoryData;
  }
}
