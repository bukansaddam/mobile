import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:material_ui/material_ui.dart';

class JagaTanahFieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const JagaTanahFieldLabel({
    super.key,
    required this.label,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Text.rich(
      TextSpan(
        text: label,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.error,
                  ),
                ),
              ]
            : null,
      ),
    );
  }
}
