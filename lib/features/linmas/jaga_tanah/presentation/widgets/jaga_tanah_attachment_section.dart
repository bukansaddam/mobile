import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/core/widgets/fullscreen_video_viewer.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_attachment_tile.dart';
import 'package:flutter/material.dart';

class JagaTanahAttachmentSection extends StatelessWidget {
  final List<String> attachments;
  final int maxAttachments;
  final bool hasVideo;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;
  final ValueChanged<int> onRemove;

  const JagaTanahAttachmentSection({
    super.key,
    required this.attachments,
    required this.maxAttachments,
    required this.hasVideo,
    required this.onAddPhoto,
    required this.onAddVideo,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final canAddMore = attachments.length < maxAttachments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'Lampiran Foto / Video',
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${attachments.length}/$maxAttachments lampiran',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: !canAddMore
                      ? AppColors.earth
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Maksimal 1 video, sisanya foto. Diambil langsung dari kamera.',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Row(
            children: [
              if (canAddMore) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Material(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: onAddPhoto,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 86,
                          minHeight: 86,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.grey300,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.textSecondary,
                              size: 26,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Foto',
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (!hasVideo)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Material(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: onAddVideo,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 86,
                            minHeight: 86,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.grey300,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.videocam_rounded,
                                color: AppColors.textSecondary,
                                size: 26,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Video',
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              ...List.generate(attachments.length, (index) {
                final path = attachments[index];
                final isVideo = FileSecurityUtils.isVideoPath(path);
                return JagaTanahAttachmentTile(
                  path: path,
                  onRemove: () => onRemove(index),
                  onTap: () {
                    if (isVideo) {
                      FullscreenVideoViewer.show(
                        context,
                        pathOrUrl: path,
                        title: 'Video Laporan Jaga Tanahku',
                      );
                      return;
                    }
                    final photos = attachments
                        .where((item) => !FileSecurityUtils.isVideoPath(item))
                        .toList();
                    FullscreenImageViewer.show(
                      context,
                      imagePathOrUrl: path,
                      images: photos,
                      initialIndex: photos.indexOf(path),
                      title: 'Foto Laporan Jaga Tanahku',
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
