import 'package:flutter/material.dart';

class CategoryData {
  final String label;
  final double percentage;
  final Color color;

  const CategoryData({
    required this.label,
    required this.percentage,
    required this.color,
  });
}

class ActivityDeadlineItem {
  final String id;
  final String title;
  final String category;
  final String location;
  final String deadlineText;
  final String daysLeftText;
  final Color statusColor;
  final double progress;

  const ActivityDeadlineItem({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.deadlineText,
    required this.daysLeftText,
    required this.statusColor,
    required this.progress,
  });
}

class AnalisisProvider extends ChangeNotifier {
  final int _totalTasks = 23;
  final int _totalAgendas = 8;
  final int _totalReports = 5;

  int get totalTasks => _totalTasks;
  int get totalAgendas => _totalAgendas;
  int get totalReports => _totalReports;

  final List<CategoryData> _categoryDistribution = const [
    CategoryData(
      label: 'Pemasangan APK',
      percentage: 28,
      color: Color(0xFF00897B),
    ),
    CategoryData(
      label: 'Door to Door',
      percentage: 25,
      color: Color(0xFF8E24AA),
    ),
    CategoryData(
      label: 'Keamanan & Sosial',
      percentage: 22,
      color: Color(0xFF1E6FFF),
    ),
    CategoryData(label: 'Lingkungan', percentage: 15, color: Color(0xFF20D489)),
    CategoryData(
      label: 'Bencana Alam',
      percentage: 10,
      color: Color(0xFFFF5252),
    ),
  ];

  List<CategoryData> get categoryDistribution => _categoryDistribution;

  final List<ActivityDeadlineItem> _upcomingDeadlines = const [
    ActivityDeadlineItem(
      id: 'act_1',
      title: 'Pemasangan Baliho & Spanduk Utama APK',
      category: 'Pemasangan APK',
      location: 'Simpang Jalan Utama RW 03',
      deadlineText: 'Besok, 17:00 WIB',
      daysLeftText: 'Sisa 1 Hari',
      statusColor: Color(0xFFC62828),
      progress: 0.85,
    ),
    ActivityDeadlineItem(
      id: 'act_2',
      title: 'Kunjungan Pendataan Warga Door to Door',
      category: 'Door to Door',
      location: 'Lingkungan RT 02 / RW 01',
      deadlineText: '6 Ags 2026, 10:00 WIB',
      daysLeftText: 'Sisa 2 Hari',
      statusColor: Color(0xFF8E24AA),
      progress: 0.70,
    ),
    ActivityDeadlineItem(
      id: 'act_3',
      title: 'Penyaluran Bantuan Logistik Tanggap Bencana',
      category: 'Bencana Alam',
      location: 'Posko Siaga Bencana RW 02',
      deadlineText: '7 Ags 2026, 16:00 WIB',
      daysLeftText: 'Sisa 3 Hari',
      statusColor: Color(0xFFFF5252),
      progress: 0.55,
    ),
    ActivityDeadlineItem(
      id: 'act_4',
      title: 'Kerja Bakti Pembersihan Drainase & Penghijauan',
      category: 'Lingkungan',
      location: 'Lingkungan RT 03 / RW 04',
      deadlineText: '9 Ags 2026, 08:00 WIB',
      daysLeftText: 'Sisa 5 Hari',
      statusColor: Color(0xFFD49000),
      progress: 0.35,
    ),
    ActivityDeadlineItem(
      id: 'act_5',
      title: 'Patroli Ronda Malam & Penyaluran Sembako',
      category: 'Keamanan & Sosial',
      location: 'Pos Ronda & Balai Warga Utama',
      deadlineText: '11 Ags 2026, 21:00 WIB',
      daysLeftText: 'Sisa 7 Hari',
      statusColor: Color(0xFF1E6FFF),
      progress: 0.15,
    ),
  ];

  List<ActivityDeadlineItem> get upcomingDeadlines => _upcomingDeadlines;
}
