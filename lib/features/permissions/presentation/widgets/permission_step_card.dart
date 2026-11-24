import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:flutter/material.dart';

/// Card presenting the active permission rationale, disclosures, and action CTAs.
class PermissionStepCard extends StatelessWidget {
  final PermissionStepSpec spec;
  final PermissionStepStatus status;
  final bool isRequesting;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onRefreshPressed;

  const PermissionStepCard({
    super.key,
    required this.spec,
    required this.status,
    required this.isRequesting,
    required this.onPrimaryPressed,
    required this.onRefreshPressed,
  });

  IconData _iconForType(AppPermissionType type) {
    switch (type) {
      case AppPermissionType.locationWhenInUse:
        return Icons.location_on_rounded;
      case AppPermissionType.locationAlways:
        return Icons.my_location_rounded;
      case AppPermissionType.camera:
        return Icons.photo_camera_rounded;
      case AppPermissionType.microphone:
        return Icons.mic_rounded;
      case AppPermissionType.notification:
        return Icons.notifications_active_rounded;
    }
  }

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

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: colors.primaryLight,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: colors.primaryBorder, width: 1.5),
              ),
              child: Icon(
                _iconForType(spec.type),
                size: 36,
                color: colors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            spec.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLarge.copyWith(
              color: colors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            spec.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
              height: 1.55,
            ),
          ),
          if (disclosureNote != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.infoLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.info.withValues(alpha: 0.35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: colors.info,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      disclosureNote,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textPrimary,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isDenied || requiresSettings) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.warningLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.warningBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    requiresSettings
                        ? Icons.settings_outlined
                        : Icons.warning_amber_rounded,
                    size: 20,
                    color: colors.warning,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      requiresSettings
                          ? spec.settingsHint
                          : 'Izin belum diberikan. Izinkan akses ini agar fitur aplikasi dapat berfungsi dengan baik.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.warningDark,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isRequesting ? null : onPrimaryPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              disabledBackgroundColor: colors.primary.withValues(alpha: 0.7),
              disabledForegroundColor: colors.onPrimary,
              minimumSize: const Size(double.infinity, 52),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: isRequesting
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colors.onPrimary,
                    ),
                  )
                : Text(
                    _primaryCtaLabel(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.button.copyWith(
                      fontSize: 15,
                      color: colors.onPrimary,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                Icons.refresh_rounded,
                size: 18,
                color: colors.primaryDark,
              ),
              label: Text(
                'Periksa Ulang Status',
                style: AppTextStyles.button.copyWith(
                  color: colors.primaryDark,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
