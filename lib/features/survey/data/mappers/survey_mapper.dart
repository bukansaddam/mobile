import 'package:akar/features/survey/data/models/survey_model.dart';
import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';

export 'package:akar/features/survey/domain/entities/survey_api_entity.dart';

extension SurveyConditionalFieldModelMapper on SurveyConditionalFieldModel {
  SurveyConditionalFieldEntity toDomain() {
    return SurveyConditionalFieldEntity(
      id: id,
      label: label,
      type: type,
      value: value,
      options: options,
    );
  }
}

extension SurveyConditionalFieldEntityMapper on SurveyConditionalFieldEntity {
  SurveyConditionalFieldModel toModel() {
    return SurveyConditionalFieldModel(
      id: id,
      label: label,
      type: type,
      value: value,
      options: options,
    );
  }
}

extension SurveyQuestionModelMapper on SurveyQuestionModel {
  SurveyQuestionEntity toDomain() {
    return SurveyQuestionEntity(
      id: id,
      text: text,
      type: type,
      options: options,
      showFieldsWhen: showFieldsWhen,
      conditionalFields: conditionalFields
          .map((field) => field.toDomain())
          .toList(),
    );
  }
}

extension SurveyQuestionEntityMapper on SurveyQuestionEntity {
  SurveyQuestionModel toModel() {
    return SurveyQuestionModel(
      id: id,
      text: text,
      type: type,
      options: options,
      showFieldsWhen: showFieldsWhen,
      conditionalFields: conditionalFields
          .map((field) => field.toModel())
          .toList(),
    );
  }
}

extension SurveyItemModelMapper on SurveyItemModel {
  SurveyItemEntity toDomain() {
    return SurveyItemEntity(
      id: id,
      title: title,
      description: description,
      period: period,
      deadline: deadline,
      status: status,
      requireAllQuestions: requireAllQuestions,
      estimatedMinutes: estimatedMinutes,
      questionsCount: questionsCount,
      respondentsCount: respondentsCount,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      publishedAt: publishedAt != null ? DateTime.tryParse(publishedAt!) : null,
      questions: questions.map((q) => q.toDomain()).toList(),
    );
  }
}

extension SurveyItemEntityMapper on SurveyItemEntity {
  SurveyItemModel toModel() {
    return SurveyItemModel(
      id: id,
      title: title,
      description: description,
      period: period,
      deadline: deadline,
      status: status,
      requireAllQuestions: requireAllQuestions,
      estimatedMinutes: estimatedMinutes,
      questionsCount: questionsCount,
      respondentsCount: respondentsCount,
      createdAt: createdAt?.toIso8601String(),
      publishedAt: publishedAt?.toIso8601String(),
      questions: questions.map((q) => q.toModel()).toList(),
    );
  }
}

// Mappers for Submit Request

extension SurveyFieldAnswerEntityMapper on SurveyFieldAnswerEntity {
  SurveyFieldAnswerModel toModel() {
    return SurveyFieldAnswerModel(fieldId: fieldId, value: value);
  }
}

extension SurveyQuestionAnswerEntityMapper on SurveyQuestionAnswerEntity {
  SurveyQuestionAnswerModel toModel() {
    return SurveyQuestionAnswerModel(
      questionId: questionId,
      value: value,
      fields: fields.map((f) => f.toModel()).toList(),
    );
  }
}

extension SurveySubmitRequestEntityMapper on SurveySubmitRequestEntity {
  SurveySubmitRequestModel toModel() {
    return SurveySubmitRequestModel(
      answers: answers.map((a) => a.toModel()).toList(),
    );
  }
}
