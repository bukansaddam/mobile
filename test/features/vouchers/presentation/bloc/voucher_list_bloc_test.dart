import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_page_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_summary_entity.dart';
import 'package:akar/features/vouchers/domain/repositories/voucher_repository.dart';
import 'package:akar/features/vouchers/domain/usecases/get_my_vouchers_usecase.dart';
import 'package:akar/features/vouchers/presentation/bloc/voucher_list_bloc/voucher_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeVoucherRepository implements VoucherRepository {
  Either<Failure, VoucherPageEntity>? getMyVouchersResponse;

  @override
  Future<Either<Failure, VoucherPageEntity>> getMyVouchers({
    VoucherStatus? status,
    int page = 1,
    int perPage = 20,
  }) async {
    return getMyVouchersResponse ??
        const Right(
          VoucherPageEntity(
            items: [],
            currentPage: 1,
            lastPage: 1,
            perPage: 20,
            total: 0,
            summary: VoucherSummaryEntity(
              currentPoints: 100,
              voucherPointCost: 100,
              canRedeem: true,
              redeemableCount: 1,
            ),
          ),
        );
  }

  @override
  Future<Either<Failure, RedeemVoucherResultEntity>> redeemVoucher({
    String? notes,
    required String idempotencyKey,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  group('VoucherListBloc Tests', () {
    late _FakeVoucherRepository fakeRepo;
    late GetMyVouchersUsecase getMyVouchers;
    late VoucherListBloc bloc;

    setUp(() {
      fakeRepo = _FakeVoucherRepository();
      getMyVouchers = GetMyVouchersUsecase(fakeRepo);
      bloc = VoucherListBloc(getMyVouchers: getMyVouchers);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has correct default values', () {
      expect(bloc.state.historyFilter, VoucherStatus.used);
      expect(bloc.state.activeBucket.items, isEmpty);
      expect(bloc.state.summary, isNull);
      expect(bloc.state.displayedPoints, 0);
    });

    test(
      'SetInitialPointsEvent updates displayedPoints before summary arrives',
      () {
        bloc.add(const SetInitialPointsEvent(250));
        expectLater(
          bloc.stream,
          emits(
            predicate<VoucherListState>((state) {
              return state.initialPointsFallback == 250 &&
                  state.displayedPoints == 250;
            }),
          ),
        );
      },
    );

    test(
      'FetchVouchersEvent succeeds and populates bucket and summary',
      () async {
        fakeRepo.getMyVouchersResponse = Right(
          VoucherPageEntity(
            items: [
              VoucherEntity(
                id: 1,
                code: 'VCR-001',
                pointsSpent: 100,
                status: VoucherStatus.active,
                redeemedAt: DateTime.now(),
              ),
            ],
            currentPage: 1,
            lastPage: 2,
            perPage: 20,
            total: 1,
            summary: const VoucherSummaryEntity(
              currentPoints: 300,
              voucherPointCost: 100,
              canRedeem: true,
              redeemableCount: 3,
            ),
          ),
        );

        bloc.add(const FetchVouchersEvent(status: VoucherStatus.active));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<VoucherListState>((s) => s.activeBucket.isInitialLoading),
            predicate<VoucherListState>((s) {
              return s.activeBucket.items.length == 1 &&
                  s.activeBucket.items.first.code == 'VCR-001' &&
                  s.activeBucket.hasLoaded &&
                  !s.activeBucket.isInitialLoading &&
                  s.summary?.currentPoints == 300 &&
                  s.displayedPoints == 300;
            }),
          ]),
        );
      },
    );

    test('FetchVouchersEvent emits errorMessage on failure', () async {
      fakeRepo.getMyVouchersResponse = const Left(
        ServerFailure('Server tidak merespon'),
      );

      bloc.add(const FetchVouchersEvent(status: VoucherStatus.active));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<VoucherListState>((s) => s.activeBucket.isInitialLoading),
          predicate<VoucherListState>((s) {
            return s.activeBucket.errorMessage == 'Server tidak merespon' &&
                !s.activeBucket.isInitialLoading;
          }),
        ]),
      );
    });

    test(
      'SyncVoucherAfterRedeemEvent prepends new voucher and reduces points',
      () {
        final newVoucher = VoucherEntity(
          id: 99,
          code: 'VCR-NEW',
          pointsSpent: 100,
          status: VoucherStatus.active,
          redeemedAt: DateTime.now(),
        );

        bloc.add(
          SyncVoucherAfterRedeemEvent(
            RedeemVoucherResultEntity(
              voucher: newVoucher,
              pointsSpent: 100,
              remainingPoints: 50,
              message: 'Sukses',
            ),
          ),
        );

        expectLater(
          bloc.stream,
          emits(
            predicate<VoucherListState>((s) {
              return s.activeBucket.items.first.id == 99 &&
                  s.summary?.currentPoints == 50 &&
                  s.summary?.canRedeem == false &&
                  s.summary?.pointsNeeded == 50;
            }),
          ),
        );
      },
    );

    test('ChangeHistoryFilterEvent switches filter and triggers fetch when not loaded', () async {
      bloc.add(const ChangeHistoryFilterEvent(VoucherStatus.expired));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<VoucherListState>(
            (s) => s.historyFilter == VoucherStatus.expired,
          ),
          predicate<VoucherListState>((s) => s.expiredBucket.isInitialLoading),
          predicate<VoucherListState>((s) => s.expiredBucket.hasLoaded),
        ]),
      );
    });
  });
}
