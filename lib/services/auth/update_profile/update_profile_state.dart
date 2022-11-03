part of "update_profile_bloc.dart";

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

class UpdateProfileInitialState extends UpdateProfileState {}

class UpdateProfileLoadingState extends UpdateProfileState {}

class UpdateProfileSuccessState extends UpdateProfileState {}

class UpdateProfileFailureState extends UpdateProfileState {
  final String code;

  const UpdateProfileFailureState({
    required this.code,
  });

  @override
  List<Object> get props => [
        code,
      ];
}
