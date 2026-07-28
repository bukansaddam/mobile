import 'dart:async';
import 'dart:ui';
import 'package:akar/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundServiceHelper {
  BackgroundServiceHelper._();

  static const String notificationChannelId = 'akar_tracking_channel';
  static const int notificationId = 888;

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId,
      'AKAR Location Tracking Service',
      description: 'Layanan pelacakan lokasi background 24/7 AKAR',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: 'AKAR Tracking Service 24/7',
        initialNotificationContent: 'Pelacakan lokasi aktif di latar belakang',
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    await service.startService();
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    final prefs = await SharedPreferences.getInstance();
    int intervalSeconds = prefs.getInt('trackingIntervalSeconds') ?? 900;
    bool isTrackingActive = prefs.getBool('isTrackingActive') ?? true;

    Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
      // Re-check prefs per tick in case user updated settings
      final updatedPrefs = await SharedPreferences.getInstance();
      isTrackingActive = updatedPrefs.getBool('isTrackingActive') ?? true;
      final newInterval = updatedPrefs.getInt('trackingIntervalSeconds') ?? 900;

      if (newInterval != intervalSeconds) {
        intervalSeconds = newInterval;
        timer.cancel();
        onStart(service);
        return;
      }

      if (!isTrackingActive) return;

      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return;

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );

        final token = updatedPrefs.getString('CACHED_AUTH_TOKEN');
        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        final response = await dio.patch(
          ApiConstants.tracking,
          data: {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
          options: Options(headers: headers),
        );

        final nowStr = DateTime.now().toIso8601String();
        await updatedPrefs.setString('LAST_TRACKING_TIME', nowStr);
        await updatedPrefs.setDouble('LAST_TRACKING_LAT', position.latitude);
        await updatedPrefs.setDouble('LAST_TRACKING_LNG', position.longitude);
        await updatedPrefs.setString(
          'LAST_TRACKING_MSG',
          response.data?['message']?.toString() ??
              'Lokasi berhasil terkirim ke API (24/7)',
        );
        await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', true);

        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            service.setForegroundNotificationInfo(
              title: 'AKAR Location Tracking 24/7',
              content:
                  'Terkirim: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
            );
          }
        }
      } catch (e) {
        debugPrint('Error in 24/7 background tracking tick: $e');
        final updatedPrefs = await SharedPreferences.getInstance();
        await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', false);
        await updatedPrefs.setString('LAST_TRACKING_MSG', e.toString());
      }
    });
  }
}
