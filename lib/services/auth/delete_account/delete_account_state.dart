part of "delete_account_bloc.dart";

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitialState extends DeleteAccountState {}

class DeleteAccountLoadingState extends DeleteAccountState {}

class DeleteAccountSuccessState extends DeleteAccountState {}

class DeleteAccountFailureState extends DeleteAccountState {
  final String code;

  const DeleteAccountFailureState(
    this.code,
  );

  @override
  List<Object> get props => [
        code,
      ];
}
