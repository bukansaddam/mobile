import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Displays the transparent shield emblem inside a clean rounded badge.
class AppLogoBadge extends StatelessWidget {
  final double size;
  final double borderRadius;
  final double fallbackIconSize;
  final List<BoxShadow>? boxShadow;

  const AppLogoBadge({
    super.key,
    this.size = 38,
    this.borderRadius = 10,
    this.fallbackIconSize = 22,
    this.boxShadow,
  });

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
          AppConstants.logoIconAsset,
          fit: BoxFit.contain,
          cacheWidth: decodedSize,
          cacheHeight: decodedSize,
          filterQuality: FilterQuality.high,
          semanticLabel: 'Ikon Perisai LINMAS',
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
