class InitialQuizOptionEntity {
  final int id;
  final String key;
  final String value;
  final String label;
  final int position;
  final bool triggersSubInput;

  const InitialQuizOptionEntity({
    required this.id,
    required this.key,
    required this.value,
    required this.label,
    this.position = 0,
    this.triggersSubInput = false,
  });

  String get displayLabel {
    if (label.isEmpty) return key.toUpperCase();
    final lower = label.trim().toLowerCase();
    final keyPrefix = '${key.toLowerCase()}.';
    if (lower.startsWith(keyPrefix)) return label;
    return '${key.toUpperCase()}. $label';
  }
}

class InitialQuizQuestionEntity {
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
  final List<InitialQuizOptionEntity> options;

  const InitialQuizQuestionEntity({
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

  bool isOptionTriggeringSubInput(String? selectedValue) {
    if (selectedValue == null) return false;
    final normalized = selectedValue.trim().toLowerCase();

    // Check if the selected option explicitly has triggersSubInput == true
    for (final opt in options) {
      if (opt.value.trim().toLowerCase() == normalized &&
          opt.triggersSubInput) {
        return true;
      }
    }

    // Check if subInputTriggerValue matches
    if (hasSubInput &&
        subInputTriggerValue != null &&
        subInputTriggerValue!.isNotEmpty) {
      return subInputTriggerValue!.trim().toLowerCase() == normalized;
    }

    return false;
  }
}

class InitialQuizResponseEntity {
  final bool success;
  final bool hasSubmitted;
  final bool isInitialQuizCompleted;
  final bool isInitialQuizFilled;
  final String? submittedAt;
  final List<InitialQuizQuestionEntity> questions;
  final String? message;

  const InitialQuizResponseEntity({
    this.success = false,
    this.hasSubmitted = false,
    this.isInitialQuizCompleted = false,
    this.isInitialQuizFilled = false,
    this.submittedAt,
    this.questions = const [],
    this.message,
  });

  bool get isAlreadyCompleted =>
      hasSubmitted || isInitialQuizCompleted || isInitialQuizFilled;
}
