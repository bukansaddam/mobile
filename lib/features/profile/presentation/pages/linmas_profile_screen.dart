import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/kta_card_dialog.dart';
import 'package:akar/core/widgets/theme_mode_selector_tile.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/linmas/activation/data/datasources/activation_pending_report_local_datasource.dart';
import 'package:akar/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/profile/presentation/widgets/profile_points_card.dart';
import 'package:akar/features/profile/presentation/widgets/profile_settings_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LinmasProfileScreen extends StatefulWidget {
  const LinmasProfileScreen({super.key});

  @override
  State<LinmasProfileScreen> createState() => _LinmasProfileScreenState();
}

class _LinmasProfileScreenState extends State<LinmasProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(GetProfileEvent());
      }
    });
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final unsentReports = await _countUnsentReports();
    if (!context.mounted) return;

    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Keluar Akun',
      message: unsentReports > 0
          ? 'Masih ada $unsentReports laporan yang belum tersinkronisasi. Laporan '
                'akan dihapus jika Anda keluar.\n\nTetap keluar?'
          : 'Apakah Anda yakin ingin keluar dari akun?',
      confirmText: 'Keluar',
      cancelText: 'Batal',
      isDestructive: true,
      icon: Icons.logout_rounded,
    );

    if (confirmed && context.mounted) {
      context.read<TrackingBloc>().add(StopTrackingEvent());
      context.read<AuthBloc>().add(const LogoutEvent(clearOfflineQueue: true));
      AppToast.showSuccess(context, message: 'Berhasil keluar dari akun');
      context.goNamed('login', queryParameters: {'role': 'linmas'});
    }
  }

  Future<int> _countUnsentReports() async {
    try {
      final user = await sl<AuthLocalDatasource>().getUser();
      if (user == null) return 0;
      var count = 0;
      if (sl.isRegistered<OfflineQueueLocalDatasource>()) {
        count += await sl<OfflineQueueLocalDatasource>().getPendingCount(
          user.id.toString(),
        );
      }
      if (sl.isRegistered<ActivationPendingReportLocalDatasource>()) {
        final reports = await sl<ActivationPendingReportLocalDatasource>()
            .getPending();
        count += reports
            .where((report) => report.belongsTo(user.id.toString()))
            .length;
      }
      return count;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        if (user == null) {
          return Scaffold(
            backgroundColor: colors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 80,
                      color: colors.textHint,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sesi Pengguna Tidak Ditemukan',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Silakan masuk terlebih dahulu untuk mengakses profil.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.goNamed(
                        'login',
                        queryParameters: {'role': 'linmas'},
                      ),
                      icon: const Icon(Icons.login),
                      label: const Text('Masuk'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final activeThemeMode =
            ThemeModeSelectorTile.maybeWatchBloc(context)?.state.themeMode ??
            ThemeMode.light;
        final initialLetter =
            (user.name != null && user.name!.trim().isNotEmpty)
            ? user.name!.trim()[0].toUpperCase()
            : 'U';
        const ktaSubtitleFg = Color(0xD9FFFFFF); // media-overlay
        const ktaBadgeBg = Color(0x2EFFFFFF); // media-overlay
        const ktaBadgeBorder = Color(0x4DFFFFFF); // media-overlay

        return Scaffold(
          backgroundColor: colors.background,
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(GetProfileEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: colors.primaryGradient,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.28),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // media-overlay
                            border: Border.all(
                              color: Colors.white, // media-overlay
                              width: 3,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12, // media-overlay
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child:
                                (user.displayProfilePic != null &&
                                    user.displayProfilePic!.trim().isNotEmpty)
                                ? AppNetworkImage(
                                    imageUrl: user.displayProfilePic!.trim(),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    borderRadius: BorderRadius.circular(40),
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: colors.primaryLight,
                                    alignment: Alignment.center,
                                    child: Text(
                                      initialLetter,
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primaryDark,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          user.name ?? 'Pengguna',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // media-overlay
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        if (user.username != null && user.username!.isNotEmpty)
                          Text(
                            user.username!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: ktaSubtitleFg,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ktaBadgeBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: ktaBadgeBorder),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: Colors.white, // media-overlay
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Anggota Terdaftar',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white, // media-overlay
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ProfilePointsCard(
                    points: user.points,
                    isOfficer: true,
                    isEmbedded: false,
                    onTap: () async {
                      await context.push(
                        AppRouter.vouchersPath,
                        extra: {'points': user.points, 'isOfficer': true},
                      );
                      if (context.mounted) {
                        context.read<ProfileBloc>().add(GetProfileEvent());
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.badge_rounded,
                            color: colors.onPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KTA Digital Linmas',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Lihat & unduh Kartu Tanda Anggota resmi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => showKtaCardDialog(context, user),
                          icon: const Icon(Icons.download_rounded, size: 16),
                          label: const Text('KTA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            elevation: 0,
                            minimumSize: const Size(0, 44),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  const ProfileSettingsSectionLabel(title: 'Pengaturan Akun'),
                  ProfileMenuGroupCard(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profil Saya',
                        onTap: () => AppRouter.toEditProfile(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  const ProfileSettingsSectionLabel(title: 'Pengaturan'),
                  ProfileMenuGroupCard(
                    children: [
                      ProfileMenuItem(
                        icon: ThemeModeSelectorTile.iconFor(activeThemeMode),
                        title: 'Tema Tampilan',
                        trailingLabel: ThemeModeSelectorTile.labelFor(
                          activeThemeMode,
                        ),
                        onTap: () =>
                            ThemeModeSelectorTile.showSelectorSheet(context),
                      ),
                      ProfileMenuItem(
                        icon: Icons.logout_rounded,
                        title: 'Keluar dari Akun',
                        textColor: colors.error,
                        iconColor: colors.error,
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      '${AppConstants.appName} • versi ${AppConstants.appVersion}',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
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

typedef ProfileScreen = LinmasProfileScreen;
