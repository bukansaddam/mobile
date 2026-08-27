import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/features/survey/data/models/survey_model.dart';

abstract class SurveyRemoteDatasource {
  Future<SurveyListResponseModel> getSurveys({String? period});
  Future<bool> submitSurveyAnswers({
    required int surveyId,
    required SurveySubmitRequestModel request,
  });
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

    final response = await handleRequest<Map<String, dynamic>>(
      () => dio.post(endpoint, data: request.toJson()),
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
}
