import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/services/disaster_alert_service.dart';

typedef DisasterEmergencyCallPage = DisasterEmergencyWarningPage;
typedef MemberEmergencyCallPage = DisasterEmergencyWarningPage;

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
  late Animation<double> _waveAnimation;
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
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(
      begin: 1.0,
      end: 1.35,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _isRinging = sl<AudioAlarmService>().isPlaying;
  }

  @override
  void dispose() {
    sl<DisasterAlertService>().dismissAlarm();
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

  void _dismissCall() {
    sl<AudioAlarmService>().stopAlarm();
    sl<DisasterAlertService>().dismissAlarm();
    Navigator.of(context).pop();
  }

  Future<void> _acceptCall() async {
    sl<AudioAlarmService>().stopAlarm();
    sl<DisasterAlertService>().dismissAlarm();

    final lat = widget.event.latitude;
    final lng = widget.event.longitude;

    if (lat != null && lng != null && (lat != 0.0 || lng != 0.0)) {
      final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
      );
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        debugPrint('Error launching maps: $e');
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _openWhatsApp() async {
    final phone = widget.event.senderPhone;
    if (phone == null || phone.isEmpty) return;

    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    }

    final name = widget.event.senderName ?? 'Rekan';
    final text = Uri.encodeComponent(
      'Halo $name, saya menerima sinyal darurat SOS Anda. Posisi saya segera merapat ke lokasi Anda.',
    );
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$text');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }

  Future<void> _openDialer() async {
    final phone = widget.event.senderPhone;
    if (phone == null || phone.isEmpty) return;

    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching phone dialer: $e');
    }
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final phone = widget.event.senderPhone ?? '';
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hubungi Pemanggil (${widget.event.senderName ?? "Anggota"})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  phone,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_rounded,
                      color: Color(0xFF25D366),
                    ),
                  ),
                  title: const Text(
                    'Chat via WhatsApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Kirim konfirmasi respon cepat',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openWhatsApp();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_in_talk_rounded,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                  title: const Text(
                    'Panggil Telepon Langsung',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Panggilan suara biasa (GSM)',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openDialer();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final callerName =
        widget.event.senderName ??
        widget.event.title.replaceAll('🚨', '').trim();
    final phone = widget.event.senderPhone;
    final locationText = widget.event.location;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background pulsing emergency radial gradient
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.3),
                      radius: 1.2 + (_pulseController.value * 0.25),
                      colors: [
                        const Color(0xFFDC2626).withAlpha(
                          (150 + (_pulseController.value * 70)).toInt(),
                        ),
                        const Color(0xFF7F1D1D).withAlpha(200),
                        const Color(0xFF0F172A),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                );
              },
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Top Badge: PANGGILAN DARURAT SOS ANGGOTA
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDC2626).withAlpha(160),
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'PANGGILAN DARURAT SOS ANGGOTA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Central Avatar with Pulsing Radar Rings
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer ripple wave
                            Transform.scale(
                              scale: _waveAnimation.value,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFEF4444).withAlpha(
                                      (120 * (1 - _pulseController.value))
                                          .toInt(),
                                    ),
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                            // Middle glowing ring
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(20),
                                border: Border.all(
                                  color: Colors.white.withAlpha(80),
                                  width: 2,
                                ),
                              ),
                            ),
                            // Inner core avatar
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEF4444),
                                      Color(0xFFB91C1C),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFEF4444,
                                      ).withAlpha(200),
                                      blurRadius: 35,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_pin_circle_rounded,
                                  color: Colors.white,
                                  size: 54,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Caller Name
                    Text(
                      callerName.isNotEmpty ? callerName : 'Anggota / Petugas',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Role / Status Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withAlpha(50)),
                      ),
                      child: Text(
                        phone != null && phone.isNotEmpty
                            ? '📞 $phone'
                            : 'Petugas / Anggota Linmas',
                        style: const TextStyle(
                          color: Color(0xFFF1F5F9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Emergency Information Card (Location & Note)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withAlpha(230),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF334155)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(80),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Titik Lokasi Pemanggil:',
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
                            locationText.isNotEmpty
                                ? locationText
                                : 'Lokasi pemanggil sedang diproses',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Siren Alarm Status Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isRinging
                            ? const Color(0xFFFEF2F2).withAlpha(25)
                            : const Color(0xFF334155).withAlpha(80),
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
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _isRinging
                                  ? 'Sirine darurat berdering...'
                                  : 'Sirine dimatikan',
                              style: TextStyle(
                                color: _isRinging
                                    ? const Color(0xFFFCA5A5)
                                    : const Color(0xFF94A3B8),
                                fontSize: 12,
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
                              backgroundColor: Colors.white.withAlpha(25),
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

                    const Spacer(flex: 1),

                    // Action Buttons (Incoming Call Style)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Button 1: Tolak / Matikan (Merah)
                        _buildCallActionButton(
                          icon: Icons.call_end_rounded,
                          label: 'Tolak',
                          color: const Color(0xFFDC2626),
                          onTap: _dismissCall,
                        ),

                        // Button 2: Hubungi (WhatsApp / Telpon) - if phone available
                        if (phone != null && phone.isNotEmpty)
                          _buildCallActionButton(
                            icon: Icons.chat_bubble_rounded,
                            label: 'Hubungi',
                            color: const Color(0xFF0284C7),
                            onTap: _showContactOptions,
                          ),

                        // Button 3: Terima & Buka Lokasi (Hijau)
                        _buildCallActionButton(
                          icon: Icons.navigation_rounded,
                          label: 'Terima & Rute',
                          color: const Color(0xFF16A34A),
                          onTap: _acceptCall,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(160),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
