import 'dart:async';
import 'dart:io';

import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/network/base_remote_data_source.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestRemoteDataSource extends BaseRemoteDataSource {}

void main() {
  group('ErrorUtils.parseErrorMessage', () {
    test('returns "Terjadi Kesalahan" when status code is 500', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/positions/me'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/positions/me'),
          statusCode: 500,
          statusMessage: 'Internal Server Error',
        ),
        type: DioExceptionType.badResponse,
        message:
            'This exception was thrown because the response has a status code of 500 and RequestOptions.validateStatus was configured to throw for this status code.',
      );

      final result = ErrorUtils.parseErrorMessage(dioException);
      expect(result, equals('Terjadi Kesalahan'));
    });

    test('returns "Terjadi Kesalahan" when response data is HTML string', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 200,
          data:
              '<!DOCTYPE html><html><head><title>500 Internal Server Error</title></head><body><h1>Server Error</h1></body></html>',
        ),
        type: DioExceptionType.badResponse,
      );

      final result = ErrorUtils.parseErrorMessage(dioException);
      expect(result, equals('Terjadi Kesalahan'));
    });

    test('returns custom server message when valid and not 500/HTML', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 400,
          data: {'message': 'NIK sudah terdaftar'},
        ),
        type: DioExceptionType.badResponse,
      );

      final result = ErrorUtils.parseErrorMessage(dioException);
      expect(result, equals('NIK sudah terdaftar'));
    });

    test(
      'returns "Sesi telah berakhir, silakan login ulang" for status 401',
      () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/api/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/test'),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        );

        final result = ErrorUtils.parseErrorMessage(dioException);
        expect(result, equals('Sesi telah berakhir, silakan login ulang'));
      },
    );

    test(
      'returns "Terjadi Kesalahan" for raw string containing 500 or validateStatus',
      () {
        const rawError =
            'DioException [bad response]: This exception was thrown because the response has a status code of 500 and RequestOptions.validateStatus was configured to throw for this status code.';

        final result = ErrorUtils.parseErrorMessage(rawError);
        expect(result, equals('Terjadi Kesalahan'));
      },
    );

    test('extracts specific validation errors from errors map', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/figure'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/figure'),
          statusCode: 422,
          data: {
            'message': 'Validation failed',
            'errors': {
              'phone': ['The phone has already been taken.'],
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final result = ErrorUtils.parseErrorMessage(dioException);
      expect(result, equals('The phone has already been taken.'));
    });

    test('extracts multiple validation errors and joins them', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/figure'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/figure'),
          statusCode: 422,
          data: {
            'message': 'Validation failed',
            'errors': {
              'phone': ['The phone field is required.'],
              'institute_id': ['The selected institute id is invalid.'],
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final result = ErrorUtils.parseErrorMessage(dioException);
      expect(
        result,
        equals(
          'The phone field is required.\nThe selected institute id is invalid.',
        ),
      );
    });

    test('extracts errors when input is a Map directly', () {
      final mapData = {
        'message': 'Validation failed',
        'errors': {
          'ethnic': ['Suku wajib diisi'],
        },
      };

      final result = ErrorUtils.parseErrorMessage(mapData);
      expect(result, equals('Suku wajib diisi'));
    });

    test('cleans Exception prefix from raw string and exception objects', () {
      expect(
        ErrorUtils.parseErrorMessage(
          Exception('Nomor WhatsApp sudah terdaftar'),
        ),
        equals('Nomor WhatsApp sudah terdaftar'),
      );
      expect(
        ErrorUtils.parseErrorMessage(
          'Exception: Format nomor telepon tidak valid',
        ),
        equals('Format nomor telepon tidak valid'),
      );
      expect(
        ErrorUtils.parseErrorMessage(
          Exception('Exception: ServerFailure: Kode OTP tidak sesuai'),
        ),
        equals('Kode OTP tidak sesuai'),
      );
      expect(
        ErrorUtils.parseErrorMessage({
          'message': 'Exception: NIK sudah terdaftar',
        }),
        equals('NIK sudah terdaftar'),
      );
    });

    test('parses JSON string response in DioException data', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 400,
          data: '{"message": "Exception: Kode verifikasi salah"}',
        ),
        type: DioExceptionType.badResponse,
      );

      final result = ErrorUtils.parseErrorMessage(dioException);
      expect(result, equals('Kode verifikasi salah'));
    });

    test('parses OpenAPI list-of-maps validation errors array', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/jaga-tanah-reports'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/jaga-tanah-reports'),
          statusCode: 422,
          data: {
            'success': false,
            'message': 'Validasi gagal.',
            'errors': [
              {'field': 'latitude', 'error': 'The latitude field is required.'},
              {'field': 'title', 'error': 'Judul maksimal 255 karakter.'},
            ],
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final result = ErrorUtils.parseErrorMessage(dioException);
      expect(
        result,
        equals(
          'Validasi gagal.: The latitude field is required.\nJudul maksimal 255 karakter.',
        ),
      );
    });
  });

  group('ErrorUtils offline classification', () {
    test('mengenali error jaringan dan timeout sebagai network exception', () {
      expect(
        ErrorUtils.isNetworkException(const SocketException('No route')),
        isTrue,
      );
      expect(
        ErrorUtils.isNetworkException(TimeoutException('Timeout')),
        isTrue,
      );
      expect(
        ErrorUtils.isNetworkException(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          ),
        ),
        isTrue,
      );
      expect(
        ErrorUtils.isNetworkException(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.receiveTimeout,
          ),
        ),
        isTrue,
      );
    });

    test('tidak menyamarkan SSL handshake / badCertificate / cancel', () {
      expect(
        ErrorUtils.isNetworkException(const HandshakeException('Pin mismatch')),
        isFalse,
      );
      expect(
        ErrorUtils.isNetworkException(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badCertificate,
            error: const HandshakeException('Pin mismatch'),
          ),
        ),
        isFalse,
      );
      expect(
        ErrorUtils.isNetworkException(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.cancel,
          ),
        ),
        isFalse,
      );
    });

    test('memetakan status HTTP dan network error ke Failure tepat', () {
      final netFailure = ErrorUtils.toFailure(
        DioException(
          requestOptions: RequestOptions(path: '/reports'),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      expect(netFailure, isA<NetworkFailure>());
      expect(netFailure.isRetryable, isTrue);

      final valFailure = ErrorUtils.toFailure(
        const ValidationException('Judul wajib diisi', statusCode: 422),
      );
      expect(valFailure, isA<ValidationFailure>());
      expect(valFailure.statusCode, 422);
      expect(valFailure.isRetryable, isFalse);

      final authFailure = ErrorUtils.toFailure(
        const UnauthorizedException('Token kadaluwarsa', statusCode: 401),
      );
      expect(authFailure, isA<ServerFailure>());
      expect(authFailure.statusCode, 401);
      expect(authFailure.isAuthInvalid, isTrue);
      expect(authFailure.isRetryable, isFalse);

      final server503 = ErrorUtils.toFailure(
        const ServerException('Maintenance', statusCode: 503),
      );
      expect(server503.isRetryable, isTrue);
    });
  });

  group('BaseRemoteDataSource.throwResponseError', () {
    final ds = _TestRemoteDataSource();

    test('mempertahankan tipe exception sesuai statusCode/isNetworkError', () {
      expect(
        () => ds.throwResponseError(
          const ApiResponse<void>(
            success: false,
            message: 'Offline',
            isNetworkError: true,
          ),
        ),
        throwsA(isA<NetworkException>()),
      );
      expect(
        () => ds.throwResponseError(
          const ApiResponse<void>(
            success: false,
            message: 'Forbidden',
            statusCode: 403,
          ),
        ),
        throwsA(
          isA<UnauthorizedException>().having((e) => e.statusCode, 'code', 403),
        ),
      );
      expect(
        () => ds.throwResponseError(
          const ApiResponse<void>(
            success: false,
            message: 'Invalid payload',
            statusCode: 422,
          ),
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
