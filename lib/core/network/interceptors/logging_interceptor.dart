import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Debug-only logging with redacted secrets.
class LoggingInterceptor extends Interceptor {
  static const _redacted = '***';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '→ ${options.method} ${options.uri} '
        'headers=${_sanitizeHeaders(options.headers)}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '✖ ${err.response?.statusCode ?? '-'} ${err.requestOptions.uri} '
        '${err.message}',
      );
    }
    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final copy = Map<String, dynamic>.from(headers);
    for (final key in copy.keys.toList()) {
      final lower = key.toLowerCase();
      if (lower == 'authorization' || lower.contains('token')) {
        copy[key] = _redacted;
      }
    }
    return copy;
  }
}
