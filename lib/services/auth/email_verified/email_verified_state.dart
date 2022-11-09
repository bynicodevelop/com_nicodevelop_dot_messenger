part of "email_verified_bloc.dart";

abstract class EmailVerifiedState extends Equatable {
  const EmailVerifiedState();

  @override
  List<Object> get props => [];
}

class EmailVerifiedInitialState extends EmailVerifiedState {
  final UserModel user;

  const EmailVerifiedInitialState({
    required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}
