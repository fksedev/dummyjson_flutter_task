import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../security/secure_token_store.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'session_expired_notifier.dart';

class ApiClient {
  ApiClient({
    required SecureTokenStore tokenStore,
    required SessionExpiredNotifier sessionExpiredNotifier,
    Dio? dio,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: AppConfig.apiBaseUrl,
               connectTimeout: AppConfig.connectTimeout,
               receiveTimeout: AppConfig.receiveTimeout,
               headers: const {
                 'Content-Type': 'application/json',
                 'Accept': 'application/json',
               },
             ),
           ) {
    _dio.interceptors.addAll([
      AuthInterceptor(
        tokenStore: tokenStore,
        dio: _dio,
        sessionExpiredNotifier: sessionExpiredNotifier,
      ),
      LoggingInterceptor(),
    ]);
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
