part of "login_bloc.dart";

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginState {
  final String code;

  const LoginFailureState(
    this.code,
  );

  @override
  List<Object> get props => [
        code,
      ];
}
