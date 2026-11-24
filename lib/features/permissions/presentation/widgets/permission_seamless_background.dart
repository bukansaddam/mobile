import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

/// Full-bleed static diagonal backdrop behind the seamless permission wizard.
class PermissionSeamlessBackground extends StatelessWidget {
  const PermissionSeamlessBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return RepaintBoundary(
      child: CustomPaint(
        painter: _DiagonalSeamPainter(
          topColor: colors.isDark ? colors.background : colors.surface,
          bottomColor: colors.primaryLight,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _DiagonalSeamPainter extends CustomPainter {
  final Color topColor;
  final Color bottomColor;

  const _DiagonalSeamPainter({
    required this.topColor,
    required this.bottomColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final topPaint = Paint()..color = topColor;
    canvas.drawRect(Offset.zero & size, topPaint);

    final bottomPath = Path()
      ..moveTo(0, size.height * 0.56)
      ..lineTo(size.width, size.height * 0.49)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final bottomPaint = Paint()..color = bottomColor;
    canvas.drawPath(bottomPath, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant _DiagonalSeamPainter oldDelegate) {
    return oldDelegate.topColor != topColor ||
        oldDelegate.bottomColor != bottomColor;
  }
}
