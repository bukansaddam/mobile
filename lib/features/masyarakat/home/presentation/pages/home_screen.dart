import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/offline/widgets/offline_status_banner.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_event.dart';
import 'package:akar/features/masyarakat/complaint/presentation/models/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/complaint_detail_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/create_complaint_page.dart';
import 'package:akar/features/masyarakat/complaint/presentation/widgets/complaint_list_widget.dart';
import 'package:akar/features/masyarakat/home/presentation/widgets/complaint_banner_card.dart';
import 'package:akar/features/masyarakat/home/presentation/widgets/home_announcement_section.dart';
import 'package:akar/features/masyarakat/main/presentation/bloc/main_bloc/main_bloc.dart';
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

  Future<void> _onRefresh(BuildContext context) async {
    context.read<AnnouncementBloc>().add(
      const FetchAnnouncements(isRefresh: true),
    );
    context.read<AnnouncementBloc>().add(const FetchBannerAnnouncements());
    context.read<MyComplaintListBloc>().add(
      const FetchMyComplaintsEvent(isRefresh: true),
    );
  }

  Future<void> _openCreateComplaint(BuildContext context) async {
    final result = await CreateComplaintPage.show(context);
    if (result == true && context.mounted) {
      context.read<MainBloc>().add(const MainTabChanged(0));
      context.read<MyComplaintListBloc>().add(
        const FetchMyComplaintsEvent(isRefresh: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocProvider(
      create: (context) => sl<AnnouncementBloc>()
        ..add(const FetchAnnouncements())
        ..add(const FetchBannerAnnouncements()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: colors.background,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                color: colors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OfflineStatusBanner(),
                        ComplaintBannerCard(
                          onCreateComplaint: () =>
                              _openCreateComplaint(context),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pengaduan Saya',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                letterSpacing: 0.2,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.read<MainBloc>().add(
                                    const MainTabChanged(3),
                                  ),
                              child: Text(
                                'Lihat Semua',
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        BlocBuilder<MyComplaintListBloc, MyComplaintListState>(
                          builder: (context, state) {
                            final items = state.items
                                .take(3)
                                .map(ComplaintItem.fromReport)
                                .toList();
                            if (items.isEmpty &&
                                state.status == MyComplaintListStatus.loading) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ComplaintListWidget(
                              items: items,
                              isError:
                                  state.status == MyComplaintListStatus.failure,
                              errorMessage: state.errorMessage,
                              onItemTap: (item) =>
                                  ComplaintDetailPage.show(context, item),
                              onCreateTap: () => _openCreateComplaint(context),
                              onRefreshTap: () =>
                                  context.read<MyComplaintListBloc>().add(
                                    const FetchMyComplaintsEvent(
                                      isRefresh: true,
                                    ),
                                  ),
                            );
                          },
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
