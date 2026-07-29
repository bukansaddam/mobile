import 'package:akar/features/activation/data/datasources/dummy_activation_data.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:flutter/material.dart';

class ActivationProvider extends ChangeNotifier {
  String _searchQuery = '';
  ActivationCategory? _selectedCategoryFilter; // null = Semua

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
}
