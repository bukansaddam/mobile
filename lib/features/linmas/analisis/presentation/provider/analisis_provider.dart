import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:flutter/material.dart';

class CategoryData {
  final String label;
  final int count;
  final double percentage;
  final Color color;

  const CategoryData({
    required this.label,
    required this.count,
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
  List<ActivationActivity> _activities = [];

  AnalisisProvider({List<ActivationActivity>? activities}) {
    if (activities != null) {
      _activities = activities;
    }
  }

  void updateActivities(List<ActivationActivity> activities) {
    _activities = activities;
  }

  int get totalTasks => _activities.length;

  int get totalAgendas => _activities
      .where((act) => act.status == ActivationStatus.sedangBerjalan)
      .length;

  int get totalReports =>
      _activities
          .where((act) => act.status == ActivationStatus.selesai)
          .length +
      _activities.fold<int>(0, (sum, act) => sum + act.reports.length);

  List<CategoryData> get categoryDistribution {
    final total = _activities.length;
    if (total == 0) {
      return ActivationCategory.values.map((cat) {
        return CategoryData(
          label: cat.label,
          count: 0,
          percentage: 0,
          color: cat.color,
        );
      }).toList();
    }

    return ActivationCategory.values.map((cat) {
      final count = _activities.where((act) => act.category == cat).length;
      final percentage = (count / total) * 100;
      return CategoryData(
        label: cat.label,
        count: count,
        percentage: double.parse(percentage.toStringAsFixed(1)),
        color: cat.color,
      );
    }).toList();
  }

  List<ActivityDeadlineItem> get upcomingDeadlines {
    if (_activities.isEmpty) return [];

    final sorted = List<ActivationActivity>.from(_activities)
      ..sort((a, b) => a.endDate.compareTo(b.endDate));

    final now = DateTime.now();
    return sorted.take(5).map((act) {
      final diffDays = act.endDate.difference(now).inDays;
      final String daysText;
      if (diffDays < 0) {
        daysText = 'Lewat Deadline';
      } else if (diffDays == 0) {
        daysText = 'Hari Ini';
      } else {
        daysText = 'Sisa $diffDays Hari';
      }

      const monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Ags',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      final monthStr = monthNames[(act.endDate.month - 1).clamp(0, 11)];
      final deadlineText = '${act.endDate.day} $monthStr ${act.endDate.year}';

      return ActivityDeadlineItem(
        id: act.id,
        title: act.title,
        category: act.category.label,
        location: act.location,
        deadlineText: deadlineText,
        daysLeftText: daysText,
        statusColor: act.status.color,
        progress: act.progressPercentage > 0
            ? act.progressPercentage
            : act.deadlineProgressPercentage,
      );
    }).toList();
  }
}
