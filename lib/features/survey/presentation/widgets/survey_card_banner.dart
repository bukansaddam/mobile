import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/dashboard/domain/entities/member_dashboard_entity.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:akar/features/linmas/dashboard/presentation/bloc/member_dashboard_bloc.dart';
import 'package:akar/features/linmas/dashboard/presentation/bloc/member_dashboard_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SurveyCardBanner extends StatefulWidget {
  final MemberDashboardSurveyEntity? survey;

  const SurveyCardBanner({super.key, this.survey});

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
        bool isAvailable = true;
        String surveyTitle = 'Survey Bulanan Lingkungan & RT';
        String? surveyDescription;

        if (widget.survey != null) {
          final s = widget.survey!;
          if (s.periodLabel.isNotEmpty) {
            periodLabel = s.periodLabel;
          }
          isSubmitted = s.isFilled;
          isAvailable = s.isAvailable;
          if (s.surveyTitle != null && s.surveyTitle!.trim().isNotEmpty) {
            surveyTitle = s.surveyTitle!.trim();
          }
          if (s.description != null && s.description!.trim().isNotEmpty) {
            surveyDescription = s.description!.trim();
          }
        } else if (state is SurveyStatusLoadedState) {
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

        // Jangan tampilkan card jika survey tidak tersedia (is_available == false)
        // atau survey sudah diisi (is_filled == true / isSubmitted == true)
        if (!isAvailable || isSubmitted || isDismissed) {
          return const SizedBox.shrink();
        }

        final descriptionText =
            surveyDescription ??
            (isSubmitted
                ? 'Terima kasih atas partisipasi Anda dalam memantau lingkungan & keamanan RT.'
                : 'Isi pertanyaan survey bulanan berkala dari Admin untuk evaluasi lingkungan RT Anda.');

        final badgeText = isSubmitted
            ? 'Sudah Diisi'
            : (isAvailable ? 'Wajib Diisi' : 'Belum Tersedia');

        final badgeBgColor = isSubmitted
            ? AppColors.white
            : (isAvailable ? const Color(0xFFFEF3C7) : const Color(0xFFE2E8F0));

        final badgeTextColor = isSubmitted
            ? AppColors.accent
            : (isAvailable ? const Color(0xFF92400E) : const Color(0xFF475569));

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
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
                                ScaffoldMessenger.of(context).clearSnackBars();
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
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              color: badgeTextColor,
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
                    surveyTitle,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descriptionText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                  ),
                  if (!isSubmitted && isAvailable) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () async {
                          await context.pushNamed('survey');
                          if (context.mounted) {
                            try {
                              context.read<MemberDashboardBloc>().add(
                                const FetchMemberDashboardEvent(),
                              );
                            } catch (_) {}
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.accent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Isi Survey',
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
          ),
        );
      },
    );
  }
}
