import 'dart:async';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/ad_banner_slider.dart';
import 'package:akar/features/masyarakat/complaint/data/dummy_complaints.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/widgets/complaint_list_widget.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_cubit.dart';
import 'package:akar/features/masyarakat/notification/presentation/pages/disaster_emergency_call_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<DisasterAlertEvent>? _alertSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestHomePermissions();
    });

    _alertSubscription = sl<DisasterAlertService>().alertStream.listen((event) {
      if (mounted) {
        DisasterEmergencyWarningPage.show(context, event);
      }
    });
  }

  @override
  void dispose() {
    _alertSubscription?.cancel();
    super.dispose();
  }

  Future<void> _requestHomePermissions() async {
    try {
      final locationStatus = await Permission.location.status;
      final cameraStatus = await Permission.camera.status;

      if (!locationStatus.isGranted || !cameraStatus.isGranted) {
        await [Permission.location, Permission.camera].request();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardPengaduan(),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pengaduan Saya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                        letterSpacing: 0.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.read<MainCubit>().changeTab(3),
                      child: Text(
                        'Lihat Semua',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ComplaintListWidget(
                  items: dummyMyComplaints.take(3).toList(),
                  onItemTap: (item) => ComplaintDetailPage.show(context, item),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Informasi Terbaru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),

                const AdBannerSlider(height: 165.0),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildCardPengaduan() {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: const Alignment(1.5, 1.0),
              child: Image.asset(
                'assets/placeholder_feature.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/placeholder_feature.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: AppColors.primaryDark);
                    },
                  );
                },
              ),
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primaryDark.withAlpha(245),
                      AppColors.primaryDark.withAlpha(180),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 0.65, 0.95],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PENGADUAN\nMASYARAKAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sampaikan keluhan anda untuk\nlingkungan yang lebih baik.',
                        style: TextStyle(
                          color: Colors.white.withAlpha(230),
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth * 0.5,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await CreateComplaintPage.show(
                              context,
                            );
                            if (result == true && context.mounted) {
                              context.read<MainCubit>().changeTab(0);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'BUAT PENGADUAN',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
