import 'package:flutter/material.dart';

/// Data model for pins displayed on Indonesian map.
class MapPinData {
  final double x; // Normalized 0.0 - 1.0
  final double y; // Normalized 0.0 - 1.0
  final Color color;
  final IconData icon;
  final double phase; // Floating animation phase offset

  const MapPinData({
    required this.x,
    required this.y,
    required this.color,
    required this.icon,
    this.phase = 0.0,
  });
}
