import 'dart:async';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/services/firebase_notification_service.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisasterAlertBanner extends StatelessWidget {
  const DisasterAlertBanner({super.key});

  static void showSimulateMenu(BuildContext context) {
    final colors = context.appColors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final sheetColors = sheetContext.appColors;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: sheetColors.borderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    color: sheetColors.error,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Simulasi Peringatan Bencana Alam',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: sheetColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Pilih jenis bencana di bawah ini untuk menguji notifikasi berdering sirine darurat:',
                style: TextStyle(fontSize: 12.5, color: sheetColors.textMuted),
              ),
              const SizedBox(height: 16),
              _buildSimulateOption(
                sheetContext,
                title: '📋 Salin Token FCM Perangkat',
                subtitle: 'Salin token unik HP ini untuk test notifikasi dari Firebase Console',
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final token = await sl<FirebaseNotificationService>()
                      .getToken();
                  if (token != null && token.isNotEmpty) {
                    await Clipboard.setData(ClipboardData(text: token));
                    if (context.mounted) {
                      final dialogColors = context.appColors;
                      AppDialogs.showSuccess<void>(
                        context,
                        title: 'Token FCM Berhasil Disalin',
                        message: 'Token FCM unik perangkat ini telah disalin ke clipboard.',
                        buttonText: 'OK',
                        barrierDismissible: true,
                        customContent: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: dialogColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SelectableText(
                                token,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: dialogColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Gunakan token ini di Firebase Console -> Messaging -> Send test message.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: dialogColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      final snackColors = context.appColors;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '⚠️ Gagal mengambil token FCM. Pastikan internet & izin notifikasi aktif.',
                            style: TextStyle(color: snackColors.onErrorSolid),
                          ),
                          backgroundColor: snackColors.errorSolid,
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildSimulateOption(
                sheetContext,
                title: '📱 Tes Push Notifikasi Sistem (Luar Aplikasi)',
                subtitle: 'Picu peringatan dalam 8 detik (minimize app sekarang untuk menguji)',
                onTap: () {
                  Navigator.pop(sheetContext);
                  DisasterSimulateCountdownDialog.show(context);
                },
              ),
              const SizedBox(height: 10),
              _buildSimulateOption(
                sheetContext,
                title: '🌊 Peringatan Banjir Bandang',
                subtitle: 'Debit air meningkat drastis di hulu sungai',
                onTap: () {
                  Navigator.pop(sheetContext);
                  sl<DisasterAlertService>().triggerSimulatedDisaster(
                    type: 'Banjir Bandang',
                    magnitude: 3.5,
                    location: 'Bantaran Sungai Ciliwung - Pos Siaga 1',
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildSimulateOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.errorLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.errorBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: colors.errorDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.5, color: colors.errorDark),
                  ),
                ],
              ),
            ),
            Icon(Icons.play_circle_fill_rounded, color: colors.error, size: 28),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cardColors = colors.isDark
        ? [colors.surface, colors.surfaceElevated]
        : [colors.textPrimary, colors.secondary];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: colors.isDark ? Border.all(color: colors.border) : null,
        borderRadius: BorderRadius.circular(18),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.error.withAlpha(40),
              shape: BoxShape.circle,
              border: Border.all(color: colors.error, width: 1.5),
            ),
            child: Icon(Icons.shield_outlined, color: colors.error, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'PERINGATAN DINI BENCANA',
                        style: TextStyle(
                          color: colors.isDark
                              ? colors.textMuted
                              : colors.textHint,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Deteksi Berdering 24/7 Aktif',
                  style: TextStyle(
                    color: colors.isDark ? colors.textPrimary : colors.surface,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef DisasterSimulateCountdownDialog = CountdownTestDialog;

/// Dialog Pop-Up Hitung Mundur Interaktif untuk Uji Notifikasi Luar Aplikasi
class CountdownTestDialog extends StatefulWidget {
  const CountdownTestDialog({super.key});

  static Future<void> show(BuildContext context) {
    return AppDialogs.showCustom<void>(
      context,
      barrierDismissible: false,
      canPop: false,
      builder: (context) => const CountdownTestDialog(),
    );
  }

  @override
  State<CountdownTestDialog> createState() => _CountdownTestDialogState();
}

class _CountdownTestDialogState extends State<CountdownTestDialog> {
  static const int _totalSeconds = 8;
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _totalSeconds;

    // Trigger Native OS Exact System Alarm immediately in background service
    sl<DisasterAlertService>().triggerDelayedBackgroundDisaster(
      delaySeconds: 8,
      type: 'Gempa Bumi Tektonik M 6.4',
      location: 'Kab. Cianjur, Jawa Barat',
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        _timer?.cancel();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final progress = _remainingSeconds / _totalSeconds;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.errorLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.phonelink_ring_rounded,
              color: colors.error,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'MINIMIZE APLIKASI SEKARANG',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Peringatan sistem darurat akan terpicu secara otomatis di luar aplikasi saat timer 8 detik habis:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: colors.textMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),

          // Animated Circular Countdown Gauge
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: colors.errorLight,
                  color: colors.error,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_remainingSeconds',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: colors.error,
                    ),
                  ),
                  Text(
                    'detik',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colors.textHint,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                _timer?.cancel();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text(
                'SIAP, SAYA MINIMIZE SEKARANG',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.errorSolid,
                foregroundColor: colors.onErrorSolid,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
