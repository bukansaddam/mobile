/// Base class untuk semua custom exception di aplikasi.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException: $message (code: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized'])
    : super(statusCode: 401);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Internal Server Error'])
    : super(statusCode: 500);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;
  const ValidationException(
    super.message, {
    this.errors,
    super.statusCode = 422,
  });
}

class NotFoundException extends AppException {
  const NotFoundException(super.message) : super(statusCode: 404);
}
