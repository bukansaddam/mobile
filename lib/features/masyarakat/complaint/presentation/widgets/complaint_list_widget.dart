import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:flutter/material.dart';

class ComplaintListWidget extends StatelessWidget {
  final List<ComplaintItem> items;
  final Function(ComplaintItem item)? onItemTap;
  final VoidCallback? onCreateTap;
  final VoidCallback? onRefreshTap;
  final bool isError;
  final String? errorMessage;

  const ComplaintListWidget({
    super.key,
    required this.items,
    this.onItemTap,
    this.onCreateTap,
    this.onRefreshTap,
    this.isError = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _ComplaintEmptyState(
        isError: isError,
        errorMessage: errorMessage,
        onCreateTap: onCreateTap,
        onRefreshTap: onRefreshTap,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        return _ComplaintCard(item: item, onTap: () => onItemTap?.call(item));
      },
    );
  }
}

class _ComplaintEmptyState extends StatelessWidget {
  final bool isError;
  final String? errorMessage;
  final VoidCallback? onCreateTap;
  final VoidCallback? onRefreshTap;

  const _ComplaintEmptyState({
    required this.isError,
    this.errorMessage,
    this.onCreateTap,
    this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconBgColor = isError ? AppColors.errorLight : AppColors.primaryLight;
    final iconColor = isError ? AppColors.error : AppColors.primaryDark;
    final icon = isError ? Icons.cloud_off_rounded : Icons.post_add_rounded;
    final title = isError
        ? 'Gagal Memuat Pengaduan'
        : 'Belum Ada Pengaduan Saya';
    final subtitle = isError
        ? (errorMessage ?? 'Periksa koneksi Anda lalu coba muat ulang.')
        : 'Laporkan kendala fasilitas, keamanan, atau kebersihan di sekitar Anda agar segera ditindaklanjuti.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          if (isError && onRefreshTap != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRefreshTap,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi'),
              style: _outlinedActionStyle(),
            ),
          ] else if (!isError && onCreateTap != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCreateTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                minimumSize: const Size(0, 44),
                tapTargetSize: MaterialTapTargetSize.padded,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Buat Pengaduan'),
            ),
          ],
        ],
      ),
    );
  }

  ButtonStyle _outlinedActionStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.45),
      side: BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.25)),
      minimumSize: const Size(0, 44),
      tapTargetSize: MaterialTapTargetSize.padded,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final ComplaintItem item;
  final VoidCallback? onTap;

  const _ComplaintCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: const Color(0xFF64748B), size: 22),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.timeAgo,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: item.status.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.status.label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: item.status.textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
