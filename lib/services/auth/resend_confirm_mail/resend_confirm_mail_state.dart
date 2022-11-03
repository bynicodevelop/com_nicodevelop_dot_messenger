part of "resend_confirm_mail_bloc.dart";

abstract class ResendConfirmMailState extends Equatable {
  const ResendConfirmMailState();

  @override
  List<Object> get props => [];
}

class ResendConfirmMailInitialState extends ResendConfirmMailState {}

class ResendConfirmMailLoadingState extends ResendConfirmMailState {}

class ResendConfirmMailSuccessState extends ResendConfirmMailState {}

class ResendConfirmMailFailureState extends ResendConfirmMailState {
  final String code;

  const ResendConfirmMailFailureState(
    this.code,
  );

  @override
  List<Object> get props => [
        code,
      ];
}
