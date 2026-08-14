import 'package:flutter/material.dart';

enum ComplaintCategory {
  lingkungan('Lingkungan', Icons.park_rounded),
  sosial('Sosial', Icons.people_rounded),
  bencanaAlam('Bencana Alam', Icons.warning_amber_rounded);

  final String label;
  final IconData icon;

  const ComplaintCategory(this.label, this.icon);

  static List<String> get names => values.map((e) => e.label).toList();

  static IconData getIconFor(String? categoryName) {
    if (categoryName == null) return Icons.campaign_rounded;
    for (final cat in values) {
      if (cat.label.toLowerCase() == categoryName.toLowerCase()) {
        return cat.icon;
      }
    }
    return Icons.campaign_rounded;
  }
}
