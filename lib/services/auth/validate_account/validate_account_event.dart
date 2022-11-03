part of "validate_account_bloc.dart";

abstract class ValidateAccountEvent extends Equatable {
  const ValidateAccountEvent();

  @override
  List<Object> get props => [];
}

class OnValidateAccountEvent extends ValidateAccountEvent {
  final String code;

  const OnValidateAccountEvent(
    this.code,
  );

  @override
  List<Object> get props => [
        code,
      ];
}
