import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

enum AppBrandLogoVariant {
  horizontal(
    assetPath: AppConstants.logoHorizontalAsset,
    aspectRatio: 2048 / 682,
    maxDecodedWidth: 2048,
    semanticLabel: 'Logo ASLINMAS Aduan Masyarakat dan Laporan ASLINMAS',
  ),
  general(
    assetPath: AppConstants.logoGeneralAsset,
    aspectRatio: 1.0,
    maxDecodedWidth: 1024,
    semanticLabel: 'Logo SISKAMLING.org Laporan ASLINMAS dan DUMAS',
  ),
  linmas(
    assetPath: AppConstants.logoLinmasAsset,
    aspectRatio: 1.0,
    maxDecodedWidth: 1254,
    semanticLabel: 'Logo ASLINMAS Aduan Masyarakat dan Laporan ASLINMAS',
  ),
  dumas(
    assetPath: AppConstants.logoDumasAsset,
    aspectRatio: 1.0,
    maxDecodedWidth: 1024,
    semanticLabel: 'Logo DUMAS Aduan Masyarakat dan Laporan ASLINMAS',
  );

  const AppBrandLogoVariant({
    required this.assetPath,
    required this.aspectRatio,
    required this.maxDecodedWidth,
    required this.semanticLabel,
  });

  final String assetPath;
  final double aspectRatio;
  final int maxDecodedWidth;
  final String semanticLabel;
}

/// Displays the transparent brand lockup responsively.
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

  const AppBrandLogo.general({
    super.key,
    this.maxWidth = 220,
    this.fallbackIconSize = 64,
  }) : variant = AppBrandLogoVariant.general;

  const AppBrandLogo.linmas({
    super.key,
    this.maxWidth = 220,
    this.fallbackIconSize = 64,
  }) : variant = AppBrandLogoVariant.linmas;

  const AppBrandLogo.dumas({
    super.key,
    this.maxWidth = 220,
    this.fallbackIconSize = 64,
  }) : variant = AppBrandLogoVariant.dumas;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 3.0;
    final decodedWidth = (maxWidth * dpr).round().clamp(
      768,
      variant.maxDecodedWidth,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: AspectRatio(
        aspectRatio: variant.aspectRatio,
        child: Image.asset(
          variant.assetPath,
          fit: BoxFit.contain,
          cacheWidth: decodedWidth,
          filterQuality: FilterQuality.high,
          semanticLabel: variant.semanticLabel,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.shield_rounded,
              size: fallbackIconSize,
              color: context.appColors.primary,
            );
          },
        ),
      ),
    );
  }
}
