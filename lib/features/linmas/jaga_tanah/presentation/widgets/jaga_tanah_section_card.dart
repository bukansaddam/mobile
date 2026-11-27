import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:material_ui/material_ui.dart';

/// Kartu seksi langkah form Jaga Tanahku yang selaras dengan kartu step Laporan Harian.
class JagaTanahSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? accentColor;
  final Color? badgeColor;
  final Widget child;

  const JagaTanahSectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.accentColor,
    this.badgeColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final effectiveAccent = accentColor ?? colors.primaryDark;
    final effectiveBadge = badgeColor ?? colors.primaryLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: effectiveBadge,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: effectiveAccent, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: effectiveAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: colors.divider),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
