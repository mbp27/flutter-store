part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final DateTime? refreshTime;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.refreshTime,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    DateTime? refreshTime,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      refreshTime: refreshTime ?? this.refreshTime,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      refreshTime,
      error,
    ];
  }
}
