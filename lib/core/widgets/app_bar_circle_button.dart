import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

/// Tombol ikon lingkaran standar AppBar (visual 36x36, area sentuh 48x48dp).
class AppBarCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;
  final Color? iconColor;
  final bool isActive;
  final Color? backgroundColor;

  const AppBarCircleButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconSize = 20,
    this.iconColor,
    this.isActive = false,
    this.backgroundColor,
  });

  const AppBarCircleButton.back({
    super.key,
    this.onPressed,
    this.tooltip = 'Kembali',
    this.iconColor,
  }) : icon = Icons.chevron_left_rounded,
       iconSize = 22,
       isActive = false,
       backgroundColor = null;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDisabled = onPressed == null;
    final activeBg = colors.isDark ? colors.primary : colors.primaryDark;
    final resolvedBg = isActive
        ? activeBg
        : isDisabled
        ? colors.surface.withValues(alpha: colors.isDark ? 0.5 : 0.55)
        : (backgroundColor ??
              colors.surface.withValues(alpha: colors.isDark ? 0.92 : 0.9));
    final resolvedIconColor = isActive
        ? colors.onPrimary
        : isDisabled
        ? colors.textDisabled
        : (iconColor ?? colors.textPrimary);

    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          tooltip: tooltip,
          style: IconButton.styleFrom(
            fixedSize: const Size(36, 36),
            minimumSize: const Size(36, 36),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: resolvedBg,
            disabledBackgroundColor: resolvedBg,
            shape: const CircleBorder(),
            side: BorderSide.none,
          ),
          icon: Icon(icon, color: resolvedIconColor, size: iconSize),
        ),
      ),
    );
  }
}
