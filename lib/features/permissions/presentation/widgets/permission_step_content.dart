import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_illustration.dart';
import 'package:akar/features/permissions/presentation/widgets/permission_notice_strip.dart';
import 'package:flutter/material.dart';

/// Scrollable cardless step content (illustration, copy, and conditional notices).
class PermissionStepContent extends StatelessWidget {
  final PermissionStepSpec spec;
  final PermissionStepStatus status;
  final double illustrationHeight;

  const PermissionStepContent({
    super.key,
    required this.spec,
    required this.status,
    required this.illustrationHeight,
  });

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
      ],
    );
  }
}
