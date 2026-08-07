import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/activation/presentation/provider/activation_provider.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:akar/features/home/presentation/widgets/ad_banner_slider.dart';
import 'package:akar/features/home/presentation/widgets/home_profile_card.dart';
import 'package:akar/features/home/presentation/widgets/home_summary_card.dart';
import 'package:akar/features/tracking/presentation/provider/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _logoTapCount = 0;
  DateTime? _lastLogoTapTime;

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
        return Consumer<TrackingProvider>(
          builder: (context, trackingProvider, child) {
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
                      color: trackingProvider.isTrackingActive
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
                              trackingProvider.isTrackingActive
                                  ? 'Aktif (Mengirim otomatis ke API 24/7)'
                                  : 'Dinonaktifkan',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: trackingProvider.isTrackingActive
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: trackingProvider.isTrackingActive,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            if (val) {
                              trackingProvider.startTracking();
                            } else {
                              trackingProvider.stopTracking();
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
                        value: trackingProvider.intervalSeconds,
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
                            trackingProvider.changeInterval(val);
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
                              trackingProvider.lastSuccess
                                  ? Icons.check_circle_rounded
                                  : Icons.error_rounded,
                              size: 16,
                              color: trackingProvider.lastSuccess
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                trackingProvider.lastMessage ??
                                    'Belum ada pengiriman ke API',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: trackingProvider.lastSuccess
                                      ? AppColors.textPrimary
                                      : AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (trackingProvider.lastSentTime != null) ...[
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
                                  'Waktu Terakhir: ${DateFormat('dd MMM yyyy, HH:mm:ss').format(trackingProvider.lastSentTime!)} WIB',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (trackingProvider.lastLatitude != null &&
                            trackingProvider.lastLongitude != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Koordinat Terakhir: ${trackingProvider.lastLatitude}, ${trackingProvider.lastLongitude}',
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
                      onPressed: trackingProvider.isSending
                          ? null
                          : () async {
                              await trackingProvider.sendLocationNow();
                            },
                      icon: trackingProvider.isSending
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
                        trackingProvider.isSending
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
    return Consumer2<AuthProvider, ActivationProvider>(
      builder: (context, authProvider, activationProvider, child) {
        final user = authProvider.currentUser;
        final activities = activationProvider.activities;

        final totalTugasCount = activities.length;
        final totalAgendaCount = activities
            .where((act) => act.status == ActivationStatus.sedangBerjalan)
            .length;
        final totalLaporanCount = activities
            .where((act) => act.status == ActivationStatus.selesai)
            .length;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _onLogoTap,
                  child: HomeProfileCard(user: user),
                ),
              ),
              const SizedBox(height: 16),

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: HomeSummaryCard(
                        title: 'Total Daftar Tugas',
                        subtitle: 'Kegiatan aktif',
                        count: '$totalTugasCount',
                        icon: Icons.assignment_outlined,
                        gradientColors: const [
                          Color(0xFF0F9F66),
                          Color(0xFF0A754B),
                        ],
                        isCompact: true,
                        onTap: () {
                          widget.onNavigateToTab?.call(2);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: HomeSummaryCard(
                        title: 'Total Agenda',
                        subtitle: 'Sedang berjalan',
                        count: '$totalAgendaCount',
                        icon: Icons.event_note_rounded,
                        gradientColors: const [
                          Color(0xFF5CB836),
                          Color(0xFF438A24),
                        ],
                        isCompact: true,
                        onTap: () {
                          widget.onNavigateToTab?.call(2);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: HomeSummaryCard(
                        title: 'Total Laporan',
                        subtitle: 'Telah selesai',
                        count: '$totalLaporanCount',
                        icon: Icons.insert_drive_file_outlined,
                        gradientColors: const [
                          Color(0xFFD99B00),
                          Color(0xFFB37B00),
                        ],
                        isCompact: true,
                        onTap: () {
                          widget.onNavigateToTab?.call(2);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Menu Utama',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),

              _buildMenuUtamaSection(context),

              const SizedBox(height: 16),

              Text(
                'Informasi Terbaru',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),

              const AdBannerSlider(),

              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuUtamaSection(BuildContext context) {
    final menuItems = [
      {
        'title': 'Presensi',
        'subtitle': 'Swafoto & Lokasi',
        'icon': Icons.co_present_rounded,
        'color': AppColors.primary,
        'onTap': () => context.pushNamed('presensi'),
      },
      {
        'title': 'Ronda Malam',
        'subtitle': 'Patroli & Siaga',
        'icon': Icons.nights_stay_rounded,
        'color': const Color(0xFF5B4DFF),
        'onTap': () => context.pushNamed('ronda_malam'),
      },
      {
        'title': 'Profiling',
        'subtitle': 'Tokoh Sekitar',
        'icon': Icons.badge_rounded,
        'color': const Color(0xFF0F9F66),
        'onTap': () => context.pushNamed('profiling'),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
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
              child: Row(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
