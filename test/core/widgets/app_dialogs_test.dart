import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/linmas/analisis/presentation/widgets/bank_sampah_analisis_card.dart';
import 'package:akar/features/masyarakat/home/presentation/widgets/disaster_alert_banner.dart';
import 'package:akar/features/masyarakat/notification/presentation/widgets/emergency_disaster_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeAudioAlarmService extends Fake implements AudioAlarmService {
  bool _isPlaying = true;

  @override
  bool get isPlaying => _isPlaying;

  @override
  Future<void> startEmergencyAlarm() async {
    _isPlaying = true;
  }

  @override
  Future<void> stopAlarm() async {
    _isPlaying = false;
  }
}

class _FakeDisasterAlertService extends Fake implements DisasterAlertService {
  bool delayedTriggered = false;

  @override
  Future<void> triggerDelayedBackgroundDisaster({
    int delaySeconds = 8,
    String type = 'Gempa Bumi Tektonik',
    double magnitude = 6.4,
    String location = 'Kab. Cianjur, Jawa Barat',
  }) async {
    delayedTriggered = true;
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  group('AppDialogs Core Tests', () {
    testWidgets(
      'showSuccess renders bottom floating surface radius 32 with BackdropFilter and survives 320x640 200% text scale',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.binding.setSurfaceSize(const Size(320, 640));
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;

        bool primaryCalled = false;
        bool secondaryCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      AppDialogs.showSuccess<void>(
                        context,
                        title: 'Laporan Berhasil',
                        message: 'Data laporan telah terkirim dengan aman dan sedang menunggu verifikasi petugas lapangan.',
                        buttonText: 'Selesai',
                        onPressed: () => primaryCalled = true,
                        secondaryButtonText: 'Lihat Detail',
                        onSecondaryPressed: () => secondaryCalled = true,
                        customContent: const Text('Nomor Tiket: JGT-001'),
                      );
                    },
                    child: const Text('Buka'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Buka'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(BackdropFilter), findsWidgets);
        expect(find.text('Laporan Berhasil'), findsOneWidget);
        expect(find.text('Nomor Tiket: JGT-001'), findsOneWidget);

        final align = tester.widget<Align>(
          find
              .ancestor(
                of: find.text('Laporan Berhasil'),
                matching: find.byType(Align),
              )
              .last,
        );
        expect(align.alignment, Alignment.bottomCenter);

        final surface = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('Laporan Berhasil'),
                matching: find.byWidgetPredicate((widget) {
                  if (widget is! Container) return false;
                  final decoration = widget.decoration;
                  return decoration is BoxDecoration &&
                      decoration.borderRadius == BorderRadius.circular(32);
                }),
              )
              .first,
        );
        expect(surface.decoration, isA<BoxDecoration>());

        await tester.tap(find.text('Selesai'));
        await tester.pumpAndSettle();
        expect(primaryCalled, isTrue);
        expect(secondaryCalled, isFalse);
      },
    );

    testWidgets(
      'showConfirmation calls onCancel exactly once on cancel tap and on barrier dismiss, and calls onConfirm on confirm tap',
      (tester) async {
        int cancelCount = 0;
        int confirmCount = 0;
        bool? latestResult;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      latestResult = await AppDialogs.showConfirmation(
                        context,
                        title: 'Hapus data?',
                        message: 'Tindakan ini tidak dapat dibatalkan.',
                        confirmText: 'Hapus',
                        cancelText: 'Batal',
                        isDestructive: true,
                        onConfirm: () => confirmCount++,
                        onCancel: () => cancelCount++,
                      );
                    },
                    child: const Text('Konfirmasi'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Konfirmasi'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Batal'));
        await tester.pumpAndSettle();
        expect(latestResult, isFalse);
        expect(cancelCount, 1);
        expect(confirmCount, 0);

        await tester.tap(find.text('Konfirmasi'));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
        expect(latestResult, isFalse);
        expect(cancelCount, 2);
        expect(confirmCount, 0);

        await tester.tap(find.text('Konfirmasi'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Hapus'));
        await tester.pumpAndSettle();
        expect(latestResult, isTrue);
        expect(confirmCount, 1);
        expect(cancelCount, 2);
      },
    );

    testWidgets(
      'showLoading renders blocking spinner card, ignores barrier tap, and closes via rootNavigator',
      (tester) async {
        late BuildContext capturedContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                capturedContext = context;
                return Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        AppDialogs.showLoading(
                          context,
                          message: 'Mengompres video...',
                        );
                      },
                      child: const Text('Loading'),
                    ),
                  ),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Loading'));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Mengompres video...'), findsOneWidget);

        final popScope = tester.widget<PopScope>(
          find
              .ancestor(
                of: find.text('Mengompres video...'),
                matching: find.byType(PopScope),
              )
              .first,
        );
        expect(popScope.canPop, isFalse);

        await tester.tapAt(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('Mengompres video...'), findsOneWidget);

        Navigator.of(capturedContext, rootNavigator: true).pop();
        await tester.pumpAndSettle();
        expect(find.text('Mengompres video...'), findsNothing);
      },
    );

    testWidgets(
      'showCustom supports generic return value and useCardDecoration toggle',
      (tester) async {
        DateTime? pickedDate;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        pickedDate = await AppDialogs.showCustom<DateTime>(
                          context,
                          builder: (dialogContext) => TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, DateTime(2026, 5)),
                            child: const Text('Pilih Mei'),
                          ),
                        );
                      },
                      child: const Text('Custom Decorated'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        AppDialogs.showCustom<void>(
                          context,
                          useCardDecoration: false,
                          canPop: false,
                          builder: (dialogContext) => Container(
                            color: AppColors.error,
                            padding: const EdgeInsets.all(12),
                            child: TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Tutup Raw'),
                            ),
                          ),
                        );
                      },
                      child: const Text('Custom Undecorated'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Custom Decorated'));
        await tester.pumpAndSettle();
        expect(
          find.byWidgetPredicate((widget) {
            if (widget is! Container) return false;
            final decoration = widget.decoration;
            return decoration is BoxDecoration &&
                decoration.borderRadius == BorderRadius.circular(32);
          }),
          findsOneWidget,
        );
        await tester.tap(find.text('Pilih Mei'));
        await tester.pumpAndSettle();
        expect(pickedDate, DateTime(2026, 5));

        await tester.tap(find.text('Custom Undecorated'));
        await tester.pumpAndSettle();
        expect(
          find.byWidgetPredicate((widget) {
            if (widget is! Container) return false;
            final decoration = widget.decoration;
            return decoration is BoxDecoration &&
                decoration.borderRadius == BorderRadius.circular(32);
          }),
          findsNothing,
        );
        await tester.tap(find.text('Tutup Raw'));
        await tester.pumpAndSettle();
      },
    );
  });

  group('Migrated Feature Dialog Integration Tests', () {
    testWidgets(
      'EmergencyDisasterDialog displays in floating shell with canPop false, mute toggle, and dismiss',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(390, 844));

        final fakeAudio = _FakeAudioAlarmService();
        if (sl.isRegistered<AudioAlarmService>()) {
          await sl.unregister<AudioAlarmService>();
        }
        sl.registerSingleton<AudioAlarmService>(fakeAudio);
        addTearDown(() async {
          if (sl.isRegistered<AudioAlarmService>()) {
            await sl.unregister<AudioAlarmService>();
          }
        });

        final event = DisasterAlertEvent(
          id: 'ALT-1',
          title: 'Gempa Bumi M 6.2',
          type: 'Gempa Bumi',
          description: 'Guncangan terasa kuat di wilayah Cianjur.',
          location: 'Kab. Cianjur',
          severity: DisasterSeverity.critical,
          timestamp: DateTime(2026, 11, 23, 13, 0),
          magnitude: 6.2,
          recommendedAction: 'Menjauh dari bangunan bertingkat.',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        EmergencyDisasterDialog.show(context, event),
                    child: const Text('Trigger Emergency'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger Emergency'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(BackdropFilter), findsWidgets);
        expect(find.text('PERINGATAN DARURAT'), findsOneWidget);
        expect(find.text('Matikan Dering'), findsOneWidget);

        final popScope = tester.widget<PopScope>(
          find
              .ancestor(
                of: find.text('PERINGATAN DARURAT'),
                matching: find.byType(PopScope),
              )
              .first,
        );
        expect(popScope.canPop, isFalse);

        await tester.tap(find.text('Matikan Dering'));
        await tester.pump();
        expect(fakeAudio.isPlaying, isFalse);
        expect(find.text('Bunyikan Lagi'), findsOneWidget);

        await tester.tap(find.text('Saya Aman'));
        await tester.pumpAndSettle();
        expect(find.text('PERINGATAN DARURAT'), findsNothing);
      },
    );

    testWidgets(
      'CountdownTestDialog renders inside floating dialog and cancels timer on dismiss',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(390, 844));

        final fakeDisaster = _FakeDisasterAlertService();
        if (sl.isRegistered<DisasterAlertService>()) {
          await sl.unregister<DisasterAlertService>();
        }
        sl.registerSingleton<DisasterAlertService>(fakeDisaster);
        addTearDown(() async {
          if (sl.isRegistered<DisasterAlertService>()) {
            await sl.unregister<DisasterAlertService>();
          }
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => CountdownTestDialog.show(context),
                    child: const Text('Trigger Countdown'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger Countdown'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(fakeDisaster.delayedTriggered, isTrue);
        expect(find.byType(BackdropFilter), findsWidgets);
        expect(find.text('MINIMIZE APLIKASI SEKARANG'), findsOneWidget);
        expect(find.text('SIAP, SAYA MINIMIZE SEKARANG'), findsOneWidget);

        await tester.tap(find.text('SIAP, SAYA MINIMIZE SEKARANG'));
        await tester.pumpAndSettle();
        expect(find.text('MINIMIZE APLIKASI SEKARANG'), findsNothing);
      },
    );

    testWidgets(
      'BankSampahAnalisisCard opens month picker in floating dialog and selects month',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: BankSampahAnalisisCard(reports: []),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Bulanan'));
        await tester.pumpAndSettle();

        expect(find.text('Ubah'), findsOneWidget);
        await tester.tap(find.text('Ubah'));
        await tester.pumpAndSettle();

        expect(find.byType(BackdropFilter), findsWidgets);
        expect(find.text('Januari'), findsOneWidget);
        expect(find.text('Batal'), findsOneWidget);

        await tester.tap(find.text('Januari'));
        await tester.pumpAndSettle();

        expect(find.text('Januari'), findsNothing);
        expect(
          find.text('Periode: Januari ${DateTime.now().year}'),
          findsOneWidget,
        );
      },
    );
  });
}
