import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:flutter/material.dart';

/// Displays the current step counter and a flat segmented progress bar.
class PermissionProgressHeader extends StatelessWidget {
  final int currentStepNumber;
  final int totalSteps;
  final List<PermissionStepSpec> steps;
  final Map<AppPermissionType, PermissionStepStatus> statuses;

  const PermissionProgressHeader({
    super.key,
    required this.currentStepNumber,
    required this.totalSteps,
    required this.steps,
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Langkah $currentStepNumber dari $totalSteps',
          style: AppTextStyles.titleMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Semantics(
          label: 'Progres izin langkah $currentStepNumber dari $totalSteps',
          child: Row(
            children: [
              for (int i = 0; i < steps.length; i++)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    height: 6,
                    margin: EdgeInsets.only(
                      right: i < steps.length - 1 ? 6 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: ((statuses[steps[i].type]?.isGranted ?? false) ||
                              i == currentStepNumber - 1)
                          ? colors.primary
                          : colors.borderStrong,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
