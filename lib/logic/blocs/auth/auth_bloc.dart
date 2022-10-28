import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pitjarusstore/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<AuthStatus> _authStatusSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthRefresh>(_onAuthRefresh);
    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(AuthStatusChanged(status)),
    );
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    _authRepository.dispose();
    return super.close();
  }

  Future<void> _onAuthStatusChanged(
      AuthStatusChanged event, Emitter<AuthState> emit) async {
    try {
      switch (event.status) {
        case AuthStatus.unauthenticated:
          return emit(AuthState(status: event.status));
        case AuthStatus.authenticated:
          return emit(AuthState(status: event.status));
        default:
          return emit(const AuthState());
      }
    } catch (e) {
      return emit(AuthState(
        status: AuthStatus.error,
        error: e.toString(),
        refreshTime: DateTime.now(),
      ));
    }
  }

  Future<void> _onAuthRefresh(
      AuthRefresh event, Emitter<AuthState> emit) async {
    emit(state.copyWith(refreshTime: DateTime.now()));
  }
}
