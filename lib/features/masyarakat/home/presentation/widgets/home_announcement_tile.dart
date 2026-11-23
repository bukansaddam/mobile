import 'package:flutter/material.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/features/linmas/announcement/domain/entities/announcement_entity.dart';

class HomeAnnouncementTile extends StatelessWidget {
  final AnnouncementEntity item;
  final VoidCallback onTap;

  const HomeAnnouncementTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.hasImage
                      ? AppNetworkImage(
                          imageUrl: item.allImages.first,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorIcon: Icons.campaign_outlined,
                          backgroundColor: colors.primaryLight,
                        )
                      : Container(
                          width: 52,
                          height: 52,
                          color: colors.primaryLight,
                          child: Icon(
                            Icons.campaign_outlined,
                            color: colors.primary,
                            size: 24,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textSecondary,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (item.date.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 11,
                              color: colors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.date,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.textHint,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
