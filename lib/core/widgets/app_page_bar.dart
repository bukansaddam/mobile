import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_bar_circle_button.dart';
import 'package:flutter/material.dart';

/// AppBar standar untuk seluruh sub-halaman aplikasi.
class AppPageBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool isBackEnabled;
  final String backTooltip;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool transparentBackground;
  final Color baseColor;

  const AppPageBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.isBackEnabled = true,
    this.backTooltip = 'Kembali',
    this.actions,
    this.bottom,
    this.transparentBackground = false,
    this.baseColor = AppColors.background,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final resolvedTitle =
        titleWidget ??
        (title != null && title!.isNotEmpty
            ? Text(
                title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null);

    final resolvedActions = (actions != null && actions!.isNotEmpty)
        ? <Widget>[...actions!, const SizedBox(width: 8)]
        : null;

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: showBackButton ? 56 : null,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 8),
              child: AppBarCircleButton.back(
                tooltip: backTooltip,
                onPressed: isBackEnabled
                    ? (onBackPressed ?? () => Navigator.of(context).maybePop())
                    : null,
              ),
            )
          : null,
      title: resolvedTitle,
      actions: resolvedActions,
      bottom: bottom,
    );

    if (transparentBackground) {
      return appBar;
    }

    return ColoredBox(
      color: baseColor,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.topHeaderGradient),
        child: appBar,
      ),
    );
  }
}
