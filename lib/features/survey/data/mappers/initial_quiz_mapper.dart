import 'package:akar/features/survey/data/models/initial_quiz_model.dart';
import 'package:akar/features/survey/domain/entities/initial_quiz_entity.dart';

extension InitialQuizOptionModelMapper on InitialQuizOptionModel {
  InitialQuizOptionEntity toDomain() {
    return InitialQuizOptionEntity(
      id: id,
      key: key,
      value: value,
      label: label,
      position: position,
      triggersSubInput: triggersSubInput,
    );
  }
}

extension InitialQuizQuestionModelMapper on InitialQuizQuestionModel {
  InitialQuizQuestionEntity toDomain() {
    return InitialQuizQuestionEntity(
      id: id,
      questionNumber: questionNumber,
      questionCode: questionCode,
      text: text,
      type: type,
      hasSubInput: hasSubInput,
      subInputLabel: subInputLabel,
      subInputType: subInputType,
      subInputTriggerValue: subInputTriggerValue,
      isRequired: isRequired,
      options: options.map((e) => e.toDomain()).toList(),
    );
  }
}

extension InitialQuizResponseModelMapper on InitialQuizResponseModel {
  InitialQuizResponseEntity toDomain() {
    return InitialQuizResponseEntity(
      success: success,
      hasSubmitted: hasSubmitted,
      isInitialQuizCompleted: isInitialQuizCompleted,
      isInitialQuizFilled: isInitialQuizFilled,
      submittedAt: submittedAt,
      questions: questions.map((e) => e.toDomain()).toList(),
      message: message,
    );
  }
}
