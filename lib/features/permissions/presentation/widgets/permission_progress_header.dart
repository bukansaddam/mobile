import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:flutter/material.dart';

/// Displays the active user role pill, logout action, and segmented step progress.
class PermissionProgressHeader extends StatelessWidget {
  final String roleLabel;
  final int currentStepNumber;
  final int totalSteps;
  final List<PermissionStepSpec> steps;
  final Map<AppPermissionType, PermissionStepStatus> statuses;
  final VoidCallback onLogoutPressed;

  const PermissionProgressHeader({
    super.key,
    required this.roleLabel,
    required this.currentStepNumber,
    required this.totalSteps,
    required this.steps,
    required this.statuses,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.primaryBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      size: 16,
                      color: colors.primaryDark,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        roleLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onLogoutPressed,
              style: TextButton.styleFrom(
                foregroundColor: colors.textSecondary,
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                tapTargetSize: MaterialTapTargetSize.padded,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: Text(
                'Keluar',
                style: AppTextStyles.labelLarge.copyWith(
                  color: colors.textSecondary,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
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
                    height: i == currentStepNumber - 1 ? 8 : 6,
                    margin: EdgeInsets.only(
                      right: i < steps.length - 1 ? 6 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: ((statuses[steps[i].type]?.isGranted ?? false) ||
                              i == currentStepNumber - 1)
                          ? colors.primary
                          : colors.borderStrong,
                      borderRadius: BorderRadius.circular(4),
                      border: (i == currentStepNumber - 1 &&
                              !(statuses[steps[i].type]?.isGranted ?? false))
                          ? Border.all(
                              color: colors.primaryBorder,
                              width: 1.5,
                            )
                          : null,
                      boxShadow: (i == currentStepNumber - 1 &&
                              !(statuses[steps[i].type]?.isGranted ?? false))
                          ? [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.28),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
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
