import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/core/widgets/shimmer_loading.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/bloc/jaga_tanah_detail_bloc/jaga_tanah_detail_bloc.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_detail_labels.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_detail_field.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_detail_media_strip.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_detail_status_banner.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_detail_timeline_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_section_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_spatial_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_status_view.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Halaman detail lengkap laporan Jaga Tanah dari `GET /api/jaga-tanah-reports/{id}`.
class JagaTanahDetailPage extends StatelessWidget {
  final String reportId;
  final ComplaintItem? initialItem;
  final JagaTanahMapPreviewBuilder? mapPreviewBuilder;

  const JagaTanahDetailPage({
    super.key,
    required this.reportId,
    this.initialItem,
    this.mapPreviewBuilder,
  });

  JagaTanahDetailEntity? _resolveDisplayDetail(JagaTanahDetailState state) {
    final loaded = state.detail;
    final initial = initialItem;
    if (loaded != null) {
      if (initial == null) return loaded;
      final fallback = JagaTanahDetailLabels.fromComplaintItem(initial);
      return JagaTanahDetailEntity(
        id: loaded.id.isNotEmpty ? loaded.id : fallback.id,
        ticketNumber: loaded.ticketNumber.isNotEmpty
            ? loaded.ticketNumber
            : fallback.ticketNumber,
        title: loaded.title.isNotEmpty ? loaded.title : fallback.title,
        description: loaded.description.isNotEmpty
            ? loaded.description
            : fallback.description,
        status: loaded.status.isNotEmpty ? loaded.status : fallback.status,
        statusLabel: loaded.statusLabel.isNotEmpty
            ? loaded.statusLabel
            : fallback.statusLabel,
        category: loaded.category.isNotEmpty
            ? loaded.category
            : fallback.category,
        subCategory: loaded.subCategory,
        reportedAt: loaded.reportedAt ?? fallback.reportedAt,
        updatedAt: loaded.updatedAt,
        escalationLevel: loaded.escalationLevel,
        address: loaded.address.isNotEmpty ? loaded.address : fallback.address,
        province: loaded.province,
        regency: loaded.regency,
        district: loaded.district,
        village: loaded.village,
        latitude: loaded.latitude,
        longitude: loaded.longitude,
        geometryType: loaded.geometryType,
        objectShape: loaded.objectShape,
        estimatedArea: loaded.estimatedArea,
        locationAccess: loaded.locationAccess,
        fieldCondition: loaded.fieldCondition,
        dominantLandCover: loaded.dominantLandCover,
        visibleUsage: loaded.visibleUsage,
        usageLevel: loaded.usageLevel,
        maintenanceStatus: loaded.maintenanceStatus,
        conditionInfoSource: loaded.conditionInfoSource,
        tenureInfoSource: loaded.tenureInfoSource,
        possessionMarkers: loaded.possessionMarkers,
        conflictInfo: loaded.conflictInfo,
        verifierUnit: loaded.verifierUnit,
        verifierName: loaded.verifierName,
        verificationMethod: loaded.verificationMethod,
        verificationSummary: loaded.verificationSummary,
        followUpDecision: loaded.followUpDecision,
        followUpNotes: loaded.followUpNotes,
        bpnActionType: loaded.bpnActionType,
        bpnReferenceNumber: loaded.bpnReferenceNumber,
        sourceInstitution: loaded.sourceInstitution,
        landRightType: loaded.landRightType,
        landRightNumberNib: loaded.landRightNumberNib,
        bpnFeedbackStatus: loaded.bpnFeedbackStatus,
        bpnFeedbackSummary: loaded.bpnFeedbackSummary,
        rejectionReason: loaded.rejectionReason,
        completionSummary: loaded.completionSummary,
        attachments: loaded.attachments.isNotEmpty
            ? loaded.attachments
            : fallback.attachments,
        sla: loaded.sla,
        timeline: loaded.timeline,
      );
    }
    return initial != null
        ? JagaTanahDetailLabels.fromComplaintItem(initial)
        : null;
  }

  Future<void> _onRefresh(BuildContext context) async {
    if (reportId.trim().isEmpty) return;
    final bloc = context.read<JagaTanahDetailBloc>();
    final nextState = bloc.stream
        .firstWhere(
          (state) =>
              !state.isLoading && state.status != JagaTanahDetailStatus.initial,
        )
        .timeout(const Duration(seconds: 15));
    bloc.add(FetchJagaTanahDetailEvent(reportId, isRefresh: true));
    try {
      await nextState;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppPageBar(title: 'Detail Laporan Jaga Tanah'),
      body: BlocConsumer<JagaTanahDetailBloc, JagaTanahDetailState>(
        listenWhen: (previous, current) =>
            current.status == JagaTanahDetailStatus.failure &&
            (previous.status != current.status ||
                previous.isRefreshing != current.isRefreshing),
        listener: (context, state) {
          if (state.detail != null || initialItem != null) {
            AppToast.showWarning(
              context,
              message:
                  state.errorMessage ??
                  'Gagal memuat detail terbaru laporan Jaga Tanah.',
            );
          }
        },
        builder: (context, state) {
          final detail = _resolveDisplayDetail(state);

          if (detail == null && state.isLoading) {
            return const ReportCardShimmerList(
              semanticLabel: 'Memuat detail laporan Jaga Tanah...',
            );
          }

          if (detail == null && state.status == JagaTanahDetailStatus.failure) {
            return JagaTanahStatusView(
              icon: Icons.cloud_off_rounded,
              iconColor: AppColors.error,
              iconBackgroundColor: AppColors.errorLight,
              title: 'Gagal Memuat Detail Laporan',
              message:
                  state.errorMessage ??
                  'Terjadi kendala saat mengambil detail laporan Jaga Tanah.',
              actionLabel: 'Coba Lagi',
              actionIcon: Icons.refresh_rounded,
              onAction: () {
                if (reportId.trim().isEmpty) return;
                context.read<JagaTanahDetailBloc>().add(
                  FetchJagaTanahDetailEvent(reportId),
                );
              },
            );
          }

          if (detail == null) {
            return const JagaTanahStatusView(
              icon: Icons.description_outlined,
              iconColor: AppColors.primaryDark,
              iconBackgroundColor: AppColors.primaryLight,
              title: 'Data Laporan Tidak Tersedia',
              message: 'Identitas laporan Jaga Tanah tidak ditemukan.',
            );
          }

          return SafeArea(
            top: false,
            child: RefreshIndicator(
              color: AppColors.primaryDark,
              onRefresh: () => _onRefresh(context),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.isLoading) ...[
                      const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        child: LinearProgressIndicator(
                          minHeight: 3,
                          color: AppColors.primaryDark,
                          backgroundColor: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    JagaTanahDetailStatusBanner(detail: detail),
                    const SizedBox(height: 14),
                    JagaTanahSectionCard(
                      title: 'Informasi Laporan',
                      icon: Icons.article_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JagaTanahDetailField(
                            label: 'Kategori Laporan',
                            value: detail.category,
                          ),
                          if (detail.subCategory?.isNotEmpty == true)
                            JagaTanahDetailField(
                              label: 'Sub-Kategori',
                              value: detail.subCategory,
                            ),
                          JagaTanahDetailField(
                            label: 'Judul Laporan',
                            value: detail.title,
                          ),
                          JagaTanahDetailField(
                            label: 'Deskripsi',
                            value: detail.description,
                          ),
                          JagaTanahDetailField(
                            label: 'Tanggal Dilaporkan',
                            value: JagaTanahDetailLabels.formatDateTime(
                              detail.reportedAt,
                            ),
                            bottomSpacing: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    JagaTanahSectionCard(
                      title: 'Lokasi & Data Spasial',
                      icon: Icons.location_on_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (detail.hasSpatialCoordinates) ...[
                            JagaTanahSpatialCard(
                              latitude: detail.latitude,
                              longitude: detail.longitude,
                              height: 164,
                              mapPreviewBuilder: mapPreviewBuilder,
                            ),
                            const SizedBox(height: 14),
                          ],
                          if (detail.hasRegionFields) ...[
                            if (detail.province?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Provinsi',
                                value: detail.province,
                              ),
                            if (detail.regency?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Kabupaten/Kota',
                                value: detail.regency,
                              ),
                            if (detail.district?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Kecamatan',
                                value: detail.district,
                              ),
                            if (detail.village?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Desa/Kelurahan',
                                value: detail.village,
                              ),
                          ],
                          JagaTanahDetailField(
                            label: 'Alamat / Patokan Lokasi',
                            value: detail.address,
                          ),
                          if (detail.objectShape?.isNotEmpty == true)
                            JagaTanahDetailField(
                              label: 'Bentuk Objek',
                              value: detail.objectShape,
                            ),
                          if (detail.estimatedArea?.isNotEmpty == true)
                            JagaTanahDetailField(
                              label: 'Perkiraan Luas',
                              value: detail.estimatedArea,
                            ),
                          JagaTanahDetailField(
                            label: 'Akses Lokasi',
                            value: detail.locationAccess,
                            bottomSpacing: detail.attachments.isNotEmpty
                                ? 14
                                : 0,
                          ),
                          if (detail.attachments.isNotEmpty)
                            JagaTanahDetailMediaStrip(
                              attachments: detail.attachments,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    JagaTanahSectionCard(
                      title: 'Kondisi Penggunaan & Pemanfaatan',
                      icon: Icons.eco_rounded,
                      accentColor: AppColors.earth,
                      badgeColor: AppColors.warningLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JagaTanahDetailField(
                            label: 'Kondisi Utama di Lapangan',
                            value: detail.fieldCondition,
                          ),
                          JagaTanahDetailField(
                            label: 'Penutup Lahan Dominan',
                            value: detail.dominantLandCover,
                          ),
                          JagaTanahDetailField(
                            label: 'Penggunaan Terlihat',
                            value: detail.visibleUsage,
                          ),
                          JagaTanahDetailField(
                            label: 'Tingkat Penggunaan',
                            value: detail.usageLevel,
                          ),
                          JagaTanahDetailField(
                            label: 'Pemeliharaan / Fasilitas',
                            value: detail.maintenanceStatus,
                          ),
                          JagaTanahDetailField(
                            label: 'Sumber Informasi Kondisi',
                            value: detail.conditionInfoSource,
                            bottomSpacing: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    JagaTanahSectionCard(
                      title: 'Informasi Hak & Penguasaan',
                      icon: Icons.description_rounded,
                      accentColor: AppColors.secondary,
                      badgeColor: AppColors.grey100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JagaTanahDetailField(
                            label: 'Sumber Informasi Penguasaan',
                            value: detail.tenureInfoSource,
                          ),
                          JagaTanahDetailField(
                            label: 'Tanda Penguasaan (Pagar / Papan)',
                            value: detail.possessionMarkers,
                          ),
                          JagaTanahDetailField(
                            label: 'Informasi Konflik / Sengketa',
                            value: detail.conflictInfo,
                            bottomSpacing: 0,
                          ),
                        ],
                      ),
                    ),
                    if (detail.hasWorkflowDetails) ...[
                      const SizedBox(height: 14),
                      JagaTanahSectionCard(
                        title: 'Verifikasi & Tindak Lanjut',
                        icon: Icons.assignment_turned_in_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (detail.verifierUnit?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Unit Verifikator',
                                value: detail.verifierUnit,
                              ),
                            if (detail.verifierName?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Verifikator',
                                value: detail.verifierName,
                              ),
                            if (detail.verificationMethod?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Metode Verifikasi',
                                value:
                                    JagaTanahDetailLabels.translateVerificationMethod(
                                      detail.verificationMethod,
                                    ),
                              ),
                            if (detail.verificationSummary?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Ringkasan Verifikasi',
                                value: detail.verificationSummary,
                              ),
                            if (detail.followUpDecision?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Keputusan Tindak Lanjut',
                                value:
                                    JagaTanahDetailLabels.translateFollowUpDecision(
                                      detail.followUpDecision,
                                    ),
                              ),
                            if (detail.followUpNotes?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Catatan Tindak Lanjut',
                                value: detail.followUpNotes,
                              ),
                            if (detail.bpnActionType?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Langkah BPN',
                                value: JagaTanahDetailLabels.translateBpnAction(
                                  detail.bpnActionType,
                                ),
                              ),
                            if (detail.sourceInstitution?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Instansi Feedback BPN',
                                value: detail.sourceInstitution,
                              ),
                            if (detail.landRightType?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Jenis Hak Terkonfirmasi',
                                value: detail.landRightType,
                              ),
                            if (detail.landRightNumberNib?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Nomor Hak / NIB',
                                value: detail.landRightNumberNib,
                              ),
                            if (detail.bpnReferenceNumber?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Nomor Referensi BPN',
                                value: detail.bpnReferenceNumber,
                              ),
                            if (detail.bpnFeedbackStatus?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Status BPN',
                                value:
                                    JagaTanahDetailLabels.translateBpnFeedbackStatus(
                                      detail.bpnFeedbackStatus,
                                    ),
                              ),
                            if (detail.bpnFeedbackSummary?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Ringkasan Feedback BPN',
                                value: detail.bpnFeedbackSummary,
                              ),
                            if (detail.rejectionReason?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Alasan Penolakan',
                                value: detail.rejectionReason,
                              ),
                            if (detail.completionSummary?.isNotEmpty == true)
                              JagaTanahDetailField(
                                label: 'Ringkasan Penyelesaian',
                                value: detail.completionSummary,
                                bottomSpacing: 0,
                              ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    JagaTanahDetailTimelineCard(detail: detail),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
