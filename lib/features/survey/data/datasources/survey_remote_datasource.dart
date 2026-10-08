import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/features/survey/data/models/initial_quiz_model.dart';
import 'package:akar/features/survey/data/models/survey_model.dart';

abstract class SurveyRemoteDatasource {
  Future<SurveyListResponseModel> getSurveys({String? period});
  Future<bool> submitSurveyAnswers({
    required int surveyId,
    required SurveySubmitRequestModel request,
  });
  Future<InitialQuizResponseModel> getInitialQuiz();
  Future<bool> submitInitialQuizAnswers(dynamic answers);
}

class SurveyRemoteDatasourceImpl extends BaseRemoteDataSource
    implements SurveyRemoteDatasource {
  @override
  Future<SurveyListResponseModel> getSurveys({String? period}) async {
    final queryParams = <String, dynamic>{};
    if (period != null && period.isNotEmpty) {
      queryParams['period'] = period;
    }

    final response = await handleRequest<SurveyListResponseModel>(
      () => dio.get(ApiConstants.surveys, queryParameters: queryParams),
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return SurveyListResponseModel.fromJson(json);
        }
        if (json is List) {
          return SurveyListResponseModel(
            success: true,
            data: json
                .map(
                  (e) => SurveyItemModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList(),
          );
        }
        return const SurveyListResponseModel();
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Gagal mengambil data survey');
    }
  }

  @override
  Future<bool> submitSurveyAnswers({
    required int surveyId,
    required SurveySubmitRequestModel request,
  }) async {
    final endpoint = '${ApiConstants.surveys}/$surveyId/answers';

    final payload = {
      'answers': request.answers.map((a) {
        return {
          'question_id': a.questionId,
          'questionId': a.questionId,
          'value': a.value,
          'fields': a.fields.map((f) {
            return {
              'field_id': f.fieldId,
              'fieldId': f.fieldId,
              'value': f.value,
            };
          }).toList(),
        };
      }).toList(),
    };

    final response = await handleRequest<Map<String, dynamic>>(
      () => dio.post(endpoint, data: payload),
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return {'success': true};
      },
    );

    if (response.success) {
      return true;
    } else {
      throw Exception(response.message ?? 'Gagal mengirim jawaban survey');
    }
  }

  @override
  Future<InitialQuizResponseModel> getInitialQuiz() async {
    final response = await handleRequest<InitialQuizResponseModel>(
      () => dio.get(ApiConstants.initialQuiz),
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          if (json.containsKey('data') &&
              json['data'] is Map<String, dynamic>) {
            return InitialQuizResponseModel.fromJson(
              json['data'] as Map<String, dynamic>,
            );
          }
          return InitialQuizResponseModel.fromJson(json);
        }
        return const InitialQuizResponseModel(success: false);
      },
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Gagal mengambil data survey awal');
    }
  }

  @override
  Future<bool> submitInitialQuizAnswers(dynamic answers) async {
    final Map<String, dynamic> payload;
    if (answers is Map<String, dynamic> && answers.containsKey('answers')) {
      payload = answers;
    } else if (answers is InitialQuizSubmitRequestModel) {
      payload = answers.toJson();
    } else if (answers is List) {
      payload = {
        'answers': answers.map((item) {
          if (item is InitialQuizAnswerItemModel) return item.toJson();
          if (item is Map) return Map<String, dynamic>.from(item);
          return item;
        }).toList(),
      };
    } else {
      payload = {'answers': answers};
    }

    final response = await handleRequest<Map<String, dynamic>>(
      () => dio.post(ApiConstants.initialQuiz, data: payload),
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return {'success': true};
      },
    );

    if (response.success) {
      return true;
    } else {
      throw Exception(response.message ?? 'Gagal mengirim jawaban survey awal');
    }
  }
}
