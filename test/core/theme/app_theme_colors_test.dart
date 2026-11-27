import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_alarm_service.dart';
import 'package:akar/core/services/disaster_alert_service.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_report_entity.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/widgets/bank_sampah_card.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/widgets/jaga_tanah_status_view.dart';
import 'package:akar/features/linmas/laporan_insidentil/presentation/widgets/laporan_insidentil_status_view.dart';
import 'package:akar/features/linmas/panic/presentation/widgets/panic_bottom_panel.dart';
import 'package:akar/features/masyarakat/complaint/presentation/models/complaint_item.dart';
import 'package:akar/features/masyarakat/notification/presentation/widgets/emergency_disaster_dialog.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_empty_view.dart';
import 'package:akar/features/notifications/presentation/widgets/notification_error_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

class _TestAudioAlarmService extends Fake implements AudioAlarmService {
  @override
  bool get isPlaying => false;

  @override
  Future<void> stopAlarm() async {}
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });
  double contrastRatio(Color a, Color b) {
    final l1 = a.computeLuminance();
    final l2 = b.computeLuminance();
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  group('AppColors Semantic Companion Tokens', () {
    test(
      'defines semantic companion error & warning tokens with AA contrast',
      () {
        expect(AppColors.errorDark, const Color(0xFF991B1B));
        expect(AppColors.errorBorder, const Color(0xFFFCA5A5));
        expect(AppColors.warningDark, const Color(0xFF92400E));
        expect(AppColors.warningBorder, const Color(0xFFFDE68A));

        expect(
          contrastRatio(AppColors.warningDark, AppColors.warningLight),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrastRatio(AppColors.errorDark, AppColors.errorLight),
          greaterThanOrEqualTo(4.5),
        );
      },
    );
  });

  group('AppTheme Unified Button & FAB Theme', () {
    test('aligns ElevatedButton, FilledButton, OutlinedButton, TextButton, and FAB to AppColors.primary', () {
      final theme = AppTheme.lightTheme;

      expect(
        theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        theme.filledButtonTheme.style?.backgroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.filledButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.white,
      );
      expect(
        theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.textButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.floatingActionButtonTheme.backgroundColor,
        AppColors.primary,
      );
      expect(theme.floatingActionButtonTheme.foregroundColor, AppColors.white);
    });
  });

  group('Task 2 Primary CTA & Status Views Alignment', () {
    testWidgets(
      'NotificationEmptyView, NotificationErrorView, JagaTanahStatusView, and LaporanInsidentilStatusView use AppColors.primary',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationEmptyView(
                unreadOnlyFilter: true,
                onShowAll: () {},
              ),
            ),
          ),
        );
        final emptyBtn = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(emptyBtn.style?.backgroundColor?.resolve({}), AppColors.primary);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationErrorView(message: 'Gagal', onRetry: () {}),
            ),
          ),
        );
        final errorBtn = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(errorBtn.style?.backgroundColor?.resolve({}), AppColors.primary);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: JagaTanahStatusView(
                icon: Icons.landscape_rounded,
                iconColor: AppColors.primary,
                iconBackgroundColor: AppColors.primaryLight,
                title: 'Kosong',
                message: 'Belum ada data',
                actionLabel: 'Buat Laporan',
                onAction: () {},
              ),
            ),
          ),
        );
        final jgBtn = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(jgBtn.style?.backgroundColor?.resolve({}), AppColors.primary);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LaporanInsidentilStatusView(
                icon: Icons.report_problem_rounded,
                iconColor: AppColors.primary,
                iconBackgroundColor: AppColors.primaryLight,
                title: 'Kosong',
                message: 'Belum ada data',
                actionLabel: 'Coba Lagi',
                onAction: () {},
              ),
            ),
          ),
        );
        final liBtn = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(liBtn.style?.backgroundColor?.resolve({}), AppColors.primary);
      },
    );
  });

  group('Task 3 Panic & Emergency Semantic Button Alignment', () {
    testWidgets(
      'PanicBottomPanel deactivate button uses AppColors.primary and EmergencyDisasterDialog Saya Aman uses AppColors.grey300 and AppColors.secondary',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PanicBottomPanel(
                fullAddress: 'Jl. Merdeka No. 1',
                isEmergencyActive: true,
                isActionLoading: false,
                tapCount: 3,
                isExpanded: false,
                filteredMembers: const [],
                filteredLeaders: const [],
                onToggleExpanded: () {},
                onEmergencyButtonPressed: () {},
                onDeactivateButtonPressed: () {},
              ),
            ),
          ),
        );

        final deactivateBtn = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'MATIKAN SINYAL SOS'),
        );
        expect(
          deactivateBtn.style?.backgroundColor?.resolve({}),
          AppColors.primary,
        );
        expect(
          deactivateBtn.style?.foregroundColor?.resolve({}),
          AppColors.white,
        );

        if (sl.isRegistered<AudioAlarmService>()) {
          await sl.unregister<AudioAlarmService>();
        }
        sl.registerSingleton<AudioAlarmService>(_TestAudioAlarmService());
        addTearDown(() async {
          if (sl.isRegistered<AudioAlarmService>()) {
            await sl.unregister<AudioAlarmService>();
          }
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmergencyDisasterDialog(
                event: DisasterAlertEvent(
                  id: 'ALT-T3',
                  title: 'Peringatan Uji',
                  type: 'Gempa',
                  description: 'Deskripsi singkat',
                  location: 'Cianjur',
                  severity: DisasterSeverity.critical,
                  timestamp: DateTime(2026, 11, 23, 13, 0),
                ),
              ),
            ),
          ),
        );

        final safeBtn = tester.widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'Saya Aman'),
        );
        expect(safeBtn.style?.side?.resolve({})?.color, AppColors.grey300);
        final safeLabel = tester.widget<Text>(find.text('Saya Aman'));
        expect(safeLabel.style?.color, AppColors.secondary);
      },
    );
  });

  group('Task 4 ComplaintStatus Semantic Token Mapping', () {
    test(
      'uses standardized AppColors status tokens across ComplaintStatus',
      () {
        expect(ComplaintStatus.pending.textColor, AppColors.warning);
        expect(ComplaintStatus.pending.bgColor, AppColors.warningLight);
        expect(ComplaintStatus.verified.textColor, AppColors.info);
        expect(ComplaintStatus.verified.bgColor, AppColors.infoLight);
        expect(ComplaintStatus.rejected.textColor, AppColors.error);
        expect(ComplaintStatus.rejected.bgColor, AppColors.errorLight);
        expect(ComplaintStatus.completed.textColor, AppColors.success);
        expect(ComplaintStatus.completed.bgColor, AppColors.successLight);
      },
    );
  });

  group('Task 5 BankSampahCard Semantic Category & Status Tokens', () {
    testWidgets(
      'maps category icons and status labels to standardized AppColors tokens',
      (tester) async {
        final cases = <(String, String, String, Color, Color)>[
          (
            'Organik',
            'verified',
            'Terverifikasi',
            AppColors.primary,
            AppColors.success,
          ),
          ('Anorganik', 'pending', 'Menunggu', AppColors.info, AppColors.earth),
          (
            'Kardus',
            'rejected',
            'Ditolak',
            AppColors.warning,
            AppColors.errorDark,
          ),
          (
            'Plastik Kemasan',
            'verified',
            'Terverifikasi',
            AppColors.error,
            AppColors.success,
          ),
        ];

        for (final (jenis, status, statusLabel, expectedCat, expectedStatus)
            in cases) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BankSampahCard(
                  report: BankSampahReportEntity(
                    id: 'id-$jenis',
                    bankSampahNama: 'Bank Sampah Uji',
                    jenisSampah: jenis,
                    beratKg: 2.0,
                    nilaiRupiah: 10000,
                    status: status,
                    statusLabel: statusLabel,
                    createdAt: DateTime(2026, 11, 23),
                  ),
                ),
              ),
            ),
          );

          final catIcon = tester.widget<Icon>(
            find.byWidgetPredicate(
              (w) =>
                  w is Icon &&
                  (w.icon == Icons.eco_rounded ||
                      w.icon == Icons.recycling_rounded ||
                      w.icon == Icons.inventory_2_rounded ||
                      w.icon == Icons.shopping_bag_rounded),
            ),
          );
          expect(catIcon.color, expectedCat);

          final statusText = tester.widget<Text>(find.text(statusLabel));
          expect(statusText.style?.color, expectedStatus);
        }
      },
    );
  });
}
