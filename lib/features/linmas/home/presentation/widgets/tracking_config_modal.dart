import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TrackingConfigModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocBuilder<TrackingBloc, TrackingState>(
          builder: (context, trackingState) {
            final intervals = [
              {'value': 5, 'label': '5 Detik'},
              {'value': 10, 'label': '10 Detik'},
              {'value': 30, 'label': '30 Detik'},
              {'value': 60, 'label': '1 Menit'},
              {'value': 300, 'label': '5 Menit'},
              {'value': 900, 'label': '15 Menit (Default)'},
            ];

            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.satellite_alt_rounded,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Konfigurasi Tracking API',
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: trackingState.isTrackingActive
                          ? AppColors.successLight.withValues(alpha: 0.15)
                          : AppColors.grey200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Background Tracking',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              trackingState.isTrackingActive
                                  ? 'Aktif (Mengirim otomatis ke API 24/7)'
                                  : 'Dinonaktifkan',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: trackingState.isTrackingActive
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: trackingState.isTrackingActive,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            if (val) {
                              context.read<TrackingBloc>().add(
                                StartTrackingEvent(),
                              );
                            } else {
                              context.read<TrackingBloc>().add(
                                StopTrackingEvent(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Interval Pengiriman API',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: trackingState.intervalSeconds,
                        isExpanded: true,
                        items: intervals.map((item) {
                          return DropdownMenuItem<int>(
                            value: item['value'] as int,
                            child: Text(
                              item['label'] as String,
                              style: AppTextStyles.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            context.read<TrackingBloc>().add(
                              ChangeTrackingIntervalEvent(val),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Terakhir API:',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              trackingState.lastSuccess
                                  ? Icons.check_circle_rounded
                                  : Icons.error_rounded,
                              size: 16,
                              color: trackingState.lastSuccess
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                trackingState.lastMessage ??
                                    'Belum ada pengiriman ke API',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: trackingState.lastSuccess
                                      ? AppColors.textPrimary
                                      : AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (trackingState.lastSentTime != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Waktu Terakhir: ${DateFormat('dd MMM yyyy, HH:mm:ss').format(trackingState.lastSentTime!)} WIB',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (trackingState.lastLatitude != null &&
                            trackingState.lastLongitude != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Koordinat Terakhir: ${trackingState.lastLatitude}, ${trackingState.lastLongitude}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: trackingState.isSending
                          ? null
                          : () {
                              context.read<TrackingBloc>().add(
                                SendLocationNowEvent(),
                              );
                            },
                      icon: trackingState.isSending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        trackingState.isSending ? 'Mengirim...' : 'Kirim',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pengujian Status Survey (Mode Eksklusif)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<SurveyBloc>().add(
                          const ResetSurveyStatusEvent(),
                        );
                        Navigator.pop(modalContext);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Seluruh status survey (Baseline & Bulanan) berhasil di-reset untuk pengujian.',
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: const Text(
                        'Reset Status Survey (Baseline & Bulanan)',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
