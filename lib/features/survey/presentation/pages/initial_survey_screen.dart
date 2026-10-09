import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/survey/domain/entities/initial_quiz_entity.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class InitialSurveyScreen extends StatefulWidget {
  const InitialSurveyScreen({super.key});

  @override
  State<InitialSurveyScreen> createState() => _InitialSurveyScreenState();
}

class _InitialSurveyScreenState extends State<InitialSurveyScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _answers = {};
  final Map<String, TextEditingController> _subControllers = {};
  final Map<String, TextEditingController> _textControllers = {};

  InitialQuizResponseEntity? _loadedQuiz;

  @override
  void initState() {
    super.initState();
    _fetchQuiz();
  }

  void _fetchQuiz() {
    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.id;
    context.read<SurveyBloc>().add(GetInitialQuizEvent(userId: userId));
  }

  @override
  void dispose() {
    for (final controller in _subControllers.values) {
      controller.dispose();
    }
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getSubController(String key) {
    if (!_subControllers.containsKey(key)) {
      _subControllers[key] = TextEditingController();
    }
    return _subControllers[key]!;
  }

  TextEditingController _getTextController(String key) {
    if (!_textControllers.containsKey(key)) {
      _textControllers[key] = TextEditingController();
    }
    return _textControllers[key]!;
  }

  void _submitForm() {
    if (_loadedQuiz == null) return;
    final questions = _loadedQuiz!.questions;

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final key = q.id.toString();
      final answer = _answers[key];

      if (q.isRequired) {
        if (answer == null ||
            (answer is String && answer.trim().isEmpty) ||
            (answer is List && answer.isEmpty)) {
          _showWarningSnackBar(
            'Mohon jawab pertanyaan ${q.questionNumber ?? (i + 1)} (${q.text})',
          );
          return;
        }
      }

      if (q.isOptionTriggeringSubInput(answer?.toString())) {
        final subText = _subControllers[key]?.text.trim() ?? '';
        if (subText.isEmpty) {
          _showWarningSnackBar(
            'Mohon isi ${q.subInputLabel ?? 'keterangan lanjutan'} pada pertanyaan ${q.questionNumber ?? (i + 1)}',
          );
          return;
        }
      }
    }

    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.id ?? 0;

    final List<Map<String, dynamic>> answersList = [];
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final key = q.id.toString();
      final answerVal = _answers[key];
      if (answerVal == null) continue;

      final questionNum = q.questionNumber ?? (i + 1);
      final item = <String, dynamic>{
        'question_number': questionNum,
        'value': answerVal.toString(),
      };

      if (q.isOptionTriggeringSubInput(answerVal.toString())) {
        final subText = _subControllers[key]?.text.trim() ?? '';
        if (subText.isNotEmpty) {
          item['sub_value'] = subText;
        }
      }

      answersList.add(item);
    }

    context.read<SurveyBloc>().add(
      SubmitInitialQuizAnswersEvent(userId: userId, answers: answersList),
    );
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          false, // Mengharuskan pengisian survey baseline saat login pertama
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Survey Profil Baseline Linmas',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: BlocConsumer<SurveyBloc, SurveyState>(
          listener: (context, state) {
            if (state is InitialQuizAlreadyCompletedState) {
              context.go('/main');
            } else if (state is InitialSurveySuccessState) {
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
                  title: const Text('Profil Linmas Berhasil Disimpan'),
                  content: const Text(
                    'Terima kasih telah melengkapi data baseline profil lingkungan & keamanan RT Anda.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.go('/main');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Masuk ke Aplikasi'),
                    ),
                  ],
                ),
              );
            } else if (state is SurveyFailureState) {
              _showWarningSnackBar(state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is InitialQuizLoadedState) {
              _loadedQuiz = state.quiz;
            }

            if (state is SurveyLoadingState && _loadedQuiz == null) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'Memuat pertanyaan survey profil...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is SurveyFailureState && _loadedQuiz == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 56,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal Memuat Survey',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _fetchQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_loadedQuiz != null) {
              return _buildQuizContent(_loadedQuiz!);
            }

            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: _loadedQuiz == null
            ? null
            : AnimatedPadding(
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                    top: false,
                    bottom: MediaQuery.of(context).viewInsets.bottom == 0,
                    child: BlocBuilder<SurveyBloc, SurveyState>(
                      builder: (context, state) {
                        final isSubmitting = state is SurveySubmittingState;

                        return SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : _submitForm,
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
                                        'Simpan...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Simpan',
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
              ),
      ),
    );
  }

  Widget _buildQuizContent(InitialQuizResponseEntity quiz) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
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
                    Icons.verified_user_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Survey Profil Initial (Sekali Seumur Hidup)',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sebagai anggota Linmas, mohon lengkapi ${quiz.questions.length} pertanyaan baseline profil wilayah RT Anda sebelum melanjutkan.',
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
            ...quiz.questions.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final question = entry.value;
              return _buildDynamicQuestionCard(
                number: question.questionNumber ?? index,
                question: question,
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicQuestionCard({
    required int number,
    required InitialQuizQuestionEntity question,
  }) {
    final key = question.id.toString();
    final selectedValue = _answers[key];

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
                child: Text(
                  question.text,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Options / inputs
          if (question.options.isNotEmpty) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: question.options.map((opt) {
                final isSelected = selectedValue == opt.value;
                final triggersSub = question.isOptionTriggeringSubInput(
                  opt.value,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRadioOption<String>(
                      label: opt.displayLabel,
                      value: opt.value,
                      groupValue: selectedValue?.toString(),
                      onChanged: (val) {
                        setState(() {
                          _answers[key] = val;
                          if (!triggersSub) {
                            _subControllers[key]?.clear();
                          }
                        });
                      },
                    ),
                    if (isSelected && triggersSub) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 36,
                          top: 4,
                          bottom: 8,
                          right: 8,
                        ),
                        child: TextFormField(
                          controller: _getSubController(key),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          keyboardType: question.subInputType == 'number'
                              ? TextInputType.number
                              : TextInputType.text,
                          inputFormatters: question.subInputType == 'number'
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : [],
                          decoration: InputDecoration(
                            labelText:
                                question.subInputLabel ?? 'Masukkan Keterangan',
                            hintText: question.subInputType == 'number'
                                ? 'Contoh: 5'
                                : 'Masukkan keterangan...',
                            prefixIcon: Icon(
                              question.subInputType == 'number'
                                  ? Icons.people_outline_rounded
                                  : Icons.edit_note_rounded,
                            ),
                            filled: true,
                            fillColor: AppColors.grey50,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.grey300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }).toList(),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: TextFormField(
                controller: _getTextController(key),
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                maxLines: 3,
                onChanged: (val) {
                  _answers[key] = val;
                },
                decoration: InputDecoration(
                  hintText: 'Tuliskan jawaban Anda...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textHint,
                  ),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRadioOption<T>({
    required String label,
    required T value,
    required T? groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
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
