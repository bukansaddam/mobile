import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Displays the transparent brand emblem inside a clean rounded badge.
class AppLogoBadge extends StatelessWidget {
  final double size;
  final double borderRadius;
  final double fallbackIconSize;
  final List<BoxShadow>? boxShadow;
  final String assetPath;
  final String semanticLabel;

  const AppLogoBadge({
    super.key,
    this.size = 38,
    this.borderRadius = 10,
    this.fallbackIconSize = 22,
    this.boxShadow,
    this.assetPath = AppConstants.logoIconAsset,
    this.semanticLabel = 'Ikon Perisai ${AppConstants.appName}',
  });

  const AppLogoBadge.dumas({
    super.key,
    this.size = 38,
    this.borderRadius = 10,
    this.fallbackIconSize = 22,
    this.boxShadow,
  }) : assetPath = AppConstants.logoDumasAsset,
       semanticLabel = 'Logo DUMAS Aduan Masyarakat dan Laporan LINMAS';

  const AppLogoBadge.linmas({
    super.key,
    this.size = 38,
    this.borderRadius = 10,
    this.fallbackIconSize = 22,
    this.boxShadow,
  }) : assetPath = AppConstants.logoLinmasAsset,
       semanticLabel = 'Logo LINMAS Aduan Masyarakat dan Laporan LINMAS';

  @override
  Widget build(BuildContext context) {
    final decodedSize = (size * 3).round();

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          (borderRadius - 3).clamp(0.0, borderRadius),
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          cacheWidth: decodedSize,
          cacheHeight: decodedSize,
          filterQuality: FilterQuality.high,
          semanticLabel: semanticLabel,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.shield_rounded,
              color: AppColors.primary,
              size: fallbackIconSize,
            );
          },
        ),
      ),
    );
  }
}
