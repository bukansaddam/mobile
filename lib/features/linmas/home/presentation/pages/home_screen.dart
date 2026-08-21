import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';
import 'package:akar/features/linmas/home/presentation/widgets/ad_banner_slider.dart';
import 'package:akar/features/linmas/home/presentation/widgets/bank_sampah_summary_card.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:akar/features/survey/presentation/widgets/survey_card_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return BlocBuilder<AuthBloc, AuthState>(
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
