import '../../domain/entities/auth_user.dart';

class AuthUserDto {
  const AuthUserDto({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.image,
  });

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? image;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) {
    return AuthUserDto(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      gender: json['gender'] as String?,
      image: json['image'] as String?,
    );
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      image: image,
    );
  }
}
