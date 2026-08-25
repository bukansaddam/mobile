// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SurveyConditionalFieldModel _$SurveyConditionalFieldModelFromJson(
  Map<String, dynamic> json,
) => _SurveyConditionalFieldModel(
  id: (json['id'] as num).toInt(),
  label: json['label'] as String?,
  type: json['type'] as String?,
  value: json['value'] as String?,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$SurveyConditionalFieldModelToJson(
  _SurveyConditionalFieldModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'type': instance.type,
  'value': instance.value,
  'options': instance.options,
};

_SurveyQuestionModel _$SurveyQuestionModelFromJson(
  Map<String, dynamic> json,
) => _SurveyQuestionModel(
  id: (json['id'] as num).toInt(),
  text: json['text'] as String,
  type: json['type'] as String,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  showFieldsWhen: json['showFieldsWhen'] as String?,
  conditionalFields:
      (json['conditionalFields'] as List<dynamic>?)
          ?.map(
            (e) =>
                SurveyConditionalFieldModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$SurveyQuestionModelToJson(
  _SurveyQuestionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'type': instance.type,
  'options': instance.options,
  'showFieldsWhen': instance.showFieldsWhen,
  'conditionalFields': instance.conditionalFields,
};

_SurveyItemModel _$SurveyItemModelFromJson(Map<String, dynamic> json) =>
    _SurveyItemModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      period: json['period'] as String?,
      deadline: json['deadline'] as String?,
      status: json['status'] as String?,
      requireAllQuestions: json['requireAllQuestions'] as bool? ?? true,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
      questionsCount: (json['questionsCount'] as num?)?.toInt(),
      respondentsCount: (json['respondentsCount'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      publishedAt: json['publishedAt'] as String?,
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map(
                (e) => SurveyQuestionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SurveyItemModelToJson(_SurveyItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'period': instance.period,
      'deadline': instance.deadline,
      'status': instance.status,
      'requireAllQuestions': instance.requireAllQuestions,
      'estimatedMinutes': instance.estimatedMinutes,
      'questionsCount': instance.questionsCount,
      'respondentsCount': instance.respondentsCount,
      'createdAt': instance.createdAt,
      'publishedAt': instance.publishedAt,
      'questions': instance.questions,
    };

_SurveyListResponseModel _$SurveyListResponseModelFromJson(
  Map<String, dynamic> json,
) => _SurveyListResponseModel(
  success: json['success'] as bool? ?? false,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => SurveyItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  message: json['message'] as String?,
);

Map<String, dynamic> _$SurveyListResponseModelToJson(
  _SurveyListResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

_SurveyFieldAnswerModel _$SurveyFieldAnswerModelFromJson(
  Map<String, dynamic> json,
) => _SurveyFieldAnswerModel(
  fieldId: (json['fieldId'] as num).toInt(),
  value: json['value'] as String,
);

Map<String, dynamic> _$SurveyFieldAnswerModelToJson(
  _SurveyFieldAnswerModel instance,
) => <String, dynamic>{'fieldId': instance.fieldId, 'value': instance.value};

_SurveyQuestionAnswerModel _$SurveyQuestionAnswerModelFromJson(
  Map<String, dynamic> json,
) => _SurveyQuestionAnswerModel(
  questionId: (json['questionId'] as num).toInt(),
  value: json['value'] as String,
  fields:
      (json['fields'] as List<dynamic>?)
          ?.map(
            (e) => SurveyFieldAnswerModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$SurveyQuestionAnswerModelToJson(
  _SurveyQuestionAnswerModel instance,
) => <String, dynamic>{
  'questionId': instance.questionId,
  'value': instance.value,
  'fields': instance.fields,
};

_SurveySubmitRequestModel _$SurveySubmitRequestModelFromJson(
  Map<String, dynamic> json,
) => _SurveySubmitRequestModel(
  answers:
      (json['answers'] as List<dynamic>?)
          ?.map(
            (e) =>
                SurveyQuestionAnswerModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$SurveySubmitRequestModelToJson(
  _SurveySubmitRequestModel instance,
) => <String, dynamic>{'answers': instance.answers};
