import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_detail_labels.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';

/// Kartu ringkasan status laporan Jaga Tanah.
class JagaTanahDetailStatusBanner extends StatelessWidget {
  final JagaTanahDetailEntity detail;

  const JagaTanahDetailStatusBanner({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final statusIcon = complaintStatusFromCode(detail.status).icon;
    final statusTitle = JagaTanahDetailLabels.resolveStatusLabel(
      detail.status,
      detail.statusLabel,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(statusIcon, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Laporan',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusTitle,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
