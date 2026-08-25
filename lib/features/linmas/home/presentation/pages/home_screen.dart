import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_event.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_state.dart';
import 'package:akar/features/linmas/announcement/presentation/pages/announcement_list_page.dart';
import 'package:akar/features/linmas/announcement/presentation/widgets/announcement_detail_modal.dart';
import 'package:akar/features/linmas/announcement/presentation/widgets/pengumuman_banner_slider.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:akar/features/linmas/home/presentation/widgets/bank_sampah_summary_card.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:akar/features/survey/presentation/widgets/survey_card_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Widget _buildHomeListImage(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return Image.network(
      path,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 52,
        height: 52,
        color: AppColors.primaryLight,
        child: const Icon(
          Icons.campaign_outlined,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
  return Image.asset(
    path,
    width: 52,
    height: 52,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => Container(
      width: 52,
      height: 52,
      color: AppColors.primaryLight,
      child: const Icon(
        Icons.campaign_outlined,
        color: AppColors.primary,
        size: 24,
      ),
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
    return BlocProvider(
      create: (context) => sl<AnnouncementBloc>()
        ..add(const FetchAnnouncements())
        ..add(const FetchBannerAnnouncements()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user = authState is AuthAuthenticated ? authState.user : null;

          return BlocBuilder<ActivationBloc, ActivationState>(
            builder: (context, activationState) {
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
                          onTap: () {
                            _dismissSurveyIfSubmitted(context);
                            context.pushNamed('bankSampah');
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const SurveyCardBanner(),
                    _buildMenuUtamaSection(context),

                    const SizedBox(height: 20),
                    const PengumumanBannerSlider(),

                    const SizedBox(height: 20),
                    _buildPengumumanHeader(context),
                    const SizedBox(height: 12),
                    _buildPengumumanListTileSection(context),

                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPengumumanHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Pengumuman',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
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
              color: AppColors.primary,
            ),
          ),
        ),
      ],
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

  Widget _buildPengumumanListTileSection(BuildContext context) {
    return BlocBuilder<AnnouncementBloc, AnnouncementState>(
      builder: (context, state) {
        if (state.status == AnnouncementStatus.loading &&
            state.announcements.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: const Center(
              child: Text(
                'Belum ada pengumuman',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
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
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.03),
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
                          child: _buildHomeListImage(item.allImages.first),
                        )
                      : Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.campaign_outlined,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
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
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (item.date.isNotEmpty) ...[
                              const Icon(
                                Icons.access_time_rounded,
                                size: 11,
                                color: AppColors.grey500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.date,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.grey500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey400,
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
