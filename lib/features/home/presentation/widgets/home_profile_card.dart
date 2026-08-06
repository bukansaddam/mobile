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
        : '-';

    final phoneNumber =
        (user?.phoneNumber != null && user!.phoneNumber!.trim().isNotEmpty)
        ? user!.phoneNumber!.trim()
        : '-';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Positioned(
                    top: -20,
                    right: -20,
                    width: 175,
                    height: 175,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 16,
                    top: 12,
                    bottom: 12,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        border: Border.all(color: AppColors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/indonesian_headshot_portrait.jpg',
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) {
                            return const CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.person_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 16.0,
                        bottom: 16.0,
                        right: 145.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No. Telepon',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone_android_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  phoneNumber,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
