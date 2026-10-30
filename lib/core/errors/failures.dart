import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please try again.',
  ]);
}

final class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}

final class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Authentication failed. Please sign in again.',
  ]);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Session expired. Please sign in again.',
  ]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Unexpected error. Please try again.',
  ]);
}
