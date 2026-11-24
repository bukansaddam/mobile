import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/report_point_policy.dart';
import 'package:akar/core/widgets/report_point_banner_strip.dart';
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
    final colors = context.appColors;
    final statusIcon = complaintStatusFromCode(detail.status).icon;
    final statusTitle = JagaTanahDetailLabels.resolveStatusLabel(
      detail.status,
      detail.statusLabel,
    );
    final pointInfo = ReportPointPolicy.resolve(
      category: ReportPointCategory.jagaTanah,
      statusCode: detail.status,
      apiPoints: detail.pointsAwarded,
      timelineTypes: detail.timeline.map((entry) => entry.type),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(statusIcon, color: colors.primaryDark, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Laporan',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statusTitle,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: colors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ReportPointBannerStrip(info: pointInfo),
        ],
      ),
    );
  }
}
