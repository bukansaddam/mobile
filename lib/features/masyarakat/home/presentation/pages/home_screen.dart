import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_event.dart';
import 'package:akar/features/masyarakat/complaint/data/dummy_complaints.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/widgets/complaint_list_widget.dart';
import 'package:akar/features/masyarakat/home/presentation/widgets/complaint_banner_card.dart';
import 'package:akar/features/masyarakat/home/presentation/widgets/home_announcement_section.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_cubit.dart';
import 'package:akar/features/masyarakat/notification/presentation/pages/disaster_emergency_call_page.dart';

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

      if (mounted) {
        await sl<FirebaseNotificationService>().checkAndPromptOverlayPermission(
          context,
        );
      }
    } catch (_) {}
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<AnnouncementBloc>().add(
      const FetchAnnouncements(isRefresh: true),
    );
    context.read<AnnouncementBloc>().add(const FetchBannerAnnouncements());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnnouncementBloc>()
        ..add(const FetchAnnouncements())
        ..add(const FetchBannerAnnouncements()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ComplaintBannerCard(
                          onCreateComplaint: () async {
                            final result = await CreateComplaintPage.show(
                              context,
                            );
                            if (result == true && context.mounted) {
                              context.read<MainCubit>().changeTab(0);
                            }
                          },
                        ),

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
                              onTap: () =>
                                  context.read<MainCubit>().changeTab(3),
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
                          onItemTap: (item) =>
                              ComplaintDetailPage.show(context, item),
                        ),

                        const SizedBox(height: 20),

                        const HomeAnnouncementSection(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
