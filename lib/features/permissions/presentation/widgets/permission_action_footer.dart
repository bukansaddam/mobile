import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:akar/features/permissions/domain/entities/permission_step_status.dart';
import 'package:flutter/material.dart';

/// Sticky bottom action dock holding the primary CTA, optional refresh, and logout.
class PermissionActionFooter extends StatelessWidget {
  final PermissionStepSpec spec;
  final PermissionStepStatus status;
  final bool isRequesting;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onRefreshPressed;
  final VoidCallback onLogoutPressed;

  const PermissionActionFooter({
    super.key,
    required this.spec,
    required this.status,
    required this.isRequesting,
    required this.onPrimaryPressed,
    required this.onRefreshPressed,
    required this.onLogoutPressed,
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: isRequesting ? null : onPrimaryPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  disabledBackgroundColor: colors.primary.withValues(
                    alpha: 0.65,
                  ),
                  disabledForegroundColor: colors.onPrimary,
                  minimumSize: const Size(double.infinity, 52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
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
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: isRequesting ? null : onRefreshPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.primaryDark,
                    minimumSize: const Size(double.infinity, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
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
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: onLogoutPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.textSecondary,
                    minimumSize: const Size(88, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    tapTargetSize: MaterialTapTargetSize.padded,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Keluar',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textSecondary,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
