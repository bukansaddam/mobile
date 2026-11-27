import 'package:material_ui/material_ui.dart';

/// Skema warna dinamis aplikasi untuk Light Mode dan Deep Slate Forest Dark Mode.
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Brightness brightness;

  // Brand & Accents
  final Color primary;
  final Color onPrimary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryBorder;
  final Color accent;
  final Color earth;
  final Color secondary;
  final Color onSecondary;

  // Surfaces & Borders
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceElevated;
  final Color border;
  final Color borderStrong;
  final Color divider;

  // Typography
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textHint;
  final Color textDisabled;

  // Semantic & Category
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningDark;
  final Color warningLight;
  final Color warningBorder;
  final Color error;
  final Color errorSolid;
  final Color onErrorSolid;
  final Color errorDark;
  final Color errorLight;
  final Color errorBorder;
  final Color info;
  final Color infoLight;
  final Color indigo;
  final Color indigoLight;
  final Color orange;
  final Color orangeLight;
  final Color emerald;

  // Overlays & Shadows
  final Color scrim;
  final Color shadow;

  const AppColorScheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryBorder,
    required this.accent,
    required this.earth,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceElevated,
    required this.border,
    required this.borderStrong,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textHint,
    required this.textDisabled,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningDark,
    required this.warningLight,
    required this.warningBorder,
    required this.error,
    required this.errorSolid,
    required this.onErrorSolid,
    required this.errorDark,
    required this.errorLight,
    required this.errorBorder,
    required this.info,
    required this.infoLight,
    required this.indigo,
    required this.indigoLight,
    required this.orange,
    required this.orangeLight,
    required this.emerald,
    required this.scrim,
    required this.shadow,
  });

  static const AppColorScheme light = AppColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0D8E34),
    onPrimary: Color(0xFFFFFFFF),
    primaryDark: Color(0xFF114C30),
    primaryLight: Color(0xFFE8F5E9),
    primaryBorder: Color(0xFFBBF7D0),
    accent: Color(0xFF4B2E0E),
    earth: Color(0xFFB45309),
    secondary: Color(0xFF1E293B),
    onSecondary: Color(0xFFFFFFFF),
    background: Color(0xFFF4F6F9),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF8FAFC),
    surfaceElevated: Color(0xFFF1F5F9),
    border: Color(0xFFE2E8F0),
    borderStrong: Color(0xFFCBD5E1),
    divider: Color(0xFFE0E0E0),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF64748B),
    textHint: Color(0xFF94A3B8),
    textDisabled: Color(0xFFBDBDBD),
    success: Color(0xFF2E7D32),
    successLight: Color(0xFFE8F5E9),
    warning: Color(0xFFF57F17),
    warningDark: Color(0xFF92400E),
    warningLight: Color(0xFFFFF8E1),
    warningBorder: Color(0xFFFDE68A),
    error: Color(0xFFC62828),
    errorSolid: Color(0xFFC62828),
    onErrorSolid: Color(0xFFFFFFFF),
    errorDark: Color(0xFF991B1B),
    errorLight: Color(0xFFFFEBEE),
    errorBorder: Color(0xFFFCA5A5),
    info: Color(0xFF0277BD),
    infoLight: Color(0xFFE1F5FE),
    indigo: Color(0xFF4F46E5),
    indigoLight: Color(0xFFEEF2FF),
    orange: Color(0xFFEA580C),
    orangeLight: Color(0xFFFFEDD5),
    emerald: Color(0xFF0F9F66),
    scrim: Color(0x8A000000),
    shadow: Color(0x0F000000),
  );

  static const AppColorScheme dark = AppColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF22C55E),
    onPrimary: Color(0xFF052E16),
    primaryDark: Color(0xFF86EFAC),
    primaryLight: Color(0xFF143326),
    primaryBorder: Color(0xFF1E4D37),
    accent: Color(0xFFFDBA74),
    earth: Color(0xFFF59E0B),
    secondary: Color(0xFFE2E8F0),
    onSecondary: Color(0xFF0F172A),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceVariant: Color(0xFF162032),
    surfaceElevated: Color(0xFF263548),
    border: Color(0xFF334155),
    borderStrong: Color(0xFF475569),
    divider: Color(0xFF334155),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    textHint: Color(0xFF64748B),
    textDisabled: Color(0xFF475569),
    success: Color(0xFF4ADE80),
    successLight: Color(0xFF143326),
    warning: Color(0xFFFBBF24),
    warningDark: Color(0xFFFDE68A),
    warningLight: Color(0xFF3B2811),
    warningBorder: Color(0xFF784915),
    error: Color(0xFFF87171),
    errorSolid: Color(0xFFDC2626),
    onErrorSolid: Color(0xFFFFFFFF),
    errorDark: Color(0xFFFCA5A5),
    errorLight: Color(0xFF3B181E),
    errorBorder: Color(0xFF7F1D1D),
    info: Color(0xFF38BDF8),
    infoLight: Color(0xFF122C3E),
    indigo: Color(0xFF818CF8),
    indigoLight: Color(0xFF1E1B4B),
    orange: Color(0xFFFB923C),
    orangeLight: Color(0xFF3D1F0D),
    emerald: Color(0xFF34D399),
    scrim: Color(0xB8000000),
    shadow: Color(0x4D000000),
  );

  bool get isDark => brightness == Brightness.dark;

  /// Gradien halus bagian AppBar agar tetap nyaman di Light maupun Dark Mode.
  LinearGradient get topHeaderGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primary.withValues(alpha: isDark ? 0.22 : 0.4),
      Colors.transparent,
    ],
  );

  /// Gradien brand utama untuk header/kartu bernuansa hijau.
  LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark
        ? const [Color(0xFF15803D), Color(0xFF0B3B24)]
        : const [Color(0xFF0D8E34), Color(0xFF114C30)],
  );

  @override
  AppColorScheme copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? primaryDark,
    Color? primaryLight,
    Color? primaryBorder,
    Color? accent,
    Color? earth,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceElevated,
    Color? border,
    Color? borderStrong,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textHint,
    Color? textDisabled,
    Color? success,
    Color? successLight,
    Color? warning,
    Color? warningDark,
    Color? warningLight,
    Color? warningBorder,
    Color? error,
    Color? errorSolid,
    Color? onErrorSolid,
    Color? errorDark,
    Color? errorLight,
    Color? errorBorder,
    Color? info,
    Color? infoLight,
    Color? indigo,
    Color? indigoLight,
    Color? orange,
    Color? orangeLight,
    Color? emerald,
    Color? scrim,
    Color? shadow,
  }) {
    return AppColorScheme(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryBorder: primaryBorder ?? this.primaryBorder,
      accent: accent ?? this.accent,
      earth: earth ?? this.earth,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textHint: textHint ?? this.textHint,
      textDisabled: textDisabled ?? this.textDisabled,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningDark: warningDark ?? this.warningDark,
      warningLight: warningLight ?? this.warningLight,
      warningBorder: warningBorder ?? this.warningBorder,
      error: error ?? this.error,
      errorSolid: errorSolid ?? this.errorSolid,
      onErrorSolid: onErrorSolid ?? this.onErrorSolid,
      errorDark: errorDark ?? this.errorDark,
      errorLight: errorLight ?? this.errorLight,
      errorBorder: errorBorder ?? this.errorBorder,
      info: info ?? this.info,
      infoLight: infoLight ?? this.infoLight,
      indigo: indigo ?? this.indigo,
      indigoLight: indigoLight ?? this.indigoLight,
      orange: orange ?? this.orange,
      orangeLight: orangeLight ?? this.orangeLight,
      emerald: emerald ?? this.emerald,
      scrim: scrim ?? this.scrim,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppColorScheme lerp(
    covariant ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      brightness: t < 0.5 ? brightness : other.brightness,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? onPrimary,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t) ?? primaryDark,
      primaryLight:
          Color.lerp(primaryLight, other.primaryLight, t) ?? primaryLight,
      primaryBorder:
          Color.lerp(primaryBorder, other.primaryBorder, t) ?? primaryBorder,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      earth: Color.lerp(earth, other.earth, t) ?? earth,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t) ?? onSecondary,
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceVariant:
          Color.lerp(surfaceVariant, other.surfaceVariant, t) ?? surfaceVariant,
      surfaceElevated:
          Color.lerp(surfaceElevated, other.surfaceElevated, t) ??
          surfaceElevated,
      border: Color.lerp(border, other.border, t) ?? border,
      borderStrong:
          Color.lerp(borderStrong, other.borderStrong, t) ?? borderStrong,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      textHint: Color.lerp(textHint, other.textHint, t) ?? textHint,
      textDisabled:
          Color.lerp(textDisabled, other.textDisabled, t) ?? textDisabled,
      success: Color.lerp(success, other.success, t) ?? success,
      successLight:
          Color.lerp(successLight, other.successLight, t) ?? successLight,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      warningDark: Color.lerp(warningDark, other.warningDark, t) ?? warningDark,
      warningLight:
          Color.lerp(warningLight, other.warningLight, t) ?? warningLight,
      warningBorder:
          Color.lerp(warningBorder, other.warningBorder, t) ?? warningBorder,
      error: Color.lerp(error, other.error, t) ?? error,
      errorSolid: Color.lerp(errorSolid, other.errorSolid, t) ?? errorSolid,
      onErrorSolid:
          Color.lerp(onErrorSolid, other.onErrorSolid, t) ?? onErrorSolid,
      errorDark: Color.lerp(errorDark, other.errorDark, t) ?? errorDark,
      errorLight: Color.lerp(errorLight, other.errorLight, t) ?? errorLight,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t) ?? errorBorder,
      info: Color.lerp(info, other.info, t) ?? info,
      infoLight: Color.lerp(infoLight, other.infoLight, t) ?? infoLight,
      indigo: Color.lerp(indigo, other.indigo, t) ?? indigo,
      indigoLight: Color.lerp(indigoLight, other.indigoLight, t) ?? indigoLight,
      orange: Color.lerp(orange, other.orange, t) ?? orange,
      orangeLight: Color.lerp(orangeLight, other.orangeLight, t) ?? orangeLight,
      emerald: Color.lerp(emerald, other.emerald, t) ?? emerald,
      scrim: Color.lerp(scrim, other.scrim, t) ?? scrim,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
    );
  }
}

/// Akses mudah skema warna aktif dari BuildContext tanpa boilerplate.
extension AppThemeContextX on BuildContext {
  AppColorScheme get appColors {
    final theme = Theme.of(this);
    return theme.extension<AppColorScheme>() ??
        (theme.brightness == Brightness.dark
            ? AppColorScheme.dark
            : AppColorScheme.light);
  }

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
