import 'dart:math' as math;
import 'dart:ui';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:material_ui/material_ui.dart';

class RosetteBadge extends StatelessWidget {
  final IconData icon;
  final Color badgeColor;
  final Color iconColor;
  final double size;
  final double iconSize;

  const RosetteBadge({
    super.key,
    required this.icon,
    required this.badgeColor,
    required this.iconColor,
    this.size = 76.0,
    this.iconSize = 38.0,
  });

  @override
  Widget build(BuildContext context) {
    final double boxSize = size * 0.85;
    final double cornerRadius = boxSize * 0.28;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: boxSize * 0.9,
            height: boxSize * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: badgeColor.withValues(alpha: 0.5),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
          Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(cornerRadius),
              ),
            ),
          ),
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
          ),
          Icon(icon, color: iconColor, size: iconSize),
        ],
      ),
    );
  }
}

class AppDialogs {
  AppDialogs._();

  static Future<T?> showSuccess<T>(
    BuildContext context, {
    String title = 'Berhasil',
    required String message,
    String buttonText = 'Selesai',
    VoidCallback? onPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    Widget? customContent,
    IconData badgeIcon = Icons.check_rounded,
    Color? buttonColor,
    bool barrierDismissible = false,
  }) {
    return _showAnimatedDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final colors = dialogContext.appColors;
        return _AppDialogCard(
          badge: RosetteBadge(
            icon: badgeIcon,
            badgeColor: colors.primaryLight,
            iconColor: colors.primaryDark,
          ),
          title: title,
          message: message,
          customContent: customContent,
          actions: [
            _DialogPrimaryButton(
              text: buttonText,
              color: buttonColor ?? colors.primary,
              foregroundColor: buttonColor != null
                  ? colors.onErrorSolid
                  : colors.onPrimary,
              onPressed: () {
                Navigator.pop(dialogContext);
                if (onPressed != null) {
                  onPressed();
                }
              },
            ),
            if (secondaryButtonText != null) ...[
              const SizedBox(height: 12),
              _DialogOutlinedButton(
                text: secondaryButtonText,
                onPressed: () {
                  Navigator.pop(dialogContext);
                  if (onSecondaryPressed != null) {
                    onSecondaryPressed();
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }

  static Future<T?> showFailed<T>(
    BuildContext context, {
    String title = 'Terjadi Kesalahan',
    required String message,
    String primaryButtonText = 'Tutup',
    Color? primaryButtonColor,
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    Widget? customContent,
    bool barrierDismissible = false,
  }) {
    return _showAnimatedDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final colors = dialogContext.appColors;
        final twoButtonPrimaryColor = primaryButtonColor ?? colors.errorSolid;
        final twoButtonForeground = twoButtonPrimaryColor == colors.primary
            ? colors.onPrimary
            : colors.onErrorSolid;
        final singleButtonPrimaryColor = primaryButtonColor ?? colors.primary;
        final singleButtonForeground =
            singleButtonPrimaryColor == colors.primary
            ? colors.onPrimary
            : colors.onErrorSolid;
        return _AppDialogCard(
          badge: RosetteBadge(
            icon: Icons.close_rounded,
            badgeColor: colors.errorLight,
            iconColor: colors.error,
          ),
          title: title,
          message: message,
          customContent: customContent,
          actions: [
            if (secondaryButtonText != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _DialogOutlinedButton(
                      text: secondaryButtonText,
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        if (onSecondaryPressed != null) {
                          onSecondaryPressed();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DialogPrimaryButton(
                      text: primaryButtonText,
                      color: twoButtonPrimaryColor,
                      foregroundColor: twoButtonForeground,
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        if (onPrimaryPressed != null) {
                          onPrimaryPressed();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ] else ...[
              _DialogPrimaryButton(
                text: primaryButtonText,
                color: singleButtonPrimaryColor,
                foregroundColor: singleButtonForeground,
                onPressed: () {
                  Navigator.pop(dialogContext);
                  if (onPrimaryPressed != null) {
                    onPrimaryPressed();
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }

  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Lanjutkan',
    String cancelText = 'Batal',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    IconData? icon,
    Widget? customContent,
    bool barrierDismissible = true,
  }) async {
    final result = await _showAnimatedDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final colors = dialogContext.appColors;
        return _AppDialogCard(
          badge: RosetteBadge(
            icon:
                icon ??
                (isDestructive
                    ? Icons.warning_amber_rounded
                    : Icons.help_outline_rounded),
            badgeColor: isDestructive ? colors.errorLight : colors.warningLight,
            iconColor: isDestructive ? colors.error : colors.warning,
          ),
          title: title,
          message: message,
          customContent: customContent,
          actions: [
            Row(
              children: [
                Expanded(
                  child: _DialogOutlinedButton(
                    text: cancelText,
                    onPressed: () => Navigator.pop(dialogContext, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogPrimaryButton(
                    text: confirmText,
                    color: isDestructive ? colors.errorSolid : colors.primary,
                    foregroundColor: isDestructive
                        ? colors.onErrorSolid
                        : colors.onPrimary,
                    onPressed: () {
                      Navigator.pop(dialogContext, true);
                      if (onConfirm != null) onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result != true) {
      if (onCancel != null) onCancel();
      return false;
    }
    return true;
  }

  static Future<T?> showAlert<T>(
    BuildContext context, {
    String title = 'Informasi',
    required String message,
    String buttonText = 'Mengerti',
    VoidCallback? onPressed,
    IconData icon = Icons.info_outline_rounded,
    Color? buttonColor,
    Widget? customContent,
    bool barrierDismissible = false,
  }) {
    return _showAnimatedDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final colors = dialogContext.appColors;
        return _AppDialogCard(
          badge: RosetteBadge(
            icon: icon,
            badgeColor: colors.infoLight,
            iconColor: colors.info,
          ),
          title: title,
          message: message,
          customContent: customContent,
          actions: [
            _DialogPrimaryButton(
              text: buttonText,
              color: buttonColor ?? colors.primary,
              foregroundColor: buttonColor != null
                  ? colors.onErrorSolid
                  : colors.onPrimary,
              onPressed: () {
                Navigator.pop(dialogContext);
                if (onPressed != null) onPressed();
              },
            ),
          ],
        );
      },
    );
  }

  /// Menampilkan konten dialog kustom dalam gaya floating bottom card.
  static Future<T?> showCustom<T>(
    BuildContext context, {
    required Widget Function(BuildContext dialogContext) builder,
    bool barrierDismissible = true,
    bool canPop = true,
    bool useRootNavigator = true,
    bool useCardDecoration = true,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(24, 24, 24, 24),
  }) {
    return _showAnimatedDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      canPop: canPop,
      useRootNavigator: useRootNavigator,
      builder: (dialogContext) {
        final content = builder(dialogContext);
        if (!useCardDecoration) {
          return content;
        }
        return _FloatingDialogSurface(padding: padding, child: content);
      },
    );
  }

  /// Menampilkan dialog loading blocking (non-dismissible) dengan pesan proses.
  static Future<void> showLoading(
    BuildContext context, {
    required String message,
    bool useRootNavigator = true,
  }) {
    return showCustom<void>(
      context,
      barrierDismissible: false,
      canPop: false,
      useRootNavigator: useRootNavigator,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      builder: (dialogContext) {
        final colors = dialogContext.appColors;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<T?> _showAnimatedDialog<T>({
    required BuildContext context,
    required bool barrierDismissible,
    bool canPop = true,
    bool useRootNavigator = true,
    required Widget Function(BuildContext) builder,
  }) {
    final scrimColor = context.appColors.scrim;
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss Dialog',
      barrierColor: scrimColor,
      transitionDuration: const Duration(milliseconds: 260),
      useRootNavigator: useRootNavigator,
      pageBuilder: (ctx, anim1, anim2) {
        final maxHeight = MediaQuery.sizeOf(ctx).height * 0.85;
        return PopScope(
          canPop: canPop,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: barrierDismissible ? () => Navigator.of(ctx).pop() : null,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    MediaQuery.of(ctx).viewInsets.bottom > 0
                        ? MediaQuery.of(ctx).viewInsets.bottom + 16
                        : 16,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 440,
                        maxHeight: maxHeight,
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: builder(ctx),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curvedVal = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5 * curvedVal.value,
            sigmaY: 5 * curvedVal.value,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.20),
                end: Offset.zero,
              ).animate(curvedVal),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _FloatingDialogSurface extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _FloatingDialogSurface({required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(32),
        border: colors.isDark ? Border.all(color: colors.border) : null,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 36,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AppDialogCard extends StatelessWidget {
  final Widget badge;
  final String title;
  final String message;
  final Widget? customContent;
  final List<Widget> actions;

  const _AppDialogCard({
    required this.badge,
    required this.title,
    required this.message,
    this.customContent,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return _FloatingDialogSurface(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  badge,
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
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  if (customContent != null) ...[
                    const SizedBox(height: 18),
                    customContent!,
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          ...actions,
        ],
      ),
    );
  }
}

class _DialogPrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color foregroundColor;
  final VoidCallback onPressed;

  const _DialogPrimaryButton({
    required this.text,
    required this.color,
    required this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(
            fontSize: 15,
            color: foregroundColor,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

class _DialogOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _DialogOutlinedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.secondary,
          side: BorderSide(color: colors.borderStrong, width: 1.4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(
            fontSize: 15,
            color: colors.secondary,
          ),
        ),
      ),
    );
  }
}
