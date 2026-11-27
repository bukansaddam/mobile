import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:material_ui/material_ui.dart';

/// Full-bleed vertical gradient backdrop matching SplashScreen and WelcomeScreen.
class PermissionSeamlessBackground extends StatelessWidget {
  const PermissionSeamlessBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.primaryLight,
            colors.surfaceVariant,
            colors.isDark ? colors.background : colors.surface,
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}
