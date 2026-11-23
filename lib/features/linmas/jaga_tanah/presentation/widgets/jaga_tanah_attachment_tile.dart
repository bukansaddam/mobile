import 'dart:io';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:flutter/material.dart';

class JagaTanahAttachmentTile extends StatelessWidget {
  final String path;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const JagaTanahAttachmentTile({
    super.key,
    required this.path,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const videoOverlayBg = Color(0xFF1E293B); // media-overlay
    const videoOverlayFg = Color(0xFFFFFFFF); // media-overlay
    final isVideo = FileSecurityUtils.isVideoPath(path);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 86,
            height: 86,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.borderStrong),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: isVideo
                  ? Container(
                      color: videoOverlayBg,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_fill_rounded,
                            color: videoOverlayFg,
                            size: 28,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Video',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: videoOverlayFg,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      cacheWidth: 300,
                      cacheHeight: 300,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.broken_image_rounded,
                        color: colors.textSecondary,
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: 2,
          child: Semantics(
            button: true,
            label: 'Hapus lampiran',
            child: InkResponse(
              onTap: onRemove,
              radius: 20,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: colors.errorSolid,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close_rounded,
                  color: colors.onErrorSolid,
                  size: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
