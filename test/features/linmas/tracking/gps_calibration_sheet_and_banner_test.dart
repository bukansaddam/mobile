import 'dart:async';

import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/services/gps_calibration_helper.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/linmas/home/presentation/widgets/gps_anomaly_banner.dart';
import 'package:akar/features/linmas/tracking/domain/entities/tracking_entity.dart';
import 'package:akar/features/linmas/tracking/domain/usecases/send_location_usecase.dart';
import 'package:akar/features/linmas/tracking/presentation/bloc/tracking_bloc/tracking_bloc.dart';
import 'package:akar/features/linmas/tracking/presentation/widgets/gps_calibration_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSendLocationUsecase extends Fake implements SendLocationUsecase {
  final List<(double, double)> sentCoords = [];

  @override
  Future<Either<Failure, TrackingEntity>> call({
    required double latitude,
    required double longitude,
  }) async {
    sentCoords.add((latitude, longitude));
    return Right(
      TrackingEntity(success: true, message: 'Lokasi terkalibrasi terkirim'),
    );
  }
}

class _FakeBackgroundService extends Fake implements FlutterBackgroundService {
  @override
  Stream<Map<String, dynamic>?> on(String method) => const Stream.empty();

  @override
  Future<bool> isRunning() async => false;

  @override
  void invoke(String method, [Map<String, dynamic>? arg]) {}
}

Position _validPos() => Position(
  longitude: 106.8166,
  latitude: -6.2000,
  timestamp: DateTime(2026, 11, 26, 11, 30),
  accuracy: 11.0,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
  isMocked: false,
);

void main() {
  testWidgets(
    'GpsAnomalyBanner tersembunyi saat GPS normal dan muncul saat ada anomali luar negeri',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final usecase = _FakeSendLocationUsecase();
      final bloc = TrackingBloc(
        sendLocationUsecase: usecase,
        sharedPreferences: prefs,
        isDebugMode: false,
        backgroundService: _FakeBackgroundService(),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: BlocProvider<TrackingBloc>.value(
            value: bloc,
            child: const Scaffold(body: GpsAnomalyBanner()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sinyal GPS Perlu Kalibrasi'), findsNothing);

      bloc.add(
        UpdateTrackingDataEvent(
          lastSuccess: false,
          lastAnomalyCode: GpsAnomalyReason.outsideIndonesia.code,
          lastMessage: GpsAnomalyReason.outsideIndonesia.userMessage,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sinyal GPS Perlu Kalibrasi'), findsOneWidget);
      expect(find.text('Kalibrasi'), findsOneWidget);
    },
  );

  testWidgets(
    'GpsCalibrationSheet mengunci posisi akurat, mengirim via TrackingBloc, dan membersihkan anomali',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'LAST_TRACKING_ANOMALY': GpsAnomalyReason.outsideIndonesia.code,
        'LAST_TRACKING_MSG': GpsAnomalyReason.outsideIndonesia.userMessage,
        'LAST_TRACKING_SUCCESS': false,
      });
      final prefs = await SharedPreferences.getInstance();
      final usecase = _FakeSendLocationUsecase();
      final bloc = TrackingBloc(
        sendLocationUsecase: usecase,
        sharedPreferences: prefs,
        isDebugMode: false,
        backgroundService: _FakeBackgroundService(),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: BlocProvider<TrackingBloc>.value(
            value: bloc,
            child: Scaffold(
              body: GpsCalibrationSheet(
                addressResolver: (lat, lng) async =>
                    'Jl. Medan Merdeka Barat, Gambir, Jakarta Pusat',
                calibrationStreamFactory: () => Stream.fromIterable([
                  const GpsCalibrationProgress(
                    statusMessage: 'Mengunci sinyal satelit GPS...',
                  ),
                  GpsCalibrationProgress(
                    samplesCollected: 2,
                    bestPosition: _validPos(),
                    bestAccuracyMeters: 11.0,
                    usedHardwareGps: true,
                    statusMessage: 'GPS terkunci dengan akurasi ±11 m.',
                    anomalyReason: GpsAnomalyReason.none,
                    isDone: true,
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(bloc.state.hasGpsAnomaly, isTrue);

      await tester.tap(find.text('Mulai Kalibrasi GPS'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('GPS terkunci dengan akurasi ±11 m.'), findsOneWidget);
      expect(find.textContaining('GPS Satelit Perangkat'), findsOneWidget);
      expect(
        find.textContaining('Jl. Medan Merdeka Barat, Gambir, Jakarta Pusat'),
        findsWidgets,
      );
      expect(find.textContaining('-6.20000'), findsNothing);
      expect(find.textContaining('106.81660'), findsNothing);
      expect(usecase.sentCoords, equals([(-6.2000, 106.8166)]));
      expect(bloc.state.hasGpsAnomaly, isFalse);
      expect(prefs.getString('LAST_TRACKING_ANOMALY'), '');
      expect(prefs.getDouble('LAST_TRACKING_ACCURACY'), 11.0);
    },
  );

  testWidgets(
    'GpsCalibrationSheet menampilkan fallback alamat tanpa koordinat mentah saat geocoding gagal',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'LAST_TRACKING_LAT': -6.2000,
        'LAST_TRACKING_LNG': 106.8166,
        'LAST_TRACKING_SUCCESS': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final bloc = TrackingBloc(
        sendLocationUsecase: _FakeSendLocationUsecase(),
        sharedPreferences: prefs,
        isDebugMode: false,
        backgroundService: _FakeBackgroundService(),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: BlocProvider<TrackingBloc>.value(
            value: bloc,
            child: Scaffold(
              body: GpsCalibrationSheet(addressResolver: (_, _) async => null),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Alamat belum dapat dimuat (periksa koneksi internet)'),
        findsOneWidget,
      );
      expect(find.textContaining('-6.20000'), findsNothing);
      expect(find.textContaining('106.81660'), findsNothing);
    },
  );

  testWidgets(
    'GpsCalibrationSheet menampilkan tombol Pengaturan Lokasi saat GPS perangkat nonaktif',
    (tester) async {
      bool openedLocationSettings = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: GpsCalibrationSheet(
              openLocationSettings: () async {
                openedLocationSettings = true;
                return true;
              },
              calibrationStreamFactory: () => Stream.value(
                GpsCalibrationProgress(
                  statusMessage: GpsAnomalyReason.serviceDisabled.userMessage,
                  anomalyReason: GpsAnomalyReason.serviceDisabled,
                  isDone: true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mulai Kalibrasi GPS'));
      await tester.pumpAndSettle();

      expect(find.text('Buka Pengaturan Lokasi'), findsOneWidget);
      await tester.tap(find.text('Buka Pengaturan Lokasi'));
      await tester.pump();
      expect(openedLocationSettings, isTrue);
    },
  );

  testWidgets(
    'TrackingBloc & GpsAnomalyBanner bereaksi real-time saat GPS dimatikan lalu dinyalakan kembali',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final statusController = StreamController<ServiceStatus>();
      addTearDown(statusController.close);

      final bloc = TrackingBloc(
        sendLocationUsecase: _FakeSendLocationUsecase(),
        sharedPreferences: prefs,
        isDebugMode: true,
        backgroundService: _FakeBackgroundService(),
        serviceStatusStream: statusController.stream,
        isLocationServiceEnabled: () async => true,
      );
      addTearDown(bloc.close);

      bool openedSettings = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: BlocProvider<TrackingBloc>.value(
            value: bloc,
            child: Scaffold(
              body: GpsAnomalyBanner(
                openLocationSettings: () async {
                  openedSettings = true;
                  return true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Layanan GPS Nonaktif'), findsNothing);

      statusController.add(ServiceStatus.disabled);
      await tester.pumpAndSettle();

      expect(find.text('Layanan GPS Nonaktif'), findsOneWidget);
      expect(find.text('Aktifkan'), findsOneWidget);
      await tester.tap(find.text('Aktifkan'));
      await tester.pump();
      expect(openedSettings, isTrue);

      statusController.add(ServiceStatus.enabled);
      await tester.pumpAndSettle();

      expect(find.text('Layanan GPS Nonaktif'), findsNothing);
      expect(bloc.state.hasGpsAnomaly, isFalse);
    },
  );
}
