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
  });
}
