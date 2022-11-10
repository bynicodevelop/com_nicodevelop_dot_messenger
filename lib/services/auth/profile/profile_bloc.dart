// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/models/user_model.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:equatable/equatable.dart";
import "package:firebase_auth/firebase_auth.dart";

part "profile_event.dart";
part "profile_state.dart";

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late ProfileRepository profileRepository;

  ProfileBloc(
    this.profileRepository,
  ) : super(ProfileInitialState()) {
    on<OnProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());

      final UserModel? user = await profileRepository.user;

      if (user != null) {
        emit(ProfileSuccessState(
          user: user,
        ));

        return;
      }

      emit(const ProfileFailureState(
        code: "user_not_authenticated",
      ));
    });
  }
}
