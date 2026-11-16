import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppBrandLogoVariant { horizontal, vertical }

/// Displays the transparent LINMAS brand lockup responsively.
class AppBrandLogo extends StatelessWidget {
  final double maxWidth;
  final double fallbackIconSize;
  final AppBrandLogoVariant variant;

  const AppBrandLogo({
    super.key,
    this.maxWidth = 320,
    this.fallbackIconSize = 64,
    this.variant = AppBrandLogoVariant.horizontal,
  });

  const AppBrandLogo.vertical({
    super.key,
    this.maxWidth = 220,
    this.fallbackIconSize = 64,
  }) : variant = AppBrandLogoVariant.vertical;

  static const double _horizontalAspectRatio = 2048 / 682;
  static const double _verticalAspectRatio = 1.0;

  @override
  Widget build(BuildContext context) {
    final isVertical = variant == AppBrandLogoVariant.vertical;
    final assetPath = isVertical
        ? AppConstants.logoVerticalAsset
        : AppConstants.logoHorizontalAsset;
    final aspectRatio = isVertical
        ? _verticalAspectRatio
        : _horizontalAspectRatio;
    final maxDecodedWidth = isVertical ? 1254 : 2048;
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 3.0;
    final decodedWidth = (maxWidth * dpr).round().clamp(768, maxDecodedWidth);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          cacheWidth: decodedWidth,
          filterQuality: FilterQuality.high,
          semanticLabel: 'Logo LINMAS Aduan Masyarakat dan Laporan LINMAS',
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.shield_rounded,
              size: fallbackIconSize,
              color: AppColors.primary,
            );
          },
        ),
      ),
    );
  }
}
