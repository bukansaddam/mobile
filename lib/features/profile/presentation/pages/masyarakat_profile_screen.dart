import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:go_router/go_router.dart';
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
import 'package:akar/features/profile/presentation/widgets/profile_points_card.dart';
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

                              const SizedBox(height: 18),

                              ProfilePointsCard(
                                points: currentUser?.points ?? 0,
                                isOfficer: false,
                                isEmbedded: true,
                                onTap: () async {
                                  await context.push(
                                    AppRouter.vouchersPath,
                                    extra: {
                                      'points': currentUser?.points ?? 0,
                                      'isOfficer': false,
                                    },
                                  );
                                  if (context.mounted) {
                                    context.read<ProfileBloc>().add(
                                      GetProfileEvent(),
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 14),

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

                              const SizedBox(height: 16),

                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: colors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: colors.border,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildProfileDetailItem(
                                      colors: colors,
                                      icon: Icons.badge_outlined,
                                      label: 'NIK',
                                      value: currentUser?.nik,
                                    ),
                                    Divider(height: 16, color: colors.border),
                                    _buildProfileDetailItem(
                                      colors: colors,
                                      icon: Icons.phone_outlined,
                                      label: 'No. Telepon',
                                      value: currentUser?.phoneNumber,
                                    ),
                                    Divider(height: 16, color: colors.border),
                                    _buildProfileDetailItem(
                                      colors: colors,
                                      icon: Icons.email_outlined,
                                      label: 'Email',
                                      value: currentUser?.email,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        const ThemeModeSelectorTile(),

                        const SizedBox(height: 16),

                        Container(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: colors.isDark
                                ? Border.all(color: colors.border)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: colors.shadow,
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildMenuItem(
                                colors: colors,
                                icon: Icons.person_outline_rounded,
                                title: 'Edit Profil Saya',
                                onTap: () => AppRouter.toEditProfile(context),
                              ),
                              if (widget.showNotificationSettings) ...[
                                Divider(height: 1, color: colors.divider),
                                _buildMenuItem(
                                  colors: colors,
                                  icon: Icons.notifications_none_rounded,
                                  title:
                                      'Pengaturan Notifikasi & Alarm Bencana',
                                  onTap: () =>
                                      _showNotificationSettingsSheet(context),
                                ),
                              ],
                              if (widget.showChangePasswordMenu) ...[
                                Divider(height: 1, color: colors.divider),
                                _buildMenuItem(
                                  colors: colors,
                                  icon: Icons.lock_outline_rounded,
                                  title: 'Ubah Kata Sandi',
                                  onTap: () => AppRouter.toEditProfile(context),
                                ),
                              ],
                              Divider(height: 1, color: colors.divider),
                              _buildMenuItem(
                                colors: colors,
                                icon: Icons.logout_rounded,
                                title: 'Keluar dari Akun',
                                textColor: colors.error,
                                iconColor: colors.error,
                                showChevron: false,
                                onTap: () async {
                                  final confirmed =
                                      await AppDialogs.showConfirmation(
                                        context,
                                        title: 'Keluar dari Akun',
                                        message: 'Apakah Anda yakin ingin keluar dari akun ini?',
                                        confirmText: 'Keluar',
                                        cancelText: 'Batal',
                                        isDestructive: true,
                                        icon: Icons.logout_rounded,
                                      );
                                  if (confirmed && context.mounted) {
                                    context.read<AuthBloc>().add(
                                      const LogoutEvent(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
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

  Widget _buildProfileDetailItem({
    required AppColorScheme colors,
    required IconData icon,
    required String label,
    required String? value,
  }) {
    final isFilled = value != null && value.trim().isNotEmpty;

    return Row(
      children: [
        Icon(icon, size: 18, color: colors.textSecondary),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
        const Spacer(),
        if (isFilled)
          Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: colors.success,
            semanticLabel: '$label tersedia',
          )
        else
          Text(
            '-',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
      ],
    );
  }

  Widget _buildMenuItem({
    required AppColorScheme colors,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    Color? textColor,
    Color? iconColor,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? colors.textMuted).withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: iconColor ?? colors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: textColor ?? colors.textPrimary,
                      ),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: colors.textHint,
              ),
          ],
        ),
      ),
    );
  }
}

typedef ProfilePage = MasyarakatProfileScreen;
