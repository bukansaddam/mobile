import 'dart:convert';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SurveyLocalDatasource {
  bool isInitialSurveyCompletedSync(int userId);
  Future<void> saveInitialSurvey(int userId, InitialSurveyEntity survey);
  Future<InitialSurveyEntity?> getInitialSurvey(int userId);

  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(String periodKey);
  Future<void> saveDynamicMonthlySurvey(DynamicMonthlySurveyEntity survey);
  Future<DynamicMonthlySurveyEntity?> getLatestDynamicSurveyForPeriod(
    String periodKey,
  );

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
  static const String _keyDynamicSurveyList = 'DYNAMIC_MONTHLY_SURVEY_LIST';
  static const String _keySurveyDismissedPrefix = 'SURVEY_DISMISSED_';
  static const String _keyInitialSurveyPrefix = 'INITIAL_SURVEY_USER_';
  static const String _keyInitialSurveyAnyCompleted =
      'INITIAL_SURVEY_ANY_COMPLETED';

  SurveyLocalDatasourceImpl({required this.sharedPreferences});

  @override
  bool isInitialSurveyCompletedSync(int userId) {
    if (sharedPreferences.getBool(_keyInitialSurveyAnyCompleted) == true) {
      return true;
    }
    if (userId != 0 &&
        sharedPreferences.getBool('$_keyInitialSurveyPrefix$userId') == true) {
      return true;
    }
    return sharedPreferences.getBool('${_keyInitialSurveyPrefix}0') ?? false;
  }

  @override
  Future<void> saveInitialSurvey(int userId, InitialSurveyEntity survey) async {
    await sharedPreferences.setBool(_keyInitialSurveyAnyCompleted, true);
    await sharedPreferences.setBool('$_keyInitialSurveyPrefix$userId', true);
    if (userId != 0) {
      await sharedPreferences.setBool('${_keyInitialSurveyPrefix}0', true);
    }
    final encoded = json.encode(survey.toMap());
    await sharedPreferences.setString(
      '$_keyInitialSurveyPrefix${userId}_DATA',
      encoded,
    );
  }

  @override
  Future<InitialSurveyEntity?> getInitialSurvey(int userId) async {
    final str = sharedPreferences.getString(
      '$_keyInitialSurveyPrefix${userId}_DATA',
    );
    if (str == null || str.isEmpty) return null;
    try {
      return InitialSurveyEntity.fromMap(json.decode(str));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MonthlySurveyFormEntity> getActiveMonthlySurveyForm(
    String periodKey,
  ) async {
    final periodLabel = SurveyEntity.getCurrentPeriodLabel();
    return MonthlySurveyFormEntity(
      id: 'survey_admin_$periodKey',
      title: 'Survey Bulanan Linmas & RT',
      description:
          'Survey berkala dari Admin untuk evaluasi kondisi keamanan, lingkungan, dan pelayanan di wilayah Anda.',
      period: periodKey,
      periodLabel: periodLabel,
      questions: const [
        DynamicQuestionEntity(
          id: 'q_keamanan',
          question:
              'Bagaimana tingkat kondisi keamanan & ketertiban lingkungan RT Anda bulan ini?',
          type: DynamicQuestionType.singleChoice,
          options: [
            'Sangat Kondusif',
            'Cukup Kondusif',
            'Kurang Kondusif',
            'Rawan Gangguan',
          ],
          isRequired: true,
        ),
        DynamicQuestionEntity(
          id: 'q_penerangan',
          question:
              'Apakah fasilitas penerangan jalan & sarana pos siskamling berfungsi dengan baik?',
          type: DynamicQuestionType.booleanChoice,
          isRequired: true,
        ),
        DynamicQuestionEntity(
          id: 'q_kendala',
          question:
              'Sebutkan kendala atau fasilitas lingkungan yang membutuhkan bantuan penanganan Admin/Dinas:',
          type: DynamicQuestionType.textInput,
          isRequired: false,
        ),
      ],
    );
  }

  @override
  Future<void> saveDynamicMonthlySurvey(
    DynamicMonthlySurveyEntity survey,
  ) async {
    final jsonString = sharedPreferences.getString(_keyDynamicSurveyList);
    List<DynamicMonthlySurveyEntity> history = [];
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> listJson = json.decode(jsonString);
        history = listJson
            .map(
              (item) => DynamicMonthlySurveyEntity.fromMap(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      } catch (_) {}
    }
    history.removeWhere((item) => item.period == survey.period);
    history.insert(0, survey);

    final encoded = json.encode(history.map((e) => e.toMap()).toList());
    await sharedPreferences.setString(_keyDynamicSurveyList, encoded);
  }

  @override
  Future<DynamicMonthlySurveyEntity?> getLatestDynamicSurveyForPeriod(
    String periodKey,
  ) async {
    final jsonString = sharedPreferences.getString(_keyDynamicSurveyList);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final List<dynamic> listJson = json.decode(jsonString);
      final list = listJson
          .map(
            (e) =>
                DynamicMonthlySurveyEntity.fromMap(e as Map<String, dynamic>),
          )
          .toList();
      final filtered = list.where((s) => s.period == periodKey).toList();
      return filtered.isNotEmpty ? filtered.first : null;
    } catch (_) {
      return null;
    }
  }

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
    final dynamicSurvey = await getLatestDynamicSurveyForPeriod(periodKey);
    if (dynamicSurvey != null) return true;
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
    await sharedPreferences.remove(_keyDynamicSurveyList);
    await sharedPreferences.remove(_keyInitialSurveyAnyCompleted);
    final keys = sharedPreferences
        .getKeys()
        .where(
          (k) =>
              k.startsWith(_keySurveyDismissedPrefix) ||
              k.startsWith(_keyInitialSurveyPrefix),
        )
        .toList();
    for (final key in keys) {
      await sharedPreferences.remove(key);
    }
  }
}
