import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:akar/features/linmas/home/presentation/widgets/ad_banner_slider.dart';
import 'package:akar/features/linmas/home/presentation/widgets/bank_sampah_summary_card.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:akar/features/survey/presentation/widgets/survey_card_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _logoTapCount = 0;
  DateTime? _lastLogoTapTime;

  void _dismissSurveyIfSubmitted(BuildContext context) {
    final surveyBloc = context.read<SurveyBloc>();
    final state = surveyBloc.state;
    if (state is SurveyStatusLoadedState &&
        state.isSubmitted &&
        !state.isDismissed) {
      surveyBloc.add(const DismissSurveyCardEvent());
    }
  }

  void _onLogoTap() {
    final now = DateTime.now();
    if (_lastLogoTapTime != null &&
        now.difference(_lastLogoTapTime!).inSeconds > 3) {
      _logoTapCount = 0;
    }
    _lastLogoTapTime = now;
    _logoTapCount++;

    if (_logoTapCount >= 10) {
      _logoTapCount = 0;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.stars_rounded, color: AppColors.white),
              SizedBox(width: 8),
              Text('Mode Eksklusif: Membuka Pengaturan Tracking...'),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      _showTrackingConfigModal(context);
    } else if (_logoTapCount >= 3) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mode Eksklusif: Tekan kartu profil $_logoTapCount/10 kali',
          ),
          duration: const Duration(milliseconds: 700),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showTrackingConfigModal(BuildContext context) {
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
                        trackingState.isSending
                            ? 'Mengirim...'
                            : 'Kirim Lokasi Ke API Sekarang',
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;

        return BlocBuilder<ActivationBloc, ActivationState>(
          builder: (context, activationState) {
            // final activities = activationState.activities;

            // final totalTugasCount = activities.length;
            // final totalAgendaCount = activities
            //     .where((act) => act.status == ActivationStatus.sedangBerjalan)
            //     .length;
            // final totalLaporanCount = activities
            //     .where((act) => act.status == ActivationStatus.selesai)
            //     .length;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<BankSampahBloc, BankSampahState>(
                    builder: (context, bankState) {
                      return BankSampahSummaryCard(
                        user: user,
                        totalBeratKg: bankState.totalBeratKg,
                        totalNilaiRupiah: bankState.totalNilaiRupiah,
                        onAvatarTap: _onLogoTap,
                        onTap: () {
                          _dismissSurveyIfSubmitted(context);
                          context.pushNamed('bankSampah');
                        },
                      );
                    },
                  ),
                  // const SizedBox(height: 16),

                  // IntrinsicHeight(
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.stretch,
                  //     children: [
                  //       Expanded(
                  //         child: HomeSummaryCard(
                  //           title: 'Total Tugas',
                  //           subtitle: 'Kegiatan aktif',
                  //           count: '$totalTugasCount',
                  //           icon: Icons.assignment_outlined,
                  //           gradientColors: const [
                  //             Color(0xFF0F9F66),
                  //             Color(0xFF0A754B),
                  //           ],
                  //           isCompact: true,
                  //           onTap: () {
                  //             _dismissSurveyIfSubmitted(context);
                  //             context.read<ActivationBloc>().add(
                  //               const SetActivationStatusFilterEvent(null),
                  //             );
                  //             widget.onNavigateToTab?.call(2);
                  //           },
                  //         ),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       Expanded(
                  //         child: HomeSummaryCard(
                  //           title: 'Total Agenda',
                  //           subtitle: 'Sedang berjalan',
                  //           count: '$totalAgendaCount',
                  //           icon: Icons.event_note_rounded,
                  //           gradientColors: const [
                  //             Color(0xFFD99B00),
                  //             Color(0xFFB37B00),
                  //           ],
                  //           isCompact: true,
                  //           onTap: () {
                  //             _dismissSurveyIfSubmitted(context);
                  //             context.read<ActivationBloc>().add(
                  //               const SetActivationStatusFilterEvent(
                  //                 ActivationStatus.sedangBerjalan,
                  //               ),
                  //             );
                  //             widget.onNavigateToTab?.call(2);
                  //           },
                  //         ),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       Expanded(
                  //         child: HomeSummaryCard(
                  //           title: 'Total Laporan',
                  //           subtitle: 'Telah selesai',
                  //           count: '$totalLaporanCount',
                  //           icon: Icons.insert_drive_file_outlined,
                  //           gradientColors: const [
                  //             Color(0xFF5CB836),
                  //             Color(0xFF438A24),
                  //           ],
                  //           isCompact: true,
                  //           onTap: () {
                  //             _dismissSurveyIfSubmitted(context);
                  //             context.read<ActivationBloc>().add(
                  //               const SetActivationStatusFilterEvent(
                  //                 ActivationStatus.selesai,
                  //               ),
                  //             );
                  //             widget.onNavigateToTab?.call(2);
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  const SurveyCardBanner(),
                  _buildMenuUtamaSection(context),

                  const SizedBox(height: 16),
                  const AdBannerSlider(),

                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuUtamaSection(BuildContext context) {
    final menuItems = [
      {
        'title': 'Perbarui Posisi',
        'subtitle': 'Swafoto & Lokasi',
        'icon': Icons.co_present_rounded,
        'color': AppColors.primary,
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('presensi');
        },
      },
      {
        'title': 'Laporan Harian',
        'subtitle': 'Catatan & Kegiatan',
        'icon': Icons.assignment_rounded,
        'color': const Color(0xFF5B4DFF),
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('rondaMalam');
        },
      },
      {
        'title': 'Demografi',
        'subtitle': 'Tokoh Sekitar',
        'icon': Icons.badge_rounded,
        'color': const Color(0xFF0F9F66),
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('demografi');
        },
      },
      {
        'title': 'Bank Sampah',
        'subtitle': 'Laporan & Setor',
        'icon': Icons.recycling_rounded,
        'color': const Color(0xFF0284C7),
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('bankSampah');
        },
      },
      // {
      //   'title': 'Survey Bulanan',
      //   'subtitle': 'Lingkungan & RT',
      //   'icon': Icons.assignment_turned_in_rounded,
      //   'color': AppColors.accent,
      //   'onTap': () => context.pushNamed('survey'),
      // },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final color = item['color'] as Color;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: item['onTap'] as VoidCallback,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['subtitle'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
