import 'dart:io';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/core/widgets/fullscreen_video_viewer.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:flutter/material.dart';

/// Galeri horizontal lampiran foto & video pada detail laporan Jaga Tanah.
class JagaTanahDetailMediaStrip extends StatelessWidget {
  final List<ComplaintAttachmentEntity> attachments;

  const JagaTanahDetailMediaStrip({super.key, required this.attachments});

  Map<String, String>? _apiAuthHeaders(String url) {
    final uri = Uri.tryParse(url);
    final base = Uri.tryParse(ApiConstants.baseUrl);
    if (uri == null || base == null || uri.host != base.host) return null;
    final auth = DioClient.instance.options.headers['Authorization'];
    return auth is String && auth.isNotEmpty ? {'Authorization': auth} : null;
  }

  bool _isVideo(ComplaintAttachmentEntity item) =>
      item.isVideo || FileSecurityUtils.isVideoPath(item.url);

  bool _isNetworkUrl(String url) =>
      url.startsWith('http://') || url.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final photoUrls = attachments
        .where((item) => !_isVideo(item))
        .map((item) => item.url)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Lampiran Foto / Video',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${attachments.length} media',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: attachments.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final attachment = attachments[index];
              final isVideo = _isVideo(attachment);
              final url = attachment.url;
              final headers = _apiAuthHeaders(url);

              return GestureDetector(
                onTap: () {
                  if (isVideo) {
                    FullscreenVideoViewer.show(
                      context,
                      pathOrUrl: url,
                      title: 'Video Laporan Jaga Tanah',
                      httpHeaders: headers,
                    );
                    return;
                  }
                  FullscreenImageViewer.show(
                    context,
                    imagePathOrUrl: url,
                    images: photoUrls,
                    initialIndex: photoUrls.indexOf(url),
                    title: 'Foto Laporan Jaga Tanah',
                    httpHeaders: headers,
                  );
                },
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (isVideo)
                          Container(
                            color: AppColors.secondary,
                            padding: const EdgeInsets.all(6),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: AppColors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Video',
                                    maxLines: 1,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (_isNetworkUrl(url))
                          AppNetworkImage(
                            imageUrl: url,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            httpHeaders: headers,
                            errorIcon: Icons.broken_image_rounded,
                          )
                        else if (File(url).existsSync())
                          Image.file(
                            File(url),
                            fit: BoxFit.cover,
                            cacheWidth: 264,
                            cacheHeight: 264,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.broken_image_rounded,
                              color: AppColors.textSecondary,
                            ),
                          )
                        else
                          const ColoredBox(
                            color: AppColors.grey100,
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        Positioned(
                          right: 6,
                          bottom: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fullscreen_rounded,
                              color: AppColors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
