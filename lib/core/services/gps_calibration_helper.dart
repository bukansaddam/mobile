import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Klasifikasi anomali GPS untuk proteksi tracking dan panduan kalibrasi.
enum GpsAnomalyReason {
  none(''),
  serviceDisabled('service_disabled'),
  permissionDenied('permission_denied'),
  reducedAccuracy('reduced_accuracy'),
  mockLocation('mock_location'),
  invalidCoordinates('invalid_coordinates'),
  outsideIndonesia('outside_indonesia'),
  lowAccuracy('low_accuracy'),
  impossibleJump('impossible_jump'),
  timeout('timeout');

  final String code;

  const GpsAnomalyReason(this.code);

  static GpsAnomalyReason fromCode(String? code) {
    if (code == null || code.isEmpty) return GpsAnomalyReason.none;
    for (final value in GpsAnomalyReason.values) {
      if (value.code == code) return value;
    }
    return GpsAnomalyReason.none;
  }

  String get userMessage {
    switch (this) {
      case GpsAnomalyReason.none:
        return 'Sinyal GPS normal dan terverifikasi.';
      case GpsAnomalyReason.serviceDisabled:
        return 'Layanan lokasi (GPS) nonaktif. Aktifkan GPS di pengaturan perangkat.';
      case GpsAnomalyReason.permissionDenied:
        return 'Izin lokasi belum aktif. Izinkan akses lokasi agar posisi dapat dikunci.';
      case GpsAnomalyReason.reducedAccuracy:
        return 'Mode Lokasi Perkiraan aktif. Aktifkan "Gunakan lokasi presisi" di Pengaturan Aplikasi agar posisi akurat.';
      case GpsAnomalyReason.mockLocation:
        return 'Lokasi tiruan (Fake GPS) terdeteksi. Matikan aplikasi lokasi palsu untuk melanjutkan.';
      case GpsAnomalyReason.invalidCoordinates:
        return 'Koordinat GPS tidak valid. Coba kalibrasi ulang di area terbuka.';
      case GpsAnomalyReason.outsideIndonesia:
        return 'Lokasi terdeteksi di luar wilayah Indonesia. Nonaktifkan VPN/Wi-Fi bermasalah lalu kalibrasi GPS di area terbuka.';
      case GpsAnomalyReason.lowAccuracy:
        return 'Akurasi sinyal GPS terlalu rendah. Berpindah ke dekat jendela atau area terbuka lalu coba lagi.';
      case GpsAnomalyReason.impossibleJump:
        return 'Lonjakan posisi tidak wajar terdeteksi. Menunggu kunci sinyal GPS yang lebih stabil.';
      case GpsAnomalyReason.timeout:
        return 'Gagal mengunci sinyal satelit GPS tepat waktu. Coba lagi di area terbuka.';
    }
  }
}

/// Hasil validasi satu sampel posisi GPS.
class GpsValidationResult {
  final bool isValid;
  final GpsAnomalyReason reason;
  final String message;

  const GpsValidationResult({
    required this.isValid,
    required this.reason,
    required this.message,
  });

  const GpsValidationResult.valid()
    : isValid = true,
      reason = GpsAnomalyReason.none,
      message = 'Koordinat GPS valid.';

  factory GpsValidationResult.invalid(
    GpsAnomalyReason reason, {
    String? message,
  }) {
    return GpsValidationResult(
      isValid: false,
      reason: reason,
      message: message ?? reason.userMessage,
    );
  }
}

/// Hasil akhir pengambilan posisi tervalidasi (background maupun manual).
class GpsFixResult {
  final Position? position;
  final GpsValidationResult validation;
  final bool usedHardwareGps;

  const GpsFixResult({
    required this.position,
    required this.validation,
    this.usedHardwareGps = false,
  });

  bool get isValid => position != null && validation.isValid;
}

/// Snapshot progres live selama proses kalibrasi GPS multi-sampel.
class GpsCalibrationProgress {
  final int samplesCollected;
  final Position? bestPosition;
  final double? bestAccuracyMeters;
  final bool usedHardwareGps;
  final bool isReducedAccuracy;
  final String statusMessage;
  final GpsAnomalyReason anomalyReason;
  final bool isDone;

  const GpsCalibrationProgress({
    this.samplesCollected = 0,
    this.bestPosition,
    this.bestAccuracyMeters,
    this.usedHardwareGps = false,
    this.isReducedAccuracy = false,
    required this.statusMessage,
    this.anomalyReason = GpsAnomalyReason.none,
    this.isDone = false,
  });

  bool get isSuccess => isDone && bestPosition != null;
}

typedef PositionFetcher = Future<Position> Function(LocationSettings settings);
typedef LastKnownPositionFetcher = Future<Position?> Function();
typedef PositionStreamFactory = Stream<Position> Function(
  LocationSettings settings,
);

/// Helper terpusat untuk validasi koordinat, fallback GNSS hardware, dan kalibrasi GPS.
/// Tidak bergantung pada GetIt sehingga aman dipanggil dari background isolate maupun UI.
class GpsCalibrationHelper {
  GpsCalibrationHelper._();

  // shortcut: bounding box Indonesia (-11.5..6.5, 94.5..141.5) masih meloloskan sebagian
  // negara tetangga dekat perbatasan, upgrade ke polygon batas negara jika butuh filter ketat.
  static const double indonesiaMinLat = -11.5;
  static const double indonesiaMaxLat = 6.5;
  static const double indonesiaMinLng = 94.5;
  static const double indonesiaMaxLng = 141.5;

  static const double defaultMaxAccuracyMeters = 250.0;
  static const double targetLockedAccuracyMeters = 25.0;
  static const double fallbackTriggerAccuracyMeters = 50.0;
  static const Duration maxLastKnownAge = Duration(minutes: 5);
  static const Duration maxJumpWindow = Duration(hours: 6);
  static const double maxJumpDistanceMeters = 50000.0;
  static const double maxPlausibleSpeedMps = 300.0;

  static bool isInsideIndonesia(double latitude, double longitude) {
    return latitude >= indonesiaMinLat &&
        latitude <= indonesiaMaxLat &&
        longitude >= indonesiaMinLng &&
        longitude <= indonesiaMaxLng;
  }

  /// Memvalidasi satu posisi terhadap mock GPS, (0,0), batas Indonesia, akurasi, dan lonjakan ekstrem.
  static GpsValidationResult validatePosition(
    Position position, {
    double maxAccuracyMeters = defaultMaxAccuracyMeters,
    double? previousLat,
    double? previousLng,
    DateTime? previousTimestamp,
    DateTime? now,
  }) {
    if (position.isMocked) {
      return GpsValidationResult.invalid(GpsAnomalyReason.mockLocation);
    }

    final lat = position.latitude;
    final lng = position.longitude;
    if (!lat.isFinite || !lng.isFinite || (lat == 0.0 && lng == 0.0)) {
      return GpsValidationResult.invalid(GpsAnomalyReason.invalidCoordinates);
    }

    if (!isInsideIndonesia(lat, lng)) {
      return GpsValidationResult.invalid(GpsAnomalyReason.outsideIndonesia);
    }

    final acc = position.accuracy;
    if (!acc.isFinite || acc <= 0 || acc > maxAccuracyMeters) {
      return GpsValidationResult.invalid(
        GpsAnomalyReason.lowAccuracy,
        message:
            'Akurasi sinyal GPS masih terlalu kasar (${acc.isFinite && acc > 0 ? '±${acc.round()} m' : 'tidak diketahui'}). '
            'Pindah ke area lebih terbuka lalu kalibrasi ulang.',
      );
    }

    if (previousLat != null &&
        previousLng != null &&
        previousTimestamp != null) {
      final referenceNow = now ?? DateTime.now();
      final elapsed = referenceNow.difference(previousTimestamp);
      if (!elapsed.isNegative && elapsed <= maxJumpWindow) {
        final distanceMeters = Geolocator.distanceBetween(
          previousLat,
          previousLng,
          lat,
          lng,
        );
        final elapsedSeconds = elapsed.inMilliseconds > 0
            ? elapsed.inMilliseconds / 1000.0
            : 1.0;
        final impliedSpeedMps = distanceMeters / elapsedSeconds;
        if (distanceMeters > maxJumpDistanceMeters &&
            impliedSpeedMps > maxPlausibleSpeedMps) {
          return GpsValidationResult.invalid(GpsAnomalyReason.impossibleJump);
        }
      }
    }

    return const GpsValidationResult.valid();
  }

  static LocationSettings _buildPlatformSettings({
    required LocationAccuracy accuracy,
    required bool isAndroid,
    required bool forceLocationManager,
    Duration? timeLimit,
    int distanceFilter = 0,
  }) {
    if (isAndroid) {
      return AndroidSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        forceLocationManager: forceLocationManager,
        timeLimit: timeLimit,
      );
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return AppleSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        timeLimit: timeLimit,
      );
    }
    return LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
      timeLimit: timeLimit,
    );
  }

  /// Mengambil posisi GPS presisi tervalidasi dengan fallback hardware GNSS di Android
  /// dan tidak lagi mendahulukan cache getLastKnownPosition() yang rentan basi/luar negeri.
  static Future<GpsFixResult> acquireValidatedBackgroundPosition({
    Position? preCapturedPosition,
    double maxAccuracyMeters = defaultMaxAccuracyMeters,
    double? previousLat,
    double? previousLng,
    DateTime? previousTimestamp,
    PositionFetcher? getCurrentPosition,
    LastKnownPositionFetcher? getLastKnownPosition,
    bool? isAndroidOverride,
    DateTime? now,
  }) async {
    final isAndroid =
        isAndroidOverride ??
        (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);
    final fetcher =
        getCurrentPosition ??
        ((settings) =>
            Geolocator.getCurrentPosition(locationSettings: settings));
    final lastKnownFetcher =
        getLastKnownPosition ?? Geolocator.getLastKnownPosition;

    GpsValidationResult? lastFailure;
    bool hadExplicitAnomaly = false;

    if (preCapturedPosition != null) {
      final preCheck = validatePosition(
        preCapturedPosition,
        maxAccuracyMeters: maxAccuracyMeters,
        previousLat: previousLat,
        previousLng: previousLng,
        previousTimestamp: previousTimestamp,
        now: now,
      );
      if (preCheck.isValid) {
        return GpsFixResult(
          position: preCapturedPosition,
          validation: preCheck,
          usedHardwareGps: false,
        );
      }
      if (preCheck.reason == GpsAnomalyReason.mockLocation) {
        return GpsFixResult(
          position: preCapturedPosition,
          validation: preCheck,
          usedHardwareGps: false,
        );
      }
      lastFailure = preCheck;
      hadExplicitAnomaly = true;
    }

    // 1. Coba Fused Location / CoreLocation presisi tinggi terlebih dahulu.
    try {
      final primaryPos = await fetcher(
        _buildPlatformSettings(
          accuracy: LocationAccuracy.high,
          isAndroid: isAndroid,
          forceLocationManager: false,
          timeLimit: const Duration(seconds: 10),
        ),
      );
      final primaryCheck = validatePosition(
        primaryPos,
        maxAccuracyMeters: maxAccuracyMeters,
        previousLat: previousLat,
        previousLng: previousLng,
        previousTimestamp: previousTimestamp,
        now: now,
      );
      if (primaryCheck.isValid) {
        return GpsFixResult(
          position: primaryPos,
          validation: primaryCheck,
          usedHardwareGps: false,
        );
      }
      if (primaryCheck.reason == GpsAnomalyReason.mockLocation) {
        return GpsFixResult(
          position: primaryPos,
          validation: primaryCheck,
          usedHardwareGps: false,
        );
      }
      lastFailure = primaryCheck;
      hadExplicitAnomaly = true;
    } catch (_) {
      lastFailure ??= GpsValidationResult.invalid(GpsAnomalyReason.timeout);
    }

    // 2. Di Android, jika Fused gagal/anomali (mis. Wi-Fi/VPN nyasar ke luar negeri),
    // paksa baca langsung dari hardware GPS melalui LocationManager.
    bool triedHardware = false;
    if (isAndroid) {
      triedHardware = true;
      try {
        final hardwarePos = await fetcher(
          _buildPlatformSettings(
            accuracy: LocationAccuracy.high,
            isAndroid: true,
            forceLocationManager: true,
            timeLimit: const Duration(seconds: 12),
          ),
        );
        final hardwareCheck = validatePosition(
          hardwarePos,
          maxAccuracyMeters: maxAccuracyMeters,
          previousLat: previousLat,
          previousLng: previousLng,
          previousTimestamp: previousTimestamp,
          now: now,
        );
        if (hardwareCheck.isValid) {
          return GpsFixResult(
            position: hardwarePos,
            validation: hardwareCheck,
            usedHardwareGps: true,
          );
        }
        if (hardwareCheck.reason == GpsAnomalyReason.mockLocation) {
          return GpsFixResult(
            position: hardwarePos,
            validation: hardwareCheck,
            usedHardwareGps: true,
          );
        }
        lastFailure = hardwareCheck;
        hadExplicitAnomaly = true;
      } catch (_) {
        lastFailure ??= GpsValidationResult.invalid(GpsAnomalyReason.timeout);
      }
    }

    // 3. Upaya terakhir hanya jika live GPS timeout (bukan saat anomali aktif terdeteksi):
    // terima cache terakhir bila berumur <= 5 menit dan lolos seluruh validasi.
    if (!hadExplicitAnomaly) {
      try {
        final cachedPos = await lastKnownFetcher();
        if (cachedPos != null) {
          final age = (now ?? DateTime.now()).difference(cachedPos.timestamp);
          if (!age.isNegative && age <= maxLastKnownAge) {
            final cacheCheck = validatePosition(
              cachedPos,
              maxAccuracyMeters: maxAccuracyMeters,
              previousLat: previousLat,
              previousLng: previousLng,
              previousTimestamp: previousTimestamp,
              now: now,
            );
            if (cacheCheck.isValid) {
              return GpsFixResult(
                position: cachedPos,
                validation: cacheCheck,
                usedHardwareGps: false,
              );
            }
          }
        }
      } catch (_) {}
    }

    return GpsFixResult(
      position: null,
      validation: lastFailure,
      usedHardwareGps: triedHardware,
    );
  }

  /// Menjalankan kalibrasi aktif multi-sampel untuk mengunci sinyal satelit paling akurat.
  static Stream<GpsCalibrationProgress> calibrateStream({
    Duration timeout = const Duration(seconds: 15),
    Duration hardwareFallbackDelay = const Duration(seconds: 5),
    double maxAccuracyMeters = defaultMaxAccuracyMeters,
    double targetAccuracyMeters = targetLockedAccuracyMeters,
    Future<bool> Function()? isLocationServiceEnabled,
    Future<LocationPermission> Function()? checkPermission,
    Future<LocationAccuracyStatus> Function()? getLocationAccuracy,
    PositionStreamFactory? positionStreamFactory,
    bool? isAndroidOverride,
  }) {
    final controller = StreamController<GpsCalibrationProgress>();
    final isAndroid =
        isAndroidOverride ??
        (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);
    final serviceChecker =
        isLocationServiceEnabled ?? Geolocator.isLocationServiceEnabled;
    final permissionChecker = checkPermission ?? Geolocator.checkPermission;
    final accuracyChecker =
        getLocationAccuracy ?? Geolocator.getLocationAccuracy;
    final streamFactory =
        positionStreamFactory ??
        ((settings) =>
            Geolocator.getPositionStream(locationSettings: settings));

    StreamSubscription<Position>? activeSub;
    Timer? overallTimer;
    Timer? fallbackTimer;
    bool finished = false;
    bool usingHardware = false;
    bool isReducedAccuracy = false;
    int validSamples = 0;
    Position? bestPosition;
    GpsAnomalyReason lastAnomaly = GpsAnomalyReason.timeout;
    String? lastAnomalyMessage;

    void emitIfOpen(GpsCalibrationProgress progress) {
      if (!controller.isClosed) {
        controller.add(progress);
      }
    }

    Future<void> cleanup() async {
      overallTimer?.cancel();
      fallbackTimer?.cancel();
      overallTimer = null;
      fallbackTimer = null;
      await activeSub?.cancel();
      activeSub = null;
    }

    Future<void> finishCalibration() async {
      if (finished) return;
      finished = true;
      await cleanup();

      if (bestPosition != null) {
        emitIfOpen(
          GpsCalibrationProgress(
            samplesCollected: validSamples,
            bestPosition: bestPosition,
            bestAccuracyMeters: bestPosition!.accuracy,
            usedHardwareGps: usingHardware,
            isReducedAccuracy: isReducedAccuracy,
            statusMessage:
                'GPS terkunci dengan akurasi ±${bestPosition!.accuracy.round()} m.',
            anomalyReason: GpsAnomalyReason.none,
            isDone: true,
          ),
        );
      } else {
        final effectiveReason =
            (isReducedAccuracy && lastAnomaly == GpsAnomalyReason.lowAccuracy)
            ? GpsAnomalyReason.reducedAccuracy
            : lastAnomaly;
        emitIfOpen(
          GpsCalibrationProgress(
            samplesCollected: validSamples,
            bestPosition: null,
            bestAccuracyMeters: null,
            usedHardwareGps: usingHardware,
            isReducedAccuracy: isReducedAccuracy,
            statusMessage: lastAnomalyMessage ?? effectiveReason.userMessage,
            anomalyReason: effectiveReason,
            isDone: true,
          ),
        );
      }

      if (!controller.isClosed) {
        await controller.close();
      }
    }

    late void Function({required bool forceHardware}) startStream;

    startStream = ({required bool forceHardware}) {
      if (finished || controller.isClosed) return;
      usingHardware = forceHardware;

      final previousSub = activeSub;
      activeSub = null;
      previousSub?.cancel();

      emitIfOpen(
        GpsCalibrationProgress(
          samplesCollected: validSamples,
          bestPosition: bestPosition,
          bestAccuracyMeters: bestPosition?.accuracy,
          usedHardwareGps: usingHardware,
          isReducedAccuracy: isReducedAccuracy,
          statusMessage: usingHardware
              ? 'Beralih ke GPS satelit perangkat untuk menghindari bias jaringan...'
              : 'Mengunci sinyal satelit GPS...',
          anomalyReason: GpsAnomalyReason.none,
          isDone: false,
        ),
      );

      final settings = _buildPlatformSettings(
        accuracy: LocationAccuracy.best,
        isAndroid: isAndroid,
        forceLocationManager: forceHardware,
        distanceFilter: 0,
      );

      try {
        activeSub = streamFactory(settings).listen(
          (position) {
            if (finished) return;
            final validation = validatePosition(
              position,
              maxAccuracyMeters: maxAccuracyMeters,
            );

            if (!validation.isValid) {
              lastAnomaly = validation.reason;
              lastAnomalyMessage = validation.message;

              if (validation.reason == GpsAnomalyReason.mockLocation) {
                finishCalibration();
                return;
              }

              // Jika Fused Location di Android menyodorkan titik luar negeri,
              // segera beralih ke satelit GPS hardware.
              if (isAndroid &&
                  !usingHardware &&
                  validation.reason == GpsAnomalyReason.outsideIndonesia) {
                fallbackTimer?.cancel();
                startStream(forceHardware: true);
                return;
              }

              emitIfOpen(
                GpsCalibrationProgress(
                  samplesCollected: validSamples,
                  bestPosition: bestPosition,
                  bestAccuracyMeters: bestPosition?.accuracy,
                  usedHardwareGps: usingHardware,
                  isReducedAccuracy: isReducedAccuracy,
                  statusMessage: 'Menyaring sinyal tidak akurat, mencari kunci satelit terbaik...',
                  anomalyReason: validation.reason,
                  isDone: false,
                ),
              );
              return;
            }

            validSamples++;
            if (bestPosition == null ||
                position.accuracy <= bestPosition!.accuracy) {
              bestPosition = position;
            }

            emitIfOpen(
              GpsCalibrationProgress(
                samplesCollected: validSamples,
                bestPosition: bestPosition,
                bestAccuracyMeters: bestPosition!.accuracy,
                usedHardwareGps: usingHardware,
                isReducedAccuracy: isReducedAccuracy,
                statusMessage:
                    'Menstabilkan sinyal (sampel $validSamples, akurasi ±${bestPosition!.accuracy.round()} m)...',
                anomalyReason: GpsAnomalyReason.none,
                isDone: false,
              ),
            );

            if (validSamples >= 2 &&
                bestPosition!.accuracy <= targetAccuracyMeters) {
              finishCalibration();
            }
          },
          onError: (_) {
            if (finished) return;
            if (isAndroid && !usingHardware) {
              fallbackTimer?.cancel();
              startStream(forceHardware: true);
            } else {
              lastAnomaly = GpsAnomalyReason.timeout;
              lastAnomalyMessage = GpsAnomalyReason.timeout.userMessage;
            }
          },
        );
      } catch (_) {
        if (isAndroid && !usingHardware) {
          startStream(forceHardware: true);
        } else {
          lastAnomaly = GpsAnomalyReason.timeout;
          finishCalibration();
        }
      }
    };

    controller.onListen = () async {
      try {
        final serviceEnabled = await serviceChecker();
        if (!serviceEnabled) {
          finished = true;
          emitIfOpen(
            GpsCalibrationProgress(
              statusMessage: GpsAnomalyReason.serviceDisabled.userMessage,
              anomalyReason: GpsAnomalyReason.serviceDisabled,
              isDone: true,
            ),
          );
          await controller.close();
          return;
        }

        final permission = await permissionChecker();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          finished = true;
          emitIfOpen(
            GpsCalibrationProgress(
              statusMessage: GpsAnomalyReason.permissionDenied.userMessage,
              anomalyReason: GpsAnomalyReason.permissionDenied,
              isDone: true,
            ),
          );
          await controller.close();
          return;
        }

        try {
          final accuracyStatus = await accuracyChecker();
          isReducedAccuracy = accuracyStatus == LocationAccuracyStatus.reduced;
        } catch (_) {
          isReducedAccuracy = false;
        }

        if (controller.isClosed) return;

        overallTimer = Timer(timeout, finishCalibration);
        if (isAndroid) {
          fallbackTimer = Timer(hardwareFallbackDelay, () {
            if (finished || usingHardware) return;
            final hasGoodFix =
                bestPosition != null &&
                bestPosition!.accuracy <= fallbackTriggerAccuracyMeters;
            if (!hasGoodFix) {
              startStream(forceHardware: true);
            }
          });
        }

        startStream(forceHardware: false);
      } catch (_) {
        await finishCalibration();
      }
    };

    controller.onCancel = () async {
      finished = true;
      await cleanup();
    };

    return controller.stream;
  }
}
