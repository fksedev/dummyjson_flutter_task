import '../entities/auth_session.dart';
import '../entities/auth_tokens.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthSession> login({
    required String username,
    required String password,
  });

  Future<AuthUser> getCurrentUser();

  Future<AuthTokens> refreshSession({int expiresInMins = 30});

  Future<bool> hasValidSession();

  Future<void> logout();
}
