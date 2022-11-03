part of "delete_account_bloc.dart";

abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

class OnDeleteAccountEvent extends DeleteAccountEvent {}
