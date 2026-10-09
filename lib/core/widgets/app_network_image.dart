import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:akar/core/theme/app_colors.dart';

/// Reusable and optimized network image component with persistent caching,
/// memory downsampling, and graceful loading/error states.
class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final IconData errorIcon;
  final Color? backgroundColor;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.memCacheWidth,
    this.memCacheHeight,
    this.placeholder,
    this.errorWidget,
    this.errorIcon = Icons.broken_image_outlined,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty ||
        (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://'))) {
      return _buildErrorPlaceholder(context, 'invalid_url');
    }

    // Auto-calculate memory cache resolution to prevent decoding huge images into RAM (3x pixel ratio)
    final int? calculatedMemWidth =
        memCacheWidth ??
        (width != null && width! > 0 && width!.isFinite
            ? (width! * 3).toInt().clamp(32, 1200)
            : null);
    final int? calculatedMemHeight =
        memCacheHeight ??
        (height != null && height! > 0 && height!.isFinite
            ? (height! * 3).toInt().clamp(32, 1200)
            : null);

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: calculatedMemWidth,
      memCacheHeight: calculatedMemHeight,
      placeholder:
          placeholder ?? (context, url) => _buildLoadingShimmer(context),
      errorWidget:
          errorWidget ??
          (context, url, error) => _buildErrorPlaceholder(context, error),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.grey200,
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.grey400),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context, dynamic error) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.grey100,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          errorIcon,
          size: (width != null && height != null)
              ? (width! < height! ? width! * 0.45 : height! * 0.45).clamp(
                  16.0,
                  36.0,
                )
              : 24,
          color: AppColors.grey400,
        ),
      ),
    );
  }
}
