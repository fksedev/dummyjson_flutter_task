import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/use_cases/login.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.session,
    this.errorMessage,
    this.obscurePassword = true,
  });

  final LoginStatus status;
  final AuthSession? session;
  final String? errorMessage;
  final bool obscurePassword;

  LoginState copyWith({
    LoginStatus? status,
    AuthSession? session,
    String? errorMessage,
    bool clearError = false,
    bool clearSession = false,
    bool? obscurePassword,
  }) {
    return LoginState(
      status: status ?? this.status,
      session: clearSession ? null : (session ?? this.session),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [status, session, errorMessage, obscurePassword];
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login) : super(const LoginState());

  final Login _login;

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(clearError: true));
    }
  }

  Future<void> submit({
    required String username,
    required String password,
  }) async {
    emit(
      state.copyWith(
        status: LoginStatus.loading,
        clearError: true,
        clearSession: true,
      ),
    );
    try {
      final session = await _login(username: username, password: password);
      emit(state.copyWith(status: LoginStatus.success, session: session));
    } catch (error) {
      final failure = mapExceptionToFailure(error);
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: _messageFor(failure),
        ),
      );
    }
  }

  String _messageFor(Failure failure) {
    if (failure is UnauthorizedFailure || failure is AuthFailure) {
      return 'Invalid username or password.';
    }
    return failure.message;
  }
}
