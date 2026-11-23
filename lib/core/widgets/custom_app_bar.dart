import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_bar_notification_button.dart';
import 'package:akar/core/widgets/app_logo_badge.dart';
import 'package:akar/features/masyarakat/home/presentation/widgets/disaster_alert_banner.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_navigation_helper.dart';
import 'package:flutter/material.dart';

enum AppBarBrand { dumas, linmas }

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationPressed;
  final int? unreadCount;
  final String? title;
  final String? subtitle;
  final bool showNotificationButton;
  final AppBarBrand brand;
  final VoidCallback? onLogoTap;
  final bool enableDefaultLogoEasterEgg;

  const CustomAppBar({
    super.key,
    this.onNotificationPressed,
    this.unreadCount,
    this.title,
    this.subtitle,
    this.showNotificationButton = true,
    this.brand = AppBarBrand.dumas,
    this.onLogoTap,
    this.enableDefaultLogoEasterEgg = true,
  });

  const CustomAppBar.linmas({
    super.key,
    this.onNotificationPressed,
    this.unreadCount,
    this.title,
    this.subtitle = 'Laporan Linmas',
    this.showNotificationButton = true,
    this.onLogoTap,
    this.enableDefaultLogoEasterEgg = false,
  }) : brand = AppBarBrand.linmas;

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleLogoTap() {
    if (widget.onLogoTap != null) {
      widget.onLogoTap!();
      return;
    }
    if (!widget.enableDefaultLogoEasterEgg) return;

    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 3)) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }
    _lastTapTime = now;

    if (_tapCount >= 5 && _tapCount < 10) {
      final remaining = 10 - _tapCount;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mode Simulasi: Klik ${_tapCount}x (Tinggal $remaining langkah lagi)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.5,
            ),
          ),
          backgroundColor: AppColors.secondary,
          duration: const Duration(milliseconds: 1200),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (_tapCount >= 10) {
      _tapCount = 0;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      DisasterAlertBanner.showSimulateMenu(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoBadge = widget.brand == AppBarBrand.linmas
        ? const AppLogoBadge.linmas(
            size: 38,
            borderRadius: 10,
            fallbackIconSize: 22,
          )
        : const AppLogoBadge.dumas(
            size: 38,
            borderRadius: 10,
            fallbackIconSize: 22,
          );

    return ColoredBox(
      color: AppColors.background,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.topHeaderGradient),
        child: AppBar(
          toolbarHeight: 60.0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 16,
          actionsPadding: EdgeInsets.zero,
          title: GestureDetector(
            onTap:
                (widget.onLogoTap != null || widget.enableDefaultLogoEasterEgg)
                ? _handleLogoTap
                : null,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                logoBadge,
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title ?? AppConstants.appBarTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        widget.subtitle ??
                            (widget.brand == AppBarBrand.linmas
                                ? 'Laporan Linmas'
                                : 'Dumas'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (widget.showNotificationButton)
              AppBarNotificationButton(
                unreadCount: widget.unreadCount,
                onPressed:
                    widget.onNotificationPressed ??
                    () => NotificationNavigationHelper.openNotificationCenter(
                      context,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
