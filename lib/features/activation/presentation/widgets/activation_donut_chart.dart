import 'dart:math';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ActivationDonutChart extends StatelessWidget {
  final int completedSteps;
  final int totalSteps;
  final Color progressColor;
  final double size;
  final double strokeWidth;

  const ActivationDonutChart({
    super.key,
    required this.completedSteps,
    required this.totalSteps,
    this.progressColor = AppColors.primary,
    this.size = 56.0,
    this.strokeWidth = 5.5,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = totalSteps > 0
        ? (completedSteps / totalSteps).clamp(0.0, 1.0)
        : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutChartPainter(
              percentage: percentage,
              progressColor: progressColor,
              backgroundColor: AppColors.grey200,
              strokeWidth: strokeWidth,
            ),
          ),
          Text(
            '$completedSteps/$totalSteps',
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: size * 0.22,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double percentage;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _DonutChartPainter({
    required this.percentage,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (percentage > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -pi / 2;
      final sweepAngle = 2 * pi * percentage;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
