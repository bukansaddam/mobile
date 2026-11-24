import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_illustration.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_notice_strip.dart';
import 'package:flutter/material.dart';

/// Cardless seamless step body for a single permission onboarding step.
class PermissionStepContent extends StatelessWidget {
  final PermissionStepSpec spec;
  final PermissionStepStatus status;
  final bool isRequesting;
  final double illustrationHeight;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onRefreshPressed;

  const PermissionStepContent({
    super.key,
    required this.spec,
    required this.status,
    required this.isRequesting,
    required this.illustrationHeight,
    required this.onPrimaryPressed,
    required this.onRefreshPressed,
  });

  String _primaryCtaLabel() {
    if (status.requiresSettings) {
      return 'Buka Pengaturan';
    }
    if (status == PermissionStepStatus.denied) {
      return 'Coba Izinkan Lagi';
    }
    return spec.actionLabel;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final requiresSettings = status.requiresSettings;
    final isDenied = status == PermissionStepStatus.denied;
    final disclosureNote = spec.disclosureNote;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: PermissionIllustration(
            type: spec.type,
            height: illustrationHeight,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          spec.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineLarge.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          spec.description,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
            height: 1.55,
          ),
        ),
        if (disclosureNote != null) ...[
          const SizedBox(height: 14),
          PermissionNoticeStrip.info(message: disclosureNote),
        ],
        if (isDenied || requiresSettings) ...[
          const SizedBox(height: 14),
          PermissionNoticeStrip.warning(
            icon: requiresSettings
                ? Icons.settings_outlined
                : Icons.warning_amber_rounded,
            message: requiresSettings
                ? spec.settingsHint
                : 'Izin belum diberikan. Izinkan akses ini agar fitur aplikasi dapat berfungsi dengan baik.',
          ),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isRequesting ? null : onPrimaryPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            disabledBackgroundColor: colors.primary.withValues(alpha: 0.65),
            disabledForegroundColor: colors.onPrimary,
            minimumSize: const Size(double.infinity, 52),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: isRequesting
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: colors.onPrimary,
                  ),
                )
              : Text(
                  _primaryCtaLabel(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        if (requiresSettings) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: isRequesting ? null : onRefreshPressed,
            style: TextButton.styleFrom(
              foregroundColor: colors.primaryDark,
              minimumSize: const Size(double.infinity, 48),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              'Periksa Ulang Status',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
