import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class RefreshSession {
  RefreshSession(this._repository);

  final AuthRepository _repository;

  Future<AuthTokens> call({int expiresInMins = 30}) {
    return _repository.refreshSession(expiresInMins: expiresInMins);
  }
}
