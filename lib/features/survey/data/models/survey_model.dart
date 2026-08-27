import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_model.freezed.dart';
part 'survey_model.g.dart';

@freezed
abstract class SurveyConditionalFieldModel with _$SurveyConditionalFieldModel {
  const SurveyConditionalFieldModel._();

  const factory SurveyConditionalFieldModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "label") String? label,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "value") String? value,
    @JsonKey(name: "options") @Default([]) List<String> options,
  }) = _SurveyConditionalFieldModel;

  factory SurveyConditionalFieldModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyConditionalFieldModelFromJson(json);
}

@freezed
abstract class SurveyQuestionModel with _$SurveyQuestionModel {
  const SurveyQuestionModel._();

  const factory SurveyQuestionModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "text") required String text,
    @JsonKey(name: "type") required String type,
    @JsonKey(name: "options") @Default([]) List<String> options,
    @JsonKey(name: "showFieldsWhen") String? showFieldsWhen,
    @JsonKey(name: "conditionalFields")
    @Default([])
    List<SurveyConditionalFieldModel> conditionalFields,
  }) = _SurveyQuestionModel;

  factory SurveyQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionModelFromJson(json);
}

@freezed
abstract class SurveyItemModel with _$SurveyItemModel {
  const SurveyItemModel._();

  const factory SurveyItemModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "period") String? period,
    @JsonKey(name: "deadline") String? deadline,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "requireAllQuestions")
    @Default(true)
    bool requireAllQuestions,
    @JsonKey(name: "estimatedMinutes") int? estimatedMinutes,
    @JsonKey(name: "questionsCount") int? questionsCount,
    @JsonKey(name: "respondentsCount") int? respondentsCount,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "publishedAt") String? publishedAt,
    @JsonKey(name: "questions")
    @Default([])
    List<SurveyQuestionModel> questions,
  }) = _SurveyItemModel;

  factory SurveyItemModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyItemModelFromJson(json);
}

@freezed
abstract class SurveyListResponseModel with _$SurveyListResponseModel {
  const SurveyListResponseModel._();

  const factory SurveyListResponseModel({
    @JsonKey(name: "success") @Default(false) bool success,
    @JsonKey(name: "data") @Default([]) List<SurveyItemModel> data,
    @JsonKey(name: "message") String? message,
  }) = _SurveyListResponseModel;

  factory SurveyListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyListResponseModelFromJson(json);
}

// Request Payload Models for Submitting Survey Answers: POST /api/surveys/{id}/answers

@freezed
abstract class SurveyFieldAnswerModel with _$SurveyFieldAnswerModel {
  const SurveyFieldAnswerModel._();

  const factory SurveyFieldAnswerModel({
    @JsonKey(name: "fieldId") required int fieldId,
    @JsonKey(name: "value") required String value,
  }) = _SurveyFieldAnswerModel;

  factory SurveyFieldAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyFieldAnswerModelFromJson(json);
}

@freezed
abstract class SurveyQuestionAnswerModel with _$SurveyQuestionAnswerModel {
  const SurveyQuestionAnswerModel._();

  const factory SurveyQuestionAnswerModel({
    @JsonKey(name: "questionId") required int questionId,
    @JsonKey(name: "value") required String value,
    @JsonKey(name: "fields") @Default([]) List<SurveyFieldAnswerModel> fields,
  }) = _SurveyQuestionAnswerModel;

  factory SurveyQuestionAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionAnswerModelFromJson(json);
}

@freezed
abstract class SurveySubmitRequestModel with _$SurveySubmitRequestModel {
  const SurveySubmitRequestModel._();

  const factory SurveySubmitRequestModel({
    @JsonKey(name: "answers")
    @Default([])
    List<SurveyQuestionAnswerModel> answers,
  }) = _SurveySubmitRequestModel;

  factory SurveySubmitRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SurveySubmitRequestModelFromJson(json);
}
