import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (AppLogger.isProduction) return false;
    return true;
  }
}

class AppLogger {
  AppLogger._();

  /// Menandakan apakah aplikasi berjalan dalam mode produksi (release mode / prod).
  static const bool isProduction = kReleaseMode ||
      String.fromEnvironment('ENV') == 'prod' ||
      String.fromEnvironment('ENV') == 'production' ||
      String.fromEnvironment('ENVIRONMENT') == 'prod' ||
      String.fromEnvironment('ENVIRONMENT') == 'production';

  static final Logger _logger = Logger(
    filter: _AppLogFilter(),
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: false,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: isProduction ? Level.off : Level.trace,
  );

  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isProduction) return;
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isProduction) return;
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isProduction) return;
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isProduction) return;
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isProduction) return;
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isProduction) return;
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

