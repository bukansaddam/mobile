import 'dart:io';

import 'package:akar/core/theme/app_colors.dart';
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
              border: Border.all(color: AppColors.grey300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: isVideo
                  ? Container(
                      color: AppColors.secondary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_fill_rounded,
                            color: AppColors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Video',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.white,
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
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.broken_image_rounded,
                        color: AppColors.textSecondary,
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
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.white,
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
