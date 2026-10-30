import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureTokenStore {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<bool> hasAccessToken();

  Future<void> clear();
}

class SecureTokenStoreImpl implements SecureTokenStore {
  SecureTokenStoreImpl(this._storage);

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: accessToken),
      _storage.write(key: _refreshKey, value: refreshToken),
    ]);
  }

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  @override
  Future<bool> hasAccessToken() async {
    final token = await readAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
    ]);
  }
}
