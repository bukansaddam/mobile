import 'package:flutter/material.dart';

enum ActivationCategory { pemasanganPerangkat, doorToDoor }

enum ActivationStatus { terjadwal, sedangBerjalan, selesai, dibatalkan }

extension ActivationCategoryExtension on ActivationCategory {
  String get label {
    switch (this) {
      case ActivationCategory.pemasanganPerangkat:
        return 'Pemasangan Perangkat';
      case ActivationCategory.doorToDoor:
        return 'Door to Door';
    }
  }

  Color get color {
    switch (this) {
      case ActivationCategory.pemasanganPerangkat:
        return const Color(0xFF00897B);
      case ActivationCategory.doorToDoor:
        return const Color(0xFF8E24AA);
    }
  }

  Color get stripColor {
    switch (this) {
      case ActivationCategory.pemasanganPerangkat:
        return const Color(0xFF00897B);
      case ActivationCategory.doorToDoor:
        return const Color(0xFF8E24AA);
    }
  }

  IconData get icon {
    switch (this) {
      case ActivationCategory.pemasanganPerangkat:
        return Icons.router_rounded;
      case ActivationCategory.doorToDoor:
        return Icons.meeting_room_rounded;
    }
  }
}

extension ActivationStatusExtension on ActivationStatus {
  String get label {
    switch (this) {
      case ActivationStatus.terjadwal:
        return 'Terjadwal';
      case ActivationStatus.sedangBerjalan:
        return 'Sedang Berjalan';
      case ActivationStatus.selesai:
        return 'Selesai';
      case ActivationStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case ActivationStatus.terjadwal:
        return const Color(0xFFF57F17);
      case ActivationStatus.sedangBerjalan:
        return const Color(0xFF1877F2);
      case ActivationStatus.selesai:
        return const Color(0xFF2E7D32);
      case ActivationStatus.dibatalkan:
        return const Color(0xFFC62828);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ActivationStatus.terjadwal:
        return const Color(0xFFFFF8E1);
      case ActivationStatus.sedangBerjalan:
        return const Color(0xFFE8F1FF);
      case ActivationStatus.selesai:
        return const Color(0xFFE8F5E9);
      case ActivationStatus.dibatalkan:
        return const Color(0xFFFFEBEE);
    }
  }
}

class ActivationActivity {
  final String id;
  final String title;
  final ActivationCategory category;
  final String location;
  final ActivationStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int completedSteps;
  final int totalSteps;
  final String? description;

  const ActivationActivity({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.completedSteps,
    required this.totalSteps,
    this.description,
  });

  double get progressPercentage =>
      totalSteps > 0 ? (completedSteps / totalSteps).clamp(0.0, 1.0) : 0.0;
}
