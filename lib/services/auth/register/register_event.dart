part of "register_bloc.dart";

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class OnRegisterEvent extends RegisterEvent {
  final Map<String, dynamic> data;

  const OnRegisterEvent(
    this.data,
  );

  @override
  List<Object> get props => [
        data,
      ];
}
