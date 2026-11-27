import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:material_ui/material_ui.dart';

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
       semanticLabel = 'Logo DUMAS Aduan Masyarakat dan Laporan ASLINMAS';

  const AppLogoBadge.linmas({
    super.key,
    this.size = 38,
    this.borderRadius = 10,
    this.fallbackIconSize = 22,
    this.boxShadow,
  }) : assetPath = AppConstants.logoLinmasAsset,
       semanticLabel = 'Logo ASLINMAS Aduan Masyarakat dan Laporan ASLINMAS';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final decodedSize = (size * 3).round();

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.isDark
            ? const Color(0xFFF8FAFC) // media-overlay: keep light crest backing
            : colors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colors.border, width: 1),
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
              color: colors.primary,
              size: fallbackIconSize,
            );
          },
        ),
      ),
    );
  }
}
