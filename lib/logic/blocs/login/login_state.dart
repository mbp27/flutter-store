part of 'login_bloc.dart';

class LoginState extends Equatable {
  final TextField usernameField;
  final TextField passwordField;
  final FormzStatus status;
  final String? error;

  const LoginState({
    this.usernameField = const TextField.pure(),
    this.passwordField = const TextField.pure(),
    this.status = FormzStatus.pure,
    this.error,
  });

  bool get saveButtonActive =>
      status.isValid ||
      status.isSubmissionFailure ||
      status.isSubmissionSuccess;

  LoginState copyWith({
    TextField? usernameField,
    TextField? passwordField,
    FormzStatus? status,
    String? error,
  }) {
    return LoginState(
      usernameField: usernameField ?? this.usernameField,
      passwordField: passwordField ?? this.passwordField,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      usernameField,
      passwordField,
      status,
      error,
    ];
  }
}
