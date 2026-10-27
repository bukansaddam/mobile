import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:akar/features/auth/presentation/widgets/map_pin_data.dart';

class MapPinBadge extends StatelessWidget {
  final MapPinData pin;
  final double mapWidth;
  final double mapHeight;
  final double animVal;

  const MapPinBadge({
    super.key,
    required this.pin,
    required this.mapWidth,
    required this.mapHeight,
    required this.animVal,
  });

  @override
  Widget build(BuildContext context) {
    const pinSize = 36.0;
    final floatOffset = math.sin(animVal + pin.phase) * 3.5;

    final left = pin.x * mapWidth - (pinSize / 2);
    final top = pin.y * mapHeight - (pinSize / 2) + floatOffset;

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: pinSize,
        height: pinSize,
        decoration: BoxDecoration(
          color: pin.color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: pin.color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(pin.icon, size: 18, color: Colors.white),
      ),
    );
  }
}
