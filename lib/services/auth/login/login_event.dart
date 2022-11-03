part of "login_bloc.dart";

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class OnLoginEvent extends LoginEvent {
  final Map<String, dynamic> data;

  const OnLoginEvent(
    this.data,
  );

  @override
  List<Object> get props => [
        data,
      ];
}
