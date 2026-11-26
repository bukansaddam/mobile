import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/app_update_service.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateDialog {
  AppUpdateDialog._();

  static bool _isShowing = false;

  static Future<void> checkAndShow(
    BuildContext context, {
    AppUpdateService? service,
    Future<bool> Function(Uri uri)? urlLauncher,
  }) async {
    if (_isShowing) return;

    final resolvedService =
        service ??
        (sl.isRegistered<AppUpdateService>() ? sl<AppUpdateService>() : null);
    if (resolvedService == null) return;

    _isShowing = true;
    try {
      final info = await resolvedService.checkForUpdate();
      if (info == null || !context.mounted) return;

      await show(
        context,
        info: info,
        onDismissOptional: resolvedService.dismissOptionalUpdate,
        urlLauncher: urlLauncher,
      );
    } finally {
      _isShowing = false;
    }
  }

  static Future<void> show(
    BuildContext context, {
    required AppUpdateInfo info,
    required Future<void> Function(String version) onDismissOptional,
    Future<bool> Function(Uri uri)? urlLauncher,
  }) {
    final isForce = info.isForceUpdate;
    final launch =
        urlLauncher ??
        (Uri uri) => launchUrl(uri, mode: LaunchMode.externalApplication);

    return AppDialogs.showCustom<void>(
      context,
      barrierDismissible: !isForce,
      canPop: !isForce,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      builder: (dialogContext) {
        final colors = dialogContext.appColors;
        final title = isForce
            ? 'Pembaruan Wajib Diperlukan'
            : 'Pembaruan Aplikasi Tersedia';
        final message = isForce
            ? 'Versi aplikasi Anda sudah tidak didukung. Perbarui sekarang untuk melanjutkan.'
            : 'Versi terbaru sudah tersedia. Perbarui aplikasi agar tetap optimal dan aman.';

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RosetteBadge(
              icon: Icons.system_update_rounded,
              badgeColor: isForce ? colors.warningLight : colors.primaryLight,
              iconColor: isForce ? colors.warningDark : colors.primaryDark,
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.border),
              ),
              child: Text(
                'v${info.currentVersion} -> v${info.latestVersion}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final uri = Uri.tryParse(info.downloadUrl);
                  var launched = false;
                  if (uri != null) {
                    try {
                      launched = await launch(uri);
                    } catch (_) {
                      launched = false;
                    }
                  }
                  if (!launched && dialogContext.mounted) {
                    AppToast.showError(
                      dialogContext,
                      message: 'Gagal membuka tautan pembaruan.',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Perbarui Sekarang',
                  style: AppTextStyles.button.copyWith(
                    fontSize: 15,
                    color: colors.onPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            if (!isForce) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () async {
                    await onDismissOptional(info.latestVersion);
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.secondary,
                    side: BorderSide(color: colors.borderStrong, width: 1.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Nanti',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 15,
                      color: colors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
