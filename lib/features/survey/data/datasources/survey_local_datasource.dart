import 'dart:convert';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SurveyLocalDatasource {
  Future<bool> isSurveySubmittedForPeriod(String periodKey);
  Future<bool> isSurveyDismissedForPeriod(String periodKey);
  Future<void> setSurveyDismissedForPeriod(String periodKey);
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey);
  Future<List<SurveyEntity>> getAllSurveyHistory();
  Future<void> saveSurvey(SurveyEntity survey);
  Future<void> clearAllSurveys();
}

class SurveyLocalDatasourceImpl implements SurveyLocalDatasource {
  final SharedPreferences sharedPreferences;
  static const String _keySurveyList = 'MONTHLY_SURVEY_LIST';
  static const String _keySurveyDismissedPrefix = 'SURVEY_DISMISSED_';

  SurveyLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<List<SurveyEntity>> getAllSurveyHistory() async {
    final jsonString = sharedPreferences.getString(_keySurveyList);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> listJson = json.decode(jsonString);
      return listJson
          .map((item) => SurveyEntity.fromMap(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    } catch (_) {
      return [];
    }
  }

  @override
  Future<SurveyEntity?> getLatestSurveyForPeriod(String periodKey) async {
    final history = await getAllSurveyHistory();
    final filtered = history.where((s) => s.period == periodKey).toList();
    if (filtered.isNotEmpty) {
      return filtered.first;
    }
    return null;
  }

  @override
  Future<bool> isSurveySubmittedForPeriod(String periodKey) async {
    final survey = await getLatestSurveyForPeriod(periodKey);
    return survey != null;
  }

  @override
  Future<bool> isSurveyDismissedForPeriod(String periodKey) async {
    return sharedPreferences.getBool('$_keySurveyDismissedPrefix$periodKey') ??
        false;
  }

  @override
  Future<void> setSurveyDismissedForPeriod(String periodKey) async {
    await sharedPreferences.setBool(
      '$_keySurveyDismissedPrefix$periodKey',
      true,
    );
  }

  @override
  Future<void> saveSurvey(SurveyEntity survey) async {
    final history = await getAllSurveyHistory();
    history.removeWhere((item) => item.period == survey.period);
    history.insert(0, survey);

    final encoded = json.encode(history.map((e) => e.toMap()).toList());
    await sharedPreferences.setString(_keySurveyList, encoded);
  }

  @override
  Future<void> clearAllSurveys() async {
    await sharedPreferences.remove(_keySurveyList);
    final keys = sharedPreferences
        .getKeys()
        .where((k) => k.startsWith(_keySurveyDismissedPrefix))
        .toList();
    for (final key in keys) {
      await sharedPreferences.remove(key);
    }
  }
}
