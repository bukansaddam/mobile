import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter/material.dart';

class HomeProfileCard extends StatelessWidget {
  final UserEntity? user;
  final VoidCallback? onTap;

  const HomeProfileCard({super.key, this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    final name = (user?.name != null && user!.name!.trim().isNotEmpty)
        ? user!.name!.trim()
        : 'Nama Pengguna';

    final phoneNumber =
        (user?.phoneNumber != null && user!.phoneNumber!.trim().isNotEmpty)
        ? user!.phoneNumber!.trim()
        : '-';

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: AppColors.white, width: 3),
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.grey100,
                child: const Icon(
                  Icons.person_rounded,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),

            Text(
              name,
              style: AppTextStyles.headlineMedium.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_android_rounded,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  phoneNumber,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
