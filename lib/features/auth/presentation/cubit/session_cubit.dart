import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/session_expired_notifier.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/use_cases/check_session.dart';
import '../../domain/use_cases/get_current_user.dart';
import '../../domain/use_cases/logout.dart';
import '../../domain/use_cases/refresh_session.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState extends Equatable {
  const SessionState({required this.status, this.user});

  const SessionState.unknown() : this(status: SessionStatus.unknown);

  const SessionState.unauthenticated()
    : this(status: SessionStatus.unauthenticated);

  final SessionStatus status;
  final AuthUser? user;

  @override
  List<Object?> get props => [status, user];
}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required CheckSession checkSession,
    required GetCurrentUser getCurrentUser,
    required RefreshSession refreshSession,
    required Logout logout,
    required SessionExpiredNotifier sessionExpiredNotifier,
  }) : _checkSession = checkSession,
       _getCurrentUser = getCurrentUser,
       _refreshSession = refreshSession,
       _logout = logout,
       super(const SessionState.unknown()) {
    _subscription = sessionExpiredNotifier.stream.listen((_) {
      emit(const SessionState.unauthenticated());
    });
  }

  final CheckSession _checkSession;
  final GetCurrentUser _getCurrentUser;
  final RefreshSession _refreshSession;
  final Logout _logout;
  StreamSubscription<void>? _subscription;

  Future<void> bootstrap() async {
    final hasSession = await _checkSession();
    if (!hasSession) {
      emit(const SessionState.unauthenticated());
      return;
    }
    await _fetchCurrentUser(logoutOnFailure: true);
  }

  Future<void> onAuthenticated({AuthUser? user}) async {
    emit(SessionState(status: SessionStatus.authenticated, user: user));
    await _fetchCurrentUser(logoutOnFailure: true);
  }

  /// Extends the session via `POST /auth/refresh` and reloads `/auth/me`.
  Future<bool> refreshSession() async {
    try {
      await _refreshSession();
      await _fetchCurrentUser(logoutOnFailure: false);
      return state.status == SessionStatus.authenticated;
    } catch (_) {
      await _logout();
      emit(const SessionState.unauthenticated());
      return false;
    }
  }

  Future<void> _fetchCurrentUser({required bool logoutOnFailure}) async {
    try {
      final user = await _getCurrentUser();
      emit(SessionState(status: SessionStatus.authenticated, user: user));
    } catch (_) {
      if (!logoutOnFailure) return;
      await _logout();
      emit(const SessionState.unauthenticated());
    }
  }

  Future<void> logout() async {
    await _logout();
    emit(const SessionState.unauthenticated());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
