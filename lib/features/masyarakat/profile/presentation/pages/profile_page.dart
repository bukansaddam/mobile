import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/masyarakat/complaint/data/dummy_complaints.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int userPoints = 250;

  void _showMiniSurveyBottomSheet(BuildContext context) {
    int rating1 = 5;
    int rating2 = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.poll_rounded,
                          color: Color(0xFF16A34A),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Mini Survey Warga',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Bantu kami tingkatkan kualitas pelayanan (+50 Poin)',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    '1. Kemudahan Penggunaan Aplikasi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final star = index + 1;
                      return IconButton(
                        onPressed: () {
                          setModalState(() {
                            rating1 = star;
                          });
                        },
                        icon: Icon(
                          star <= rating1
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: star <= rating1
                              ? Colors.amber
                              : const Color(0xFFCBD5E1),
                          size: 28,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    '2. Kecepatan Respon Laporan Pengaduan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final star = index + 1;
                      return IconButton(
                        onPressed: () {
                          setModalState(() {
                            rating2 = star;
                          });
                        },
                        icon: Icon(
                          star <= rating2
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: star <= rating2
                              ? Colors.amber
                              : const Color(0xFFCBD5E1),
                          size: 28,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          userPoints += 50;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Terima kasih! +50 Poin berhasil ditambahkan.',
                            ),
                            backgroundColor: const Color(0xFF16A34A),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kirim',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationSettingsSheet(BuildContext context) {
    final audioService = sl<AudioAlarmService>();
    bool soundEnabled = audioService.soundEnabled;
    double volume = audioService.volume;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.notifications_active_rounded,
                        color: Color(0xFFDC2626),
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Notifikasi & Alarm Dering Bencana',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Atur peringatan darurat berdering ketika ada potensi bencana alam di sekitar Anda.',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 20),

                  // Switch Enable Alarm Dering
                  SwitchListTile(
                    value: soundEnabled,
                    onChanged: (val) {
                      setModalState(() {
                        soundEnabled = val;
                      });
                      audioService.setSoundEnabled(val);
                    },
                    activeTrackColor: const Color(0xFFDC2626),
                    title: const Text(
                      'Dering Sirine Bencana Alam',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    subtitle: const Text(
                      'Memutar sirine berdurasi kontinu saat ada bahaya gempa/banjir.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),

                  const Divider(height: 20),

                  // Volume Slider
                  const Text(
                    'Volume Suara Sirine Alarm',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.volume_down_rounded,
                        color: Color(0xFF64748B),
                      ),
                      Expanded(
                        child: Slider(
                          value: volume,
                          min: 0.1,
                          max: 1.0,
                          activeColor: const Color(0xFFDC2626),
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
                      const Icon(
                        Icons.volume_up_rounded,
                        color: Color(0xFFDC2626),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Test Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: soundEnabled
                          ? () {
                              audioService.playTestAlarm();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    '🔔 Memutar sampel suara alarm sirine darurat (4 detik)...',
                                  ),
                                  backgroundColor: const Color(0xFFDC2626),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFFDC2626),
                      ),
                      label: const Text(
                        'Uji Dering Sirine (Sound Test)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
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
    final totalLaporanCount = dummyMyComplaints.length;
    final inProgressCount = dummyMyComplaints
        .where(
          (c) =>
              c.status == ComplaintStatus.inProgress ||
              c.status == ComplaintStatus.received ||
              c.status == ComplaintStatus.pending,
        )
        .length;
    final completedCount = dummyMyComplaints
        .where((c) => c.status == ComplaintStatus.completed)
        .length;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                      Container(
                        width: 105,
                        height: 105,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1F0F172A),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/indonesian_user_portrait.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFE2E8F0),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: Color(0xFF64748B),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D0F172A),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(
                                  builder: (context) {
                                    final authState = context
                                        .watch<AuthBloc>()
                                        .state;
                                    final currentUser =
                                        authState is AuthAuthenticated
                                        ? authState.user
                                        : null;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentUser?.name ??
                                              'Warga Masyarakat',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0F172A),
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          currentUser?.email ??
                                              currentUser?.phoneNumber ??
                                              'Warga Terdaftar',
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryDark,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primaryDark.withAlpha(
                                        90,
                                      ),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.stars_rounded,
                                        color: Color(0xFF22C55E),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$userPoints Poin',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                _buildStatCard(
                                  number: '$totalLaporanCount',
                                  label: 'Laporan',
                                ),
                                const SizedBox(width: 10),
                                _buildStatCard(
                                  number: '$inProgressCount',
                                  label: 'Proses',
                                ),
                                const SizedBox(width: 10),
                                _buildStatCard(
                                  number: '$completedCount',
                                  label: 'Selesai',
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            GestureDetector(
                              onTap: () => _showMiniSurveyBottomSheet(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x1A16A34A),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(35),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.poll_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Isi Mini Survey Warga',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'Dapatkan +50 Poin bonus warga.',
                                            style: TextStyle(
                                              color: Color(0xFFDCFCE7),
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Isi Survey',
                                        style: TextStyle(
                                          color: Color(0xFF15803D),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x080F172A),
                              blurRadius: 14,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.person_outline_rounded,
                              title: 'Edit Profil Saya',
                              onTap: () {},
                            ),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            _buildMenuItem(
                              icon: Icons.stars_rounded,
                              title: 'Tukar Poin',
                              onTap: () {},
                            ),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            _buildMenuItem(
                              icon: Icons.notifications_none_rounded,
                              title: 'Pengaturan Notifikasi & Alarm Bencana',
                              onTap: () =>
                                  _showNotificationSettingsSheet(context),
                            ),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            _buildMenuItem(
                              icon: Icons.lock_outline_rounded,
                              title: 'Ubah Kata Sandi',
                              onTap: () {},
                            ),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            _buildMenuItem(
                              icon: Icons.help_outline_rounded,
                              title: 'Pusat Bantuan & FAQ',
                              onTap: () {},
                            ),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            _buildMenuItem(
                              icon: Icons.logout_rounded,
                              title: 'Keluar dari Akun',
                              textColor: const Color(0xFFDC2626),
                              iconColor: const Color(0xFFDC2626),
                              showChevron: false,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Keluar dari Akun'),
                                    content: const Text(
                                      'Apakah Anda yakin ingin keluar dari akun ini?',
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          context.read<AuthBloc>().add(
                                            LogoutEvent(),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFDC2626,
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Keluar'),
                                      ),
                                    ],
                                  ),
                                );
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
    );
  }

  Widget _buildStatCard({required String number, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
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
                color: (iconColor ?? const Color(0xFF64748B)).withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: iconColor ?? const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? const Color(0xFF1E293B),
                ),
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFF94A3B8),
              ),
          ],
        ),
      ),
    );
  }
}
