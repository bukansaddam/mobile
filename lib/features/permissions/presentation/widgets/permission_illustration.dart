import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/features/permissions/domain/entities/app_permission_type.dart';
import 'package:flutter/material.dart';

/// Renders the transparent flat-vector AKAR illustration for a permission step.
class PermissionIllustration extends StatelessWidget {
  final AppPermissionType type;
  final double height;

  const PermissionIllustration({
    super.key,
    required this.type,
    required this.height,
  });

  static String assetPathFor(AppPermissionType type) {
    switch (type) {
      case AppPermissionType.locationWhenInUse:
        return 'assets/permissions/permission_location.png';
      case AppPermissionType.locationAlways:
        return 'assets/permissions/permission_location_always.png';
      case AppPermissionType.camera:
        return 'assets/permissions/permission_camera.png';
      case AppPermissionType.microphone:
        return 'assets/permissions/permission_microphone.png';
      case AppPermissionType.notification:
        return 'assets/permissions/permission_notification.png';
    }
  }

  IconData _fallbackIconFor(AppPermissionType type) {
    switch (type) {
      case AppPermissionType.locationWhenInUse:
        return Icons.location_on_rounded;
      case AppPermissionType.locationAlways:
        return Icons.my_location_rounded;
      case AppPermissionType.camera:
        return Icons.photo_camera_rounded;
      case AppPermissionType.microphone:
        return Icons.mic_rounded;
      case AppPermissionType.notification:
        return Icons.notifications_active_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheHeight = (height * dpr).round().clamp(1, 1024);
    final groundWidth = height * 0.62;

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: groundWidth,
            height: 16,
            decoration: BoxDecoration(
              color: colors.isDark
                  ? colors.surfaceElevated.withValues(alpha: 0.35)
                  : colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.all(
                Radius.elliptical(groundWidth / 2, 8),
              ),
            ),
          ),
          Image.asset(
            assetPathFor(type),
            height: height,
            fit: BoxFit.contain,
            cacheHeight: cacheHeight,
            filterQuality: FilterQuality.medium,
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: colors.isDark ? colors.surface : colors.primaryLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.primaryBorder),
                  ),
                  child: Icon(
                    _fallbackIconFor(type),
                    size: 40,
                    color: colors.primary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
