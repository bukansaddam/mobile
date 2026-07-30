import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/home/presentation/provider/home_provider.dart';
import 'package:akar/features/tracking/presentation/provider/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(context, provider),
          backgroundColor: AppColors.background,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Pengaturan',
        style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
      backgroundColor: AppColors.primary,
    );
  }

  Widget _buildBody(BuildContext context, HomeProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileSection(context),
          const SizedBox(height: 20),
          _buildTrackingControlSection(context, provider),
          const SizedBox(height: 20),
          _buildIntervalSection(context, provider),
          const SizedBox(height: 20),
          _buildBtnClear(provider, context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: AppColors.primary),
        ),
        title: Text(
          'Profil Saya',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Lihat informasi akun & token tersimpan',
          style: AppTextStyles.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.grey600),
        onTap: () => context.pushNamed('profile'),
      ),
    );
  }

  ElevatedButton _buildBtnClear(HomeProvider provider, BuildContext context) {
    return ElevatedButton.icon(
      onPressed: provider.locations.isEmpty
          ? null
          : () => _showClearConfirmationDialog(context, provider),
      icon: const Icon(Icons.delete_forever),
      label: const Text("Bersihkan List Lokasi"),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.textDisabled,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  Widget _buildTrackingControlSection(
    BuildContext context,
    HomeProvider provider,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kontrol Pelacakan",
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: provider.isTrackingEnabled
                        ? null
                        : () {
                            provider.startTracking();
                            context.read<TrackingProvider>().startTracking();
                          },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Start"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: AppColors.successLight
                          .withValues(alpha: 0.5),
                      disabledForegroundColor: AppColors.success.withValues(
                        alpha: 0.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: !provider.isTrackingEnabled
                        ? null
                        : () {
                            provider.stopTracking();
                            context.read<TrackingProvider>().stopTracking();
                          },
                    icon: const Icon(Icons.pause),
                    label: const Text("Pause"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: AppColors.warningLight
                          .withValues(alpha: 0.5),
                      disabledForegroundColor: AppColors.warning.withValues(
                        alpha: 0.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalSection(BuildContext context, HomeProvider provider) {
    final intervals = [
      {'value': 5, 'label': '5 Detik'},
      {'value': 10, 'label': '10 Detik'},
      {'value': 30, 'label': '30 Detik'},
      {'value': 60, 'label': '1 Menit'},
      {'value': 300, 'label': '5 Menit'},
      {'value': 900, 'label': '15 Menit'},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Interval Pengambilan Lokasi & Pengiriman API",
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Seberapa sering aplikasi akan mengirimkan lokasi Anda ke API server.",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: intervals.any(
                        (i) => i['value'] == provider.intervalSeconds,
                      )
                      ? provider.intervalSeconds
                      : 900,
                  isExpanded: true,
                  items: intervals.map((item) {
                    return DropdownMenuItem<int>(
                      value: item['value'] as int,
                      child: Text(
                        item['label'] as String,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      provider.changeInterval(newValue);
                      context
                          .read<TrackingProvider>()
                          .changeInterval(newValue);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmationDialog(
    BuildContext context,
    HomeProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: AppColors.error),
              SizedBox(width: 8),
              Text("Hapus Riwayat"),
            ],
          ),
          content: const Text(
            "Apakah Anda yakin ingin menghapus semua riwayat tanda lokasi? Tindakan ini tidak dapat dibatalkan.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Batal",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                provider.clearLocations();
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Seluruh riwayat lokasi berhasil dihapus"),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }
}
