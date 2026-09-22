import 'package:akar/core/utils/error_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

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

    test('returns "Sesi telah berakhir, silakan login ulang" for status 401',
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
    });

    test(
        'returns "Terjadi Kesalahan" for raw string containing 500 or validateStatus',
        () {
      const rawError =
          'DioException [bad response]: This exception was thrown because the response has a status code of 500 and RequestOptions.validateStatus was configured to throw for this status code.';

      final result = ErrorUtils.parseErrorMessage(rawError);
      expect(result, equals('Terjadi Kesalahan'));
    });

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
  });
}
