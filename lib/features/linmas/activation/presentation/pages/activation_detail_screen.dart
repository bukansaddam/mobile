import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/core/widgets/fullscreen_video_viewer.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/features/linmas/activation/data/models/pending_activation_report_model.dart';
import 'package:akar/features/linmas/activation/presentation/pages/camera_capture_screen.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/widgets/activation_detail_modal.dart';
import 'package:akar/features/linmas/activation/presentation/widgets/add_report_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akar/core/utils/data_masking_utils.dart';
import 'package:intl/intl.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ActivationBloc>().add(
        LoadActivationSubmissionsEvent(participantId: widget.activityId),
      );

      if (widget.autoShowInfo && !_infoShown) {
        _infoShown = true;
        final activity = context.read<ActivationBloc>().state.getActivityById(
          widget.activityId,
        );
        if (activity != null) {
          ActivationDetailModal.show(context, activity);
        }
      }
    });
  }

  Future<void> _startSubmission(
    BuildContext context,
    ActivationActivity activity,
  ) async {
    final isVideo = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Jenis Bukti',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Maksimal 5 lampiran: 1 video dan sisanya foto',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(
                Icons.add_a_photo_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Ambil Foto'),
              onTap: () => Navigator.pop(sheetContext, false),
            ),
            ListTile(
              leading: const Icon(
                Icons.videocam_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Ambil Video (Maksimal 1 Menit)'),
              onTap: () => Navigator.pop(sheetContext, true),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (isVideo == null || !context.mounted) return;

    final path = isVideo
        ? await CameraCaptureScreen.openVideo(context)
        : await CameraCaptureScreen.open(context);
    if (path != null && context.mounted) {
      AddReportBottomSheet.show(
        context,
        activity: activity,
        initialAttachmentPath: path,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivationBloc, ActivationState>(
      builder: (context, state) {
        final activity = state.getActivityById(widget.activityId);

        if (activity == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Kegiatan')),
            body: const Center(child: Text('Kegiatan tidak ditemukan')),
          );
        }

        final isOngoing = activity.status == ActivationStatus.sedangBerjalan;

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
          bottomNavigationBar: isOngoing
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
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
                      child: ElevatedButton(
                        onPressed: () => _startSubmission(context, activity),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Buat Laporan',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
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
            value: activity.deadlineProgressPercentage,
            minHeight: 10,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(
              activity.deadlineProgressPercentage >= 0.9
                  ? AppColors.warning
                  : activity.status.color,
            ),
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
    final pendingReports = context
        .read<ActivationBloc>()
        .state
        .pendingReports
        .where((report) => report.participantId == activity.id)
        .toList();
    final isLoadingReports = context
        .read<ActivationBloc>()
        .state
        .isLoadingSubmissions;

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
        if (pendingReports.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 14,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  '${pendingReports.length} laporan belum terkirim',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        if (isLoadingReports &&
            activity.reports.isEmpty &&
            pendingReports.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (activity.reports.isEmpty && pendingReports.isEmpty)
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
            itemCount: pendingReports.length + activity.reports.length,
            itemBuilder: (context, idx) {
              if (idx < pendingReports.length) {
                return _buildPendingReportCard(pendingReports[idx], timeFormat);
              }
              final report = activity.reports[idx - pendingReports.length];
              return _buildReportCard(context, report, activity, timeFormat);
            },
          ),
      ],
    );
  }

  Widget _buildPendingReportCard(
    PendingActivationReportModel pendingReport,
    DateFormat timeFormat,
  ) {
    final firstAttachment = pendingReport.attachmentPaths.first;
    final isVideo = FileSecurityUtils.isVideoPath(firstAttachment);
    final isSyncing = context.read<ActivationBloc>().state.isSyncingPending;

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
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showPendingPreview(pendingReport),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: isVideo
                            ? Container(
                                color: AppColors.grey900,
                                child: const Center(
                                  child: Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: AppColors.white,
                                    size: 36,
                                  ),
                                ),
                              )
                            : Image.file(
                                File(firstAttachment),
                                fit: BoxFit.cover,
                                cacheWidth: 400,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: AppColors.grey200,
                                      child: const Icon(
                                        Icons.broken_image_rounded,
                                        color: AppColors.grey500,
                                      ),
                                    ),
                              ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Belum terkirim',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
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
                        timeFormat.format(pendingReport.createdAt),
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (pendingReport.receiverName != null &&
                          pendingReport.receiverName!.isNotEmpty)
                        Text(
                          'Penerima: ${pendingReport.receiverName}',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      else if (pendingReport.notes != null &&
                          pendingReport.notes!.isNotEmpty)
                        Text(
                          pendingReport.notes!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (pendingReport.lastError != null)
                        Text(
                          pendingReport.lastError!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.error,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                onPressed: isSyncing
                                    ? null
                                    : () => context.read<ActivationBloc>().add(
                                        SyncPendingReportsEvent(
                                          reportId: pendingReport.id,
                                        ),
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Kirim ulang',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 34,
                            height: 30,
                            child: OutlinedButton(
                              onPressed: isSyncing
                                  ? null
                                  : () => _confirmDeletePending(pendingReport),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                side: const BorderSide(color: AppColors.error),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                size: 16,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Future<void> _confirmDeletePending(
    PendingActivationReportModel report,
  ) async {
    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Hapus laporan?',
      message:
          'Laporan "${report.activityTitle}" akan dihapus dari perangkat '
          'dan tidak akan pernah terkirim.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
      icon: Icons.delete_outline_rounded,
    );

    if (confirmed && mounted) {
      context.read<ActivationBloc>().add(DeletePendingReportEvent(report.id));
    }
  }

  void _showPendingPreview(PendingActivationReportModel report) {
    final imagePaths = report.attachmentPaths
        .where((path) => !FileSecurityUtils.isVideoPath(path))
        .toList();

    if (report.attachmentPaths.length == 1 && imagePaths.isEmpty) {
      FullscreenVideoViewer.show(
        context,
        pathOrUrl: report.attachmentPaths.first,
        title: 'Video Bukti (Belum terkirim)',
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Laporan Belum Terkirim',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('dd MMMM yyyy, HH:mm').format(report.createdAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: PageView.builder(
                  itemCount: report.attachmentPaths.length,
                  itemBuilder: (context, index) {
                    final path = report.attachmentPaths[index];
                    if (FileSecurityUtils.isVideoPath(path)) {
                      return GestureDetector(
                        onTap: () => FullscreenVideoViewer.show(
                          context,
                          pathOrUrl: path,
                          title: 'Video Bukti (Belum terkirim)',
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.grey900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: AppColors.white,
                                  size: 48,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Putar video',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        final imageIndex = imagePaths.indexOf(path);
                        FullscreenImageViewer.show(
                          context,
                          imagePathOrUrl: path,
                          images: imagePaths,
                          initialIndex: imageIndex < 0 ? 0 : imageIndex,
                          title: 'Foto Laporan Bukti',
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(path),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: AppColors.grey200,
                                child: const Icon(
                                  Icons.broken_image_rounded,
                                  color: AppColors.grey500,
                                ),
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${report.attachmentPaths.length} lampiran',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
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
            onTap: () {
              if (report.photoUrls.isEmpty && report.videoUrls.isNotEmpty) {
                FullscreenVideoViewer.show(
                  context,
                  pathOrUrl: report.videoUrls.first,
                  title: 'Video Laporan Bukti',
                  httpHeaders: _apiAuthHeaders(report.videoUrls.first),
                );
                return;
              }
              _showPhotoPreview(context, report, activity);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: report.photoUrls.isNotEmpty
                            ? _buildReportImage(
                                report.photoUrl,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: AppColors.grey900,
                                child: const Center(
                                  child: Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: AppColors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                      ),
                      if (report.photoUrls.length + report.videoUrls.length > 1)
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
                                  report.videoUrls.isEmpty
                                      ? '${report.photoUrls.length} Foto'
                                      : '${report.photoUrls.length + report.videoUrls.length} Media',
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
                      if (report.latitude != 0 || report.longitude != 0)
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
                      if (report.videoUrls.isNotEmpty &&
                          report.photoUrls.isNotEmpty)
                        Positioned(
                          right: 6,
                          bottom: 6,
                          child: GestureDetector(
                            onTap: () => FullscreenVideoViewer.show(
                              context,
                              pathOrUrl: report.videoUrls.first,
                              title: 'Video Laporan Bukti',
                              httpHeaders: _apiAuthHeaders(
                                report.videoUrls.first,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    size: 10,
                                    color: AppColors.white,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'Video',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 9,
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
      return AppNetworkImage(
        imageUrl: pathOrUrl,
        width: width,
        height: height,
        fit: fit,
        httpHeaders: _apiAuthHeaders(pathOrUrl),
        errorIcon: Icons.broken_image_rounded,
        backgroundColor: AppColors.grey200,
      );
    } else {
      return Image.file(
        File(pathOrUrl),
        width: width,
        height: height,
        cacheWidth: width != null && width > 0 && width.isFinite
            ? (width * 3).toInt()
            : null,
        cacheHeight: height != null && height > 0 && height.isFinite
            ? (height * 3).toInt()
            : null,
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

  Map<String, String>? _apiAuthHeaders(String url) {
    final uri = Uri.tryParse(url);
    final base = Uri.tryParse(ApiConstants.baseUrl);
    if (uri == null || base == null || uri.host != base.host) return null;
    final auth = DioClient.instance.options.headers['Authorization'];
    return auth is String && auth.isNotEmpty ? {'Authorization': auth} : null;
  }

  void _showPhotoPreview(
    BuildContext context,
    ActivationReport report,
    ActivationActivity activity,
  ) {
    final timeFormat = DateFormat('dd MMMM yyyy, HH:mm');
    final photoUrls = report.photoUrls;
    final mediaUrls = [...photoUrls, ...report.videoUrls];
    int selectedMediaIdx = 0;
    final PageController dialogPageController = PageController();

    bool isVideoIndex(int index) => index >= photoUrls.length;

    void openMedia(BuildContext context, int index) {
      final url = mediaUrls[index];
      if (isVideoIndex(index)) {
        FullscreenVideoViewer.show(
          context,
          pathOrUrl: url,
          title: 'Video Laporan Bukti',
          httpHeaders: _apiAuthHeaders(url),
        );
      } else {
        FullscreenImageViewer.show(
          context,
          imagePathOrUrl: url,
          images: photoUrls,
          initialIndex: index,
          title: 'Foto Laporan Bukti',
          httpHeaders: _apiAuthHeaders(url),
        );
      }
    }

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
                            itemCount: mediaUrls.length,
                            onPageChanged: (idx) {
                              setDialogState(() {
                                selectedMediaIdx = idx;
                              });
                            },
                            itemBuilder: (context, idx) {
                              final url = mediaUrls[idx];
                              return GestureDetector(
                                onTap: () => openMedia(context, idx),
                                child: isVideoIndex(idx)
                                    ? Container(
                                        color: AppColors.grey900,
                                        child: const Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.play_circle_fill_rounded,
                                                color: AppColors.white,
                                                size: 48,
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                'Putar video',
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : _buildReportImage(
                                        url,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 230,
                                      ),
                              );
                            },
                          ),
                        ),
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
                              '${selectedMediaIdx + 1} / ${mediaUrls.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: GestureDetector(
                            onTap: () => openMedia(context, selectedMediaIdx),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isVideoIndex(selectedMediaIdx)
                                        ? Icons.play_arrow_rounded
                                        : Icons.fullscreen_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isVideoIndex(selectedMediaIdx)
                                        ? 'Putar'
                                        : 'Fullscreen',
                                    style: const TextStyle(
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

                  if (mediaUrls.length > 1) ...[
                    Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: AppColors.grey100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mediaUrls.length,
                        itemBuilder: (context, idx) {
                          final isSelected = idx == selectedMediaIdx;
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedMediaIdx = idx;
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
                                child: isVideoIndex(idx)
                                    ? Container(
                                        width: 48,
                                        height: 48,
                                        color: AppColors.grey900,
                                        child: const Icon(
                                          Icons.play_circle_fill_rounded,
                                          color: AppColors.white,
                                          size: 20,
                                        ),
                                      )
                                    : _buildReportImage(
                                        mediaUrls[idx],
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
                        Text(
                          timeFormat.format(report.submittedAt),
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
                          if (report.recipientKk != null &&
                              report.recipientKk!.isNotEmpty)
                            Text(
                              'KK Penerima: ${DataMaskingUtils.maskNikOrKk(report.recipientKk)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          if (report.recipientNik != null &&
                              report.recipientNik!.isNotEmpty)
                            Text(
                              'NIK Penerima: ${DataMaskingUtils.maskNikOrKk(report.recipientNik)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          if ((report.rt != null && report.rt!.isNotEmpty) ||
                              (report.rw != null && report.rw!.isNotEmpty) ||
                              (report.houseNumber != null &&
                                  report.houseNumber!.isNotEmpty))
                            Text(
                              'Alamat: RT ${report.rt ?? '-'} / RW ${report.rw ?? '-'} No. ${report.houseNumber ?? '-'}',
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
