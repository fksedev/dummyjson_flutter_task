import 'package:equatable/equatable.dart';

import 'auth_user.dart';

class AuthSession extends Equatable {
  const AuthSession({
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

  String get displayName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }

  AuthUser toUser() {
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

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
    accessToken,
    refreshToken,
    gender,
    image,
  ];
}
