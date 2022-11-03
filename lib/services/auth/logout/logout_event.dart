part of "logout_bloc.dart";

abstract class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}

class OnLogoutEvent extends LogoutEvent {}
