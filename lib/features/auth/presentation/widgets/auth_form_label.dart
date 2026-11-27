import 'package:material_ui/material_ui.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';

class AuthFormLabel extends StatelessWidget {
  final String text;

  const AuthFormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
      ),
    );
  }
}
