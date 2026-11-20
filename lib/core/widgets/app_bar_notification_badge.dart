import 'package:akar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Badge angka merah kecil untuk tombol notifikasi AppBar (kapasitas max `99+`).
class AppBarNotificationBadge extends StatelessWidget {
  final int count;

  const AppBarNotificationBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final label = count > 99 ? '99+' : '$count';
    return Positioned(
      top: 4,
      right: 4,
      child: IgnorePointer(
        child: Semantics(
          label: '$count notifikasi belum dibaca',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.white, width: 1.5),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
