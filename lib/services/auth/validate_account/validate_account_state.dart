part of "validate_account_bloc.dart";

abstract class ValidateAccountState extends Equatable {
  const ValidateAccountState();

  @override
  List<Object> get props => [];
}

class ValidateAccountInitialState extends ValidateAccountState {}

class ValidateAccountLoadingState extends ValidateAccountState {}

class ValidateAccountSuccessState extends ValidateAccountState {}

class ValidateAccountFailureState extends ValidateAccountState {
  final String code;

  const ValidateAccountFailureState(
    this.code,
  );

  @override
  List<Object> get props => [
        code,
      ];
}
