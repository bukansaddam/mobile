part of 'analisis_bloc.dart';

class CategoryData extends Equatable {
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

  @override
  List<Object?> get props => [label, count, percentage, color];
}

class ActivityDeadlineItem extends Equatable {
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

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    location,
    deadlineText,
    daysLeftText,
    statusColor,
    progress,
  ];
}

class AnalisisState extends Equatable {
  final List<ActivationActivity> activities;

  const AnalisisState({this.activities = const []});

  int get totalTasks => activities.length;

  int get totalAgendas => activities
      .where((act) => act.status == ActivationStatus.sedangBerjalan)
      .length;

  int get totalReports =>
      activities.where((act) => act.status == ActivationStatus.selesai).length +
      activities.fold<int>(0, (sum, act) => sum + act.reports.length);

  List<CategoryData> get categoryDistribution {
    final total = activities.length;
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
      final count = activities.where((act) => act.category == cat).length;
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
    if (activities.isEmpty) return [];

    final sorted = List<ActivationActivity>.from(activities)
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

  AnalisisState copyWith({List<ActivationActivity>? activities}) {
    return AnalisisState(activities: activities ?? this.activities);
  }

  @override
  List<Object?> get props => [activities];
}
