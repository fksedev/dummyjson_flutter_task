import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_session_dto.dart';
import '../models/auth_tokens_dto.dart';
import '../models/auth_user_dto.dart';

class AuthRemoteService {
  AuthRemoteService(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSessionDto> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'username': username, 'password': password, 'expiresInMins': 30},
      options: Options(extra: const {'skipAuth': true}),
    );

    final data = response.data;
    if (data == null) {
      throw StateError('Empty login response');
    }
    return AuthSessionDto.fromJson(data);
  }

  Future<AuthUserDto> getCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.me,
    );

    final data = response.data;
    if (data == null) {
      throw StateError('Empty auth/me response');
    }
    return AuthUserDto.fromJson(data);
  }

  Future<AuthTokensDto> refreshSession({
    required String refreshToken,
    int expiresInMins = 30,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.refresh,
      data: {'refreshToken': refreshToken, 'expiresInMins': expiresInMins},
      options: Options(extra: const {'skipAuth': true}),
    );

    final data = response.data;
    if (data == null) {
      throw StateError('Empty auth/refresh response');
    }
    return AuthTokensDto.fromJson(data);
  }
}
