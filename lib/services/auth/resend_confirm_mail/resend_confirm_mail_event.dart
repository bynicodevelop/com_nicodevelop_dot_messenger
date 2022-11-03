part of "resend_confirm_mail_bloc.dart";

abstract class ResendConfirmMailEvent extends Equatable {
  const ResendConfirmMailEvent();

  @override
  List<Object> get props => [];
}

class OnResendConfirmMailEvent extends ResendConfirmMailEvent {}
