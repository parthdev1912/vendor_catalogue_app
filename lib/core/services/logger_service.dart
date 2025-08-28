import 'dart:developer' as developer;
enum LogLevel {
  info,
  debug,
  warning,
  error,
}

class LoggerService {
  final bool _isEnabled;

  LoggerService({bool isEnabled = true}) : _isEnabled = isEnabled;

  void log(
      String message, {
        LogLevel level = LogLevel.info,
        Object? error,
        StackTrace? stackTrace,
      }) {
    if (!_isEnabled) return;

    String levelStr = level.toString().split('.').last.toUpperCase();
    String formattedMessage = '[$levelStr] $message';

    developer.log(
      formattedMessage,
      name: 'API_LOGGER',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void apiRequest(String method, String url, Map<String, dynamic>? headers, dynamic body) {
    if (!_isEnabled) return;

    log('┌────────────────────── API REQUEST ──────────────────────');
    log('│ METHOD: $method');
    log('│ URL: $url');
    log('│ HEADERS: $headers');
    log('│ BODY: $body');
    log('└─────────────────────────────────────────────────────────');
  }

  void apiResponse(String url, int statusCode, dynamic body) {
    if (!_isEnabled) return;

    log('┌────────────────────── API RESPONSE ─────────────────────');
    log('│ URL: $url');
    log('│ STATUS CODE: $statusCode');
    log('│ BODY: $body');
    log('└─────────────────────────────────────────────────────────');
  }

  void apiError(String url, Object error, StackTrace? stackTrace) {
    if (!_isEnabled) return;

    log(
      '┌────────────────────── API ERROR ────────────────────────',
      level: LogLevel.error,
    );
    log('│ URL: $url', level: LogLevel.error);
    log('│ ERROR: $error', level: LogLevel.error);
    log(
      '└─────────────────────────────────────────────────────────',
      level: LogLevel.error,
      error: error,
      stackTrace: stackTrace,
    );
  }
}