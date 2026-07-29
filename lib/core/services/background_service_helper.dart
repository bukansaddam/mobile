import 'dart:async';
import 'dart:ui';
import 'package:akar/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import '../network/logging_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
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
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: 'AKAR Tracking Service 24/7',
        initialNotificationContent: 'Pelacakan lokasi aktif di latar belakang',
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
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
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(LoggingInterceptor());

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
    int currentIntervalSeconds = prefs.getInt('trackingIntervalSeconds') ?? 900;
    bool isTrackingActive = prefs.getBool('isTrackingActive') ?? true;

    Timer? timer;
    bool isExecRunning = false;

    Future<void> sendLocationUpdate({bool force = false}) async {
      if (isExecRunning) return;
      isExecRunning = true;

      try {
        final updatedPrefs = await SharedPreferences.getInstance();
        isTrackingActive = updatedPrefs.getBool('isTrackingActive') ?? true;
        if (!isTrackingActive) return;

        currentIntervalSeconds =
            updatedPrefs.getInt('trackingIntervalSeconds') ??
            currentIntervalSeconds;

        // Jika tidak dipaksa (force), cek apakah interval waktu dari pengiriman terakhir sudah tercapai
        if (!force) {
          final lastTimeStr = updatedPrefs.getString('LAST_TRACKING_TIME');
          if (lastTimeStr != null) {
            final lastTime = DateTime.tryParse(lastTimeStr);
            if (lastTime != null) {
              final elapsedSeconds = DateTime.now()
                  .difference(lastTime)
                  .inSeconds;
              if (elapsedSeconds < currentIntervalSeconds) {
                // Interval belum tercapai, lewati pengiriman API
                return;
              }
            }
          }
        }

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return;

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }

        // Use fast last known position first, fallback to quick medium accuracy position
        Position? position = await Geolocator.getLastKnownPosition();
        position ??= await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 4),
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
              'Lokasi terkirim otomatis (${currentIntervalSeconds}s)',
        );
        await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', true);

        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            service.setForegroundNotificationInfo(
              title: 'AKAR Location Tracking (${currentIntervalSeconds}s)',
              content:
                  'Terkirim: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
            );
          }
        }
      } catch (e) {
        debugPrint('Error in background tracking tick: $e');
        final updatedPrefs = await SharedPreferences.getInstance();
        await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', false);

        String errorMessage = e.toString();
        if (e is DioException) {
          final serverMsg =
              e.response?.data?['message'] ??
              e.response?.data?['meta']?['message'];
          if (serverMsg != null && serverMsg.toString().trim().isNotEmpty) {
            errorMessage = serverMsg.toString();
          } else if (e.response?.statusCode == 422) {
            errorMessage = 'Format/data lokasi ditolak server (Error 422)';
          } else if (e.response?.statusCode == 401) {
            errorMessage =
                'Sesi telah berakhir, silakan login ulang (Error 401)';
          } else if (e.response?.statusCode != null) {
            errorMessage =
                'Gagal mengirim lokasi (Error ${e.response?.statusCode})';
          } else {
            errorMessage = 'Koneksi ke server terputus';
          }
        }
        await updatedPrefs.setString('LAST_TRACKING_MSG', errorMessage);
      } finally {
        isExecRunning = false;
      }
    }

    void resetTimer(int seconds) {
      timer?.cancel();
      currentIntervalSeconds = seconds;

      // Execute immediately on timer start/reset so location sends right away
      sendLocationUpdate(force: true);

      timer = Timer.periodic(Duration(seconds: seconds), (_) {
        sendLocationUpdate();
      });
      debugPrint('Background service timer reset to $seconds seconds');
    }

    // Start initial timer
    resetTimer(currentIntervalSeconds);

    // On iOS, active background location stream with allowsBackgroundLocationUpdates is required
    // to prevent iOS from suspending the Dart isolate in background.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      Geolocator.checkPermission()
          .then((permission) {
            if (permission == LocationPermission.always ||
                permission == LocationPermission.whileInUse) {
              Geolocator.getPositionStream(
                locationSettings: AppleSettings(
                  accuracy: LocationAccuracy.medium,
                  allowBackgroundLocationUpdates: true,
                  showBackgroundLocationIndicator: true,
                  pauseLocationUpdatesAutomatically: false,
                ),
              ).listen(
                (Position position) {
                  sendLocationUpdate();
                },
                onError: (error) {
                  debugPrint('Error listening to iOS location stream: $error');
                },
              );
            } else {
              debugPrint(
                'Izin lokasi belum ada di iOS, geolocator stream ditunda',
              );
            }
          })
          .catchError((error) {
            debugPrint('Gagal mengecek izin lokasi iOS: $error');
          });
    }

    // Listen for live interval change events from main UI
    service.on('updateInterval').listen((event) {
      if (event != null && event['interval'] != null) {
        final int newInterval = event['interval'] as int;
        resetTimer(newInterval);
      }
    });

    // Listen for live active/inactive status events from main UI
    service.on('updateStatus').listen((event) {
      if (event != null && event['active'] != null) {
        isTrackingActive = event['active'] as bool;
      }
    });
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return BackgroundServiceHelper.onIosBackground(service);
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  BackgroundServiceHelper.onStart(service);
}
