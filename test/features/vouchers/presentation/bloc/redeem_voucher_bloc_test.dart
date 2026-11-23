import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/vouchers/domain/entities/redeem_voucher_result_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_page_entity.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:akar/features/vouchers/domain/repositories/voucher_repository.dart';
import 'package:akar/features/vouchers/domain/usecases/redeem_voucher_usecase.dart';
import 'package:akar/features/vouchers/presentation/bloc/redeem_voucher_bloc/redeem_voucher_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRedeemRepository implements VoucherRepository {
  Either<Failure, RedeemVoucherResultEntity>? redeemResponse;
  String? capturedNotes;
  String? capturedKey;

  @override
  Future<Either<Failure, VoucherPageEntity>> getMyVouchers({
    VoucherStatus? status,
    int page = 1,
    int perPage = 20,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, RedeemVoucherResultEntity>> redeemVoucher({
    String? notes,
    required String idempotencyKey,
  }) async {
    capturedNotes = notes;
    capturedKey = idempotencyKey;
    return redeemResponse ??
        Right(
          RedeemVoucherResultEntity(
            voucher: VoucherEntity(
              id: 1,
              code: 'VCR-SUCCESS',
              pointsSpent: 100,
              status: VoucherStatus.active,
              redeemedAt: DateTime.now(),
            ),
            pointsSpent: 100,
            remainingPoints: 50,
            message: 'Berhasil ditukar',
          ),
        );
  }
}

void main() {
  group('RedeemVoucherBloc Tests', () {
    late _FakeRedeemRepository fakeRepo;
    late RedeemVoucherUsecase redeemVoucher;
    late RedeemVoucherBloc bloc;

    setUp(() {
      fakeRepo = _FakeRedeemRepository();
      redeemVoucher = RedeemVoucherUsecase(fakeRepo);
      bloc = RedeemVoucherBloc(redeemVoucher: redeemVoucher);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is RedeemVoucherInitial', () {
      expect(bloc.state, const RedeemVoucherInitial());
    });

    test('SubmitRedeemVoucherEvent generates uuid key and emits Submitting then Success', () async {
      bloc.add(const SubmitRedeemVoucherEvent(notes: 'Catatan sembako'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const RedeemVoucherSubmitting(),
          predicate<RedeemVoucherState>((state) {
            return state is RedeemVoucherSuccess &&
                state.result.voucher.code == 'VCR-SUCCESS' &&
                state.result.remainingPoints == 50;
          }),
        ]),
      );

      expect(fakeRepo.capturedNotes, 'Catatan sembako');
      expect(fakeRepo.capturedKey, isNotNull);
      expect(fakeRepo.capturedKey?.length, 36);
    });

    test('SubmitRedeemVoucherEvent emits Failure on error', () async {
      fakeRepo.redeemResponse = const Left(
        ValidationFailure('Poin tidak mencukupi', statusCode: 422),
      );

      bloc.add(const SubmitRedeemVoucherEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const RedeemVoucherSubmitting(),
          predicate<RedeemVoucherState>((state) {
            return state is RedeemVoucherFailure &&
                state.message == 'Poin tidak mencukupi' &&
                state.statusCode == 422;
          }),
        ]),
      );
    });

    test('ResetRedeemVoucherEvent emits RedeemVoucherInitial', () async {
      fakeRepo.redeemResponse = const Left(
        ServerFailure('Gagal', statusCode: 500),
      );

      bloc.add(const SubmitRedeemVoucherEvent());
      await expectLater(bloc.stream, emitsThrough(isA<RedeemVoucherFailure>()));

      bloc.add(const ResetRedeemVoucherEvent());
      await expectLater(bloc.stream, emits(const RedeemVoucherInitial()));
    });
  });
}
