import 'package:akar/features/activation/data/datasources/dummy_activation_data.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:flutter/material.dart';

enum ActivationSortOption { deadlineTerdekat, terbaru, terlama }

extension ActivationSortOptionExtension on ActivationSortOption {
  String get label {
    switch (this) {
      case ActivationSortOption.deadlineTerdekat:
        return 'Deadline Terdekat';
      case ActivationSortOption.terbaru:
        return 'Terbaru';
      case ActivationSortOption.terlama:
        return 'Terlama';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivationSortOption.deadlineTerdekat:
        return Icons.alarm_rounded;
      case ActivationSortOption.terbaru:
        return Icons.arrow_upward_rounded;
      case ActivationSortOption.terlama:
        return Icons.arrow_downward_rounded;
    }
  }
}

class ActivationProvider extends ChangeNotifier {
  String _searchQuery = '';
  ActivationCategory? _selectedCategoryFilter;
  ActivationStatus? _selectedStatusFilter;
  ActivationSortOption _selectedSortOption =
      ActivationSortOption.deadlineTerdekat;

  String get searchQuery => _searchQuery;
  ActivationCategory? get selectedCategoryFilter => _selectedCategoryFilter;
  ActivationStatus? get selectedStatusFilter => _selectedStatusFilter;
  ActivationSortOption get selectedSortOption => _selectedSortOption;

  final List<ActivationActivity> _activities = List.from(
    DummyActivationData.activities,
  );

  List<ActivationActivity> get activities => _activities;

  List<ActivationActivity> get filteredActivities {
    final list = _activities.where((act) {
      if (_selectedCategoryFilter != null &&
          act.category != _selectedCategoryFilter) {
        return false;
      }
      if (_selectedStatusFilter != null &&
          act.status != _selectedStatusFilter) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.trim().toLowerCase();
        final titleMatch = act.title.toLowerCase().contains(query);
        final locMatch = act.location.toLowerCase().contains(query);
        final catMatch = act.category.label.toLowerCase().contains(query);
        final statusMatch = act.status.label.toLowerCase().contains(query);
        return titleMatch || locMatch || catMatch || statusMatch;
      }
      return true;
    }).toList();

    // Apply Sorting
    final now = DateTime.now();
    switch (_selectedSortOption) {
      case ActivationSortOption.deadlineTerdekat:
        list.sort((a, b) {
          final diffA = a.endDate.difference(now).inSeconds;
          final diffB = b.endDate.difference(now).inSeconds;
          return diffA.compareTo(diffB);
        });
        break;
      case ActivationSortOption.terbaru:
        list.sort((a, b) => b.startDate.compareTo(a.startDate));
        break;
      case ActivationSortOption.terlama:
        list.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
    }

    return list;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(ActivationCategory? category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void setStatusFilter(ActivationStatus? status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void setSortOption(ActivationSortOption sortOption) {
    _selectedSortOption = sortOption;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void resetAllFilters() {
    _searchQuery = '';
    _selectedCategoryFilter = null;
    _selectedStatusFilter = null;
    _selectedSortOption = ActivationSortOption.deadlineTerdekat;
    notifyListeners();
  }

  ActivationActivity? getActivityById(String id) {
    try {
      return _activities.firstWhere((act) => act.id == id);
    } catch (_) {
      return null;
    }
  }

  void addReport(String activityId, ActivationReport newReport) {
    final index = _activities.indexWhere((act) => act.id == activityId);
    if (index != -1) {
      final old = _activities[index];
      final updatedReports = List<ActivationReport>.from(old.reports)
        ..add(newReport);
      final newCompleted = (old.completedSteps + 1).clamp(0, old.totalSteps);
      final newStatus = (newCompleted >= old.totalSteps)
          ? ActivationStatus.selesai
          : (old.status == ActivationStatus.terjadwal
                ? ActivationStatus.sedangBerjalan
                : old.status);

      _activities[index] = old.copyWith(
        reports: updatedReports,
        completedSteps: newCompleted,
        status: newStatus,
      );
      notifyListeners();
    }
  }
}
