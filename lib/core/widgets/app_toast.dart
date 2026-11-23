import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:flutter/material.dart';

/// Utility untuk menampilkan feedback non-blocking (SnackBar/Toast)
/// ketika TIDAK ADA aksi lanjutan yang membutuhkan keputusan pengguna.
class AppToast {
  AppToast._();

  /// Menampilkan toast sukses ringan (non-blocking)
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = context.appColors;
    _showSnackBar(
      context,
      message: message,
      backgroundColor: colors.isDark ? colors.surfaceElevated : colors.success,
      foregroundColor: colors.isDark ? colors.textPrimary : colors.onErrorSolid,
      iconColor: colors.isDark ? colors.success : colors.onErrorSolid,
      borderColor: colors.isDark
          ? colors.success.withValues(alpha: 0.45)
          : null,
      icon: Icons.check_circle_rounded,
      duration: duration,
    );
  }

  /// Menampilkan toast error / kegagalan ringan (non-blocking)
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = context.appColors;
    _showSnackBar(
      context,
      message: message,
      backgroundColor: colors.isDark
          ? colors.surfaceElevated
          : colors.errorSolid,
      foregroundColor: colors.isDark ? colors.textPrimary : colors.onErrorSolid,
      iconColor: colors.isDark ? colors.error : colors.onErrorSolid,
      borderColor: colors.isDark ? colors.error.withValues(alpha: 0.45) : null,
      icon: Icons.error_rounded,
      duration: duration,
    );
  }

  /// Menampilkan toast peringatan (non-blocking)
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = context.appColors;
    _showSnackBar(
      context,
      message: message,
      backgroundColor: colors.isDark ? colors.surfaceElevated : colors.warning,
      foregroundColor: colors.isDark ? colors.textPrimary : colors.onErrorSolid,
      iconColor: colors.isDark ? colors.warning : colors.onErrorSolid,
      borderColor: colors.isDark
          ? colors.warning.withValues(alpha: 0.45)
          : null,
      icon: Icons.warning_rounded,
      duration: duration,
    );
  }

  /// Menampilkan toast info (non-blocking)
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = context.appColors;
    _showSnackBar(
      context,
      message: message,
      backgroundColor: colors.isDark
          ? colors.surfaceElevated
          : colors.secondary,
      foregroundColor: colors.isDark ? colors.textPrimary : colors.onSecondary,
      iconColor: colors.isDark ? colors.info : colors.onSecondary,
      borderColor: colors.isDark ? colors.borderStrong : null,
      icon: Icons.info_rounded,
      duration: duration,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color iconColor,
    Color? borderColor,
    required IconData icon,
    required Duration duration,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    final cleanMessage = ErrorUtils.cleanExceptionMessage(message);
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                cleanMessage,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: borderColor != null
              ? BorderSide(color: borderColor)
              : BorderSide.none,
        ),
        duration: duration,
      ),
    );
  }
}
