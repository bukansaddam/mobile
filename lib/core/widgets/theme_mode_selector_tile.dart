import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/theme/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tile pengaturan tema yang membuka lembar pilih 3 mode (Sistem, Terang, Gelap).
class ThemeModeSelectorTile extends StatelessWidget {
  const ThemeModeSelectorTile({super.key});

  static String labelFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Ikuti Sistem';
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
    }
  }

  static IconData iconFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
    }
  }

  ThemeBloc? _maybeWatchBloc(BuildContext context) {
    try {
      return context.watch<ThemeBloc>();
    } catch (_) {
      return null;
    }
  }

  void _openSelectorSheet(
    BuildContext context,
    ThemeBloc? bloc,
    ThemeMode activeMode,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final colors = sheetContext.appColors;
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(color: colors.border),
                left: BorderSide(color: colors.border),
                right: BorderSide(color: colors.border),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.borderStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pilih Tema Tampilan',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sesuaikan tampilan terang atau gelap sesuai kenyamanan mata Anda.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                _ThemeOptionTile(
                  mode: ThemeMode.system,
                  title: 'Ikuti Sistem',
                  subtitle: 'Otomatis mengikuti pengaturan perangkat',
                  icon: Icons.brightness_auto_rounded,
                  isSelected: activeMode == ThemeMode.system,
                  onTap: () {
                    bloc?.add(const ChangeThemeModeEvent(ThemeMode.system));
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: 10),
                _ThemeOptionTile(
                  mode: ThemeMode.light,
                  title: 'Terang',
                  subtitle: 'Kontras tinggi untuk pemakaian luar ruangan',
                  icon: Icons.light_mode_rounded,
                  isSelected: activeMode == ThemeMode.light,
                  onTap: () {
                    bloc?.add(const ChangeThemeModeEvent(ThemeMode.light));
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: 10),
                _ThemeOptionTile(
                  mode: ThemeMode.dark,
                  title: 'Gelap',
                  subtitle: 'Palet Deep Slate Forest nyaman di malam hari',
                  icon: Icons.dark_mode_rounded,
                  isSelected: activeMode == ThemeMode.dark,
                  onTap: () {
                    bloc?.add(const ChangeThemeModeEvent(ThemeMode.dark));
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bloc = _maybeWatchBloc(context);
    final activeMode = bloc?.state.themeMode ?? ThemeMode.system;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _openSelectorSheet(context, bloc, activeMode),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  iconFor(activeMode),
                  size: 20,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tema Tampilan',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      labelFor(activeMode),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final ThemeMode mode;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: isSelected ? colors.primaryLight : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? colors.primary : colors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.primary.withValues(alpha: 0.16)
                      : colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? colors.primaryDark : colors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isSelected
                            ? colors.primaryDark
                            : colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: colors.primary,
                  size: 22,
                )
              else
                Icon(
                  Icons.radio_button_unchecked_rounded,
                  color: colors.textHint,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
