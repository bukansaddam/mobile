import 'dart:math' as math;
import 'dart:ui';
import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Komponen badge berbentuk rosette (stempel 8 sisi melengkung)
/// sesuai dengan desain referensi modern.
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
          // Soft ambient glow shadow under the badge
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

/// Standarisasi Dialog Interaktif (ADA AKSI lanjutan) di aplikasi AKAR NARADATA.
/// Tampilan mengikuti floating bottom sheet: berada di bawah dengan margin, sudut membulat lebar,
/// dan tombol berbentuk pill (kapsul).
class AppDialogs {
  AppDialogs._();

  /// Menampilkan Success Dialog seperti pada referensi desain.
  /// Cocok untuk aksi berhasil yang membutuhkan tombol tindakan (misal: "Selesai", "Kembali ke Beranda", dll).
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
    Color buttonColor = AppColors.primary,
    bool barrierDismissible = false,
  }) {
    return _showAnimatedDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return _AppDialogCard(
          badge: RosetteBadge(
            icon: badgeIcon,
            badgeColor: const Color(0xFFC7F8A5),
            iconColor: const Color(0xFF14532D),
          ),
          title: title,
          message: message,
          customContent: customContent,
          actions: [
            _DialogPrimaryButton(
              text: buttonText,
              color: buttonColor,
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

  /// Menampilkan Failed / Error Dialog.
  /// Cocok saat operasi gagal dan butuh perhatian user (misal: opsi "Coba Lagi" atau "Tutup").
  static Future<T?> showFailed<T>(
    BuildContext context, {
    String title = 'Terjadi Kesalahan',
    required String message,
    String primaryButtonText = 'Tutup',
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
        return _AppDialogCard(
          badge: const RosetteBadge(
            icon: Icons.close_rounded,
            badgeColor: Color(0xFFFEE2E2),
            iconColor: Color(0xFFDC2626),
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
                      color: const Color(0xFFDC2626),
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
                color: AppColors.primary,
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

  /// Menampilkan Confirmation Dialog sebelum melakukan aksi penting.
  /// Mengembalikan Future<bool?>: `true` jika user konfirmasi, `false` jika batal.
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
        return _AppDialogCard(
          badge: RosetteBadge(
            icon:
                icon ??
                (isDestructive
                    ? Icons.warning_amber_rounded
                    : Icons.help_outline_rounded),
            badgeColor: isDestructive
                ? const Color(0xFFFEE2E2)
                : const Color(0xFFFEF3C7),
            iconColor: isDestructive
                ? const Color(0xFFDC2626)
                : const Color(0xFFD97706),
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
                    onPressed: () {
                      Navigator.pop(dialogContext, false);
                      if (onCancel != null) onCancel();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogPrimaryButton(
                    text: confirmText,
                    color: isDestructive
                        ? const Color(0xFFDC2626)
                        : AppColors.primary,
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

  /// Menampilkan Alert / Info Dialog.
  /// Cocok untuk pemberitahuan penting yang wajib dibaca dan ditutup dengan tombol konfirmasi.
  static Future<T?> showAlert<T>(
    BuildContext context, {
    String title = 'Informasi',
    required String message,
    String buttonText = 'Mengerti',
    VoidCallback? onPressed,
    IconData icon = Icons.info_outline_rounded,
    Color buttonColor = AppColors.primary,
    Widget? customContent,
    bool barrierDismissible = false,
  }) {
    return _showAnimatedDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return _AppDialogCard(
          badge: RosetteBadge(
            icon: icon,
            badgeColor: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
          title: title,
          message: message,
          customContent: customContent,
          actions: [
            _DialogPrimaryButton(
              text: buttonText,
              color: buttonColor,
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

  /// Helper untuk animasi transisi slide-up lembut dari bawah + fade + backdrop blur
  /// dengan tata letak floating bottom sheet (di bawah dengan margin).
  static Future<T?> _showAnimatedDialog<T>({
    required BuildContext context,
    required bool barrierDismissible,
    required Widget Function(BuildContext) builder,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss Dialog',
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (ctx, anim1, anim2) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: barrierDismissible ? () => Navigator.of(ctx).pop() : null,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.of(ctx).viewInsets.bottom > 0
                      ? MediaQuery.of(ctx).viewInsets.bottom + 16
                      : 16,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: GestureDetector(
                      // Mencegah klik di dalam kartu dialog menutup dialog
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: builder(ctx),
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

/// Container kartu dialog bersih, melayang (floating bottom sheet) dengan rounded sudut besar.
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 36,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          badge,
          const SizedBox(height: 22),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
              fontWeight: FontWeight.normal,
            ),
          ),
          if (customContent != null) ...[
            const SizedBox(height: 18),
            customContent!,
          ],
          const SizedBox(height: 26),
          ...actions,
        ],
      ),
    );
  }
}

class _DialogPrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _DialogPrimaryButton({
    required this.text,
    required this.color,
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
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
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
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1E293B),
          side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
      ),
    );
  }
}
