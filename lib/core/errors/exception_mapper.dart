import 'package:dio/dio.dart';

import 'failures.dart';

Failure mapExceptionToFailure(Object error) {
  if (error is Failure) return error;

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response?.statusCode, error.response?.data);
      case DioExceptionType.cancel:
        return const UnexpectedFailure('Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const NetworkFailure('Secure connection failed.');
      case DioExceptionType.unknown:
        return const NetworkFailure();
    }
  }

  return UnexpectedFailure(error.toString());
}

Failure _mapStatusCode(int? statusCode, dynamic data) {
  final serverMessage = _extractMessage(data);

  switch (statusCode) {
    case 400:
    case 422:
      return ValidationFailure(serverMessage ?? 'Invalid request.');
    case 401:
      return UnauthorizedFailure(serverMessage ?? 'Invalid credentials.');
    case 403:
      return const AuthFailure(
        'You do not have permission to perform this action.',
      );
    case 404:
      return const ServerFailure('Requested resource was not found.');
    default:
      return ServerFailure(serverMessage ?? 'Server error ($statusCode).');
  }
}

String? _extractMessage(dynamic data) {
  if (data is Map) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}
