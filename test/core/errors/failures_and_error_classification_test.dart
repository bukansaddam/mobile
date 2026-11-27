// test/core/errors/failures_and_error_classification_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/utils/error_utils.dart';

void main() {
  group('Failure.isRetryable', () {
    test('returns true for status code 409 Conflict', () {
      const failure = ServerFailure('Laporan sedang diproses', statusCode: 409);
      expect(failure.isRetryable, isTrue);
    });

    test('returns true for 408, 429, and 500+', () {
      expect(const ServerFailure('Timeout', statusCode: 408).isRetryable, isTrue);
      expect(const ServerFailure('Too many', statusCode: 429).isRetryable, isTrue);
      expect(const ServerFailure('Internal', statusCode: 500).isRetryable, isTrue);
      expect(const ServerFailure('Bad Gateway', statusCode: 502).isRetryable, isTrue);
      expect(const NetworkFailure('Offline').isRetryable, isTrue);
    });

    test('returns false for validation and permanent 4xx', () {
      expect(const ValidationFailure('Invalid', statusCode: 422).isRetryable, isFalse);
      expect(const ServerFailure('Bad Request', statusCode: 400).isRetryable, isFalse);
      expect(const ServerFailure('Forbidden', statusCode: 403).isRetryable, isFalse);
    });
  });

  group('ErrorUtils.toFailure mapping', () {
    test('preserves statusCode 409 in ServerFailure', () {
      const exception = ServerException('Laporan sedang diproses', statusCode: 409);
      final failure = ErrorUtils.toFailure(exception);
      expect(failure.statusCode, equals(409));
      expect(failure.isRetryable, isTrue);
    });
  });
}
