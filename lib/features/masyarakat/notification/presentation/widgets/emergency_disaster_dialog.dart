import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';

class EmergencyDisasterDialog extends StatefulWidget {
  final DisasterAlertEvent event;

  const EmergencyDisasterDialog({super.key, required this.event});

  static Future<void> show(BuildContext context, DisasterAlertEvent event) {
    return AppDialogs.showCustom<void>(
      context,
      barrierDismissible: false,
      canPop: false,
      useCardDecoration: false,
      builder: (context) => EmergencyDisasterDialog(event: event),
    );
  }

  @override
  State<EmergencyDisasterDialog> createState() =>
      _EmergencyDisasterDialogState();
}

class _EmergencyDisasterDialogState extends State<EmergencyDisasterDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  bool _isRinging = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _isRinging = sl<AudioAlarmService>().isPlaying;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleMuteRinging() {
    setState(() {
      if (_isRinging) {
        sl<AudioAlarmService>().stopAlarm();
        _isRinging = false;
      } else {
        sl<AudioAlarmService>().startEmergencyAlarm();
        _isRinging = true;
      }
    });
  }

  void _stopAlarmAndDismiss() {
    sl<AudioAlarmService>().stopAlarm();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colors.errorSolid, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: colors.errorSolid.withAlpha(100),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Warning Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: colors.errorSolid,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(29.5),
              ),
            ),
            child: Column(
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.onErrorSolid.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: colors.onErrorSolid,
                      size: 44,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'PERINGATAN DARURAT',
                  style: TextStyle(
                    color: colors.onErrorSolid,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.event.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onErrorSolid,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content Body so Saya Aman stays pinned below
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Dering Sirine
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _isRinging
                          ? colors.errorLight
                          : colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isRinging ? colors.errorBorder : colors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isRinging
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_off_rounded,
                          color: _isRinging ? colors.error : colors.textMuted,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isRinging
                                ? 'Sirine darurat sedang berdering!'
                                : 'Sirine darurat dimatikan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _isRinging
                                  ? colors.errorDark
                                  : colors.secondary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _toggleMuteRinging,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _isRinging ? 'Matikan Dering' : 'Bunyikan Lagi',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: _isRinging ? colors.error : colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Detail Lokasi & Deskripsi
                  _buildInfoRow(
                    colors: colors,
                    icon: Icons.location_on_rounded,
                    label: 'Lokasi Bencana',
                    value: widget.event.location,
                  ),
                  const SizedBox(height: 10),
                  if (widget.event.magnitude != null) ...[
                    _buildInfoRow(
                      colors: colors,
                      icon: Icons.waves_rounded,
                      label: 'Kekuatan / Skala',
                      value: 'M ${widget.event.magnitude}',
                    ),
                    const SizedBox(height: 10),
                  ],
                  _buildInfoRow(
                    colors: colors,
                    icon: Icons.info_outline_rounded,
                    label: 'Keterangan',
                    value: widget.event.description,
                  ),

                  if (widget.event.recommendedAction != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.warningLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.warningBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.health_and_safety_rounded,
                            color: colors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.event.recommendedAction!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.warningDark,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Pinned Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _stopAlarmAndDismiss,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.secondary,
                  side: BorderSide(color: colors.divider),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Saya Aman',
                  style: TextStyle(
                    color: colors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required AppColorScheme colors,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colors.textHint,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
