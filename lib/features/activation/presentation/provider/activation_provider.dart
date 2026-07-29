import 'package:akar/features/activation/data/datasources/dummy_activation_data.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:flutter/material.dart';

class ActivationProvider extends ChangeNotifier {
  String _searchQuery = '';
  ActivationCategory? _selectedCategoryFilter;

  String get searchQuery => _searchQuery;
  ActivationCategory? get selectedCategoryFilter => _selectedCategoryFilter;

  final List<ActivationActivity> _activities = List.from(
    DummyActivationData.activities,
  );

  List<ActivationActivity> get activities => _activities;

  List<ActivationActivity> get filteredActivities {
    return _activities.where((act) {
      if (_selectedCategoryFilter != null &&
          act.category != _selectedCategoryFilter) {
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
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(ActivationCategory? category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
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
