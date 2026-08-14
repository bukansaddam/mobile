import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'audio_alarm_service.dart';

enum DisasterSeverity { warning, danger, critical }

class DisasterAlertEvent {
  final String id;
  final String title;
  final String type; // e.g. Gempa Bumi, Banjir, Tanah Longsor, Erupsi
  final String description;
  final String location;
  final DisasterSeverity severity;
  final DateTime timestamp;
  final double? magnitude;
  final String? recommendedAction;

  DisasterAlertEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.location,
    required this.severity,
    required this.timestamp,
    this.magnitude,
    this.recommendedAction,
  });
}

class DisasterAlertService {
  final AudioAlarmService _audioAlarmService;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _alertStreamController =
      StreamController<DisasterAlertEvent>.broadcast();
  Stream<DisasterAlertEvent> get alertStream => _alertStreamController.stream;

  DisasterAlertEvent? _latestAlert;
  DisasterAlertEvent? get latestAlert => _latestAlert;
  Timer? _retriggerTimer;

  DisasterAlertService(this._audioAlarmService) {
    _initLocalNotifications();
  }

  Future<void> _initLocalNotifications() async {
    try {
      tz.initializeTimeZones();

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        requestCriticalPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
        macOS: darwinInit,
      );

      await _notificationsPlugin.initialize(settings: initSettings);

      // Create Android High-Priority Emergency Channel for Background Push Notifications
      const androidChannel = AndroidNotificationChannel(
        'disaster_emergency_channel',
        'Peringatan Bencana Alam',
        description:
            'Saluran notifikasi darurat untuk deteksi dan peringatan dini bencana alam.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(androidChannel);
        await androidPlugin.requestNotificationsPermission();
        await androidPlugin.requestExactAlarmsPermission();
      }

      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (iosPlugin != null) {
        await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
      }
    } catch (e) {
      debugPrint('Error initializing local notifications: $e');
    }
  }

  /// Triggers a disaster alert with loud ringing alarm and high-priority push notification outside the app
  Future<void> triggerAlert(DisasterAlertEvent event) async {
    _latestAlert = event;
    _alertStreamController.add(event);

    // 1. Start continuous ringing siren audio
    await _audioAlarmService.startEmergencyAlarm();

    // 2. Show system push notification (Appears on top of other apps / Lock screen)
    try {
      const androidDetails = AndroidNotificationDetails(
        'disaster_emergency_channel',
        'Peringatan Bencana Alam',
        channelDescription:
            'Saluran notifikasi darurat untuk deteksi dan peringatan dini bencana alam.',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.call,
        visibility: NotificationVisibility.public,
        fullScreenIntent: true,
        ongoing: true,
        playSound: true,
        enableVibration: true,
        ticker: '🚨 PANGGILAN DARURAT BENCANA ALAM',
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        interruptionLevel: InterruptionLevel.critical,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      await _notificationsPlugin.show(
        id: 999,
        title: '🚨 PERINGATAN DARURAT: ${event.title}',
        body: '${event.location} - ${event.description}',
        notificationDetails: details,
      );

      // Start re-trigger timer every 4 seconds so floating pop-up banner stays active continuously
      _retriggerTimer?.cancel();
      _retriggerTimer = Timer.periodic(const Duration(seconds: 4), (
        timer,
      ) async {
        if (!_audioAlarmService.isPlaying) {
          timer.cancel();
          return;
        }
        try {
          await _notificationsPlugin.show(
            id: 999,
            title: '🚨 PERINGATAN DARURAT: ${event.title}',
            body: '${event.location} - ${event.description}',
            notificationDetails: details,
          );
        } catch (_) {}
      });
    } catch (e) {
      debugPrint('Local notification error: $e');
    }
  }

  /// Stop ringing alarm for current alert
  Future<void> dismissAlarm() async {
    _retriggerTimer?.cancel();
    _retriggerTimer = null;
    try {
      await _notificationsPlugin.cancel(id: 999);
    } catch (_) {}
    await _audioAlarmService.stopAlarm();
  }

  /// Simulate a disaster detection event for testing
  Future<void> triggerSimulatedDisaster({
    String type = 'Gempa Bumi Tektonik',
    double magnitude = 6.4,
    String location = '24 km Barat Daya Kab. Cianjur - Jabar',
  }) async {
    final event = DisasterAlertEvent(
      id: 'ALT-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Peringatan Dini $type M $magnitude',
      type: type,
      description:
          'Terdeteksi getaran kuat magnitudo $magnitude di lokasi $location. Berpotensi merusak infrastruktur lokal.',
      location: location,
      severity: DisasterSeverity.critical,
      timestamp: DateTime.now(),
      magnitude: magnitude,
      recommendedAction:
          'Segera jauhi bangunan tinggi, cari area lapang terbuka, dan lindungi kepala Anda!',
    );

    await triggerAlert(event);
  }

  /// Scheduled Native OS Alarm Manager Background Notification (Does NOT pause when app is minimized!)
  Future<void> triggerDelayedBackgroundDisaster({
    int delaySeconds = 8,
    String type = 'Gempa Bumi Tektonik',
    double magnitude = 6.4,
    String location = 'Kab. Cianjur, Jawa Barat',
  }) async {
    final event = DisasterAlertEvent(
      id: 'ALT-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Peringatan Dini $type M $magnitude',
      type: type,
      description:
          'Terdeteksi getaran kuat magnitudo $magnitude di lokasi $location.',
      location: location,
      severity: DisasterSeverity.critical,
      timestamp: DateTime.now(),
      magnitude: magnitude,
      recommendedAction:
          'Segera jauhi bangunan tinggi, cari area lapang terbuka, dan lindungi kepala Anda!',
    );

    try {
      final scheduledTime = tz.TZDateTime.now(
        tz.local,
      ).add(Duration(seconds: delaySeconds));

      const androidDetails = AndroidNotificationDetails(
        'disaster_emergency_channel',
        'Peringatan Bencana Alam',
        channelDescription:
            'Saluran notifikasi darurat untuk deteksi dan peringatan dini bencana alam.',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.call,
        visibility: NotificationVisibility.public,
        fullScreenIntent: true,
        ongoing: true,
        playSound: true,
        enableVibration: true,
        ticker: '🚨 PANGGILAN DARURAT BENCANA ALAM',
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        interruptionLevel: InterruptionLevel.critical,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      // Trigger native OS Exact Alarm via AlarmManager (runs at Android OS level)
      await _notificationsPlugin.zonedSchedule(
        id: 999,
        title: '🚨 PERINGATAN DARURAT: ${event.title}',
        body: '${event.location} - ${event.description}',
        scheduledDate: scheduledTime,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      // Backup trigger for in-app event listener
      Timer(Duration(seconds: delaySeconds), () {
        triggerAlert(event);
      });

      debugPrint(
        '✅ Native Exact System Alarm Scheduled for $delaySeconds seconds!',
      );
    } catch (e) {
      debugPrint('Native AlarmManager Schedule Error, fallback to timer: $e');
      Timer(Duration(seconds: delaySeconds), () {
        triggerAlert(event);
      });
    }
  }

  void dispose() {
    _alertStreamController.close();
  }
}
