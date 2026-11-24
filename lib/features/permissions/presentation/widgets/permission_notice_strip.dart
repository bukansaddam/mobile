import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

enum _PermissionNoticeVariant { info, warning }

/// Lightweight flat notice strip for disclosure notes and permission warnings.
class PermissionNoticeStrip extends StatelessWidget {
  final String message;
  final IconData icon;
  final _PermissionNoticeVariant _variant;

  const PermissionNoticeStrip.info({super.key, required this.message})
    : icon = Icons.info_outline_rounded,
      _variant = _PermissionNoticeVariant.info;

  const PermissionNoticeStrip.warning({
    super.key,
    required this.message,
    required this.icon,
  }) : _variant = _PermissionNoticeVariant.warning;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isInfo = _variant == _PermissionNoticeVariant.info;

    final backgroundColor = isInfo ? colors.infoLight : colors.warningLight;
    final borderColor = isInfo
        ? colors.info.withValues(alpha: 0.35)
        : colors.warningBorder;
    final iconColor = isInfo ? colors.info : colors.warning;
    final textColor = isInfo ? colors.textPrimary : colors.warningDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: textColor,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
