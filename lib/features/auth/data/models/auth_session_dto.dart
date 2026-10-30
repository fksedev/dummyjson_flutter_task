import '../../domain/entities/auth_session.dart';

class AuthSessionDto {
  const AuthSessionDto({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.accessToken,
    required this.refreshToken,
    this.gender,
    this.image,
  });

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String accessToken;
  final String refreshToken;
  final String? gender;
  final String? image;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) {
    return AuthSessionDto(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      accessToken:
          json['accessToken'] as String? ?? json['token'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      gender: json['gender'] as String?,
      image: json['image'] as String?,
    );
  }

  AuthSession toEntity() {
    return AuthSession(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      accessToken: accessToken,
      refreshToken: refreshToken,
      gender: gender,
      image: image,
    );
  }
}
