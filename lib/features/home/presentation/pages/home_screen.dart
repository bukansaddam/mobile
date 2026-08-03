import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/activation/presentation/provider/activation_provider.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:akar/features/home/presentation/widgets/home_profile_card.dart';
import 'package:akar/features/home/presentation/widgets/home_summary_card.dart';
import 'package:akar/features/home/presentation/widgets/notification_modal.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
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

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.pushNamed('panic'),
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            elevation: 6,
            icon: const Icon(Icons.warning_amber_rounded, size: 24),
            label: const Text(
              'PANIC',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xFFD6E6FE),
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logo.webp',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () => NotificationModalSheet.show(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.textPrimary,
                          size: 26,
                        ),
                        tooltip: 'Notifikasi Kegiatan',
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: const Text(
                              '5',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: HomeProfileCard(user: user)),
                const SizedBox(height: 20),

                Text(
                  'Ringkasan Kegiatan',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 14),

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
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Menu Utama',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 14),

                _buildMenuUtamaSection(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuUtamaSection(BuildContext context) {
    final menuItems = [
      {
        'title': 'Aktivasi',
        'icon': Icons.flash_on_rounded,
        'color': const Color(0xFF2563EB),
        'bgColor': const Color(0xFFEFF6FF),
        'onTap': () {},
      },
      {
        'title': 'Peta Tracking',
        'icon': Icons.map_rounded,
        'color': const Color(0xFF0D9488),
        'bgColor': const Color(0xFFCCFBF1),
        'onTap': () {
          context.pushNamed('map_tracking');
        },
      },
      {
        'title': 'Analisis',
        'icon': Icons.analytics_rounded,
        'color': const Color(0xFF7C3AED),
        'bgColor': const Color(0xFFF3E8FF),
        'onTap': () {},
      },
      {
        'title': 'Pengaturan',
        'icon': Icons.settings_rounded,
        'color': const Color(0xFF4B5563),
        'bgColor': const Color(0xFFF3F4F6),
        'onTap': () {
          context.pushNamed('setting');
        },
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: menuItems.map((item) {
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: item['onTap'] as VoidCallback?,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: item['bgColor'] as Color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title'] as String,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
