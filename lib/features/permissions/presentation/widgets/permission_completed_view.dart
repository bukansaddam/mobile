import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Cardless seamless completion state shown briefly once all permissions pass.
class PermissionCompletedView extends StatelessWidget {
  const PermissionCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_rounded, size: 56, color: colors.success),
        const SizedBox(height: 16),
        Text(
          'Semua Izin Lengkap',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Membuka halaman utama aplikasi...',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}
