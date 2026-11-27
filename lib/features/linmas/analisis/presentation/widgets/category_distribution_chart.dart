import 'dart:math' as math;

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/presentation/extensions/activation_activity_ui_extension.dart';
import 'package:akar/features/linmas/analisis/presentation/bloc/analisis_bloc/analisis_bloc.dart';
import 'package:material_ui/material_ui.dart';

class CategoryDistributionChartCard extends StatelessWidget {
  final List<CategoryData> categoryData;
  final ValueChanged<ActivationCategory>? onCategoryTap;

  const CategoryDistributionChartCard({
    super.key,
    required this.categoryData,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final totalItems = categoryData.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribusi Kategori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Proporsi kegiatan berdasarkan kategori',
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
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
                  colors: colors,
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
              final catColor = item.category.resolveColor(colors);
              return InkWell(
                onTap: () => onCategoryTap?.call(item.category),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isZero ? colors.textHint : catColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${item.label} (${item.count} item • ${item.percentage.toInt()}%)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isZero
                              ? FontWeight.normal
                              : FontWeight.w600,
                          color: isZero
                              ? colors.textSecondary
                              : colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
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
  final AppColorScheme colors;

  _DonutChartPainter({
    required this.categoryData,
    required this.totalItems,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    const strokeWidth = 36.0;
    final chartRadius = outerRadius - (strokeWidth / 2);

    final totalValue = categoryData.fold<double>(
      0,
      (sum, item) => sum + item.percentage,
    );

    // Draw Center Donut Hole Content (Total Count & Label)
    final countSpan = TextSpan(
      text: '$totalItems',
      style: TextStyle(
        color: colors.textPrimary,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
    final countPainter = TextPainter(
      text: countSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final labelSpan = TextSpan(
      text: 'Kegiatan',
      style: TextStyle(
        color: colors.textSecondary,
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
        ..color = colors.border
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
        ..color = item.category.resolveColor(colors)
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
        style: TextStyle(
          color: colors.isDark ? colors.onSecondary : colors.onErrorSolid,
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
        oldDelegate.totalItems != totalItems ||
        oldDelegate.colors != colors;
  }
}
