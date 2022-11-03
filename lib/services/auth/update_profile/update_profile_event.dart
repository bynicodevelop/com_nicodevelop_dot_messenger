part of "update_profile_bloc.dart";

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object> get props => [];
}

class OnUpdateProfileEvent extends UpdateProfileEvent {
  final Map<String, dynamic> data;

  const OnUpdateProfileEvent({
    required this.data,
  });

  @override
  List<Object> get props => [
        data,
      ];
}
