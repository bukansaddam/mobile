import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_api_entity.freezed.dart';

@freezed
abstract class SurveyConditionalFieldEntity
    with _$SurveyConditionalFieldEntity {
  const SurveyConditionalFieldEntity._();

  const factory SurveyConditionalFieldEntity({
    required int id,
    String? label,
    String? type,
    String? value,
    @Default([]) List<String> options,
  }) = _SurveyConditionalFieldEntity;

  bool get isSelect => type == 'select';
  bool get isStatic => type == 'static';
  bool get isText => type == 'text';
  bool get isTime => type == 'time';
}

@freezed
abstract class SurveyQuestionEntity with _$SurveyQuestionEntity {
  const SurveyQuestionEntity._();

  const factory SurveyQuestionEntity({
    required int id,
    required String text,
    required String type,
    @Default([]) List<String> options,
    String? showFieldsWhen,
    @Default([]) List<SurveyConditionalFieldEntity> conditionalFields,
  }) = _SurveyQuestionEntity;

  bool get isPilihanGanda => type == 'pilihan_ganda';
  bool get isSkala => type == 'skala';
  bool get isIsian => type == 'isian';

  bool get hasConditionalFields => conditionalFields.isNotEmpty;

  bool shouldShowConditionalFields(String? selectedOption) {
    if (showFieldsWhen == null || showFieldsWhen!.isEmpty) return false;
    if (selectedOption == null) return false;
    return selectedOption.trim().toLowerCase() ==
        showFieldsWhen!.trim().toLowerCase();
  }
}

@freezed
abstract class SurveyItemEntity with _$SurveyItemEntity {
  const SurveyItemEntity._();

  const factory SurveyItemEntity({
    required int id,
    required String title,
    String? description,
    String? period,
    String? deadline,
    String? status,
    @Default(true) bool requireAllQuestions,
    int? estimatedMinutes,
    int? questionsCount,
    int? respondentsCount,
    DateTime? createdAt,
    DateTime? publishedAt,
    @Default([]) List<SurveyQuestionEntity> questions,
  }) = _SurveyItemEntity;
}

// Entities for Submitting Survey Answers

@freezed
abstract class SurveyFieldAnswerEntity with _$SurveyFieldAnswerEntity {
  const SurveyFieldAnswerEntity._();

  const factory SurveyFieldAnswerEntity({
    required int fieldId,
    required String value,
  }) = _SurveyFieldAnswerEntity;
}

@freezed
abstract class SurveyQuestionAnswerEntity with _$SurveyQuestionAnswerEntity {
  const SurveyQuestionAnswerEntity._();

  const factory SurveyQuestionAnswerEntity({
    required int questionId,
    required String value,
    @Default([]) List<SurveyFieldAnswerEntity> fields,
  }) = _SurveyQuestionAnswerEntity;
}

@freezed
abstract class SurveySubmitRequestEntity with _$SurveySubmitRequestEntity {
  const SurveySubmitRequestEntity._();

  const factory SurveySubmitRequestEntity({
    @Default([]) List<SurveyQuestionAnswerEntity> answers,
  }) = _SurveySubmitRequestEntity;
}
