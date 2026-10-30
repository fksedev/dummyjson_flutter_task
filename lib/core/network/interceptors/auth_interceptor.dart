import 'dart:async';

import 'package:dio/dio.dart';

import '../../security/secure_token_store.dart';
import '../api_endpoints.dart';
import '../session_expired_notifier.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureTokenStore tokenStore,
    required Dio dio,
    required SessionExpiredNotifier sessionExpiredNotifier,
  }) : _tokenStore = tokenStore,
       _dio = dio,
       _sessionExpiredNotifier = sessionExpiredNotifier;

  final SecureTokenStore _tokenStore;
  final Dio _dio;
  final SessionExpiredNotifier _sessionExpiredNotifier;

  Completer<bool>? _refreshCompleter;

  static const _skipAuthExtra = 'skipAuth';
  static const _retriedExtra = 'retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skipAuth = options.extra[_skipAuthExtra] == true;
    if (!skipAuth) {
      final token = await _tokenStore.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final alreadyRetried = err.requestOptions.extra[_retriedExtra] == true;
    final skipAuth = err.requestOptions.extra[_skipAuthExtra] == true;

    if (status != 401 || alreadyRetried || skipAuth) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshTokenSingleFlight();
    if (!refreshed) {
      await _tokenStore.clear();
      _sessionExpiredNotifier.notify();
      handler.next(err);
      return;
    }

    try {
      final response = await _retry(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _refreshTokenSingleFlight() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      final refreshToken = await _tokenStore.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken, 'expiresInMins': 30},
        options: Options(extra: {_skipAuthExtra: true}),
      );

      final data = response.data ?? <String, dynamic>{};
      final accessToken = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String? ?? refreshToken;

      if (accessToken == null || accessToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      await _tokenStore.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefresh,
      );
      _refreshCompleter!.complete(true);
      return true;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await _tokenStore.readAccessToken();
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return _dio.fetch<dynamic>(
      requestOptions.copyWith(
        headers: headers,
        extra: {...requestOptions.extra, _retriedExtra: true},
      ),
    );
  }
}
