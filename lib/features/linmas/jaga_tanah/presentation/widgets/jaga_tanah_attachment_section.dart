import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/core/widgets/fullscreen_video_viewer.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_attachment_tile.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_field_label.dart';
import 'package:flutter/material.dart';

class JagaTanahAttachmentSection extends StatelessWidget {
  final List<String> attachments;
  final int maxAttachments;
  final bool hasVideo;
  final bool isRequired;
  final String? errorText;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;
  final ValueChanged<int> onRemove;

  const JagaTanahAttachmentSection({
    super.key,
    required this.attachments,
    required this.maxAttachments,
    required this.hasVideo,
    this.isRequired = false,
    this.errorText,
    required this.onAddPhoto,
    required this.onAddVideo,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
              JagaTanahFieldLabel(
                label: 'Lampiran Foto / Video',
                isRequired: isRequired,
              ),
              Text(
                '${attachments.length}/$maxAttachments lampiran',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: !canAddMore ? colors.earth : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Maksimal 1 video, sisanya foto. Diambil langsung dari kamera.',
          style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
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
                    color: colors.surfaceElevated,
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
                            color: errorText != null
                                ? colors.error
                                : colors.borderStrong,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: colors.textSecondary,
                              size: 26,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Foto',
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors.textSecondary,
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
                      color: colors.surfaceElevated,
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
                              color: errorText != null
                                  ? colors.error
                                  : colors.borderStrong,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videocam_rounded,
                                color: colors.textSecondary,
                                size: 26,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Video',
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.textSecondary,
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
                        title: 'Video Laporan Jaga Tanah',
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
                      title: 'Foto Laporan Jaga Tanah',
                    );
                  },
                );
              }),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: AppTextStyles.bodySmall.copyWith(color: colors.error),
          ),
        ],
      ],
    );
  }
}
