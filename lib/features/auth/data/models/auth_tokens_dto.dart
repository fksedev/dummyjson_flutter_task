import '../../domain/entities/auth_tokens.dart';

class AuthTokensDto {
  const AuthTokensDto({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) {
    return AuthTokensDto(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  AuthTokens toEntity() {
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }
}
