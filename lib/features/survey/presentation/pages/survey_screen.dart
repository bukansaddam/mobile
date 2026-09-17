import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final Map<String, dynamic> _answers = {};
  final Map<String, TextEditingController> _textControllers = {};

  SurveyItemEntity? _currentApiSurvey;
  MonthlySurveyFormEntity? _currentForm;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    context.read<SurveyBloc>().add(const LoadDynamicMonthlyFormEvent());
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getTextController(String key) {
    if (!_textControllers.containsKey(key)) {
      _textControllers[key] = TextEditingController();
    }
    return _textControllers[key]!;
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitApiForm(SurveyItemEntity survey) {
    for (final q in survey.questions) {
      final key = q.id.toString();
      final answer = _answers[key];

      if (survey.requireAllQuestions) {
        if (answer == null ||
            (answer is String && answer.trim().isEmpty) ||
            (answer is List && answer.isEmpty)) {
          _showWarningSnackBar('Mohon jawab pertanyaan: "${q.text}"');
          return;
        }
      }
      if (q.shouldShowConditionalFields(answer?.toString())) {
        for (final cond in q.conditionalFields) {
          final condKey = '${q.id}_cond_${cond.id}';
          final condAns = _answers[condKey] ?? cond.value;

          if (cond.isSelect || cond.isText || cond.isTime) {
            if (condAns == null || condAns.toString().trim().isEmpty) {
              _showWarningSnackBar(
                'Mohon lengkapi "${cond.label ?? 'pilihan lanjutan'}" untuk pertanyaan "${q.text}"',
              );
              return;
            }
          }
        }
      }
    }

    final questionAnswerEntities = <SurveyQuestionAnswerEntity>[];

    for (final q in survey.questions) {
      final key = q.id.toString();
      final mainValue = _answers[key]?.toString() ?? '';

      final fieldAnswerEntities = <SurveyFieldAnswerEntity>[];

      if (q.shouldShowConditionalFields(mainValue)) {
        for (final cond in q.conditionalFields) {
          final condKey = '${q.id}_cond_${cond.id}';
          final condVal = _answers[condKey]?.toString() ?? cond.value ?? '';
          if (condVal.isNotEmpty) {
            fieldAnswerEntities.add(
              SurveyFieldAnswerEntity(fieldId: cond.id, value: condVal),
            );
          }
        }
      }

      questionAnswerEntities.add(
        SurveyQuestionAnswerEntity(
          questionId: q.id,
          value: mainValue,
          fields: fieldAnswerEntities,
        ),
      );
    }

    final requestEntity = SurveySubmitRequestEntity(
      answers: questionAnswerEntities,
    );

    context.read<SurveyBloc>().add(
      SubmitApiSurveyAnswersEvent(
        surveyId: survey.id,
        periodKey: survey.period ?? SurveyEntity.getCurrentPeriodKey(),
        request: requestEntity,
      ),
    );
  }

  void _submitDynamicForm(MonthlySurveyFormEntity form) {
    for (final q in form.questions) {
      if (q.isRequired) {
        final answer = _answers[q.id];
        if (answer == null ||
            (answer is String && answer.trim().isEmpty) ||
            (answer is List && answer.isEmpty)) {
          _showWarningSnackBar('Mohon jawab pertanyaan wajib: "${q.question}"');
          return;
        }
      }
    }

    final responses = form.questions.map((q) {
      return DynamicSurveyResponseItem(
        questionId: q.id,
        questionText: q.question,
        answer: _answers[q.id],
      );
    }).toList();

    final survey = DynamicMonthlySurveyEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      period: form.period,
      periodLabel: form.periodLabel,
      responses: responses,
      submittedAt: DateTime.now(),
    );

    context.read<SurveyBloc>().add(SubmitDynamicMonthlySurveyEvent(survey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Survey Bulanan Admin',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocConsumer<SurveyBloc, SurveyState>(
        listener: (context, state) {
          if (state is ApiSurveyLoadedState) {
            _currentApiSurvey = state.survey;
            _isSubmitted = state.isSubmitted;
          } else if (state is DynamicFormLoadedState) {
            _currentForm = state.form;
            _isSubmitted = state.isSubmitted;
          } else if (state is SurveyStatusLoadedState) {
            _isSubmitted = state.isSubmitted;
          } else if (state is DynamicSurveySuccessState) {
            _isSubmitted = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                icon: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 54,
                ),
                title: const Text('Survey Bulanan Berhasil Dikirim'),
                content: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<SurveyBloc>().add(
                        const CheckSurveyStatusEvent(),
                      );
                      Navigator.pop(dialogContext);
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Selesai'),
                  ),
                ],
              ),
            );
          } else if (state is SurveyFailureState) {
            _showWarningSnackBar(state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is ApiSurveyLoadedState) {
            _currentApiSurvey = state.survey;
            _isSubmitted = state.isSubmitted;
          } else if (state is DynamicFormLoadedState) {
            _currentForm = state.form;
            _isSubmitted = state.isSubmitted;
          } else if (state is DynamicSurveySuccessState) {
            _isSubmitted = true;
          } else if (state is SurveyStatusLoadedState) {
            _isSubmitted = state.isSubmitted;
          }

          if (state is SurveyLoadingState &&
              _currentApiSurvey == null &&
              _currentForm == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_currentApiSurvey != null) {
            return _buildApiSurveyBody(_currentApiSurvey!, _isSubmitted);
          }

          if (_currentForm != null) {
            return _buildLegacyFormBody(_currentForm!, _isSubmitted);
          }

          return const Center(child: Text('Gagal memuat survey bulanan'));
        },
      ),
    );
  }

  Widget _buildApiSurveyBody(SurveyItemEntity survey, bool isSubmitted) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.assignment_turned_in_rounded,
                        color: AppColors.primary,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              survey.title,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            if (survey.description != null &&
                                survey.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                survey.description!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (isSubmitted) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Anda telah mengisi survey bulanan ini.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                ...survey.questions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final question = entry.value;
                  return _buildApiQuestionCard(
                    number: index,
                    question: question,
                    isEnabled: !isSubmitted,
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (!isSubmitted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: BlocBuilder<SurveyBloc, SurveyState>(
                builder: (context, blocState) {
                  final isSubmitting = blocState is SurveySubmittingState;

                  return SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () => _submitApiForm(survey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Mengirim...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Kirim',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLegacyFormBody(MonthlySurveyFormEntity form, bool isSubmitted) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: AppColors.primary,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${form.title} (${form.periodLabel})',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              form.description,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (isSubmitted) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Anda telah mengisi survey bulanan dinamis untuk periode ${form.periodLabel}.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                ...form.questions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final question = entry.value;
                  return _buildLegacyDynamicQuestionCard(
                    number: index,
                    question: question,
                    isEnabled: !isSubmitted,
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (!isSubmitted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: BlocBuilder<SurveyBloc, SurveyState>(
                builder: (context, blocState) {
                  final isSubmitting = blocState is SurveySubmittingState;

                  return SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () => _submitDynamicForm(form),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Mengirim...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Kirim',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildApiQuestionCard({
    required int number,
    required SurveyQuestionEntity question,
    required bool isEnabled,
  }) {
    final key = question.id.toString();
    final selectedValue = _answers[key]?.toString();
    final showConditional = question.shouldShowConditionalFields(selectedValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: question.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          _buildApiQuestionInput(question, isEnabled),
          if (showConditional && question.hasConditionalFields) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.alt_route_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Pertanyaan Lanjutan:',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...question.conditionalFields.map((field) {
                    return _buildConditionalFieldWidget(
                      questionId: question.id,
                      field: field,
                      isEnabled: isEnabled,
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildApiQuestionInput(SurveyQuestionEntity question, bool isEnabled) {
    final key = question.id.toString();

    if (question.isPilihanGanda) {
      return Column(
        children: question.options.map((opt) {
          final isSelected = _answers[key] == opt;
          return InkWell(
            onTap: isEnabled
                ? () {
                    setState(() {
                      _answers[key] = opt;
                    });
                  }
                : null,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey400,
                        width: isSelected ? 6 : 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      opt,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }

    if (question.isSkala) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: question.options.map((opt) {
          final isSelected = _answers[key] == opt;
          return InkWell(
            onTap: isEnabled
                ? () {
                    setState(() {
                      _answers[key] = opt;
                    });
                  }
                : null,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryLight.withValues(alpha: 0.5)
                    : AppColors.grey50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey300,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey400,
                        width: isSelected ? 6 : 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      opt,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
    final controller = _getTextController(key);
    return TextFormField(
      controller: controller,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      enabled: isEnabled,
      maxLines: 3,
      onChanged: (val) {
        _answers[key] = val;
      },
      decoration: InputDecoration(
        hintText: 'Tuliskan jawaban Anda...',
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
      ),
    );
  }

  Widget _buildConditionalFieldWidget({
    required int questionId,
    required SurveyConditionalFieldEntity field,
    required bool isEnabled,
  }) {
    final condKey = '${questionId}_cond_${field.id}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.label != null && field.label!.isNotEmpty) ...[
            Text(
              field.label!,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
          ],

          if (field.isStatic)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Text(
                field.value ?? '-',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ),

          if (field.isSelect)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _answers[condKey] as String?,
                  hint: const Text('Pilih salah satu...'),
                  isExpanded: true,
                  onChanged: isEnabled
                      ? (val) {
                          setState(() {
                            _answers[condKey] = val;
                          });
                        }
                      : null,
                  items: field.options.map((opt) {
                    return DropdownMenuItem<String>(
                      value: opt,
                      child: Text(opt, style: AppTextStyles.bodyMedium),
                    );
                  }).toList(),
                ),
              ),
            ),

          if (field.isText)
            TextFormField(
              controller: _getTextController(condKey),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              enabled: isEnabled,
              onChanged: (val) {
                _answers[condKey] = val;
              },
              decoration: InputDecoration(
                hintText: 'Tuliskan jawaban Anda...',
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
              ),
            ),

          if (field.isTime)
            InkWell(
              onTap: isEnabled
                  ? () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        final formattedHour = pickedTime.hour
                            .toString()
                            .padLeft(2, '0');
                        final formattedMinute = pickedTime.minute
                            .toString()
                            .padLeft(2, '0');
                        final timeStr = '$formattedHour:$formattedMinute';
                        setState(() {
                          _answers[condKey] = timeStr;
                          _getTextController(condKey).text = timeStr;
                        });
                      }
                    }
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: IgnorePointer(
                child: TextFormField(
                  controller: _getTextController(condKey),
                  enabled: isEnabled,
                  decoration: InputDecoration(
                    hintText: 'Pilih jam (HH:mm)...',
                    prefixIcon: const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegacyDynamicQuestionCard({
    required int number,
    required DynamicQuestionEntity question,
    required bool isEnabled,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: question.question,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    children: [
                      if (question.isRequired)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _buildLegacyQuestionInputWidget(question, isEnabled),
        ],
      ),
    );
  }

  Widget _buildLegacyQuestionInputWidget(
    DynamicQuestionEntity question,
    bool isEnabled,
  ) {
    switch (question.type) {
      case DynamicQuestionType.singleChoice:
        return Column(
          children: question.options.map((opt) {
            final isSelected = _answers[question.id] == opt;
            return InkWell(
              onTap: isEnabled
                  ? () {
                      setState(() {
                        _answers[question.id] = opt;
                      });
                    }
                  : null,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey400,
                          width: isSelected ? 6 : 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        opt,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );

      case DynamicQuestionType.booleanChoice:
        return Column(
          children: [
            _buildRadioBooleanOption(
              label: 'Ya',
              value: true,
              questionId: question.id,
              isEnabled: isEnabled,
            ),
            _buildRadioBooleanOption(
              label: 'Tidak',
              value: false,
              questionId: question.id,
              isEnabled: isEnabled,
            ),
          ],
        );

      case DynamicQuestionType.numberInput:
        final controller = _getTextController(question.id);
        return TextFormField(
          controller: controller,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          enabled: isEnabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            _answers[question.id] = val;
          },
          decoration: InputDecoration(
            hintText: 'Masukkan angka',
            filled: true,
            fillColor: AppColors.grey50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
          ),
        );

      case DynamicQuestionType.textInput:
      default:
        final controller = _getTextController(question.id);
        return TextFormField(
          controller: controller,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          enabled: isEnabled,
          maxLines: 3,
          onChanged: (val) {
            _answers[question.id] = val;
          },
          decoration: InputDecoration(
            hintText: 'Tuliskan jawaban Anda...',
            filled: true,
            fillColor: AppColors.grey50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
          ),
        );
    }
  }

  Widget _buildRadioBooleanOption({
    required String label,
    required bool value,
    required String questionId,
    required bool isEnabled,
  }) {
    final isSelected = _answers[questionId] == value;

    return InkWell(
      onTap: isEnabled
          ? () {
              setState(() {
                _answers[questionId] = value;
              });
            }
          : null,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey400,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
