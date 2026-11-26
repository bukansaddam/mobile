import 'dart:async';

import 'package:akar/core/services/gps_calibration_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

Position _pos({
  required double lat,
  required double lng,
  double accuracy = 15.0,
  bool isMocked = false,
  DateTime? timestamp,
}) {
  return Position(
    longitude: lng,
    latitude: lat,
    timestamp: timestamp ?? DateTime(2026, 11, 26, 11, 0),
    accuracy: accuracy,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
    isMocked: isMocked,
  );
}

void main() {
  final fixedNow = DateTime(2026, 11, 26, 11, 0, 0);

  group('GpsCalibrationHelper.validatePosition', () {
    test('menerima koordinat valid di wilayah Indonesia', () {
      for (final point in [
        _pos(lat: -6.2000, lng: 106.8166, accuracy: 18), // Jakarta
        _pos(lat: 5.8932, lng: 95.3214, accuracy: 25), // Sabang
        _pos(lat: -8.4932, lng: 140.4018, accuracy: 40), // Merauke
      ]) {
        final result = GpsCalibrationHelper.validatePosition(point);
        expect(result.isValid, isTrue);
        expect(result.reason, GpsAnomalyReason.none);
      }
    });

    test('menolak koordinat luar negeri dan Null Island (0,0)', () {
      final mountainView = GpsCalibrationHelper.validatePosition(
        _pos(lat: 37.4220, lng: -122.0841),
      );
      expect(mountainView.isValid, isFalse);
      expect(mountainView.reason, GpsAnomalyReason.outsideIndonesia);

      final london = GpsCalibrationHelper.validatePosition(
        _pos(lat: 51.5074, lng: -0.1278),
      );
      expect(london.isValid, isFalse);
      expect(london.reason, GpsAnomalyReason.outsideIndonesia);

      final nullIsland = GpsCalibrationHelper.validatePosition(
        _pos(lat: 0.0, lng: 0.0),
      );
      expect(nullIsland.isValid, isFalse);
      expect(nullIsland.reason, GpsAnomalyReason.invalidCoordinates);
    });

    test('menolak lokasi palsu (mock) dan akurasi kasar (> 250m)', () {
      final mocked = GpsCalibrationHelper.validatePosition(
        _pos(lat: -6.2, lng: 106.8, isMocked: true),
      );
      expect(mocked.isValid, isFalse);
      expect(mocked.reason, GpsAnomalyReason.mockLocation);

      final coarse = GpsCalibrationHelper.validatePosition(
        _pos(lat: -6.2, lng: 106.8, accuracy: 850.0),
      );
      expect(coarse.isValid, isFalse);
      expect(coarse.reason, GpsAnomalyReason.lowAccuracy);
    });

    test('menolak lonjakan ekstrem dalam waktu singkat, tetapi meloloskan setelah > 6 jam', () {
      // Jakarta -> Jayapura (~3700 km) dalam 30 detik harus ditolak.
      final jumpBlocked = GpsCalibrationHelper.validatePosition(
        _pos(lat: -2.5337, lng: 140.7181, accuracy: 20),
        previousLat: -6.2000,
        previousLng: 106.8166,
        previousTimestamp: fixedNow.subtract(const Duration(seconds: 30)),
        now: fixedNow,
      );
      expect(jumpBlocked.isValid, isFalse);
      expect(jumpBlocked.reason, GpsAnomalyReason.impossibleJump);

      // Setelah 7 jam, perpindahan sah antar pulau diperbolehkan.
      final validFlight = GpsCalibrationHelper.validatePosition(
        _pos(lat: -2.5337, lng: 140.7181, accuracy: 20),
        previousLat: -6.2000,
        previousLng: 106.8166,
        previousTimestamp: fixedNow.subtract(const Duration(hours: 7)),
        now: fixedNow,
      );
      expect(validFlight.isValid, isTrue);
    });
  });

  group('GpsCalibrationHelper.acquireValidatedBackgroundPosition', () {
    test('di Android otomatis fallback ke hardware GPS saat Fused mengembalikan titik luar negeri', () async {
      final requestedHardwareFlags = <bool>[];
      final result =
          await GpsCalibrationHelper.acquireValidatedBackgroundPosition(
            isAndroidOverride: true,
            now: fixedNow,
            getCurrentPosition: (settings) async {
              final isHardware =
                  settings is AndroidSettings && settings.forceLocationManager;
              requestedHardwareFlags.add(isHardware);
              if (!isHardware) {
                return _pos(lat: 37.4220, lng: -122.0841, accuracy: 20);
              }
              return _pos(lat: -6.9175, lng: 107.6191, accuracy: 12);
            },
            getLastKnownPosition: () async => null,
          );

      expect(requestedHardwareFlags, equals([false, true]));
      expect(result.isValid, isTrue);
      expect(result.usedHardwareGps, isTrue);
      expect(result.position!.latitude, closeTo(-6.9175, 0.0001));
    });

    test('menolak mengirim koordinat dan tidak memakai cache jika Fused & hardware keduanya di luar negeri', () async {
      bool cacheCalled = false;
      final result =
          await GpsCalibrationHelper.acquireValidatedBackgroundPosition(
            isAndroidOverride: true,
            now: fixedNow,
            getCurrentPosition: (_) async =>
                _pos(lat: 40.7128, lng: -74.0060, accuracy: 15),
            getLastKnownPosition: () async {
              cacheCalled = true;
              return _pos(
                lat: -6.2,
                lng: 106.8,
                timestamp: fixedNow.subtract(const Duration(minutes: 1)),
              );
            },
          );

      expect(result.isValid, isFalse);
      expect(result.position, isNull);
      expect(result.validation.reason, GpsAnomalyReason.outsideIndonesia);
      expect(cacheCalled, isFalse);
    });

    test('menerima cache <= 5 menit saat live timeout, dan menolak cache basi > 5 menit', () async {
      final freshResult =
          await GpsCalibrationHelper.acquireValidatedBackgroundPosition(
            isAndroidOverride: false,
            now: fixedNow,
            getCurrentPosition: (_) async => throw TimeoutException('timeout'),
            getLastKnownPosition: () async => _pos(
              lat: -6.2,
              lng: 106.8,
              accuracy: 25,
              timestamp: fixedNow.subtract(const Duration(minutes: 2)),
            ),
          );
      expect(freshResult.isValid, isTrue);

      final staleResult =
          await GpsCalibrationHelper.acquireValidatedBackgroundPosition(
            isAndroidOverride: false,
            now: fixedNow,
            getCurrentPosition: (_) async => throw TimeoutException('timeout'),
            getLastKnownPosition: () async => _pos(
              lat: -6.2,
              lng: 106.8,
              accuracy: 25,
              timestamp: fixedNow.subtract(const Duration(minutes: 10)),
            ),
          );
      expect(staleResult.isValid, isFalse);
      expect(staleResult.validation.reason, GpsAnomalyReason.timeout);
    });

    test('menggunakan preCapturedPosition yang valid langsung tanpa memanggil getCurrentPosition', () async {
      int fetchCount = 0;
      final result =
          await GpsCalibrationHelper.acquireValidatedBackgroundPosition(
            preCapturedPosition: _pos(lat: -6.2, lng: 106.8, accuracy: 14),
            isAndroidOverride: false,
            getCurrentPosition: (_) async {
              fetchCount++;
              return _pos(lat: -6.2, lng: 106.8);
            },
          );

      expect(result.isValid, isTrue);
      expect(fetchCount, 0);
    });
  });

  group('GpsCalibrationHelper.calibrateStream', () {
    test(
      'langsung gagal dengan serviceDisabled bila GPS perangkat mati',
      () async {
        final events = await GpsCalibrationHelper.calibrateStream(
          isLocationServiceEnabled: () async => false,
          checkPermission: () async => LocationPermission.always,
        ).toList();

        expect(events.last.isDone, isTrue);
        expect(events.last.isSuccess, isFalse);
        expect(events.last.anomalyReason, GpsAnomalyReason.serviceDisabled);
      },
    );

    test('beralih ke hardware GPS di Android saat Fused mengirim titik luar negeri lalu mengunci akurasi <= 25m', () async {
      final streamModes = <bool>[];
      final events = await GpsCalibrationHelper.calibrateStream(
        timeout: const Duration(seconds: 3),
        hardwareFallbackDelay: const Duration(seconds: 2),
        isAndroidOverride: true,
        isLocationServiceEnabled: () async => true,
        checkPermission: () async => LocationPermission.always,
        getLocationAccuracy: () async => LocationAccuracyStatus.precise,
        positionStreamFactory: (settings) {
          final isHardware =
              settings is AndroidSettings && settings.forceLocationManager;
          streamModes.add(isHardware);
          if (!isHardware) {
            return Stream.value(
              _pos(lat: 37.4220, lng: -122.0841, accuracy: 15),
            );
          }
          return Stream.fromIterable([
            _pos(lat: -6.2001, lng: 106.8165, accuracy: 30),
            _pos(lat: -6.2000, lng: 106.8166, accuracy: 12),
          ]);
        },
      ).toList();

      expect(streamModes, equals([false, true]));
      expect(events.last.isDone, isTrue);
      expect(events.last.isSuccess, isTrue);
      expect(events.last.usedHardwareGps, isTrue);
      expect(events.last.bestAccuracyMeters, 12.0);
    });
  });
}
