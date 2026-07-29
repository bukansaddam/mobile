import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:akar/features/home/presentation/widgets/home_profile_card.dart';
import 'package:akar/features/home/presentation/widgets/home_summary_card.dart';
import 'package:akar/features/home/presentation/widgets/notification_modal.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestHomePermissions();
    });
  }

  Future<void> _requestHomePermissions() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (e) {
      debugPrint('Error requesting permissions on Home: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        return Scaffold(
          backgroundColor: AppColors.background,
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
                padding: const EdgeInsets.only(right: 12.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      onPressed: () => NotificationModalSheet.show(context),
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.textPrimary,
                        size: 26,
                      ),
                      tooltip: 'Notifikasi Kegiatan',
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
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
                  ],
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

                HomeSummaryCard(
                  title: 'Total Daftar Tugas',
                  subtitle: 'Daftar tugas aktif',
                  count: '4',
                  icon: Icons.assignment_outlined,
                  gradientColors: const [Color(0xFF0F9F66), Color(0xFF0A754B)],
                ),
                const SizedBox(height: 16),
                HomeSummaryCard(
                  title: 'Total Agenda',
                  subtitle: 'Agenda kegiatan mendatang',
                  count: '5',
                  icon: Icons.event_note_rounded,
                  gradientColors: const [Color(0xFF5CB836), Color(0xFF438A24)],
                ),
                const SizedBox(height: 16),
                HomeSummaryCard(
                  title: 'Total Laporan',
                  subtitle: 'Laporan telah terkirim',
                  count: '9',
                  icon: Icons.insert_drive_file_outlined,
                  gradientColors: const [Color(0xFFD99B00), Color(0xFFB37B00)],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
