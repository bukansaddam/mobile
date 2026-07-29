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

class ActivationReport {
  final String id;
  final String photoUrl;
  final DateTime submittedAt;
  final double latitude;
  final double longitude;
  final String? notes;
  // Door to door mandatory fields:
  final String? recipientName;
  final String? recipientNik;

  const ActivationReport({
    required this.id,
    required this.photoUrl,
    required this.submittedAt,
    required this.latitude,
    required this.longitude,
    this.notes,
    this.recipientName,
    this.recipientNik,
  });
}

class ActivationActivity {
  final String id;
  final String title;
  final ActivationCategory category;
  final String location;
  final String address;
  final String ownerName;
  final ActivationStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int completedSteps;
  final int totalSteps;
  final String? description;
  final String? notes;
  final List<ActivationReport> reports;

  const ActivationActivity({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.address,
    required this.ownerName,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.completedSteps,
    required this.totalSteps,
    this.description,
    this.notes,
    this.reports = const [],
  });

  double get progressPercentage =>
      totalSteps > 0 ? (completedSteps / totalSteps).clamp(0.0, 1.0) : 0.0;

  ActivationActivity copyWith({
    String? id,
    String? title,
    ActivationCategory? category,
    String? location,
    String? address,
    String? ownerName,
    ActivationStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? completedSteps,
    int? totalSteps,
    String? description,
    String? notes,
    List<ActivationReport>? reports,
  }) {
    return ActivationActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      address: address ?? this.address,
      ownerName: ownerName ?? this.ownerName,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      completedSteps: completedSteps ?? this.completedSteps,
      totalSteps: totalSteps ?? this.totalSteps,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      reports: reports ?? this.reports,
    );
  }
}
