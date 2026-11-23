import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_detail_labels.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_section_card.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:flutter/material.dart';

/// Kartu perkembangan status Jaga Tanah (stepper 4 tahap + riwayat kronologis).
class JagaTanahDetailTimelineCard extends StatelessWidget {
  final JagaTanahDetailEntity detail;

  const JagaTanahDetailTimelineCard({super.key, required this.detail});

  ({int activeStep, bool isTerminalNegative, List<String> labels})
  _resolveProgress(String code) {
    final normalized = code.trim().toLowerCase();
    final mapped = complaintStatusFromCode(normalized);

    var activeStep = 0;
    var isRejected = false;
    if (mapped == ComplaintStatus.received) {
      activeStep = 0;
    } else if (mapped == ComplaintStatus.pending ||
        mapped == ComplaintStatus.verified) {
      activeStep = 1;
    } else if (mapped == ComplaintStatus.inProgress) {
      activeStep = 2;
    } else if (mapped == ComplaintStatus.completed) {
      activeStep = 3;
    } else if (mapped == ComplaintStatus.rejected ||
        mapped == ComplaintStatus.cancelled) {
      activeStep = 1;
      isRejected = true;
    }

    final verificationLabel = switch (normalized) {
      'rejected' => 'Ditolak',
      'cancelled' || 'canceled' => 'Dibatalkan',
      'verified' => 'Terverifikasi',
      _ when activeStep > 1 => 'Terverifikasi',
      _ => 'Verifikasi',
    };

    final followUpLabel = switch (normalized) {
      'mediation' => 'Mediasi',
      'fifty_fifty' => '50:50',
      'bpn_forwarded' => 'BPN',
      _ => 'Tindak Lanjut',
    };

    return (
      activeStep: activeStep,
      isTerminalNegative: isRejected,
      labels: ['Diajukan', verificationLabel, followUpLabel, 'Selesai'],
    );
  }

  List<ComplaintTimelineEntity> _effectiveTimeline() {
    if (detail.timeline.isNotEmpty) {
      return detail.timeline.reversed.toList();
    }
    return [
      ComplaintTimelineEntity(
        type: detail.status,
        description: JagaTanahDetailLabels.resolveStatusLabel(
          detail.status,
          detail.statusLabel,
        ),
        createdAt: detail.reportedAt,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final progress = _resolveProgress(detail.status);
    final entries = _effectiveTimeline();
    const icons = [
      Icons.inbox_rounded,
      Icons.verified_user_rounded,
      Icons.engineering_rounded,
      Icons.check_circle_rounded,
    ];

    return JagaTanahSectionCard(
      title: 'Perkembangan Status',
      icon: Icons.timeline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: colors.primaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colors.primaryDark.withValues(alpha: 0.16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: List.generate(4, (index) {
                    final isCompleted = index < progress.activeStep;
                    final isCurrent = index == progress.activeStep;

                    final Color circleColor;
                    final Color iconColor;
                    final IconData stepIcon;

                    if (isCompleted) {
                      circleColor = colors.primary;
                      iconColor = colors.onPrimary;
                      stepIcon = Icons.check_rounded;
                    } else if (isCurrent) {
                      circleColor = progress.isTerminalNegative
                          ? colors.errorSolid
                          : colors.primary;
                      iconColor = progress.isTerminalNegative
                          ? colors.onErrorSolid
                          : colors.onPrimary;
                      stepIcon = progress.isTerminalNegative
                          ? Icons.close_rounded
                          : icons[index];
                    } else {
                      circleColor = colors.borderStrong;
                      iconColor = colors.textPrimary;
                      stepIcon = icons[index];
                    }

                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: index == 0
                                ? const SizedBox.shrink()
                                : Container(
                                    height: 2,
                                    margin: const EdgeInsets.only(right: 4),
                                    color: index <= progress.activeStep
                                        ? colors.primaryDark
                                        : colors.borderStrong,
                                  ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: circleColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(stepIcon, size: 15, color: iconColor),
                          ),
                          Expanded(
                            child: index == 3
                                ? const SizedBox.shrink()
                                : Container(
                                    height: 2,
                                    margin: const EdgeInsets.only(left: 4),
                                    color: index < progress.activeStep
                                        ? colors.primaryDark
                                        : colors.borderStrong,
                                  ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (index) {
                    final active = index <= progress.activeStep;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              progress.labels[index],
                              maxLines: 1,
                              softWrap: false,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelSmall.copyWith(
                                fontSize: 10,
                                letterSpacing: 0,
                                fontWeight: active
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: active
                                    ? colors.primaryDark
                                    : colors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(entries.length, (index) {
            final entry = entries[index];
            final isLatest = index == 0;
            final isLast = index == entries.length - 1;
            final created = entry.createdAt;
            final note = entry.description.isNotEmpty
                ? entry.description
                : JagaTanahDetailLabels.resolveStatusLabel(entry.type, '');

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 82,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          created != null
                              ? JagaTanahDetailLabels.formatDate(created)
                              : '-',
                          textAlign: TextAlign.end,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: isLatest
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isLatest
                                ? colors.textPrimary
                                : colors.textSecondary,
                          ),
                        ),
                        if (created != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            JagaTanahDetailLabels.formatTime(created),
                            textAlign: TextAlign.end,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 11,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: isLatest
                                ? colors.primaryDark
                                : colors.textHint,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.surface, width: 2),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              constraints: const BoxConstraints(minHeight: 28),
                              color: colors.divider,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isLatest
                                  ? colors.textPrimary
                                  : colors.textSecondary,
                              fontWeight: isLatest
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                          if (entry.actorName.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Oleh: ${entry.actorName}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
