part of "register_bloc.dart";

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterFailureState extends RegisterState {
  final String code;

  const RegisterFailureState(
    this.code,
  );

  @override
  List<Object> get props => [
        code,
      ];
}
