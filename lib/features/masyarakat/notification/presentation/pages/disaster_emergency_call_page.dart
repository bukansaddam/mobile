import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef DisasterEmergencyCallPage = DisasterEmergencyWarningPage;

class DisasterEmergencyWarningPage extends StatefulWidget {
  final DisasterAlertEvent event;

  const DisasterEmergencyWarningPage({super.key, required this.event});

  static Future<void> show(BuildContext context, DisasterAlertEvent event) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DisasterEmergencyWarningPage(event: event),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<DisasterEmergencyWarningPage> createState() =>
      _DisasterEmergencyWarningPageState();
}

class _DisasterEmergencyWarningPageState
    extends State<DisasterEmergencyWarningPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  bool _isRinging = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0F172A),
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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

  void _toggleMute() {
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

  void _dismissWarning() {
    sl<AudioAlarmService>().stopAlarm();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.4),
                      radius: 1.1 + (_pulseController.value * 0.2),
                      colors: [
                        const Color(0xFFDC2626).withAlpha(
                          (160 + (_pulseController.value * 60)).toInt(),
                        ),
                        const Color(0xFF991B1B).withAlpha(200),
                        const Color(0xFF0F172A),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                );
              },
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDC2626).withAlpha(140),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'PERINGATAN DARURAT BENCANA ALAM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      widget.event.type,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (widget.event.magnitude != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withAlpha(60)),
                        ),
                        child: Text(
                          'Kekuatan: Magnitudo ${widget.event.magnitude}',
                          style: const TextStyle(
                            color: Color(0xFFFDE68A),
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withAlpha(220),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.location_on_rounded,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Lokasi Bencana:',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.event.location,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(25),
                          border: Border.all(
                            color: Colors.white.withAlpha(80),
                            width: 2,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFDC2626),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withAlpha(180),
                                blurRadius: 30,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    if (widget.event.recommendedAction != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF78350F).withAlpha(180),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFD97706)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.health_and_safety_rounded,
                                  color: Color(0xFFFBBF24),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Langkah Keselamatan Segera:',
                                  style: TextStyle(
                                    color: Color(0xFFFDE68A),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.event.recommendedAction!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _isRinging
                            ? const Color(0xFFFEF2F2).withAlpha(30)
                            : const Color(0xFF334155).withAlpha(100),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isRinging
                              ? const Color(0xFFEF4444).withAlpha(100)
                              : const Color(0xFF475569),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isRinging
                                ? Icons.notifications_active_rounded
                                : Icons.notifications_off_rounded,
                            color: _isRinging
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF94A3B8),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _isRinging
                                  ? 'Sirine darurat sedang berdering!'
                                  : 'Suara sirine telah dimatikan',
                              style: TextStyle(
                                color: _isRinging
                                    ? const Color(0xFFFCA5A5)
                                    : const Color(0xFF94A3B8),
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _toggleMute,
                            icon: Icon(
                              _isRinging
                                  ? Icons.volume_off_rounded
                                  : Icons.volume_up_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: Text(
                              _isRinging ? 'Mute' : 'Bunyikan',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withAlpha(30),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _dismissWarning,
                        icon: const Icon(Icons.check_circle_rounded, size: 22),
                        label: const Text(
                          'SAYA AMAN & MENGERTI',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
