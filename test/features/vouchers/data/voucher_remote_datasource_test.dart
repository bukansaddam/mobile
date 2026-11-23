import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/features/vouchers/data/datasources/voucher_remote_datasource.dart';
import 'package:akar/features/vouchers/data/models/redeem_voucher_result_model.dart';
import 'package:akar/features/vouchers/data/models/voucher_page_model.dart';
import 'package:akar/features/vouchers/data/repositories/voucher_repository_impl.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockDioAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _MockDioAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<dynamic>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('Voucher Data Layer Tests', () {
    test('VoucherPageModel.fromJson parses complete response correctly', () {
      final json = {
        'success': true,
        'message': 'OK',
        'data': [
          {
            'id': 1,
            'code': 'VCR-261123-8F3K9A',
            'points_spent': 100,
            'status': 'active',
            'notes': null,
            'redeemed_at': '2026-11-23T11:10:00+07:00',
            'used_at': null,
          },
        ],
        'meta': {
          'current_page': 1,
          'last_page': 2,
          'per_page': 20,
          'total': 25,
        },
        'summary': {
          'current_points': 150,
          'voucher_point_cost': 100,
          'can_redeem': true,
          'redeemable_count': 1,
        },
      };

      final model = VoucherPageModel.fromJson(json);

      expect(model.items.length, 1);
      expect(model.items.first.id, 1);
      expect(model.items.first.code, 'VCR-261123-8F3K9A');
      expect(model.items.first.status, VoucherStatus.active);
      expect(model.items.first.isActive, isTrue);
      expect(model.currentPage, 1);
      expect(model.lastPage, 2);
      expect(model.hasMore, isTrue);
      expect(model.total, 25);
      expect(model.summary.currentPoints, 150);
      expect(model.summary.voucherPointCost, 100);
      expect(model.summary.canRedeem, isTrue);
      expect(model.summary.redeemableCount, 1);
      expect(model.summary.pointsNeeded, 0);
    });

    test('RedeemVoucherResultModel.fromJson parses 201 response correctly', () {
      final json = {
        'success': true,
        'message': 'Voucher berhasil ditukar dengan 100 poin.',
        'data': {
          'voucher': {
            'id': 42,
            'code': 'VCR-261123-ABC123',
            'points_spent': 100,
            'status': 'active',
            'notes': 'Tukar voucher sembako',
            'redeemed_at': '2026-11-23T11:10:00+07:00',
            'used_at': null,
          },
          'points_spent': 100,
          'remaining_points': 50,
        },
      };

      final model = RedeemVoucherResultModel.fromJson(json);

      expect(model.voucher.id, 42);
      expect(model.voucher.code, 'VCR-261123-ABC123');
      expect(model.voucher.notes, 'Tukar voucher sembako');
      expect(model.pointsSpent, 100);
      expect(model.remainingPoints, 50);
      expect(model.message, 'Voucher berhasil ditukar dengan 100 poin.');
    });

    test('VoucherRemoteDatasourceImpl.getMyVouchers succeeds on 200', () async {
      RequestOptions? capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _MockDioAdapter((options) async {
        capturedOptions = options;
        return ResponseBody.fromString(
          '{"success":true,"message":"OK","data":[],"meta":{"current_page":1,"last_page":1,"per_page":20,"total":0},"summary":{"current_points":50,"voucher_point_cost":100,"can_redeem":false,"redeemable_count":0}}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final ds = VoucherRemoteDatasourceImpl(dio: dio);
      final result = await ds.getMyVouchers(
        status: VoucherStatus.active,
        page: 1,
        perPage: 20,
      );

      expect(result.items, isEmpty);
      expect(result.summary.currentPoints, 50);
      expect(result.summary.canRedeem, isFalse);
      expect(result.summary.pointsNeeded, 50);
      expect(capturedOptions?.queryParameters['status'], 'active');
      expect(capturedOptions?.queryParameters['page'], 1);
      expect(capturedOptions?.queryParameters['per_page'], 20);
    });

    test('VoucherRemoteDatasourceImpl.redeemVoucher sends idempotency and payload', () async {
      RequestOptions? capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _MockDioAdapter((options) async {
        capturedOptions = options;
        return ResponseBody.fromString(
          '{"success":true,"message":"Voucher dibuat","data":{"voucher":{"id":7,"code":"VCR-1111","points_spent":100,"status":"active","notes":"Catatan uji","redeemed_at":"2026-11-23T11:10:00+07:00","used_at":null},"points_spent":100,"remaining_points":20}}',
          201,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final ds = VoucherRemoteDatasourceImpl(dio: dio);
      final result = await ds.redeemVoucher(
        notes: 'Catatan uji',
        idempotencyKey: 'idemp-uuid-1234',
      );

      expect(result.voucher.id, 7);
      expect(result.remainingPoints, 20);
      expect(capturedOptions?.headers['X-Idempotency-Key'], 'idemp-uuid-1234');
      expect((capturedOptions?.data as Map)['notes'], 'Catatan uji');
    });

    test('VoucherRemoteDatasourceImpl throws ValidationException on 422', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _MockDioAdapter((options) async {
        return ResponseBody.fromString(
          '{"success":false,"message":"Poin tidak mencukupi untuk penukaran"}',
          422,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final ds = VoucherRemoteDatasourceImpl(dio: dio);

      expect(
        () => ds.redeemVoucher(idempotencyKey: 'key-1'),
        throwsA(isA<ValidationException>()),
      );

      final repo = VoucherRepositoryImpl(remoteDatasource: ds);
      final result = await repo.redeemVoucher(idempotencyKey: 'key-1');
      expect(result.isLeft, isTrue);
      expect(result.left, isA<ValidationFailure>());
    });

    test('VoucherRepositoryImpl returns Right on success and Left on failure', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _MockDioAdapter((options) async {
        return ResponseBody.fromString(
          '{"success":true,"message":"OK","data":[],"meta":{"current_page":1,"last_page":1,"per_page":20,"total":0},"summary":{"current_points":200,"voucher_point_cost":100,"can_redeem":true,"redeemable_count":2}}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final ds = VoucherRemoteDatasourceImpl(dio: dio);
      final repo = VoucherRepositoryImpl(remoteDatasource: ds);

      final result = await repo.getMyVouchers();
      expect(result.isRight, isTrue);
      expect(result.right.summary.canRedeem, isTrue);
      expect(result.right.summary.redeemableCount, 2);
    });
  });
}
