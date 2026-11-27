import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/offline/widgets/offline_status_banner.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_event.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_state.dart';
import 'package:akar/features/linmas/announcement/presentation/pages/announcement_list_page.dart';
import 'package:akar/features/linmas/announcement/presentation/widgets/announcement_detail_modal.dart';
import 'package:akar/features/linmas/announcement/presentation/widgets/pengumuman_banner_slider.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:akar/features/linmas/dashboard/presentation/bloc/member_dashboard_bloc.dart';
import 'package:akar/features/linmas/dashboard/presentation/bloc/member_dashboard_event.dart';
import 'package:akar/features/linmas/dashboard/presentation/bloc/member_dashboard_state.dart';
import 'package:akar/features/linmas/home/presentation/widgets/bank_sampah_summary_card.dart';
import 'package:akar/features/linmas/home/presentation/widgets/gps_anomaly_banner.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:akar/features/survey/presentation/widgets/survey_card_banner.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Widget _buildHomeListImage(BuildContext context, String path) {
  final colors = context.appColors;
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return AppNetworkImage(
      imageUrl: path,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      errorIcon: Icons.campaign_outlined,
      backgroundColor: colors.primaryLight,
    );
  }
  return Image.asset(
    path,
    width: 52,
    height: 52,
    cacheWidth: 156,
    cacheHeight: 156,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => Container(
      width: 52,
      height: 52,
      color: colors.primaryLight,
      child: Icon(Icons.campaign_outlined, color: colors.primary, size: 24),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _dismissSurveyIfSubmitted(BuildContext context) {
    final surveyBloc = context.read<SurveyBloc>();
    final state = surveyBloc.state;
    if (state is SurveyStatusLoadedState &&
        state.isSubmitted &&
        !state.isDismissed) {
      surveyBloc.add(const DismissSurveyCardEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AnnouncementBloc>()
            ..add(const FetchAnnouncements())
            ..add(const FetchBannerAnnouncements()),
        ),
        BlocProvider(
          create: (context) =>
              sl<MemberDashboardBloc>()..add(const FetchMemberDashboardEvent()),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user = authState is AuthAuthenticated ? authState.user : null;

          return BlocBuilder<ActivationBloc, ActivationState>(
            builder: (context, activationState) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MemberDashboardBloc>().add(
                    const RefreshMemberDashboardEvent(),
                  );
                  context.read<AnnouncementBloc>()
                    ..add(const FetchAnnouncements())
                    ..add(const FetchBannerAnnouncements());
                  context.read<BankSampahBloc>().add(
                    const RefreshBankSampahDataEvent(),
                  );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const OfflineStatusBanner(),
                      const GpsAnomalyBanner(),
                      BlocBuilder<MemberDashboardBloc, MemberDashboardState>(
                        builder: (context, dashboardState) {
                          final dashboard =
                              dashboardState is MemberDashboardLoaded
                              ? dashboardState.dashboard
                              : null;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<BankSampahBloc, BankSampahState>(
                                builder: (context, bankState) {
                                  final bankBloc = context
                                      .read<BankSampahBloc>();
                                  return BankSampahSummaryCard(
                                    user: user,
                                    userName: dashboard?.user.name,
                                    userPhone: dashboard?.user.phone,
                                    userPhotoUrl:
                                        dashboard?.user.displayPhotoUrl,
                                    totalBeratKg:
                                        dashboard?.waste.totalWeightKg ??
                                        bankBloc.totalBeratKg,
                                    totalNilaiRupiah:
                                        dashboard?.waste.totalEarnings ??
                                        bankBloc.totalNilaiRupiah,
                                    onTap: () {
                                      _dismissSurveyIfSubmitted(context);
                                      context.pushNamed('bankSampah');
                                    },
                                  );
                                },
                              ),
                              if (dashboard?.survey != null &&
                                  dashboard!.survey.isAvailable &&
                                  !dashboard.survey.isFilled) ...[
                                const SizedBox(height: 16),
                                SurveyCardBanner(survey: dashboard.survey),
                              ] else ...[
                                const SizedBox(height: 16),
                              ],
                            ],
                          );
                        },
                      ),
                      _buildMenuUtamaSection(context),

                      const SizedBox(height: 12),
                      const PengumumanBannerSlider(),
                      const SizedBox(height: 8),
                      _buildPengumumanHeader(context),
                      const SizedBox(height: 12),
                      _buildPengumumanListTileSection(context),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPengumumanHeader(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Pengumuman',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        GestureDetector(
          onTap: () => AnnouncementListPage.show(context),
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
    );
  }

  Widget _buildMenuUtamaSection(BuildContext context) {
    final colors = context.appColors;
    final menuItems = [
      {
        'title': 'Perbarui Posisi',
        'subtitle': 'Swafoto & Lokasi',
        'icon': Icons.co_present_rounded,
        'color': colors.primary,
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('presensi');
        },
      },
      {
        'title': 'Laporan Harian',
        'subtitle': 'Catatan & Kegiatan',
        'icon': Icons.assignment_rounded,
        'color': colors.indigo,
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('rondaMalam');
        },
      },
      {
        'title': 'Laporan Insidentil',
        'subtitle': 'Kejadian Lapangan',
        'icon': Icons.report_problem_rounded,
        'color': colors.error,
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('laporanInsidentil');
        },
      },
      {
        'title': 'Demografi',
        'subtitle': 'Tokoh Sekitar',
        'icon': Icons.badge_rounded,
        'color': colors.emerald,
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('demografi');
        },
      },
      {
        'title': 'Bank Sampah',
        'subtitle': 'Laporan & Setor',
        'icon': Icons.recycling_rounded,
        'color': colors.info,
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('bankSampah');
        },
      },
      {
        'title': 'Jaga Tanah',
        'subtitle': 'Laporan Aset Tanah',
        'icon': Icons.landscape_rounded,
        'color': colors.earth,
        'onTap': () {
          _dismissSurveyIfSubmitted(context);
          context.pushNamed('jagaTanah');
        },
      },
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
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
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
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['subtitle'] as String,
                    style: TextStyle(fontSize: 10, color: colors.textSecondary),
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

  Widget _buildPengumumanListTileSection(BuildContext context) {
    final colors = context.appColors;
    return BlocBuilder<AnnouncementBloc, AnnouncementState>(
      builder: (context, state) {
        if (state.status == AnnouncementStatus.loading &&
            state.announcements.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              ),
            ),
          );
        }

        final announcements = state.announcements.take(3).toList();

        if (announcements.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Center(
              child: Text(
                'Belum ada pengumuman',
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: announcements.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = announcements[index];

            return Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  onTap: () => AnnouncementDetailModal.show(context, item),
                  leading: item.hasImage
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildHomeListImage(
                            context,
                            item.allImages.first,
                          ),
                        )
                      : Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: colors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.campaign_outlined,
                            color: colors.primary,
                            size: 24,
                          ),
                        ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textSecondary,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (item.date.isNotEmpty) ...[
                              Icon(
                                Icons.access_time_rounded,
                                size: 11,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.date,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.textHint,
                    size: 20,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
