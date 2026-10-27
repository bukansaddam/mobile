import 'package:flutter/material.dart';

/// Data model representing a feature highlight item.
class FeatureHighlightItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const FeatureHighlightItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}
