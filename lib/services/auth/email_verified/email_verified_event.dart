part of "email_verified_bloc.dart";

abstract class EmailVerifiedEvent extends Equatable {
  const EmailVerifiedEvent();

  @override
  List<Object> get props => [];
}

class OnEmailVerifiedEvent extends EmailVerifiedEvent {
  final UserModel user;

  const OnEmailVerifiedEvent({
    required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}
