import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/survey/domain/entities/survey_api_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:material_ui/material_ui.dart';
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
    AppToast.showWarning(context, message: message);
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

  void _handleBack(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      if (router.canPop()) {
        router.pop();
      } else {
        router.go('/main');
      }
      return;
    }
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppPageBar(
        title: 'Survey Bulanan',
        onBackPressed: () => _handleBack(context),
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
            AppDialogs.showSuccess(
              context,
              title: 'Survey Bulanan Berhasil Dikirim',
              message: state.message,
              buttonText: 'Selesai',
              onPressed: () {
                context.read<SurveyBloc>().add(const CheckSurveyStatusEvent());
                _handleBack(context);
              },
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
    final colors = context.appColors;
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
                    color: colors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.assignment_turned_in_rounded,
                        color: colors.primary,
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
                                color: colors.primaryDark,
                              ),
                            ),
                            if (survey.description != null &&
                                survey.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                survey.description!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textSecondary,
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
                ...survey.questions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final question = entry.value;
                  return _buildApiQuestionCard(
                    number: index,
                    question: question,
                    isEnabled: true,
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
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
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: colors.onPrimary,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Mengirim...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimary,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Kirim',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.onPrimary,
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
    final colors = context.appColors;
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
                    color: colors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings_rounded,
                        color: colors.primary,
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
                                color: colors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              form.description,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...form.questions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final question = entry.value;
                  return _buildLegacyDynamicQuestionCard(
                    number: index,
                    question: question,
                    isEnabled: true,
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
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
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: colors.onPrimary,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Mengirim...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimary,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Kirim',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.onPrimary,
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
    final colors = context.appColors;
    final key = question.id.toString();
    final selectedValue = _answers[key]?.toString();
    final showConditional = question.shouldShowConditionalFields(selectedValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
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
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.primary,
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
                      color: colors.textPrimary,
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
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderStrong),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.alt_route_rounded,
                        size: 16,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Pertanyaan Lanjutan:',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryDark,
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
    final colors = context.appColors;
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
                        color: isSelected ? colors.primary : colors.textHint,
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
                            ? colors.primaryDark
                            : colors.textPrimary,
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
                    ? colors.primaryLight.withValues(alpha: 0.5)
                    : colors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.borderStrong,
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
                        color: isSelected ? colors.primary : colors.textHint,
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
                            ? colors.primaryDark
                            : colors.textPrimary,
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
      style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      enabled: isEnabled,
      maxLines: 3,
      onChanged: (val) {
        _answers[key] = val;
      },
      decoration: InputDecoration(
        hintText: 'Tuliskan jawaban Anda...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: colors.textHint),
        filled: true,
        fillColor: colors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.borderStrong),
        ),
      ),
    );
  }

  Widget _buildConditionalFieldWidget({
    required int questionId,
    required SurveyConditionalFieldEntity field,
    required bool isEnabled,
  }) {
    final colors = context.appColors;
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
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
          ],

          if (field.isStatic)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.borderStrong),
              ),
              child: Text(
                field.value ?? '-',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.primaryDark,
                ),
              ),
            ),

          if (field.isSelect)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.borderStrong),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _answers[condKey] as String?,
                  dropdownColor: colors.surface,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  hint: Text(
                    'Pilih salah satu...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textHint,
                    ),
                  ),
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
                      child: Text(
                        opt,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          if (field.isText)
            TextFormField(
              controller: _getTextController(condKey),
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textPrimary,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              enabled: isEnabled,
              onChanged: (val) {
                _answers[condKey] = val;
              },
              decoration: InputDecoration(
                hintText: 'Tuliskan jawaban Anda...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textHint,
                ),
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.borderStrong),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.borderStrong),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.primary),
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  enabled: isEnabled,
                  decoration: InputDecoration(
                    hintText: 'Pilih jam (HH:mm)...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textHint,
                    ),
                    prefixIcon: Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: colors.primary,
                    ),
                    filled: true,
                    fillColor: colors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colors.borderStrong),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colors.borderStrong),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colors.primary),
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
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
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
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.primary,
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
                      color: colors.textPrimary,
                      height: 1.3,
                    ),
                    children: [
                      if (question.isRequired)
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: colors.error),
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
    final colors = context.appColors;
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
                          color: isSelected ? colors.primary : colors.textHint,
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
                              ? colors.primaryDark
                              : colors.textPrimary,
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
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
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
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: colors.textHint,
            ),
            filled: true,
            fillColor: colors.surfaceVariant,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.borderStrong),
            ),
          ),
        );

      case DynamicQuestionType.textInput:
      default:
        final controller = _getTextController(question.id);
        return TextFormField(
          controller: controller,
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          enabled: isEnabled,
          maxLines: 3,
          onChanged: (val) {
            _answers[question.id] = val;
          },
          decoration: InputDecoration(
            hintText: 'Tuliskan jawaban Anda...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: colors.textHint,
            ),
            filled: true,
            fillColor: colors.surfaceVariant,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.borderStrong),
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
    final colors = context.appColors;
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
                  color: isSelected ? colors.primary : colors.textHint,
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
                  color: isSelected ? colors.primaryDark : colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
