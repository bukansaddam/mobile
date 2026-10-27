import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_event.dart';
import 'package:akar/features/linmas/announcement/presentation/bloc/announcement_state.dart';
import 'package:akar/features/linmas/announcement/presentation/pages/announcement_list_page.dart';
import 'package:akar/features/linmas/announcement/presentation/widgets/announcement_detail_modal.dart';
import 'package:akar/features/linmas/announcement/presentation/widgets/pengumuman_banner_slider.dart';
import 'package:akar/features/masyarakat/home/presentation/widgets/home_announcement_tile.dart';

class HomeAnnouncementSection extends StatelessWidget {
  const HomeAnnouncementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Informasi Terbaru',
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
        ),
        const SizedBox(height: 12),

        const PengumumanBannerSlider(height: 165.0),

        const SizedBox(height: 16),

        BlocBuilder<AnnouncementBloc, AnnouncementState>(
          builder: (context, state) {
            if (state.status == AnnouncementStatus.loading &&
                state.announcements.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            }

            if (state.status == AnnouncementStatus.error &&
                state.announcements.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  children: [
                    Text(
                      state.errorMessage ?? 'Gagal memuat informasi terbaru',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<AnnouncementBloc>().add(
                          const FetchAnnouncements(),
                        );
                        context.read<AnnouncementBloc>().add(
                          const FetchBannerAnnouncements(),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Coba Lagi', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              );
            }

            final announcements = state.announcements.take(3).toList();

            if (announcements.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: const Center(
                  child: Text(
                    'Belum ada informasi terbaru',
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
                return HomeAnnouncementTile(
                  item: item,
                  onTap: () => AnnouncementDetailModal.show(context, item),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
