import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/offline/widgets/pending_queue_bottom_sheet.dart';
import 'package:akar/core/routes/app_router.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/utils/app_logger.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/masyarakat/notification/presentation/pages/disaster_emergency_call_page.dart';
import 'package:akar/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (AppLogger.isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.i(
      '🔥 [FCM Background] Message ID: ${message.messageId} | Data: ${message.data}',
    );

    final data = message.data;
    final title =
        message.notification?.title ??
        data['title'] ??
        'PERINGATAN DARURAT: Panggilan SOS';
    final body =
        message.notification?.body ??
        data['body'] ??
        data['message'] ??
        'Panggilan darurat masuk, segera buka aplikasi.';

    final type = (data['type'] ?? data['category'] ?? data['tag'] ?? '')
        .toString()
        .toLowerCase();
    final titleLower = title.toLowerCase();
    final bodyLower = body.toLowerCase();
    final channelId =
        (message.notification?.android?.channelId ?? data['channel_id'] ?? '')
            .toString();

    final isEmergency =
        type == 'emergency' ||
        type == 'disaster' ||
        type == 'darurat' ||
        type == 'panic' ||
        type == 'sos' ||
        data['severity'] == 'critical' ||
        channelId == 'akar_emergency_channel' ||
        channelId == 'disaster_emergency_channel' ||
        titleLower.contains('sos') ||
        titleLower.contains('darurat') ||
        titleLower.contains('bencana') ||
        titleLower.contains('panic') ||
        titleLower.contains('emergency') ||
        bodyLower.contains('sos') ||
        bodyLower.contains('darurat') ||
        bodyLower.contains('panic');

    if (message.notification != null) {
      AppLogger.i(
        '🔥 [FCM Background] Message contains notification payload; Android OS handles display. Skipping manual local notification.',
      );
      return;
    }

    if (isEmergency) {
      final fln = FlutterLocalNotificationsPlugin();
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await fln.initialize(settings: initSettings);

      const androidDetails = AndroidNotificationDetails(
        'akar_emergency_channel',
        'Peringatan Darurat ${AppConstants.appName}',
        channelDescription:
            'Saluran notifikasi darurat dan bencana ${AppConstants.appName}',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.call,
        visibility: NotificationVisibility.private,
        fullScreenIntent: true,
        ongoing: true,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        actions: [
          AndroidNotificationAction(
            'open_emergency',
            'BUKA DARURAT',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ],
      );
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.critical,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      const notifId = 999;
      await fln.show(
        id: notifId,
        title: title,
        body: body,
        notificationDetails: details,
        payload: jsonEncode(data),
      );
    }
  } catch (e, stack) {
    AppLogger.e('Error in firebaseMessagingBackgroundHandler', e, stack);
  }
}

class FirebaseNotificationService {
  static const String _prefsFcmTokenKey = 'FCM_TOKEN';
  static const String _prefsDeviceIdKey = 'DEVICE_ID';

  static const String defaultChannelId = 'akar_notification_channel';
  static const String defaultChannelName = 'Notifikasi ${AppConstants.appName}';
  static const String defaultChannelDesc =
      'Saluran utama penerimaan notifikasi aplikasi ${AppConstants.appName}';

  static const String emergencyChannelId = 'akar_emergency_channel';
  static const String emergencyChannelName =
      'Peringatan Darurat ${AppConstants.appName}';
  static const String emergencyChannelDesc =
      'Saluran notifikasi darurat dan bencana ${AppConstants.appName}';

  static const AndroidNotificationChannel defaultChannel =
      AndroidNotificationChannel(
        defaultChannelId,
        defaultChannelName,
        description: defaultChannelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

  static const AndroidNotificationChannel emergencyChannel =
      AndroidNotificationChannel(
        emergencyChannelId,
        emergencyChannelName,
        description: emergencyChannelDesc,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final SharedPreferences _prefs;
  final Dio? _dio;

  final _foregroundMessageController =
      StreamController<RemoteMessage>.broadcast();
  final _notificationTapController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _tokenRefreshController = StreamController<String>.broadcast();
  final DisasterAlertService? _disasterAlertService;

  bool _isInitialized = false;
  StreamSubscription<String>? _registeredSubscription;
  StreamSubscription<String>? _unregisteredSubscription;
  Completer<String?>? _pendingRegistrationCompleter;
  String? _lastSyncedDeviceId;
  String? _lastSyncedAuthHeader;
  Future<void>? _inFlightDeviceSync;

  FirebaseNotificationService({
    required this._prefs,
    FirebaseMessaging? fcm,
    FlutterLocalNotificationsPlugin? localNotifications,
    this._disasterAlertService,
    this._dio,
  }) : _fcm = fcm ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  Stream<RemoteMessage> get onForegroundMessage =>
      _foregroundMessageController.stream;

  Stream<Map<String, dynamic>> get onNotificationTap =>
      _notificationTapController.stream;

  Stream<String> get onTokenRefresh => _tokenRefreshController.stream;

  String? get cachedToken => _prefs.getString(_prefsFcmTokenKey);
  String? get deviceId => cachedToken ?? _prefs.getString(_prefsDeviceIdKey);

  static bool _isLegacyFcmToken(String value) =>
      value.contains(':') || value.length >= 64;

  static String _maskIdentifier(String value) {
    if (value.length <= 6) return '***';
    return '${value.substring(0, 6)}...';
  }

  bool get _hasValidCachedFid {
    final current = cachedToken?.trim();
    return current != null && current.isNotEmpty && !_isLegacyFcmToken(current);
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _initLocalNotifications();

      await _initToken();

      _setupMessageListeners();

      _isInitialized = true;
      AppLogger.i('🔥 [FCM Service] Initialized successfully');
    } catch (e, stack) {
      AppLogger.e('🔥 [FCM Service] Initialization error: $e', e, stack);
    }
  }

  Future<void> ensureTokenCached() async {
    if (!_hasValidCachedFid) {
      await _initToken();
    } else {
      await syncDeviceIdToBackend();
    }
  }

  Future<bool> requestNotificationPermission() async {
    final settings = await _requestPermission();
    await ensureTokenCached();

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<NotificationSettings> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    AppLogger.i(
      '🔥 [FCM Service] Permission status: ${settings.authorizationStatus}',
    );

    return settings;
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      requestCriticalPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onSelectLocalNotification(response);
      },
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(defaultChannel);
      await androidPlugin.createNotificationChannel(emergencyChannel);
    }
  }

  void _ensureRegistrationListeners() {
    _registeredSubscription ??= _fcm.onRegistered.listen((fid) async {
      final cleaned = fid.trim();
      if (cleaned.isEmpty) return;

      await _prefs.setString(_prefsFcmTokenKey, cleaned);
      await _prefs.setString(_prefsDeviceIdKey, cleaned);

      final pending = _pendingRegistrationCompleter;
      if (pending != null && !pending.isCompleted) {
        pending.complete(cleaned);
      }

      if (!_tokenRefreshController.isClosed) {
        _tokenRefreshController.add(cleaned);
      }
      AppLogger.i(
        '🔥 [FCM Service] Registered FID: ${_maskIdentifier(cleaned)}',
      );
      unawaited(syncDeviceIdToBackend(deviceIdOverride: cleaned));
    });

    _unregisteredSubscription ??= _fcm.onUnregistered.listen((fid) async {
      final cleaned = fid.trim();
      if (cleaned.isEmpty) return;
      if (cachedToken == cleaned) {
        await _prefs.remove(_prefsFcmTokenKey);
        await _prefs.remove(_prefsDeviceIdKey);
        resetSyncedDeviceState();
      }
      AppLogger.i(
        '🔥 [FCM Service] Unregistered FID: ${_maskIdentifier(cleaned)}',
      );
    });
  }

  Future<void> _initToken() async {
    _ensureRegistrationListeners();
    try {
      await _fcm.register();
    } catch (e) {
      AppLogger.w('🔥 [FCM Service] Unable to register FCM FID: $e');
    }
  }

  void resetSyncedDeviceState() {
    _lastSyncedDeviceId = null;
    _lastSyncedAuthHeader = null;
  }

  /// Menyinkronkan FID ke backend melalui `PATCH /api/auth/device-id`
  /// dengan payload `{"device_id": "<fid>"}` saat sesi autentikasi aktif.
  Future<void> syncDeviceIdToBackend({
    String? deviceIdOverride,
    bool force = false,
  }) async {
    final dio = _dio;
    if (dio == null) return;

    final authHeader = dio.options.headers['Authorization']?.toString().trim();
    if (authHeader == null || authHeader.isEmpty) return;

    final candidate = (deviceIdOverride ?? cachedToken)?.trim();
    if (candidate == null ||
        candidate.isEmpty ||
        _isLegacyFcmToken(candidate)) {
      return;
    }

    if (!force &&
        _lastSyncedDeviceId == candidate &&
        _lastSyncedAuthHeader == authHeader) {
      return;
    }

    final existingSync = _inFlightDeviceSync;
    if (existingSync != null) {
      await existingSync;
      if (!force &&
          _lastSyncedDeviceId == candidate &&
          _lastSyncedAuthHeader == authHeader) {
        return;
      }
    }

    final syncFuture = () async {
      try {
        await dio.patch(
          ApiConstants.authDeviceId,
          data: {'device_id': candidate},
        );
        _lastSyncedDeviceId = candidate;
        _lastSyncedAuthHeader = authHeader;
        AppLogger.i(
          '🔥 [FCM Service] Synced FID to backend: ${_maskIdentifier(candidate)}',
        );
      } catch (e) {
        AppLogger.w('🔥 [FCM Service] Failed to sync FID to backend: $e');
      }
    }();

    _inFlightDeviceSync = syncFuture;
    try {
      await syncFuture;
    } finally {
      if (identical(_inFlightDeviceSync, syncFuture)) {
        _inFlightDeviceSync = null;
      }
    }
  }

  void _setupMessageListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.i(
        '🔥 [FCM Service] Foreground message received: ${message.messageId}',
      );
      _foregroundMessageController.add(message);
      _showLocalNotificationFromRemote(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.i(
        '🔥 [FCM Service] Notification opened from background: ${message.messageId}',
      );
      _handleNotificationTap(message.data);
    });

    _fcm.getInitialMessage().then((RemoteMessage? initialMessage) {
      if (initialMessage != null) {
        AppLogger.i(
          '🔥 [FCM Service] App launched from notification: ${initialMessage.messageId}',
        );

        Future.delayed(const Duration(milliseconds: 800), () {
          _handleNotificationTap(initialMessage.data);
        });
      }
    });

    _localNotifications.getNotificationAppLaunchDetails().then((
      NotificationAppLaunchDetails? details,
    ) {
      if (details?.didNotificationLaunchApp ?? false) {
        final payload = details?.notificationResponse?.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final data = jsonDecode(payload) as Map<String, dynamic>;
            Future.delayed(const Duration(milliseconds: 800), () {
              _handleNotificationTap(data);
            });
          } catch (_) {}
        }
      }
    });
  }

  Future<void> _showLocalNotificationFromRemote(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final title =
        notification?.title ??
        data['title'] ??
        'Notifikasi ${AppConstants.appName}';
    final body = notification?.body ?? data['body'] ?? data['message'] ?? '';

    if (title.isEmpty && body.isEmpty) return;

    final type = (data['type'] ?? data['category'] ?? data['tag'] ?? '')
        .toString()
        .toLowerCase();
    final titleLower = title.toLowerCase();
    final bodyLower = body.toLowerCase();
    final channelId =
        (message.notification?.android?.channelId ?? data['channel_id'] ?? '')
            .toString();

    final isEmergency =
        type == 'emergency' ||
        type == 'disaster' ||
        type == 'darurat' ||
        type == 'panic' ||
        type == 'sos' ||
        data['severity'] == 'critical' ||
        channelId == emergencyChannelId ||
        channelId == 'disaster_emergency_channel' ||
        titleLower.contains('sos') ||
        titleLower.contains('darurat') ||
        titleLower.contains('bencana') ||
        titleLower.contains('panic') ||
        titleLower.contains('emergency') ||
        bodyLower.contains('sos') ||
        bodyLower.contains('darurat') ||
        bodyLower.contains('panic');

    final channel = isEmergency ? emergencyChannel : defaultChannel;

    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: channel.importance,
      priority: isEmergency ? Priority.max : Priority.high,
      category: isEmergency ? AndroidNotificationCategory.call : null,
      fullScreenIntent: isEmergency,
      ongoing: isEmergency,
      visibility: NotificationVisibility.private,
      ticker: isEmergency ? 'PANGGILAN DARURAT SOS ANGGOTA' : null,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
      actions: isEmergency
          ? const [
              AndroidNotificationAction(
                'open_emergency',
                'BUKA PANGGILAN SOS',
                showsUserInterface: true,
                cancelNotification: true,
              ),
            ]
          : null,
    );

    final darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: isEmergency
          ? InterruptionLevel.critical
          : InterruptionLevel.active,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final notificationId = isEmergency
        ? 999
        : ((message.messageId ?? data['id'] ?? data['alert_id'] ?? '').hashCode
                  .abs() &
              0x7FFFFFFF);

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(data),
    );

    if (isEmergency) {
      final senderName =
          data['sender_name']?.toString() ??
          data['caller_name']?.toString() ??
          data['name']?.toString() ??
          data['member_name']?.toString() ??
          data['user_name']?.toString() ??
          (title.isNotEmpty ? title : 'Anggota / Petugas Aslinmas');

      final senderPhone =
          data['sender_phone']?.toString() ??
          data['phone']?.toString() ??
          data['phone_number']?.toString() ??
          data['no_hp']?.toString();

      final lat = double.tryParse(
        data['latitude']?.toString() ?? data['lat']?.toString() ?? '',
      );
      final lng = double.tryParse(
        data['longitude']?.toString() ?? data['lng']?.toString() ?? '',
      );

      final note =
          data['note']?.toString() ?? data['pesan']?.toString() ?? body;

      final alertEvent = DisasterAlertEvent(
        id:
            data['id']?.toString() ??
            data['alert_id']?.toString() ??
            message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: senderName,
        type: 'Panggilan Darurat SOS Anggota',
        description: note,
        location:
            data['location']?.toString() ??
            data['address']?.toString() ??
            (lat != null && lng != null
                ? 'Koordinat: $lat, $lng'
                : 'Lokasi Terdeteksi'),
        severity: DisasterSeverity.critical,
        timestamp: DateTime.now(),
        senderName: senderName,
        senderPhone: senderPhone,
        latitude: lat,
        longitude: lng,
        note: note,
      );

      _disasterAlertService?.triggerAlert(alertEvent, showNotification: false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          AppRouter.router.pushNamed(
            AppRouter.emergencyCall,
            extra: alertEvent,
          );
        } catch (e) {
          final navContext = AppRouter.rootNavigatorKey.currentContext;
          if (navContext != null) {
            DisasterEmergencyWarningPage.show(navContext, alertEvent);
          }
        }
      });
    }
  }

  void _onSelectLocalNotification(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        _handleNotificationTap(data);
      } catch (e) {
        AppLogger.w('Failed to parse notification payload: $e');
      }
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    _notificationTapController.add(data);
    handleRouting(data);
  }

  void handleRouting(Map<String, dynamic> data) {
    try {
      if (data.containsKey('route') && data['route'] != null) {
        final route = data['route'].toString();
        AppRouter.router.push(route);
        return;
      }

      final kind = (data['kind'] ?? data['type'])?.toString().toLowerCase();

      if (kind != null && kind.startsWith('jaga_tanah')) {
        final reportId = data['report_id']?.toString();
        if (reportId != null && reportId.isNotEmpty) {
          AppRouter.router.pushNamed(
            AppRouter.jagaTanahDetail,
            extra: reportId,
          );
        } else {
          AppRouter.router.pushNamed(AppRouter.notifications);
        }
        return;
      }

      switch (kind) {
        case 'activation':
        case 'activation_assigned':
        case 'activation_approval_updated':
        case 'penugasan':
          final activityId =
              data['activation_run_id']?.toString() ??
              data['activityId']?.toString() ??
              '';
          AppRouter.router.pushNamed(
            AppRouter.activationDetail,
            extra: {'activityId': activityId, 'autoShowInfo': true},
          );
          break;

        case 'complaint':
        case 'pengaduan':
        case 'report_status_update':
          AppRouter.router.pushNamed(AppRouter.notifications);
          break;

        case 'emergency_report_status_update':
          AppRouter.router.pushNamed(AppRouter.notifications);
          break;

        case 'offline_queue':
          final navContext = AppRouter.rootNavigatorKey.currentContext;
          if (navContext != null && navContext.mounted) {
            PendingQueueBottomSheet.show(navContext);
          }
          break;

        case 'panic':
        case 'disaster':
        case 'darurat':
        case 'sos':
          final senderName =
              data['sender_name']?.toString() ??
              data['caller_name']?.toString() ??
              data['name']?.toString() ??
              data['member_name']?.toString() ??
              data['user_name']?.toString() ??
              data['title']?.toString() ??
              'Anggota / Petugas Aslinmas';

          final senderPhone =
              data['sender_phone']?.toString() ??
              data['phone']?.toString() ??
              data['phone_number']?.toString() ??
              data['no_hp']?.toString();

          final lat = double.tryParse(
            data['latitude']?.toString() ?? data['lat']?.toString() ?? '',
          );
          final lng = double.tryParse(
            data['longitude']?.toString() ?? data['lng']?.toString() ?? '',
          );

          final note =
              data['note']?.toString() ??
              data['pesan']?.toString() ??
              data['body']?.toString() ??
              data['message']?.toString() ??
              'Laporan panggilan darurat.';

          final alertEvent = DisasterAlertEvent(
            id:
                data['id']?.toString() ??
                data['alert_id']?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            title: senderName,
            type:
                data['disaster_type']?.toString() ??
                data['type']?.toString() ??
                'Panggilan Darurat SOS Anggota',
            description: note,
            location:
                data['location']?.toString() ??
                data['address']?.toString() ??
                (lat != null && lng != null
                    ? 'Koordinat: $lat, $lng'
                    : 'Lokasi Terdeteksi'),
            severity: DisasterSeverity.critical,
            timestamp: DateTime.now(),
            magnitude: double.tryParse(data['magnitude']?.toString() ?? ''),
            senderName: senderName,
            senderPhone: senderPhone,
            latitude: lat,
            longitude: lng,
            note: note,
          );
          AppRouter.router.pushNamed(
            AppRouter.emergencyCall,
            extra: alertEvent,
          );
          break;

        case 'announcement':
        case 'pengumuman':
          AppRouter.router.pushNamed(AppRouter.main);
          break;

        case 'bank_sampah':
          AppRouter.router.pushNamed(AppRouter.bankSampah);
          break;

        default:
          AppLogger.i('Unhandled notification payload type: $kind');
          break;
      }
    } catch (e) {
      AppLogger.e('Error navigating from notification tap: $e');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      AppLogger.i('🔥 [FCM Service] Subscribed to topic: $topic');
    } catch (e) {
      AppLogger.e('🔥 [FCM Service] Failed to subscribe to topic $topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      AppLogger.i('🔥 [FCM Service] Unsubscribed from topic: $topic');
    } catch (e) {
      AppLogger.e(
        '🔥 [FCM Service] Failed to unsubscribe from topic $topic: $e',
      );
    }
  }

  Future<String?> getToken({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    _ensureRegistrationListeners();
    if (_hasValidCachedFid) {
      return cachedToken;
    }

    final completer = Completer<String?>();
    _pendingRegistrationCompleter = completer;

    try {
      await _fcm.register();
      if (_hasValidCachedFid) {
        return cachedToken;
      }
      final fid = await completer.future.timeout(
        timeout,
        onTimeout: () => _hasValidCachedFid ? cachedToken : null,
      );
      return fid;
    } catch (e) {
      AppLogger.e('🔥 [FCM Service] Error registering FID: $e');
      return _hasValidCachedFid ? cachedToken : null;
    } finally {
      if (identical(_pendingRegistrationCompleter, completer)) {
        _pendingRegistrationCompleter = null;
      }
    }
  }

  Future<String?> getDeviceId() => getToken();

  Future<void> deleteToken() async {
    try {
      await _fcm.unregister();
      await _prefs.remove(_prefsFcmTokenKey);
      await _prefs.remove(_prefsDeviceIdKey);
      resetSyncedDeviceState();
      AppLogger.i('🔥 [FCM Service] FID unregistered');
    } catch (e) {
      AppLogger.e('🔥 [FCM Service] Error unregistering FID: $e');
    }
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    bool isEmergency = false,
  }) async {
    final channel = isEmergency ? emergencyChannel : defaultChannel;

    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: channel.importance,
      priority: isEmergency ? Priority.max : Priority.high,
      category: isEmergency ? AndroidNotificationCategory.call : null,
      fullScreenIntent: isEmergency,
      ongoing: isEmergency,
      visibility: NotificationVisibility.private,
      ticker: isEmergency ? 'PANGGILAN DARURAT BENCANA / SOS' : null,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    final darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: isEmergency
          ? InterruptionLevel.critical
          : InterruptionLevel.active,
    );

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      ),
      payload: data != null ? jsonEncode(data) : null,
    );
  }

  Future<bool> isOverlayPermissionGranted() async {
    try {
      return await Permission.systemAlertWindow.isGranted;
    } catch (_) {
      return false;
    }
  }

  Future<bool> requestOverlayPermission() async {
    try {
      final status = await Permission.systemAlertWindow.request();
      return status.isGranted;
    } catch (e) {
      AppLogger.w('Error requesting overlay permission: $e');
      return false;
    }
  }

  Future<bool> checkAndPromptOverlayPermission(
    BuildContext context, {
    bool forcePrompt = false,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) return false;

    final isGranted = await isOverlayPermissionGranted();
    if (isGranted) return true;

    const prefsKey = 'HAS_PROMPTED_OVERLAY_PERMISSION';
    if (!forcePrompt && (_prefs.getBool(prefsKey) ?? false)) {
      return false;
    }

    if (!context.mounted) return false;

    final proceed = await AppDialogs.showConfirmation(
      context,
      title: 'Izin Panggilan Darurat Fullscreen',
      message: 'Agar peringatan darurat & panggilan SOS dapat otomatis muncul Fullscreen saat Anda sedang membuka aplikasi lain (seperti WhatsApp atau YouTube), mohon aktifkan izin "Tampilkan di atas aplikasi lain".',
      confirmText: 'Aktifkan Sekarang',
      cancelText: 'Nanti Saja',
      isDestructive: true,
      icon: Icons.warning_amber_rounded,
      barrierDismissible: false,
      customContent: Builder(
        builder: (contentContext) {
          final colors = contentContext.appColors;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: colors.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Layar otomatis menyala & Fullscreen 24/7',
                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    await _prefs.setBool(prefsKey, true);

    if (proceed) {
      return await requestOverlayPermission();
    }
    return false;
  }

  void dispose() {
    _registeredSubscription?.cancel();
    _registeredSubscription = null;
    _unregisteredSubscription?.cancel();
    _unregisteredSubscription = null;
    _pendingRegistrationCompleter = null;
    _foregroundMessageController.close();
    _notificationTapController.close();
    _tokenRefreshController.close();
  }
}
