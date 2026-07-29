import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/activation/presentation/widgets/activation_donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivationDetailModal extends StatelessWidget {
  final ActivationActivity activity;

  const ActivationDetailModal({super.key, required this.activity});

  static void show(BuildContext context, ActivationActivity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivationDetailModal(activity: activity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final startDateStr = dateFormat.format(activity.startDate);
    final endDateStr = dateFormat.format(activity.endDate);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle bar
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Modal Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: activity.category.stripColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Detail Kegiatan Aktivasi',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const Divider(height: 24),

          // Title & Progress Donut Chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Badges: Category & Status
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
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
                                size: 14,
                                color: activity.category.color,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                activity.category.label,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: activity.category.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: activity.status.backgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: activity.status.color.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Text(
                            activity.status.label,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: activity.status.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ActivationDonutChart(
                completedSteps: activity.completedSteps,
                totalSteps: activity.totalSteps,
                progressColor: activity.status.color,
                size: 68,
                strokeWidth: 7,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Details List
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  Icons.location_on_rounded,
                  'Lokasi',
                  activity.location,
                  AppColors.primary,
                ),
                const Divider(height: 20),
                _buildDetailRow(
                  Icons.calendar_month_rounded,
                  'Tanggal Mulai',
                  startDateStr,
                  AppColors.textSecondary,
                ),
                const Divider(height: 20),
                _buildDetailRow(
                  Icons.event_available_rounded,
                  'Tanggal Selesai',
                  endDateStr,
                  AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Progress Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress Pengerjaan Tahapan',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${activity.completedSteps}/${activity.totalSteps} Selesai',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: activity.status.color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: activity.progressPercentage,
              minHeight: 10,
              backgroundColor: AppColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(activity.status.color),
            ),
          ),

          if (activity.description != null &&
              activity.description!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Deskripsi Kegiatan',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              activity.description!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
