part of "profile_bloc.dart";

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final User user;

  const ProfileSuccessState({
    required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}

class ProfileFailureState extends ProfileState {
  final String code;

  const ProfileFailureState({
    required this.code,
  });

  @override
  List<Object> get props => [
        code,
      ];
}
