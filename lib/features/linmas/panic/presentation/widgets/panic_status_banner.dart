import 'package:material_ui/material_ui.dart';
import 'package:akar/core/theme/app_color_scheme.dart';

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
    final colors = context.appColors;
    final bgColor = isEmergencyActive
        ? colors.errorSolid.withValues(alpha: 0.95)
        : colors.primary.withValues(alpha: 0.92);
    final fgColor = isEmergencyActive ? colors.onErrorSolid : colors.onPrimary;

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
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(iconData, color: fgColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                color: fgColor,
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
