import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/theme/app_theme.dart';
import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_page_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_summary_entity.dart';
import 'package:akar/features/vouchers/domain/repositories/voucher_repository.dart';
import 'package:akar/features/vouchers/domain/usecases/get_my_vouchers_usecase.dart';
import 'package:akar/features/vouchers/domain/usecases/redeem_voucher_usecase.dart';
import 'package:akar/features/vouchers/presentation/bloc/redeem_voucher_bloc/redeem_voucher_bloc.dart';
import 'package:akar/features/vouchers/presentation/bloc/voucher_list_bloc/voucher_list_bloc.dart';
import 'package:akar/features/vouchers/presentation/pages/voucher_page.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_card.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_detail_dialog.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_redeem_dialog.dart';
import 'package:akar/features/vouchers/presentation/widgets/voucher_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeVoucherRepository implements VoucherRepository {
  final Map<VoucherStatus, List<VoucherEntity>> data = {
    VoucherStatus.active: [
      VoucherEntity(
        id: 101,
        code: 'VCR-AKTIF-01',
        pointsSpent: 100,
        status: VoucherStatus.active,
        notes: 'Voucher sembako beras',
        redeemedAt: DateTime(2026, 11, 23, 10, 0),
      ),
    ],
    VoucherStatus.used: [
      VoucherEntity(
        id: 201,
        code: 'VCR-USED-01',
        pointsSpent: 100,
        status: VoucherStatus.used,
        notes: 'Sudah dipakai di posko',
        redeemedAt: DateTime(2026, 11, 20, 9, 0),
        usedAt: DateTime(2026, 11, 21, 14, 0),
      ),
    ],
    VoucherStatus.expired: [
      VoucherEntity(
        id: 301,
        code: 'VCR-EXP-01',
        pointsSpent: 100,
        status: VoucherStatus.expired,
        notes: null,
        redeemedAt: DateTime(2026, 10, 1, 8, 0),
      ),
    ],
  };

  int points = 250;

  @override
  Future<Either<Failure, VoucherPageEntity>> getMyVouchers({
    VoucherStatus? status,
    int page = 1,
    int perPage = 20,
  }) async {
    final s = status ?? VoucherStatus.active;
    final list = data[s] ?? [];
    return Right(
      VoucherPageEntity(
        items: list,
        currentPage: page,
        lastPage: 1,
        perPage: perPage,
        total: list.length,
        summary: VoucherSummaryEntity(
          currentPoints: points,
          voucherPointCost: 100,
          canRedeem: points >= 100,
          redeemableCount: points ~/ 100,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, RedeemVoucherResultEntity>> redeemVoucher({
    String? notes,
    required String idempotencyKey,
  }) async {
    points -= 100;
    final newVoucher = VoucherEntity(
      id: 999,
      code: 'VCR-NEW-999',
      pointsSpent: 100,
      status: VoucherStatus.active,
      notes: notes,
      redeemedAt: DateTime(2026, 11, 23, 11, 30),
    );
    data[VoucherStatus.active]!.insert(0, newVoucher);
    return Right(
      RedeemVoucherResultEntity(
        voucher: newVoucher,
        pointsSpent: 100,
        remainingPoints: points,
        message: 'Voucher berhasil ditukar dengan 100 poin.',
      ),
    );
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  group('VoucherPage Widget & Integration Tests', () {
    late _FakeVoucherRepository fakeRepo;
    late GetMyVouchersUsecase getMyVouchers;
    late RedeemVoucherUsecase redeemVoucher;

    setUp(() {
      fakeRepo = _FakeVoucherRepository();
      getMyVouchers = GetMyVouchersUsecase(fakeRepo);
      redeemVoucher = RedeemVoucherUsecase(fakeRepo);
    });

    Widget createTestWidget({
      ThemeMode mode = ThemeMode.light,
      double textScale = 1.0,
      Size size = const Size(390, 844),
    }) {
      final listBloc = VoucherListBloc(getMyVouchers: getMyVouchers);
      final redeemBloc = RedeemVoucherBloc(redeemVoucher: redeemVoucher);

      return MediaQuery(
        data: MediaQueryData(
          size: size,
          textScaler: TextScaler.linear(textScale),
        ),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: VoucherPage(
            initialPoints: 250,
            isOfficer: true,
            voucherListBloc: listBloc,
            redeemVoucherBloc: redeemBloc,
          ),
        ),
      );
    }

    testWidgets('renders VoucherPage in Light and Dark mode without errors', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget(mode: ThemeMode.light));
      await tester.pumpAndSettle();

      expect(find.text('Poin & Voucher'), findsOneWidget);
      expect(find.byType(VoucherSummaryCard), findsOneWidget);
      expect(find.text('250 Poin'), findsWidgets);
      expect(find.text('VCR-AKTIF-01'), findsOneWidget);

      await tester.pumpWidget(createTestWidget(mode: ThemeMode.dark));
      await tester.pumpAndSettle();
      expect(find.text('Poin & Voucher'), findsOneWidget);
    });

    testWidgets('switches between Aktif and Riwayat tabs and filters', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('VCR-AKTIF-01'), findsOneWidget);

      // Switch to Riwayat tab
      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle();

      expect(find.text('VCR-USED-01'), findsOneWidget);

      // Switch to Kedaluwarsa sub-filter
      await tester.tap(find.text('Kedaluwarsa'));
      await tester.pumpAndSettle();

      expect(find.text('VCR-EXP-01'), findsOneWidget);
    });

    testWidgets('tapping card opens VoucherDetailDialog', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(VoucherCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(VoucherDetailDialog), findsOneWidget);
      expect(find.text('KODE VOUCHER'), findsOneWidget);
      expect(find.text('VCR-AKTIF-01'), findsWidgets);

      await tester.ensureVisible(find.text('Tutup'));
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      expect(find.byType(VoucherDetailDialog), findsNothing);
    });

    testWidgets('redeem flow: opens dialog, submits, shows success dialog and updates points', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Tukar 100 Poin button
      await tester.tap(find.text('Tukar 100 Poin'));
      await tester.pumpAndSettle();

      expect(find.byType(VoucherRedeemDialog), findsOneWidget);
      expect(find.text('Tukar Poin ke Voucher'), findsOneWidget);

      // Enter notes
      await tester.enterText(find.byType(TextField), 'Untuk beli sembako');
      await tester.pump();

      // Tap Tukar Sekarang
      await tester.ensureVisible(find.text('Tukar Sekarang'));
      await tester.tap(find.text('Tukar Sekarang'));
      await tester.pumpAndSettle();

      // Success dialog appears
      expect(find.byType(VoucherDetailDialog), findsOneWidget);
      expect(find.text('Voucher Berhasil Ditukar'), findsOneWidget);
      expect(find.text('VCR-NEW-999'), findsWidgets);

      // Close dialog
      await tester.ensureVisible(find.text('Tutup'));
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();

      // New voucher is on list and points reduced
      expect(find.text('VCR-NEW-999'), findsOneWidget);
      expect(find.text('150 Poin'), findsWidgets);
    });

    testWidgets('responsive check on narrow screen 320x640 with 200% text scale has zero overflow', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createTestWidget(
          size: const Size(320, 640),
          textScale: 2.0,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
