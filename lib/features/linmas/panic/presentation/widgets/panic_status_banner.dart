import 'package:flutter/material.dart';
import 'package:akar/core/theme/app_colors.dart';

class PanicStatusBanner extends StatelessWidget {
  final bool isEmergencyActive;
  final int activeMemberCount;

  const PanicStatusBanner({
    super.key,
    required this.isEmergencyActive,
    required this.activeMemberCount,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEmergencyActive
        ? AppColors.error.withValues(alpha: 0.95)
        : AppColors.primary.withValues(alpha: 0.92);

    final iconData = isEmergencyActive
        ? Icons.emergency_rounded
        : Icons.radar_rounded;

    final statusText = isEmergencyActive
        ? 'SINYAL SOS AKTIF: Status darurat Anda sedang disiarkan ke tim terdekat!'
        : 'Mode Siaga: $activeMemberCount Petugas Terdekat Terdeteksi';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(iconData, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
