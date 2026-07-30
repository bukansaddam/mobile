import 'dart:io';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/features/activation/presentation/pages/camera_capture_screen.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/activation/presentation/provider/activation_provider.dart';
import 'package:akar/features/activation/presentation/widgets/activation_detail_modal.dart';
import 'package:akar/features/activation/presentation/widgets/add_report_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivationDetailScreen extends StatefulWidget {
  final String activityId;
  final bool autoShowInfo;

  const ActivationDetailScreen({
    super.key,
    required this.activityId,
    this.autoShowInfo = false,
  });

  @override
  State<ActivationDetailScreen> createState() => _ActivationDetailScreenState();
}

class _ActivationDetailScreenState extends State<ActivationDetailScreen> {
  bool _infoShown = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoShowInfo) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_infoShown && mounted) {
          _infoShown = true;
          final provider = context.read<ActivationProvider>();
          final activity = provider.getActivityById(widget.activityId);
          if (activity != null) {
            ActivationDetailModal.show(context, activity);
          }
        }
      });
    }
  }

  Future<void> _startPhotoSubmission(
    BuildContext context,
    ActivationActivity activity,
  ) async {
    final photoUrl = await CameraCaptureScreen.open(context);
    if (photoUrl != null && context.mounted) {
      AddReportBottomSheet.show(
        context,
        activity: activity,
        capturedPhotoUrl: photoUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivationProvider>(
      builder: (context, provider, child) {
        final activity = provider.getActivityById(widget.activityId);

        if (activity == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Kegiatan')),
            body: const Center(child: Text('Kegiatan tidak ditemukan')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.textPrimary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grey300),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              'Detail Kegiatan',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: () =>
                        ActivationDetailModal.show(context, activity),
                    tooltip: 'Informasi Ringkasan Kegiatan',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _startPhotoSubmission(context, activity),
                  icon: const Icon(Icons.add_a_photo_rounded),
                  label: Text(
                    'Kirim Bukti Laporan Foto',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(activity),
                const SizedBox(height: 16),

                _buildDeadlineSection(activity),
                const SizedBox(height: 20),

                _buildOwnerSection(activity),
                const SizedBox(height: 20),

                _buildAddressSection(activity),
                const SizedBox(height: 24),

                _buildReportsSection(context, activity),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(ActivationActivity activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Judul Kegiatan',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.grey600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          activity.title,
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: activity.category.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    activity.category.icon,
                    size: 14,
                    color: activity.category.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    activity.category.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: activity.category.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: activity.status.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: activity.status.color.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                activity.status.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: activity.status.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeadlineSection(ActivationActivity activity) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final startDateStr = dateFormat.format(activity.startDate);
    final endDateStr = dateFormat.format(activity.endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tenggat Waktu',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.grey600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.play_circle_outline_rounded,
                  size: 15,
                  color: AppColors.grey600,
                ),
                const SizedBox(width: 4),
                Text(
                  startDateStr,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.flag_outlined,
                  size: 15,
                  color: AppColors.grey600,
                ),
                const SizedBox(width: 4),
                Text(
                  endDateStr,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: activity.progressPercentage,
            minHeight: 10,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(activity.status.color),
          ),
        ),
      ],
    );
  }

  Future<void> _openWhatsApp(
    BuildContext context,
    String rawPhone,
    String ownerName,
  ) async {
    String cleanPhone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    }

    final Uri appUri = Uri.parse('whatsapp://send?phone=$cleanPhone');
    final Uri shortWebUri = Uri.parse('https://wa.me/$cleanPhone');
    final Uri webUri = Uri.parse(
      'https://api.whatsapp.com/send?phone=$cleanPhone',
    );

    bool launched = false;

    // 1. Try WhatsApp App directly
    try {
      if (await canLaunchUrl(appUri)) {
        launched = await launchUrl(
          appUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      }
    } catch (_) {}

    // 2. Try wa.me in external browser
    if (!launched) {
      try {
        launched = await launchUrl(
          shortWebUri,
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {}
    }

    // 3. Try platform default browser fallback
    if (!launched) {
      try {
        launched = await launchUrl(webUri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka WhatsApp untuk nomor $rawPhone'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildOwnerSection(ActivationActivity activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PJ / Penanggung Jawab',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.grey600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.ownerName,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  InkWell(
                    onTap: () => _openWhatsApp(
                      context,
                      activity.ownerPhone,
                      activity.ownerName,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            activity.ownerPhone,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey600,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF25D366,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.chat_bubble_rounded,
                                  size: 10,
                                  color: Color(0xFF128C7E),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Chat WA',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: const Color(0xFF128C7E),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressSection(ActivationActivity activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wilayah Penugasan',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.grey600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                activity.address,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsSection(
    BuildContext context,
    ActivationActivity activity,
  ) {
    final timeFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bukti Laporan Foto',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${activity.completedSteps}/${activity.totalSteps} Laporan',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (activity.reports.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.photo_library_outlined,
                  size: 48,
                  color: AppColors.grey400,
                ),
                const SizedBox(height: 10),
                Text(
                  'Belum Ada Bukti Laporan',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Klik tombol di bawah untuk mengunggah foto bukti kegiatan.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: activity.reports.length,
            itemBuilder: (context, idx) {
              final report = activity.reports[idx];
              return _buildReportCard(context, report, activity, timeFormat);
            },
          ),
      ],
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    ActivationReport report,
    ActivationActivity activity,
    DateFormat timeFormat,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppColors.grey200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showPhotoPreview(context, report, activity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _buildReportImage(
                          report.photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Multi-photo count badge
                      if (report.photoUrls.length > 1)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_library_rounded,
                                  size: 10,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${report.photoUrls.length} Foto',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        left: 6,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.my_location_rounded,
                                size: 10,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${report.latitude.toStringAsFixed(3)}, ${report.longitude.toStringAsFixed(3)}',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeFormat.format(report.submittedAt),
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (report.recipientName != null) ...[
                        Text(
                          'Penerima: ${report.recipientName}',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else if (report.notes != null) ...[
                        Text(
                          report.notes!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportImage(
    String pathOrUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return Image.network(
        pathOrUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.grey200,
          child: const Icon(
            Icons.broken_image_rounded,
            color: AppColors.grey500,
          ),
        ),
      );
    } else {
      return Image.file(
        File(pathOrUrl),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.grey200,
          child: const Icon(
            Icons.broken_image_rounded,
            color: AppColors.grey500,
          ),
        ),
      );
    }
  }

  void _showPhotoPreview(
    BuildContext context,
    ActivationReport report,
    ActivationActivity activity,
  ) {
    final timeFormat = DateFormat('dd MMMM yyyy, HH:mm');
    int selectedPhotoIdx = 0;
    final PageController dialogPageController = PageController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Swipeable Photo View (PageView)
                  SizedBox(
                    height: 230,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: PageView.builder(
                            controller: dialogPageController,
                            itemCount: report.photoUrls.length,
                            onPageChanged: (idx) {
                              setDialogState(() {
                                selectedPhotoIdx = idx;
                              });
                            },
                            itemBuilder: (context, idx) {
                              final photoUrl = report.photoUrls[idx];
                              return GestureDetector(
                                onTap: () {
                                  FullscreenImageViewer.show(
                                    context,
                                    imagePathOrUrl: photoUrl,
                                    images: report.photoUrls,
                                    initialIndex: idx,
                                    title: 'Foto Laporan Bukti',
                                  );
                                },
                                child: _buildReportImage(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 230,
                                ),
                              );
                            },
                          ),
                        ),
                        // Photo Counter Badge
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${selectedPhotoIdx + 1} / ${report.photoUrls.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Fullscreen Button Overlay
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: GestureDetector(
                            onTap: () {
                              FullscreenImageViewer.show(
                                context,
                                imagePathOrUrl:
                                    report.photoUrls[selectedPhotoIdx],
                                images: report.photoUrls,
                                initialIndex: selectedPhotoIdx,
                                title: 'Foto Laporan Bukti',
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.fullscreen_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Fullscreen',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Horizontal Thumbnails bar if multiple photos
                  if (report.photoUrls.length > 1) ...[
                    Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: AppColors.grey100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: report.photoUrls.length,
                        itemBuilder: (context, idx) {
                          final isSelected = idx == selectedPhotoIdx;
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedPhotoIdx = idx;
                              });
                              dialogPageController.animateToPage(
                                idx,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: _buildReportImage(
                                  report.photoUrls[idx],
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.my_location_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'GPS: ${report.latitude.toStringAsFixed(6)}, ${report.longitude.toStringAsFixed(6)}',
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Waktu: ${timeFormat.format(report.submittedAt)} (${report.photoUrls.length} Foto)',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (report.recipientName != null) ...[
                          const Divider(height: 16),
                          Text(
                            'Nama Penerima: ${report.recipientName}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'NIK Penerima: ${report.recipientNik}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (report.notes != null) ...[
                          const Divider(height: 16),
                          Text(
                            'Catatan: ${report.notes}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
