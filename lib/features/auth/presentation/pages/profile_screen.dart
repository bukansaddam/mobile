import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/activation/presentation/pages/activation_screen.dart';
import 'package:akar/features/activation/presentation/provider/activation_provider.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:akar/features/home/presentation/widgets/home_profile_card.dart';
import 'package:akar/features/home/presentation/widgets/home_summary_card.dart';
import 'package:akar/features/home/presentation/widgets/notification_modal.dart';
import 'package:akar/features/tracking/presentation/provider/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentTabIndex = 0;

  int _logoTapCount = 0;
  DateTime? _lastLogoTapTime;

  @override
  void initState() {
    super.initState();
  }

  void _onLogoTap() {
    final now = DateTime.now();
    if (_lastLogoTapTime != null &&
        now.difference(_lastLogoTapTime!).inSeconds > 3) {
      _logoTapCount = 0;
    }
    _lastLogoTapTime = now;
    _logoTapCount++;

    if (_logoTapCount >= 10) {
      _logoTapCount = 0;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.stars_rounded, color: AppColors.white),
              SizedBox(width: 8),
              Text('Mode Eksklusif: Membuka Pengaturan Tracking...'),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      _showTrackingConfigModal(context);
    } else if (_logoTapCount >= 3) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mode Eksklusif: Tekan kartu profil $_logoTapCount/10 kali',
          ),
          duration: const Duration(milliseconds: 700),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Keluar Akun'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.grey300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text('Batal'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  if (context.mounted) {
                    await context.read<TrackingProvider>().stopTracking();
                  }
                  await authProvider.logout();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil keluar dari akun'),
                        backgroundColor: AppColors.info,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    context.goNamed('login');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text('Keluar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRondaMalamDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        bool isPatrolling = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B4DFF).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.nights_stay_rounded,
                      color: Color(0xFF5B4DFF),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Fitur Ronda Malam & Patroli',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jadwal Operasional: 22:00 - 04:00 WIB',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.shield_rounded, color: Color(0xFF5B4DFF), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Status Regu Patroli:',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Regu 1 (Siaga)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5B4DFF),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          children: const [
                            Icon(Icons.location_city_rounded, color: AppColors.primary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Pos Utama:',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: Text(
                                'Pos Ronda Sektor 04',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F9F66).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.verified_rounded, color: Color(0xFF0F9F66), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sistem Monitoring GPS Patroli Terhubung',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF0F9F66),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            isPatrolling = !isPatrolling;
                          });
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      isPatrolling
                                          ? 'Sesi Patroli Ronda Malam Telah Diberhentikan'
                                          : 'Sesi Patroli Ronda Malam Berhasil Dimulai!',
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color(0xFF5B4DFF),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                        label: Text(
                          isPatrolling ? 'HENTIKAN PATROLI' : 'MULAI RONDA MALAM',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B4DFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.grey300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Tutup'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTrackingConfigModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Consumer<TrackingProvider>(
          builder: (context, trackingProvider, child) {
            final intervals = [
              {'value': 5, 'label': '5 Detik'},
              {'value': 10, 'label': '10 Detik'},
              {'value': 30, 'label': '30 Detik'},
              {'value': 60, 'label': '1 Menit'},
              {'value': 300, 'label': '5 Menit'},
              {'value': 900, 'label': '15 Menit (Default)'},
            ];

            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.satellite_alt_rounded,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Konfigurasi Tracking API',
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: trackingProvider.isTrackingActive
                          ? AppColors.successLight.withValues(alpha: 0.15)
                          : AppColors.grey200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Background Tracking',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              trackingProvider.isTrackingActive
                                  ? 'Aktif (Mengirim otomatis ke API 24/7)'
                                  : 'Dinonaktifkan',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: trackingProvider.isTrackingActive
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: trackingProvider.isTrackingActive,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            if (val) {
                              trackingProvider.startTracking();
                            } else {
                              trackingProvider.stopTracking();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Interval Pengiriman API',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: trackingProvider.intervalSeconds,
                        isExpanded: true,
                        items: intervals.map((item) {
                          return DropdownMenuItem<int>(
                            value: item['value'] as int,
                            child: Text(
                              item['label'] as String,
                              style: AppTextStyles.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            trackingProvider.changeInterval(val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Terakhir API:',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              trackingProvider.lastSuccess
                                  ? Icons.check_circle_rounded
                                  : Icons.error_rounded,
                              size: 16,
                              color: trackingProvider.lastSuccess
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                trackingProvider.lastMessage ??
                                    'Belum ada pengiriman ke API',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: trackingProvider.lastSuccess
                                      ? AppColors.textPrimary
                                      : AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (trackingProvider.lastSentTime != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Waktu Terakhir: ${DateFormat('dd MMM yyyy, HH:mm:ss').format(trackingProvider.lastSentTime!)} WIB',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (trackingProvider.lastLatitude != null &&
                            trackingProvider.lastLongitude != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Koordinat Terakhir: ${trackingProvider.lastLatitude}, ${trackingProvider.lastLongitude}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: trackingProvider.isSending
                          ? null
                          : () async {
                              await trackingProvider.sendLocationNow();
                            },
                      icon: trackingProvider.isSending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        trackingProvider.isSending
                            ? 'Mengirim...'
                            : 'Kirim Lokasi Ke API Sekarang',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        return Scaffold(
          backgroundColor: AppColors.background,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.pushNamed('panic'),
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            elevation: 6,
            icon: const Icon(Icons.warning_amber_rounded, size: 24),
            label: const Text(
              'PANIC',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xFFD6E6FE),
            foregroundColor: AppColors.textPrimary,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logo.webp',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () => NotificationModalSheet.show(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.textPrimary,
                          size: 26,
                        ),
                        tooltip: 'Notifikasi Kegiatan',
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: const Text(
                              '5',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentTabIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey500,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 8,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                label: 'Analisis',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flash_on_outlined),
                label: 'Aktivasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Profil',
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFD6E6FE),
                    Color(0xFFF0F6FF),
                    AppColors.background,
                  ],
                  stops: [0.0, 0.25, 0.5],
                ),
              ),
              child: user == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 80,
                              color: AppColors.grey400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sesi Pengguna Tidak Ditemukan',
                              style: AppTextStyles.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Silakan masuk terlebih dahulu untuk mengakses aplikasi.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => context.goNamed('login'),
                                    icon: const Icon(Icons.login),
                                    label: const Text('Masuk'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        context.goNamed('register'),
                                    icon: const Icon(Icons.person_add_outlined),
                                    label: const Text('Daftar'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : IndexedStack(
                      index: _currentTabIndex,
                      children: [
                        _buildHomePage(),
                        _buildPlaceholderPage(
                          'Analisis',
                          Icons.analytics_outlined,
                        ),
                        const ActivationScreen(),
                        _buildProfilPage(user, authProvider),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePage() {
    return Consumer2<AuthProvider, ActivationProvider>(
      builder: (context, authProvider, activationProvider, child) {
        final user = authProvider.currentUser;
        final activities = activationProvider.activities;

        final totalTugasCount = activities.length;
        final totalAgendaCount = activities
            .where((act) => act.status == ActivationStatus.sedangBerjalan)
            .length;
        final totalLaporanCount = activities
            .where((act) => act.status == ActivationStatus.selesai)
            .length;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _onLogoTap,
                  child: HomeProfileCard(user: user),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Ringkasan Kegiatan',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 14),

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: HomeSummaryCard(
                        title: 'Total Daftar Tugas',
                        subtitle: 'Kegiatan aktif',
                        count: '$totalTugasCount',
                        icon: Icons.assignment_outlined,
                        gradientColors: const [
                          Color(0xFF0F9F66),
                          Color(0xFF0A754B),
                        ],
                        isCompact: true,
                        onTap: () {
                          setState(() {
                            _currentTabIndex = 2;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: HomeSummaryCard(
                        title: 'Total Agenda',
                        subtitle: 'Sedang berjalan',
                        count: '$totalAgendaCount',
                        icon: Icons.event_note_rounded,
                        gradientColors: const [
                          Color(0xFF5CB836),
                          Color(0xFF438A24),
                        ],
                        isCompact: true,
                        onTap: () {
                          setState(() {
                            _currentTabIndex = 2;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: HomeSummaryCard(
                        title: 'Total Laporan',
                        subtitle: 'Telah selesai',
                        count: '$totalLaporanCount',
                        icon: Icons.insert_drive_file_outlined,
                        gradientColors: const [
                          Color(0xFFD99B00),
                          Color(0xFFB37B00),
                        ],
                        isCompact: true,
                        onTap: () {
                          setState(() {
                            _currentTabIndex = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Menu Utama',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 14),

              _buildMenuUtamaSection(context),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuUtamaSection(BuildContext context) {
    final menuItems = [
      {
        'title': 'Presensi',
        'subtitle': 'Swafoto & Lokasi',
        'icon': Icons.co_present_rounded,
        'color': AppColors.primary,
        'onTap': () => context.pushNamed('presensi'),
      },
      {
        'title': 'Ronda Malam',
        'subtitle': 'Patroli & Siaga',
        'icon': Icons.nights_stay_rounded,
        'color': const Color(0xFF5B4DFF),
        'onTap': () => _showRondaMalamDialog(context),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
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
              child: Row(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilPage(UserEntity user, AuthProvider authProvider) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profil',
                style: AppTextStyles.displayMedium.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.grey800,
                  size: 28,
                ),
                tooltip: 'Menu Opsional',
                onSelected: (value) {
                  if (value == 'logout') {
                    _showLogoutDialog(context, authProvider);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Keluar Akun',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 3,
            shadowColor: AppColors.black.withValues(alpha: 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Diri',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontSize: 20,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.person, 'Nama Lengkap', user.name),
                  _buildInfoRow(
                    Icons.alternate_email,
                    'Username',
                    user.username,
                  ),
                  _buildInfoRow(Icons.email, 'Email', user.email),
                  _buildInfoRow(Icons.badge, 'NIK', user.nik),
                  _buildInfoRow(Icons.phone, 'No. Telepon', user.phoneNumber),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur $title dalam tahap pengembangan.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    final displayValue = (value != null && value.trim().isNotEmpty)
        ? value.trim()
        : '-';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              displayValue,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
