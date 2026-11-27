import 'dart:async';
import 'dart:ui';

import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/constants/app_constants.dart';
import 'package:akar/core/network/logging_interceptor.dart';
import 'package:akar/core/security/secure_token_storage.dart';
import 'package:akar/core/services/gps_calibration_helper.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

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
      'Pemantauan Lokasi ${AppConstants.appName}',
      description:
          'Layanan pemantauan lokasi latar belakang ${AppConstants.appName}',
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
        initialNotificationTitle: 'Pemantauan Lokasi ${AppConstants.appName}',
        initialNotificationContent: 'Pemantauan lokasi aktif di latar belakang',
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
    int currentIntervalSeconds =
        prefs.getInt('trackingIntervalSeconds') ??
        prefs.getInt('intervalSeconds') ??
        900;
    bool isTrackingActive =
        prefs.getBool('isTrackingActive') ??
        prefs.getBool('isTrackingEnabled') ??
        false;

    Timer? timer;
    bool isExecRunning = false;

    Future<void> sendLocationUpdate({
      bool force = false,
      Position? streamPosition,
    }) async {
      if (isExecRunning) return;
      isExecRunning = true;

      try {
        final updatedPrefs = await SharedPreferences.getInstance();
        isTrackingActive =
            updatedPrefs.getBool('isTrackingActive') ??
            updatedPrefs.getBool('isTrackingEnabled') ??
            false;
        if (!isTrackingActive) return;

        currentIntervalSeconds =
            updatedPrefs.getInt('trackingIntervalSeconds') ??
            updatedPrefs.getInt('intervalSeconds') ??
            currentIntervalSeconds;

        final lastTimeStr = updatedPrefs.getString('LAST_TRACKING_TIME');
        final prevTime = lastTimeStr != null
            ? DateTime.tryParse(lastTimeStr)
            : null;
        final prevLat = updatedPrefs.getDouble('LAST_TRACKING_LAT');
        final prevLng = updatedPrefs.getDouble('LAST_TRACKING_LNG');

        // Jika tidak dipaksa (force), cek apakah interval waktu dari pengiriman terakhir sudah tercapai (dengan toleransi 500ms)
        if (!force && prevTime != null) {
          final elapsedMs = DateTime.now().difference(prevTime).inMilliseconds;
          if (elapsedMs < (currentIntervalSeconds * 1000 - 500)) {
            // Interval belum tercapai, lewati pengiriman API
            return;
          }
        }

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          await updatedPrefs.setString(
            'LAST_TRACKING_ANOMALY',
            GpsAnomalyReason.serviceDisabled.code,
          );
          await updatedPrefs.setString(
            'LAST_TRACKING_MSG',
            GpsAnomalyReason.serviceDisabled.userMessage,
          );
          await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', false);
          service.invoke('locationUpdated', {
            'lastSuccess': false,
            'lastMessage': GpsAnomalyReason.serviceDisabled.userMessage,
            'lastAnomalyCode': GpsAnomalyReason.serviceDisabled.code,
            'isTrackingActive': true,
          });
          return;
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          await updatedPrefs.setString(
            'LAST_TRACKING_ANOMALY',
            GpsAnomalyReason.permissionDenied.code,
          );
          await updatedPrefs.setString(
            'LAST_TRACKING_MSG',
            GpsAnomalyReason.permissionDenied.userMessage,
          );
          await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', false);
          service.invoke('locationUpdated', {
            'lastSuccess': false,
            'lastMessage': GpsAnomalyReason.permissionDenied.userMessage,
            'lastAnomalyCode': GpsAnomalyReason.permissionDenied.code,
            'isTrackingActive': true,
          });
          return;
        }

        final fix =
            await GpsCalibrationHelper.acquireValidatedBackgroundPosition(
              preCapturedPosition: streamPosition,
              previousLat: prevLat,
              previousLng: prevLng,
              previousTimestamp: prevTime,
            );

        if (!fix.isValid) {
          final reason = fix.validation.reason;
          final msg = fix.validation.message;
          AppLogger.w(
            '[Background Service] Koordinat ditolak (${reason.code}): $msg',
          );
          await updatedPrefs.setBool(
            'LAST_TRACKING_MOCKED',
            reason == GpsAnomalyReason.mockLocation,
          );
          await updatedPrefs.setString('LAST_TRACKING_ANOMALY', reason.code);
          await updatedPrefs.setString('LAST_TRACKING_MSG', msg);
          await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', false);

          if (reason == GpsAnomalyReason.mockLocation && fix.position != null) {
            service.invoke('mockLocationDetected', {
              'latitude': fix.position!.latitude,
              'longitude': fix.position!.longitude,
            });
          }

          service.invoke('locationUpdated', {
            'lastSuccess': false,
            'lastMessage': msg,
            'lastAnomalyCode': reason.code,
            'isTrackingActive': true,
          });
          return;
        }

        final position = fix.position!;
        const tokenStorage = SecureTokenStorage();
        String? token;
        try {
          token = await tokenStorage.readAccessToken();
        } catch (e) {
          AppLogger.w('[Background Service] Gagal baca secure token: $e');
        }
        if (token == null || token.isEmpty) {
          final legacyToken = updatedPrefs.getString(
            SecureTokenStorage.accessTokenKey,
          );
          if (legacyToken != null && legacyToken.isNotEmpty) {
            token = legacyToken;
            try {
              await tokenStorage.writeAccessToken(legacyToken);
              await updatedPrefs.remove(SecureTokenStorage.accessTokenKey);
            } catch (_) {
              // Tetap kirim request dengan token legacy jika secure storage belum siap.
            }
          }
        }
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
        await updatedPrefs.setDouble(
          'LAST_TRACKING_ACCURACY',
          position.accuracy,
        );
        await updatedPrefs.setBool('LAST_TRACKING_MOCKED', false);
        await updatedPrefs.setString('LAST_TRACKING_ANOMALY', '');
        final successMsg =
            response.data?['message']?.toString() ??
            'Lokasi terkirim otomatis (${currentIntervalSeconds}s)';
        await updatedPrefs.setString('LAST_TRACKING_MSG', successMsg);
        await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', true);

        service.invoke('locationUpdated', {
          'lastLatitude': position.latitude,
          'lastLongitude': position.longitude,
          'lastAccuracyMeters': position.accuracy,
          'lastSentTime': nowStr,
          'lastMessage': successMsg,
          'lastAnomalyCode': '',
          'lastSuccess': true,
          'isTrackingActive': true,
        });

        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            service.setForegroundNotificationInfo(
              title: 'Pemantauan Lokasi ${AppConstants.appName}',
              content: 'Pemantauan lokasi aktif di latar belakang',
            );
          }
        }
      } catch (e) {
        AppLogger.e('Error in background tracking tick', e);
        final updatedPrefs = await SharedPreferences.getInstance();
        await updatedPrefs.setBool('LAST_TRACKING_SUCCESS', false);

        String errorMessage = ErrorUtils.parseErrorMessage(e);
        await updatedPrefs.setString('LAST_TRACKING_MSG', errorMessage);

        service.invoke('locationUpdated', {
          'lastSuccess': false,
          'lastMessage': errorMessage,
        });
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
      AppLogger.d('Background service timer reset to $seconds seconds');
    }

    // Start initial timer if active
    if (isTrackingActive) {
      resetTimer(currentIntervalSeconds);
    }

    // On iOS, active background location stream with allowsBackgroundLocationUpdates is required
    // to prevent iOS from suspending the Dart isolate in background.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      Geolocator.checkPermission()
          .then((permission) {
            if (permission == LocationPermission.always ||
                permission == LocationPermission.whileInUse) {
              Geolocator.getPositionStream(
                locationSettings: AppleSettings(
                  accuracy: LocationAccuracy.high,
                  allowBackgroundLocationUpdates: true,
                  showBackgroundLocationIndicator: true,
                  pauseLocationUpdatesAutomatically: false,
                ),
              ).listen(
                (Position position) {
                  if (isTrackingActive) {
                    sendLocationUpdate(streamPosition: position);
                  }
                },
                onError: (error) {
                  AppLogger.e('Error listening to iOS location stream', error);
                },
              );
            } else {
              AppLogger.w(
                'Izin lokasi belum ada di iOS, geolocator stream ditunda',
              );
            }
          })
          .catchError((error) {
            AppLogger.e('Gagal mengecek izin lokasi iOS', error);
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
        if (isTrackingActive) {
          resetTimer(currentIntervalSeconds);
        } else {
          timer?.cancel();
        }
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
