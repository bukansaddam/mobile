import 'package:akar/core/services/gps_calibration_helper.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/linmas/tracking/presentation/widgets/gps_calibration_sheet.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

/// Banner peringatan kondisional di Home Aslinmas yang hanya muncul saat GPS terdeteksi bermasalah.
class GpsAnomalyBanner extends StatelessWidget {
  final VoidCallback? onCalibratePressed;
  final Future<bool> Function()? openLocationSettings;

  const GpsAnomalyBanner({
    super.key,
    this.onCalibratePressed,
    this.openLocationSettings,
  });

  @override
  Widget build(BuildContext context) {
    TrackingBloc? trackingBloc;
    try {
      trackingBloc = context.read<TrackingBloc>();
    } catch (_) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<TrackingBloc, TrackingState>(
      bloc: trackingBloc,
      builder: (context, state) {
        if (!state.hasGpsAnomaly) {
          return const SizedBox.shrink();
        }

        final colors = context.appColors;
        final reason = GpsAnomalyReason.fromCode(state.lastAnomalyCode);
        final isServiceDisabled = reason == GpsAnomalyReason.serviceDisabled;
        final message =
            (state.lastMessage != null && state.lastMessage!.trim().isNotEmpty)
            ? state.lastMessage!
            : reason.userMessage;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.warningLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.warningBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.gps_off_rounded,
                  color: colors.warningDark,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isServiceDisabled
                            ? 'Layanan GPS Nonaktif'
                            : 'Sinyal GPS Perlu Kalibrasi',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.warningDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed:
                      onCalibratePressed ??
                      (isServiceDisabled
                          ? () =>
                                (openLocationSettings ??
                                Geolocator.openLocationSettings)()
                          : () => GpsCalibrationSheet.show(context)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    elevation: 0,
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(isServiceDisabled ? 'Aktifkan' : 'Kalibrasi'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
