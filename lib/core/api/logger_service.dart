import 'dart:convert';
import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger();
  static final _encoder = JsonEncoder.withIndent('  ');

  static void logRequest({
    required String title,
    required String method,
    required String endpoint,
    required Map<String, dynamic> headers,
    dynamic body,
  }) {
    final formattedJson = _encoder.convert({
      "json_type": "request",
      "title": title,
      "method": method,
      "endpoint": endpoint,
      "headers": headers,
      "body": body ?? {},
    });

    _logger.i(formattedJson);
  }

  static void logResponse({
    required String title,
    required int? statusCode,
    required dynamic data,
  }) {
    final formattedJson = _encoder.convert({
      "json_type": "response",
      "title": title,
      "status_code": statusCode,
      "data": data,
    });

    _logger.d(formattedJson);
  }

  static void logError(String title, dynamic error) {
    _logger.e('⛔ $title\n$error');
  }

  static void logInfo(String message) {
    _logger.i(message);
  }

  static void logDebug(String message) {
    _logger.d(message);
  }
}
