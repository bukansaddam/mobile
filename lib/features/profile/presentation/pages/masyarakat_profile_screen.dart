import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/theme_mode_selector_tile.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/presentation/bloc/my_complaint_list_bloc/my_complaint_list_bloc.dart';
import 'package:akar/features/permissions/presentation/widgets/profile_permissions_sheet.dart';
import 'package:akar/features/profile/presentation/widgets/profile_settings_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MasyarakatProfileScreen extends StatefulWidget {
  final bool showNotificationSettings;
  final bool showChangePasswordMenu;

  const MasyarakatProfileScreen({
    super.key,
    this.showNotificationSettings = false,
    this.showChangePasswordMenu = false,
  });

  @override
  State<MasyarakatProfileScreen> createState() =>
      _MasyarakatProfileScreenState();
}

class _MasyarakatProfileScreenState extends State<MasyarakatProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(GetProfileEvent());
      }
    });
  }

  void _showNotificationSettingsSheet(BuildContext context) {
    final audioService = sl<AudioAlarmService>();
    bool soundEnabled = audioService.soundEnabled;
    double volume = audioService.volume;
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final sheetColors = sheetContext.appColors;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Material(
              color: sheetColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active_rounded,
                          color: sheetColors.error,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Notifikasi & Alarm Dering Bencana',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: sheetColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Atur peringatan darurat berdering ketika ada potensi bencana alam di sekitar Anda.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: sheetColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),

                    SwitchListTile(
                      value: soundEnabled,
                      onChanged: (val) {
                        setModalState(() {
                          soundEnabled = val;
                        });
                        audioService.setSoundEnabled(val);
                      },
                      activeTrackColor: sheetColors.errorSolid,
                      title: Text(
                        'Dering Sirine Bencana Alam',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: sheetColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Memutar sirine berdurasi kontinu saat ada bahaya gempa/banjir.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: sheetColors.textMuted,
                        ),
                      ),
                    ),

                    const Divider(height: 20),

                    Text(
                      'Volume Suara Sirine Alarm',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: sheetColors.textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.volume_down_rounded,
                          color: sheetColors.textMuted,
                        ),
                        Expanded(
                          child: Slider(
                            value: volume,
                            min: 0.1,
                            max: 1.0,
                            activeColor: sheetColors.errorSolid,
                            onChanged: soundEnabled
                                ? (val) {
                                    setModalState(() {
                                      volume = val;
                                    });
                                    audioService.setVolume(val);
                                  }
                                : null,
                          ),
                        ),
                        Icon(Icons.volume_up_rounded, color: sheetColors.error),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: soundEnabled
                            ? () {
                                audioService.playTestAlarm();
                                AppToast.showInfo(
                                  context,
                                  message: '🔔 Memutar sampel suara alarm sirine darurat (4 detik)...',
                                );
                              }
                            : null,
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          color: sheetColors.error,
                        ),
                        label: Text(
                          'Uji Dering Sirine (Sound Test)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: sheetColors.error,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: sheetColors.errorBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  MyComplaintListState _watchMyComplaintState(BuildContext context) {
    try {
      return context.watch<MyComplaintListBloc>().state;
    } catch (_) {
      return const MyComplaintListState();
    }
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<ProfileBloc>().add(GetProfileEvent());
    try {
      context.read<MyComplaintListBloc>().add(
        const FetchMyComplaintsEvent(isRefresh: true),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final authState = context.watch<AuthBloc>().state;
    final activeThemeMode =
        ThemeModeSelectorTile.maybeWatchBloc(context)?.state.themeMode ??
        ThemeMode.light;
    final complaintState = _watchMyComplaintState(context);
    final currentUser = authState is AuthAuthenticated ? authState.user : null;
    final userName = currentUser?.name ?? 'Warga Masyarakat';
    final userContact =
        currentUser?.email ?? currentUser?.phoneNumber ?? 'Warga Terdaftar';

    final statuses = complaintState.items
        .map((report) => complaintStatusFromCode(report.status))
        .toList();
    final totalLaporanCount = complaintState.total > complaintState.items.length
        ? complaintState.total
        : complaintState.items.length;
    final inProgressCount = statuses
        .where(
          (status) =>
              status == ComplaintStatus.inProgress ||
              status == ComplaintStatus.verified ||
              status == ComplaintStatus.received ||
              status == ComplaintStatus.pending,
        )
        .length;
    final completedCount = statuses
        .where((status) => status == ComplaintStatus.completed)
        .length;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      children: [
                        _buildAvatar(
                          colors,
                          userName,
                          currentUser?.displayProfilePic,
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: colors.isDark
                                ? Border.all(color: colors.border)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: colors.shadow,
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: colors.textPrimary,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          userContact,
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w500,
                                            color: colors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primaryLight,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: colors.primary.withAlpha(40),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.verified_user_rounded,
                                          color: colors.primaryDark,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Warga Terdaftar',
                                          style: TextStyle(
                                            color: colors.primaryDark,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // shortcut: kartu poin disembunyikan untuk Masyarakat, saat ini poin khusus Linmas.
                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  _buildStatCard(
                                    colors: colors,
                                    number: '$totalLaporanCount',
                                    label: 'Laporan',
                                  ),
                                  const SizedBox(width: 10),
                                  _buildStatCard(
                                    colors: colors,
                                    number: '$inProgressCount',
                                    label: 'Proses',
                                  ),
                                  const SizedBox(width: 10),
                                  _buildStatCard(
                                    colors: colors,
                                    number: '$completedCount',
                                    label: 'Selesai',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const ProfileSettingsSectionLabel(
                          title: 'Pengaturan Akun',
                        ),
                        ProfileMenuGroupCard(
                          children: [
                            ProfileMenuItem(
                              icon: Icons.person_outline_rounded,
                              title: 'Edit Profil Saya',
                              onTap: () => AppRouter.toEditProfile(context),
                            ),
                            if (widget.showNotificationSettings)
                              ProfileMenuItem(
                                icon: Icons.notifications_none_rounded,
                                title: 'Pengaturan Notifikasi & Alarm Bencana',
                                onTap: () =>
                                    _showNotificationSettingsSheet(context),
                              ),
                            if (widget.showChangePasswordMenu)
                              ProfileMenuItem(
                                icon: Icons.lock_outline_rounded,
                                title: 'Ubah Kata Sandi',
                                onTap: () => AppRouter.toEditProfile(context),
                              ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        const ProfileSettingsSectionLabel(title: 'Pengaturan'),
                        ProfileMenuGroupCard(
                          children: [
                            ProfileMenuItem(
                              icon: ThemeModeSelectorTile.iconFor(
                                activeThemeMode,
                              ),
                              title: 'Tema Tampilan',
                              trailingLabel: ThemeModeSelectorTile.labelFor(
                                activeThemeMode,
                              ),
                              onTap: () =>
                                  ThemeModeSelectorTile.showSelectorSheet(
                                    context,
                                  ),
                            ),
                            ProfileMenuItem(
                              icon: Icons.verified_user_outlined,
                              title: 'Izin Aplikasi',
                              onTap: () => ProfilePermissionsSheet.show(
                                context,
                                isOfficer: false,
                              ),
                            ),
                            ProfileMenuItem(
                              icon: Icons.logout_rounded,
                              title: 'Keluar dari Akun',
                              textColor: colors.error,
                              iconColor: colors.error,
                              onTap: () => _confirmAndLogout(context),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AppColorScheme colors, String name, String? profilePic) {
    final initials = name.trim().isNotEmpty
        ? name
              .trim()
              .split(' ')
              .where((w) => w.isNotEmpty)
              .map((w) => w[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'W';

    return Container(
      width: 105,
      height: 105,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primaryLight,
        border: Border.all(color: colors.surface, width: 4),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: (profilePic != null && profilePic.trim().isNotEmpty)
            ? AppNetworkImage(
                imageUrl: profilePic.trim(),
                width: 105,
                height: 105,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(52.5),
              )
            : Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: colors.primaryDark,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatCard({
    required AppColorScheme colors,
    required String number,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndLogout(BuildContext context) async {
    int pendingCount = 0;
    if (sl.isRegistered<OfflineQueueLocalDatasource>() &&
        sl.isRegistered<AuthLocalDatasource>()) {
      try {
        final user = await sl<AuthLocalDatasource>().getUser();
        if (user != null) {
          pendingCount = await sl<OfflineQueueLocalDatasource>()
              .getPendingCount(user.id.toString());
        }
      } catch (_) {}
    }
    if (!context.mounted) return;

    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Keluar dari Akun',
      message: pendingCount > 0
          ? 'Masih ada $pendingCount antrean laporan yang belum tersinkronisasi. Antrean ini akan dihapus jika Anda keluar.\n\nTetap keluar?'
          : 'Apakah Anda yakin ingin keluar dari akun ini?',
      confirmText: 'Keluar',
      cancelText: 'Batal',
      isDestructive: true,
      icon: Icons.logout_rounded,
    );
    if (confirmed && context.mounted) {
      context.read<AuthBloc>().add(const LogoutEvent(clearOfflineQueue: true));
    }
  }
}

typedef ProfilePage = MasyarakatProfileScreen;
