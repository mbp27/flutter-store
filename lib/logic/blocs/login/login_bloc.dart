import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pitjarusstore/data/repositories/auth_repository.dart';
import 'package:pitjarusstore/fields/fields.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onLoginUsernameChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginValidateForm>(_onLoginValidateForm);
    on<LoginFormSubmitted>(_onLoginFormSubmitted);
  }

  FutureOr<void> _onLoginUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) async {
    final usernameField = TextField.dirty(
      isRequired: true,
      value: event.value?.trim(),
    );
    emit(state.copyWith(usernameField: usernameField));
    add(LoginValidateForm());
  }

  FutureOr<void> _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    final passwordField = TextField.dirty(
      isRequired: true,
      value: event.value?.trim(),
    );
    emit(state.copyWith(passwordField: passwordField));
    add(LoginValidateForm());
  }

  FutureOr<void> _onLoginValidateForm(
    LoginValidateForm event,
    Emitter<LoginState> emit,
  ) {
    final fields = <FormzInput>[
      state.usernameField,
      state.passwordField,
    ];
    emit(state.copyWith(status: Formz.validate(fields)));
  }

  FutureOr<void> _onLoginFormSubmitted(
    LoginFormSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isSubmissionInProgress) return;
    if (!state.status.isValidated) {
      return add(LoginValidateForm());
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final username = state.usernameField.value;
      final password = state.passwordField.value;
      if (username == null || password == null) throw 'Terdapat kesalahan';
      await _authRepository.loginTest(
        username: username,
        password: password,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        error: e.toString(),
      ));
    }
  }
}
