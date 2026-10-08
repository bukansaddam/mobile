class InitialQuizOptionModel {
  final int id;
  final String key;
  final String value;
  final String label;
  final int position;
  final bool triggersSubInput;

  const InitialQuizOptionModel({
    required this.id,
    required this.key,
    required this.value,
    required this.label,
    this.position = 0,
    this.triggersSubInput = false,
  });

  factory InitialQuizOptionModel.fromJson(Map<String, dynamic> json) {
    return InitialQuizOptionModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      key: json['key']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      position: json['position'] is int
          ? json['position'] as int
          : int.tryParse(json['position']?.toString() ?? '') ?? 0,
      triggersSubInput: json['triggers_sub_input'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'value': value,
      'label': label,
      'position': position,
      'triggers_sub_input': triggersSubInput,
    };
  }
}

class InitialQuizQuestionModel {
  final int id;
  final int? questionNumber;
  final String? questionCode;
  final String text;
  final String type;
  final bool hasSubInput;
  final String? subInputLabel;
  final String? subInputType;
  final String? subInputTriggerValue;
  final bool isRequired;
  final List<InitialQuizOptionModel> options;

  const InitialQuizQuestionModel({
    required this.id,
    this.questionNumber,
    this.questionCode,
    required this.text,
    required this.type,
    this.hasSubInput = false,
    this.subInputLabel,
    this.subInputType,
    this.subInputTriggerValue,
    this.isRequired = true,
    this.options = const [],
  });

  factory InitialQuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    List<InitialQuizOptionModel> parsedOptions = [];
    if (rawOptions is List) {
      parsedOptions = rawOptions
          .whereType<Map>()
          .map(
            (e) =>
                InitialQuizOptionModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }

    return InitialQuizQuestionModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      questionNumber: json['question_number'] is int
          ? json['question_number'] as int
          : int.tryParse(json['question_number']?.toString() ?? ''),
      questionCode: json['question_code']?.toString(),
      text: json['text']?.toString() ?? '',
      type: json['type']?.toString() ?? 'single_choice',
      hasSubInput: json['has_sub_input'] as bool? ?? false,
      subInputLabel: json['sub_input_label']?.toString(),
      subInputType: json['sub_input_type']?.toString(),
      subInputTriggerValue: json['sub_input_trigger_value']?.toString(),
      isRequired: json['is_required'] as bool? ?? true,
      options: parsedOptions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_number': questionNumber,
      'question_code': questionCode,
      'text': text,
      'type': type,
      'has_sub_input': hasSubInput,
      'sub_input_label': subInputLabel,
      'sub_input_type': subInputType,
      'sub_input_trigger_value': subInputTriggerValue,
      'is_required': isRequired,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}

class InitialQuizResponseModel {
  final bool success;
  final bool hasSubmitted;
  final bool isInitialQuizCompleted;
  final bool isInitialQuizFilled;
  final String? submittedAt;
  final List<InitialQuizQuestionModel> questions;
  final String? message;

  const InitialQuizResponseModel({
    this.success = false,
    this.hasSubmitted = false,
    this.isInitialQuizCompleted = false,
    this.isInitialQuizFilled = false,
    this.submittedAt,
    this.questions = const [],
    this.message,
  });

  factory InitialQuizResponseModel.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'];
    List<InitialQuizQuestionModel> parsedQuestions = [];
    if (rawQuestions is List) {
      parsedQuestions = rawQuestions
          .whereType<Map>()
          .map(
            (e) =>
                InitialQuizQuestionModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }

    return InitialQuizResponseModel(
      success: json['success'] as bool? ?? false,
      hasSubmitted: json['has_submitted'] as bool? ?? false,
      isInitialQuizCompleted:
          json['is_initial_quiz_completed'] as bool? ?? false,
      isInitialQuizFilled: json['is_initial_quiz_filled'] as bool? ?? false,
      submittedAt: json['submitted_at']?.toString(),
      questions: parsedQuestions,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'has_submitted': hasSubmitted,
      'is_initial_quiz_completed': isInitialQuizCompleted,
      'is_initial_quiz_filled': isInitialQuizFilled,
      'submitted_at': submittedAt,
      'questions': questions.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class InitialQuizAnswerItemModel {
  final int questionNumber;
  final String value;
  final String? subValue;

  const InitialQuizAnswerItemModel({
    required this.questionNumber,
    required this.value,
    this.subValue,
  });

  factory InitialQuizAnswerItemModel.fromJson(Map<String, dynamic> json) {
    return InitialQuizAnswerItemModel(
      questionNumber: json['question_number'] is int
          ? json['question_number'] as int
          : int.tryParse(json['question_number']?.toString() ?? '') ?? 0,
      value: json['value']?.toString() ?? '',
      subValue: json['sub_value']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_number': questionNumber,
      'value': value,
      if (subValue != null && subValue!.isNotEmpty) 'sub_value': subValue,
    };
  }
}

class InitialQuizSubmitRequestModel {
  final List<InitialQuizAnswerItemModel> answers;

  const InitialQuizSubmitRequestModel({this.answers = const []});

  factory InitialQuizSubmitRequestModel.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['answers'];
    List<InitialQuizAnswerItemModel> parsed = [];
    if (rawAnswers is List) {
      parsed = rawAnswers
          .whereType<Map>()
          .map(
            (e) => InitialQuizAnswerItemModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    }
    return InitialQuizSubmitRequestModel(answers: parsed);
  }

  Map<String, dynamic> toJson() {
    return {'answers': answers.map((e) => e.toJson()).toList()};
  }
}
