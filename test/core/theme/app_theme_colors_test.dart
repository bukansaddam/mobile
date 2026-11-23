import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  double contrastRatio(Color a, Color b) {
    final l1 = a.computeLuminance();
    final l2 = b.computeLuminance();
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  group('AppColors Semantic Companion Tokens', () {
    test(
      'defines semantic companion error & warning tokens with AA contrast',
      () {
        expect(AppColors.errorDark, const Color(0xFF991B1B));
        expect(AppColors.errorBorder, const Color(0xFFFCA5A5));
        expect(AppColors.warningDark, const Color(0xFF92400E));
        expect(AppColors.warningBorder, const Color(0xFFFDE68A));

        expect(
          contrastRatio(AppColors.warningDark, AppColors.warningLight),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrastRatio(AppColors.errorDark, AppColors.errorLight),
          greaterThanOrEqualTo(4.5),
        );
      },
    );
  });

  group('AppTheme Unified Button & FAB Theme', () {
    test('aligns ElevatedButton, FilledButton, OutlinedButton, TextButton, and FAB to AppColors.primary', () {
      final theme = AppTheme.lightTheme;

      expect(
        theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        theme.filledButtonTheme.style?.backgroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.filledButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.textButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.floatingActionButtonTheme.backgroundColor,
        AppColors.primary,
      );
      expect(theme.floatingActionButtonTheme.foregroundColor, AppColors.white);
    });
  });
}
