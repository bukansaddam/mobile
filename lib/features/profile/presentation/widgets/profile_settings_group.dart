import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:material_ui/material_ui.dart';

class ProfileSettingsSectionLabel extends StatelessWidget {
  final String title;

  const ProfileSettingsSectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class ProfileMenuGroupCard extends StatelessWidget {
  final List<Widget> children;

  const ProfileMenuGroupCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: colors.isDark ? Border.all(color: colors.border) : null,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: children),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? badge;
  final String? trailingLabel;
  final Color? textColor;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final bool showChevron;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.badge,
    this.trailingLabel,
    this.textColor,
    this.iconColor,
    this.iconBackgroundColor,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final resolvedIconColor = iconColor ?? colors.primary;
    final resolvedIconBg =
        iconBackgroundColor ??
        (iconColor == colors.error ? colors.errorLight : colors.primaryLight);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: resolvedIconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: resolvedIconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: textColor ?? colors.textPrimary,
                      ),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingLabel != null) ...[
              Text(
                trailingLabel!,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(width: 6),
            ],
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
