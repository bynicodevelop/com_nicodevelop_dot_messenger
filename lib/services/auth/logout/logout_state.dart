part of "logout_bloc.dart";

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitialState extends LogoutState {}

class LogoutLoadingState extends LogoutState {}

class LogoutSuccessState extends LogoutState {}
