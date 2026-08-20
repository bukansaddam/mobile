import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SurveyCardBanner extends StatefulWidget {
  const SurveyCardBanner({super.key});

  @override
  State<SurveyCardBanner> createState() => _SurveyCardBannerState();
}

class _SurveyCardBannerState extends State<SurveyCardBanner> {
  late SurveyBloc _surveyBloc;
  bool _isSubmitted = false;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _surveyBloc = context.read<SurveyBloc>();
    _surveyBloc.add(const CheckSurveyStatusEvent());
  }

  @override
  void dispose() {
    if (_isSubmitted && !_isDismissed) {
      _surveyBloc.add(const DismissSurveyCardEvent());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyBloc, SurveyState>(
      builder: (context, state) {
        String periodLabel = SurveyEntity.getCurrentPeriodLabel();
        bool isSubmitted = false;
        bool isDismissed = false;

        if (state is SurveyStatusLoadedState) {
          periodLabel = state.periodLabel;
          isSubmitted = state.isSubmitted;
          isDismissed = state.isDismissed;
        } else if (state is DynamicFormLoadedState) {
          periodLabel = state.form.periodLabel;
          isSubmitted = state.isSubmitted;
        } else if (state is DynamicSurveySuccessState) {
          isSubmitted = true;
        }

        _isSubmitted = isSubmitted;
        _isDismissed = isDismissed;

        if (isSubmitted && isDismissed) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent,
                  AppColors.accent.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    isSubmitted
                        ? Icons.check_circle_outline_rounded
                        : Icons.assignment_turned_in_rounded,
                    size: 130,
                    color: AppColors.white.withValues(alpha: 0.12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Periode $periodLabel',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onLongPress: isSubmitted
                                ? () {
                                    context.read<SurveyBloc>().add(
                                      const ResetSurveyStatusEvent(),
                                    );
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Status survey berhasil di-reset untuk pengujian.',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isSubmitted
                                    ? AppColors.white
                                    : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isSubmitted ? 'Sudah Diisi' : 'Wajib Diisi',
                                style: TextStyle(
                                  color: isSubmitted
                                      ? AppColors.accent
                                      : const Color(0xFFD97706),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Survey Bulanan Lingkungan & RT',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSubmitted
                            ? 'Terima kasih atas partisipasi Anda dalam memantau lingkungan & keamanan RT.'
                            : 'Isi pertanyaan survey bulanan berkala dari Admin untuk evaluasi lingkungan RT Anda.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                      ),
                      if (!isSubmitted) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () => context.pushNamed('survey'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.accent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Isi Survey Sekarang',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
