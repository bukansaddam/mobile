import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:material_ui/material_ui.dart';

class JagaTanahFilterButton extends StatelessWidget {
  final int activeCount;
  final VoidCallback onTap;

  const JagaTanahFilterButton({
    super.key,
    required this.activeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasActiveFilter = activeCount > 0;

    return Tooltip(
      message: 'Filter laporan',
      child: Material(
        color: hasActiveFilter ? colors.primaryLight : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: hasActiveFilter ? colors.primary : colors.borderStrong,
            width: hasActiveFilter ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.tune_rounded,
                  color: hasActiveFilter
                      ? colors.primaryDark
                      : colors.textPrimary,
                  size: 22,
                ),
                if (hasActiveFilter)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$activeCount',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
