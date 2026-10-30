import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/security/secure_token_store.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/auth_remote_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteService remoteService,
    required SecureTokenStore tokenStore,
  }) : _remoteService = remoteService,
       _tokenStore = tokenStore;

  final AuthRemoteService _remoteService;
  final SecureTokenStore _tokenStore;

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    try {
      final dto = await _remoteService.login(
        username: username.trim(),
        password: password,
      );

      if (dto.accessToken.isEmpty) {
        throw const AuthFailure(
          'Login succeeded but no access token was returned.',
        );
      }

      await _tokenStore.saveTokens(
        accessToken: dto.accessToken,
        refreshToken: dto.refreshToken,
      );

      return dto.toEntity();
    } catch (error) {
      throw mapExceptionToFailure(error);
    }
  }

  @override
  Future<AuthUser> getCurrentUser() async {
    try {
      final dto = await _remoteService.getCurrentUser();
      return dto.toEntity();
    } catch (error) {
      throw mapExceptionToFailure(error);
    }
  }

  @override
  Future<AuthTokens> refreshSession({int expiresInMins = 30}) async {
    try {
      final refreshToken = await _tokenStore.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw const AuthFailure('No refresh token available.');
      }

      final dto = await _remoteService.refreshSession(
        refreshToken: refreshToken,
        expiresInMins: expiresInMins,
      );

      if (dto.accessToken.isEmpty) {
        throw const AuthFailure(
          'Refresh succeeded but no access token returned.',
        );
      }

      final nextRefresh = dto.refreshToken.isNotEmpty
          ? dto.refreshToken
          : refreshToken;

      await _tokenStore.saveTokens(
        accessToken: dto.accessToken,
        refreshToken: nextRefresh,
      );

      return AuthTokens(
        accessToken: dto.accessToken,
        refreshToken: nextRefresh,
      );
    } catch (error) {
      throw mapExceptionToFailure(error);
    }
  }

  @override
  Future<bool> hasValidSession() => _tokenStore.hasAccessToken();

  @override
  Future<void> logout() => _tokenStore.clear();
}
