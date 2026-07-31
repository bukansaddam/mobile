import 'package:flutter/material.dart';

enum ActivationCategory {
  pemasanganApk,
  doorToDoor,
}

enum ActivationStatus {
  terjadwal,
  sedangBerjalan,
  selesai,
  dibatalkan,
}

extension ActivationCategoryExtension on ActivationCategory {
  String get label {
    switch (this) {
      case ActivationCategory.pemasanganApk:
        return 'Pemasangan APK';
      case ActivationCategory.doorToDoor:
        return 'Door to Door';
    }
  }

  Color get color {
    switch (this) {
      case ActivationCategory.pemasanganApk:
        return const Color(0xFF00897B);
      case ActivationCategory.doorToDoor:
        return const Color(0xFF8E24AA);
    }
  }

  Color get stripColor {
    switch (this) {
      case ActivationCategory.pemasanganApk:
        return const Color(0xFF00897B);
      case ActivationCategory.doorToDoor:
        return const Color(0xFF8E24AA);
    }
  }

  IconData get icon {
    switch (this) {
      case ActivationCategory.pemasanganApk:
        return Icons.flag_rounded;
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
  final List<String> photoUrls; // Supports up to 5 photos per report card!
  final DateTime submittedAt;
  final double latitude;
  final double longitude;
  final String? notes;
  // Door to door mandatory & detail fields:
  final String? recipientName;
  final String? recipientKk;
  final String? recipientNik;
  final String? rt;
  final String? rw;
  final String? houseNumber;

  const ActivationReport({
    required this.id,
    required this.photoUrls,
    required this.submittedAt,
    required this.latitude,
    required this.longitude,
    this.notes,
    this.recipientName,
    this.recipientKk,
    this.recipientNik,
    this.rt,
    this.rw,
    this.houseNumber,
  });

  String get photoUrl => photoUrls.isNotEmpty ? photoUrls.first : '';
}

class ActivationActivity {
  final String id;
  final String title;
  final ActivationCategory category;
  final String location;
  final String address;
  final String ownerName;
  final String ownerPhone;
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
    this.ownerPhone = '081234567890',
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

  double get deadlineProgressPercentage {
    final now = DateTime.now();
    if (now.isBefore(startDate)) {
      return 0.0;
    }
    if (now.isAfter(endDate)) {
      return 1.0;
    }
    final totalSeconds = endDate.difference(startDate).inSeconds;
    if (totalSeconds <= 0) return 1.0;
    final elapsedSeconds = now.difference(startDate).inSeconds;
    return (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  ActivationActivity copyWith({
    String? id,
    String? title,
    ActivationCategory? category,
    String? location,
    String? address,
    String? ownerName,
    String? ownerPhone,
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
      ownerPhone: ownerPhone ?? this.ownerPhone,
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
