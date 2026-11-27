import 'dart:io';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/core/widgets/fullscreen_video_viewer.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_form_draft.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_polygon_utils.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_section_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_spatial_card.dart';
import 'package:material_ui/material_ui.dart';

/// Langkah review seluruh isian form Jaga Tanahku sebelum laporan dikirim.
class JagaTanahReviewStep extends StatelessWidget {
  final JagaTanahFormDraft draft;
  final ValueChanged<int> onEditStep;
  final JagaTanahMapPreviewBuilder? mapPreviewBuilder;

  const JagaTanahReviewStep({
    super.key,
    required this.draft,
    required this.onEditStep,
    this.mapPreviewBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const videoOverlayBg = Color(0xFF1E293B); // media-overlay
    const videoOverlayFg = Color(0xFFFFFFFF); // media-overlay
    final videoCount = draft.photoPaths
        .where(FileSecurityUtils.isVideoPath)
        .length;
    final photoCount = draft.photoPaths.length - videoCount;
    final String attachmentSummary;
    if (photoCount > 0 && videoCount > 0) {
      attachmentSummary = '$photoCount foto, $videoCount video terlampir';
    } else if (videoCount > 0) {
      attachmentSummary = '$videoCount video terlampir';
    } else {
      attachmentSummary = '$photoCount foto terlampir';
    }

    final sections = <({int step, String title, List<(String, String)> rows})>[
      (
        step: 0,
        title: '1. Informasi Laporan',
        rows: [
          ('Kategori Laporan', draft.categoryLabel),
          if (draft.subCategoryLabel != null &&
              draft.subCategoryLabel!.isNotEmpty)
            ('Sub-Kategori', draft.subCategoryLabel!),
          ('Judul Laporan', draft.title),
          ('Deskripsi', draft.description.isNotEmpty ? draft.description : '-'),
        ],
      ),
      (
        step: 1,
        title: '2. Lokasi & Data Spasial',
        rows: [
          ('Provinsi', draft.province.isNotEmpty ? draft.province : '-'),
          ('Kabupaten/Kota', draft.regency.isNotEmpty ? draft.regency : '-'),
          ('Kecamatan', draft.district.isNotEmpty ? draft.district : '-'),
          ('Desa/Kelurahan', draft.village.isNotEmpty ? draft.village : '-'),
          ('Alamat / Patokan Lokasi', draft.landmarkAddress),
          if (draft.polygonPoints.length >= 3)
            (
              'Titik Bidang Tanah',
              '${draft.polygonPoints.length} titik (${JagaTanahPolygonUtils.formatArea(JagaTanahPolygonUtils.calculateAreaSquareMeters(draft.polygonPoints))})',
            ),
          ('Lampiran Foto / Video', attachmentSummary),
          ('Akses Lokasi', draft.aksesLokasi),
        ],
      ),
      (
        step: 2,
        title: '3. Kondisi Penggunaan & Pemanfaatan',
        rows: [
          ('Kondisi Utama di Lapangan', draft.kondisiUtama),
          ('Penutup Lahan Dominan', draft.penutupLahan),
          ('Penggunaan Terlihat', draft.penggunaanTerlihat),
          ('Tingkat Penggunaan', draft.tingkatPenggunaan),
          ('Pemeliharaan / Fasilitas', draft.pemeliharaanFasilitas),
          ('Sumber Informasi Kondisi', draft.sumberInformasiKondisi),
        ],
      ),
      (
        step: 3,
        title: '4. Informasi Hak & Penguasaan',
        rows: [
          ('Sumber Informasi Penguasaan', draft.sumberInformasiPenguasaan),
          ('Tanda Penguasaan (Pagar / Papan)', draft.tandaPenguasaan),
          ('Informasi Konflik / Sengketa', draft.informasiKonflik),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JagaTanahSectionCard(
          title: 'Review Data Laporan',
          icon: Icons.fact_check_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var s = 0; s < sections.length; s++) ...[
                if (s > 0) ...[
                  const SizedBox(height: 8),
                  Divider(height: 1, color: colors.divider),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sections[s].title,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: colors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => onEditStep(sections[s].step),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.primaryDark,
                        minimumSize: const Size(48, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text('Ubah'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (sections[s].step == 1) ...[
                  JagaTanahSpatialCard(
                    latitude: draft.latitude,
                    longitude: draft.longitude,
                    polygonPoints: draft.polygonPoints,
                    height: 156,
                    mapPreviewBuilder: mapPreviewBuilder,
                  ),
                  const SizedBox(height: 12),
                ],
                ...sections[s].rows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.$1,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          row.$2,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (sections[s].step == 1 && draft.photoPaths.isNotEmpty) ...[
                  SizedBox(
                    height: 64,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: draft.photoPaths.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final path = draft.photoPaths[index];
                        final isVideo = FileSecurityUtils.isVideoPath(path);
                        return GestureDetector(
                          onTap: () {
                            if (isVideo) {
                              FullscreenVideoViewer.show(
                                context,
                                pathOrUrl: path,
                                title: 'Video Laporan Jaga Tanah',
                              );
                              return;
                            }
                            final imagePaths = draft.photoPaths
                                .where(
                                  (item) =>
                                      !FileSecurityUtils.isVideoPath(item),
                                )
                                .toList();
                            FullscreenImageViewer.show(
                              context,
                              imagePathOrUrl: path,
                              images: imagePaths,
                              initialIndex: imagePaths.indexOf(path),
                              title: 'Foto Lokasi Geotag',
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 64,
                              height: 64,
                              color: isVideo
                                  ? videoOverlayBg
                                  : colors.surfaceElevated,
                              child: isVideo
                                  ? Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.play_circle_fill_rounded,
                                              color: videoOverlayFg,
                                              size: 24,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Video',
                                              maxLines: 1,
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color: videoOverlayFg,
                                                    fontSize: 10,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      File(path),
                                      fit: BoxFit.cover,
                                      cacheWidth: 200,
                                      cacheHeight: 200,
                                      errorBuilder: (_, _, _) => Icon(
                                        Icons.image_outlined,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.primaryLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colors.primaryDark.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: colors.primaryDark,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pastikan seluruh data di atas sesuai dengan hasil pengamatan di lapangan sebelum mengirim.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.primaryDark,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
