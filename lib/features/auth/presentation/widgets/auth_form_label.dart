import 'package:flutter/material.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';

class AuthFormLabel extends StatelessWidget {
  final String text;

  const AuthFormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
