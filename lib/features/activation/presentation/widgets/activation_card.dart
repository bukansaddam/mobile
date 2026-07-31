import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/activation/presentation/widgets/activation_donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivationCard extends StatelessWidget {
  final ActivationActivity activity;
  final VoidCallback? onTap;

  const ActivationCard({super.key, required this.activity, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final startDateStr = dateFormat.format(activity.startDate);
    final endDateStr = dateFormat.format(activity.endDate);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Vertical Left Color Strip Indicator (Color depends on Category!)
                Positioned(
                  left: 0,
                  top: 18,
                  bottom: 18,
                  child: Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: activity.category.stripColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Nama Kegiatan & Donut Progress Chart
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Category Badge
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.title,
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Kategori Badge Chip
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: activity.category.color.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        activity.category.icon,
                                        size: 13,
                                        color: activity.category.color,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        activity.category.label,
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                              color: activity.category.color,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Progress Donut Chart with fraction format (e.g. 3/5)
                          ActivationDonutChart(
                            completedSteps: activity.completedSteps,
                            totalSteps: activity.totalSteps,
                            progressColor: activity.status.color,
                            size: 54,
                            strokeWidth: 5.5,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Location & Status Row
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 15,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              activity.location,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: activity.status.backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: activity.status.color.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              activity.status.label,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: activity.status.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      // Deadline Date Range (Space Between: Start Date di Kiri, End Date di Kanan)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.play_circle_outline_rounded,
                                size: 14,
                                color: AppColors.grey600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                startDateStr,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.flag_outlined,
                                size: 14,
                                color: AppColors.grey600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                endDateStr,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Linear Progress Bar Indicator (Visual Timeline Deadline)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: activity.deadlineProgressPercentage,
                          minHeight: 6,
                          backgroundColor: AppColors.grey200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            activity.deadlineProgressPercentage >= 0.9
                                ? AppColors.warning
                                : activity.status.color,
                          ),
                        ),
                      ),
                    ],
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
